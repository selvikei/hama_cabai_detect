import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TfliteService {
  Interpreter? _interpreter;
  List<String>? _labels;

  // 1. Load Model dan Label
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/yolov8s-training-4.tflite',
      );

      final labelData = await rootBundle.loadString('assets/models/labels.txt');
      _labels = labelData.split('\n').where((s) => s.isNotEmpty).toList();

      debugPrint("✅ Model dan Label berhasil dimuat!");
    } catch (e) {
      debugPrint("❌ Gagal memuat model: $e");
    }
  }

  // 2. Fungsi Prediksi Utama
  Future<List<Map<String, dynamic>>> predict(String imagePath) async {
    if (_interpreter == null || _labels == null) return [];

    try {
      final totalStopwatch = Stopwatch()..start();

      // --- A. PRE-PROCESSING ---
      final imageData = File(imagePath).readAsBytesSync();
      img.Image? originalImage = img.decodeImage(imageData);
      img.Image resizedImage = img.copyResize(
        originalImage!,
        width: 640,
        height: 640,
      );

      var input = List.generate(
        1,
        (b) => List.generate(
          640,
          (y) => List.generate(640, (x) {
            final pixel = resizedImage.getPixel(x, y);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          }),
        ),
      );

      // Wadah Output untuk 3 Kelas: [1, 7, 8400]
      // 4 koordinat (x,y,w,h) + 3 skor kelas = 7
      var output = List.filled(1 * 7 * 8400, 0.0).reshape([1, 7, 8400]);

      // --- B. INFERENCE (Ukur waktu AI berpikir) ---
      final inferenceStopwatch = Stopwatch()..start();
      _interpreter!.run(input, output);
      inferenceStopwatch.stop();

      // --- C. POST-PROCESSING ---
      List<Map<String, dynamic>> rawDetections = [];
      double threshold = 0.45; // Ambang batas keyakinan

      for (int i = 0; i < 8400; i++) {
        double highestProb = 0.0;
        int highestIdx = -1;

        // Loop untuk 3 kelas (indeks 4, 5, 6)
        for (int j = 4; j < 7; j++) {
          if (output[0][j][i] > highestProb) {
            highestProb = output[0][j][i];
            highestIdx = j - 4;
          }
        }

        if (highestProb > threshold) {
          double rawCenterX = output[0][0][i];
          double rawCenterY = output[0][1][i];
          double rawWidth   = output[0][2][i];
          double rawHeight  = output[0][3][i];

          // Konversi Center-to-Corner
          // Rumus: $x_{min} = centerX - \frac{width}{2}$
          rawDetections.add({
            "label": _labels![highestIdx],
            "confidence": (highestProb * 100).toStringAsFixed(1),
            "x": (rawCenterX - (rawWidth / 2)),
            "y": (rawCenterY - (rawHeight / 2)),
            "w": rawWidth,
            "h": rawHeight,
            "score": highestProb,
          });
        }
      }

      // Jalankan NMS untuk menghapus kotak yang menumpuk
      List<Map<String, dynamic>> finalResults = runNMS(rawDetections);
      
      totalStopwatch.stop();

      // --- OUTPUT TERMINAL UNTUK TESTING ---
      debugPrint("-----------------------------------------");
      debugPrint("🚀 TESTING MODEL RESULTS:");
      debugPrint("🤖 Inference Time: ${inferenceStopwatch.elapsedMilliseconds} ms");
      debugPrint("⏱️ Total Time: ${totalStopwatch.elapsedMilliseconds} ms");
      debugPrint("📍 Objek Terdeteksi (setelah NMS): ${finalResults.length}");
      debugPrint("-----------------------------------------");

      return finalResults;
      
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  // --- ALGORITMA NMS (Non-Maximum Suppression) ---
  List<Map<String, dynamic>> runNMS(List<Map<String, dynamic>> detections) {
    if (detections.isEmpty) return [];

    // Urutkan berdasarkan skor tertinggi
    detections.sort((a, b) => b['score'].compareTo(a['score']));

    List<Map<String, dynamic>> results = [];
    
    while (detections.isNotEmpty) {
      var best = detections.removeAt(0);
      results.add(best);

      // Hapus kotak lain yang menumpuk dengan IoU > 0.45
      detections.removeWhere((item) {
        return _calculateIoU(best, item) > 0.45;
      });
    }
    return results;
  }

  // Hitung IoU (Intersection over Union)
  // Rumus: $IoU = \frac{Area\ of\ Overlap}{Area\ of\ Union}$
  double _calculateIoU(Map<String, dynamic> a, Map<String, dynamic> b) {
    double x1 = a['x'] > b['x'] ? a['x'] : b['x'];
    double y1 = a['y'] > b['y'] ? a['y'] : b['y'];
    double x2 = (a['x'] + a['w']) < (b['x'] + b['w']) ? (a['x'] + a['w']) : (b['x'] + b['w']);
    double y2 = (a['y'] + a['h']) < (b['y'] + b['h']) ? (a['y'] + a['h']) : (b['y'] + b['h']);

    double width = x2 - x1;
    double height = y2 - y1;

    if (width <= 0 || height <= 0) return 0.0;

    double intersection = width * height;
    double union = (a['w'] * a['h']) + (b['w'] * b['h']) - intersection;

    return intersection / union;
  }

  void dispose() {
    _interpreter?.close();
  }
}