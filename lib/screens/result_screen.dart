import 'package:flutter/material.dart';
import 'dart:io';

class ResultScreen extends StatelessWidget {
  final String imagePath;
  // Menangkap List hasil deteksi dari DetectorScreen
  final List<Map<String, dynamic>> detections;

  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.detections,
  });

  Color _getBoxColor(String label) {
    // Ubah ke huruf kecil dan hapus spasi di ujung agar pencocokan lebih akurat
    String cleanLabel = label.trim().toLowerCase();

    if (cleanLabel.contains('daun')) {
      return Colors.purple;
    } else if (cleanLabel.contains('kebul')) {
      return Colors.red;
    } else if (cleanLabel.contains('thrips')) {
      return Colors.blue;
    } else {
      return Colors.black; // Warna jika tidak ada yang cocok
    }
  }

  @override
  Widget build(BuildContext context) {
    double displaySize = MediaQuery.of(context).size.width - 40;

    // Ambil data untuk card ringkasan di bawah
    // Jika ada deteksi, ambil hama dengan confidence tertinggi (urutan pertama)
    String topLabel = detections.isNotEmpty
        ? detections[0]['label']
        : "Tidak Terdapat Hama";
    String topConfidence = detections.isNotEmpty
        ? detections[0]['confidence']
        : "0.0";
    int totalDetected = detections.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Deteksi"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: displaySize,
                height: displaySize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // GAMBAR ASLI
                      Image.file(
                        File(imagePath),
                        width: displaySize,
                        height: displaySize,
                        fit: BoxFit.fill,
                      ),

                      // LOOPING BOUNDING BOX (MENGGAMBAR SEMUA KOTAK)
                      ...detections.map((det) {
                        double x = det['x'] * displaySize;
                        double y = det['y'] * displaySize;
                        double w = det['w'] * displaySize;
                        double h = det['h'] * displaySize;

                        return Positioned(
                          left: x,
                          top: y,
                          child: Container(
                            width: w,
                            height: h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _getBoxColor(det['label']),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            // child: Align(
                            //   alignment: Alignment.topLeft,
                            //   child: Container(
                            //     color: Colors.red,
                            //     padding: const EdgeInsets.all(0),
                            //     child: Text(
                            //       "${det['label']} ${det['confidence']}%",
                            //       style: const TextStyle(
                            //         color: Colors.white,
                            //         fontSize: 8, // Diperkecil agar tidak menutupi hama lain
                            //         fontWeight: FontWeight.bold,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // KARTU DETAIL HASIL (Menampilkan hama terbanyak/tertinggi)
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        topLabel,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E5959),
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Tambahan info jumlah hama yang terdeteksi
                      if (totalDetected > 0)
                        Text(
                          "Terdeteksi $totalDetected objek",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      const Divider(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Skor Prediksi",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "$topConfidence%",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // TOMBOL AKSI
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Logika simpan riwayat
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E5959),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Simpan ke Riwayat",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: Color(0xFF2E5959)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Deteksi Lagi",
                      style: TextStyle(color: Color(0xFF2E5959)),
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
