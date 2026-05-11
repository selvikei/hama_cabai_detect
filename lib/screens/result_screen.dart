import 'package:flutter/material.dart';
import 'dart:io';
import '../data/database_helper.dart';
import '../models/history_mode.dart';

class ResultScreen extends StatelessWidget {
  final String imagePath;
  final List<Map<String, dynamic>> detections;

  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.detections,
  });

  // Fungsi Helper untuk menentukan warna (Hama = Warna khusus, Tidak ada = Hijau)
  Color _getBoxColor(String label) {
    String cleanLabel = label.trim().toLowerCase();
    if (cleanLabel.contains('daun')) return Colors.purple;
    if (cleanLabel.contains('kebul')) return Colors.red;
    if (cleanLabel.contains('thrips')) return Colors.blue;
    if (cleanLabel.contains('tidak terdapat hama'))
      return Color(0xFF2E5959); // Hijau asal
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    double displaySize = MediaQuery.of(context).size.width - 40;

    // Data label utama
    String topLabel = detections.isNotEmpty
        ? detections[0]['label']
        : "Tidak Terdapat Hama";

    // Ambil confidence score untuk disimpan ke history (walaupun tidak ditampilkan di UI)
    String topConfidence = detections.isNotEmpty
        ? detections[0]['confidence']
        : "0.0";

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        title: const Text("Hasil Deteksi"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- AREA GAMBAR & BOUNDING BOX ---
            Center(
              child: Container(
                width: displaySize,
                height: displaySize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Image.file(
                        File(imagePath),
                        width: displaySize,
                        height: displaySize,
                        fit: BoxFit.fill,
                      ),
                      // Gambar semua kotak tanpa teks
                      ...detections.map((det) {
                        double x = det['x'] * displaySize;
                        double y = det['y'] * displaySize;
                        double w = det['w'] * displaySize;
                        double h = det['h'] * displaySize;
                        Color color = _getBoxColor(det['label']);

                        return Positioned(
                          left: x,
                          top: y,
                          child: Container(
                            width: w,
                            height: h,
                            decoration: BoxDecoration(
                              border: Border.all(color: color, width: 1.5),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // --- KARTU HASIL SEDERHANA ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 0,
                color: const Color(0xFFF0F7F0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: Color(0xFF2E5959), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 20,
                  ),
                  child: Center(
                    child: Text(
                      topLabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _getBoxColor(
                          topLabel,
                        ), // Hijau jika tidak ada hama
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // --- TOMBOL AKSI SEJAJAR ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      // Di dalam ResultScreen, pada bagian ElevatedButton "Simpan"
                      onPressed: () async {
                        final history = HistoryModel(
                          imagePath: imagePath,
                          detectedClass: topLabel,
                          confidenceScore: topConfidence,
                          detectedAt: DateTime.now().toString(),
                        );

                        await DatabaseHelper.instance.insertHistory(history);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Berhasil disimpan ke riwayat!"),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E5959),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Simpan",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: const BorderSide(
                          color: Color(0xFF2E5959),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Deteksi Lagi",
                        style: TextStyle(
                          color: Color(0xFF2E5959),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
