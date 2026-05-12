import 'dart:convert';

class HistoryModel {
  final int? id;
  final String imagePath;
  final String detectedClass;
  final String confidenceScore;
  final String detectedAt;
  final List<dynamic>? boundingBoxes;

  HistoryModel({
    this.id,
    required this.imagePath,
    required this.detectedClass,
    required this.confidenceScore,
    required this.detectedAt,
    required this.boundingBoxes,
  });

  // Konversi dari Model ke Map (untuk simpan ke database)
  Map<String, dynamic> toMap() {
    return {
      'image_path': imagePath,
      'detected_class': detectedClass,
      'confidence_score': confidenceScore,
      'detected_at': detectedAt,
      'bounding_boxes': jsonEncode(boundingBoxes),
    };
  }

  // Konversi dari Map ke Model (untuk ambil dari database)
  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      id: map['ID'],
      imagePath: map['image_path'],
      detectedClass: map['detected_class'],
      confidenceScore: map['confidence_score'],
      detectedAt: map['detected_at'],
      boundingBoxes: jsonDecode(map['bounding_boxes'] ?? '[]'),
    );
  }
}