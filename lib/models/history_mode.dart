class HistoryModel {
  final int? id;
  final String imagePath;
  final String detectedClass;
  final String confidenceScore;
  final String detectedAt;

  HistoryModel({
    this.id,
    required this.imagePath,
    required this.detectedClass,
    required this.confidenceScore,
    required this.detectedAt,
  });

  // Konversi dari Model ke Map (untuk simpan ke database)
  Map<String, dynamic> toMap() {
    return {
      'image_path': imagePath,
      'detected_class': detectedClass,
      'confidence_score': confidenceScore,
      'detected_at': detectedAt,
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
    );
  }
}