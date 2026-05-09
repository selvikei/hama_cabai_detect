import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TfliteService {
  Interpreter? _interpreter;
  List<String>? _labels;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/hama_model.tflite');
      final labelData = await rootBundle.loadString('assets/models/labels.txt');
      _labels = labelData.split('\n').where((s) => s.isNotEmpty).toList();
      debugPrint("Model dan Label berhasil dimuat!");
    } catch (e) {
      debugPrint("Gagal memuat model: $e");
    }
  }

  Future<List<Map<String, dynamic>>> predict(String imagePath) async {
    if (_interpreter == null || _labels == null) return [];

    try {
      final imageData = File(imagePath).readAsBytesSync();
      img.Image? originalImage = img.decodeImage(imageData);
      img.Image resizedImage = img.copyResize(originalImage!, width: 640, height: 640);

      var input = List.generate(1, (b) => List.generate(640, (y) => List.generate(640, (x) {
        final pixel = resizedImage.getPixel(x, y);
        return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
      })));

      var output = List.filled(1 * 7 * 8400, 0.0).reshape([1, 7, 8400]);
      _interpreter!.run(input, output);

      List<Map<String, dynamic>> rawDetections = [];
      double threshold = 0.45;

      for (int i = 0; i < 8400; i++) {
        double highestProb = 0.0;
        int highestIdx = -1;

        for (int j = 4; j < 7; j++) {
          if (output[0][j][i] > highestProb) {
            highestProb = output[0][j][i];
            highestIdx = j - 4;
          }
        }

        if (highestProb > threshold) {
          double rawCenterX = output[0][0][i];
          double rawCenterY = output[0][1][i];
          double rawWidth = output[0][2][i];
          double rawHeight = output[0][3][i];

          rawDetections.add({
            "label": _labels![highestIdx],
            "confidence": (highestProb * 100).toStringAsFixed(1),
            "x": (rawCenterX - (rawWidth / 2)),
            "y": (rawCenterY - (rawHeight / 2)),
            "w": rawWidth,
            "h": rawHeight,
            "score": highestProb, // Digunakan untuk sortir NMS
          });
        }
      }

      // Jalankan NMS untuk membersihkan duplikasi kotak
      return runNMS(rawDetections);
      
    } catch (e) {
      debugPrint("Error saat prediksi: $e");
      return [];
    }
  }

  // --- LOGIKA NMS (Non-Maximum Suppression) ---
  List<Map<String, dynamic>> runNMS(List<Map<String, dynamic>> detections) {
    if (detections.isEmpty) return [];

    // 1. Urutkan dari akurasi tertinggi ke terendah
    detections.sort((a, b) => b['score'].compareTo(a['score']));

    List<Map<String, dynamic>> results = [];
    
    while (detections.isNotEmpty) {
      // 2. Ambil kotak dengan skor tertinggi (paling meyakinkan)
      var best = detections.removeAt(0);
      results.add(best);

      // 3. Hapus kotak lain yang menumpuk (IoU tinggi) dengan kotak terbaik tadi
      detections.removeWhere((item) {
        return calculateIoU(best, item) > 0.45; // Ambang batas tumpukan 45%
      });
    }
    return results;
  }

  // Menghitung persentase tumpukan antara dua kotak (Intersection over Union)
  double calculateIoU(Map<String, dynamic> a, Map<String, dynamic> b) {
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

  void dispose() => _interpreter?.close();
}