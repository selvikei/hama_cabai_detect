import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TfliteService {
  Interpreter? _interpreter;
  List<String>? _labels;

  // 1. Memuat Model dan Label
  Future<void> loadModel() async {
    try {
      // Muat model TFLite dari folder assets
      _interpreter = await Interpreter.fromAsset(
        'assets/models/hama_model.tflite',
      );

      // Muat daftar label (Kutu Daun, Kutu Kebul, Thrips)
      final labelData = await rootBundle.loadString('assets/models/labels.txt');
      _labels = labelData.split('\n').where((s) => s.isNotEmpty).toList();

      debugPrint("Model dan Label berhasil dimuat!");
    } catch (e) {
      debugPrint("Gagal memuat model: $e");
    }
  }

  // 2. Fungsi Deteksi Utama
  Future<Map<String, dynamic>> predict(String imagePath) async {
    if (_interpreter == null || _labels == null) {
      return {"label": "Model Belum Siap", "confidence": 0.0};
    }

    try {
      // --- A. PRE-PROCESSING ---
      // Baca file gambar dan ubah ukurannya menjadi 640x640 (Standar YOLOv8)
      final imageData = File(imagePath).readAsBytesSync();
      img.Image? originalImage = img.decodeImage(imageData);
      img.Image resizedImage = img.copyResize(
        originalImage!,
        width: 640,
        height: 640,
      );

      // Ubah gambar menjadi format yang dipahami model (Tensor)
      // Normalisasi nilai pixel (0-255) menjadi (0.0 - 1.0)
      var input = List.generate(
        1,
        (b) => List.generate(
          640,
          (y) => List.generate(640, (x) {
            final pixel = resizedImage.getPixel(x, y);
            return [
              pixel.r / 255.0, // Red
              pixel.g / 255.0, // Green
              pixel.b / 255.0, // Blue
            ];
          }),
        ),
      );

      // --- B. MENYIAPKAN OUTPUT ---
      // YOLOv8 biasanya menghasilkan output [1, 7, 8400] atau [1, 8400, 7]
      // tergantung cara kamu mengekspornya
      var output = List.filled(1 * 8 * 8400, 0.0).reshape([1, 8, 8400]);

      // --- C. MENJALANKAN INFERENCE ---
      _interpreter!.run(input, output);

      // D. POST-PROCESSING (Ekstraksi Data)
      double highestProb = 0.0;
      int highestIdx = -1;

      // Variabel penampung koordinat mentah dari model
      double rawCenterX = 0.0;
      double rawCenterY = 0.0;
      double rawWidth = 0.0;
      double rawHeight = 0.0;

      for (int i = 0; i < 8400; i++) {
        // Loop untuk cek skor kelas (indeks 4 sampai 7)
        for (int j = 4; j < 8; j++) {
          if (output[0][j][i] > highestProb) {
            highestProb = output[0][j][i];
            highestIdx = j - 4;

            // Ambil koordinat pembentuk kotak (indeks 0, 1, 2, 3)
            rawCenterX = output[0][0][i];
            rawCenterY = output[0][1][i];
            rawWidth = output[0][2][i];
            rawHeight = output[0][3][i];
          }
        }
      }

      // E. KONVERSI COORDINATE (Center-to-Corner & Normalisasi)
      // Kita ubah ke skala 0.0 - 1.0 agar fleksibel dengan ukuran layar HP manapun
      double x = (rawCenterX - (rawWidth / 2));
      double y = (rawCenterY - (rawHeight / 2));
      double w = rawWidth;
      double h = rawHeight;

      // F. LOGIKA THRESHOLD
      if (highestProb < 0.5 || highestIdx == -1) {
        return {
          "label": "Tidak Terdapat Hama",
          "confidence": (highestProb * 100).toStringAsFixed(1),
          "x": 0.0,
          "y": 0.0,
          "w": 0.0,
          "h": 0.0,
        };
      }

      return {
        "label": _labels![highestIdx],
        "confidence": (highestProb * 100).toStringAsFixed(1),
        "x": x, "y": y, "w": w, "h": h, // Kirim koordinat ternormalisasi
      };
    } catch (e) {
      debugPrint("Error saat prediksi: $e");
      return {
        "label": "Error",
        "confidence": "0.0",
        "x": 0.0,
        "y": 0.0,
        "w": 0.0,
        "h": 0.0,
      };
    }
  }

  void dispose() {
    _interpreter?.close();
  }
}
