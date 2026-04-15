import 'package:flutter/material.dart';
import 'dart:io';

class ResultScreen extends StatelessWidget {
  final String imagePath;
  final String label;
  final String confidence;
  // Tambahkan koordinat (biasanya dalam skala 0.0 sampai 1.0)
  final double x, y, w, h;

  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.label,
    required this.confidence,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    print("DEBUG BOX: x=$x, y=$y, w=$w, h=$h, label=$label");
    // Ambil ukuran lebar layar HP user
    // 1. Tentukan lebar tampilan (lebar layar dikurangi padding)
    double displaySize = MediaQuery.of(context).size.width - 40;

    // Menghitung posisi kotak (Skala 640 ke ukuran layar)
    double left = x * displaySize;
    double top = y * displaySize;
    double width = w * displaySize;
    double height = h * displaySize;

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
            // BUNGKUS DENGAN CENTER AGAR POSISI DI TENGAH
            Center(
              child: Container(
                width: displaySize,
                height: displaySize, // PAKSA JADI KOTAK (1:1)
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
                        fit: BoxFit
                            .fill, // FIT FILL agar sama dengan input 640x640 model
                      ),

                      // BOUNDING BOX
                      if (double.tryParse(confidence) != null &&
                          double.parse(confidence) > 50)
                        Positioned(
                          // Koordinat x, y, w, h (0.0 - 1.0) dikalikan dengan ukuran kotak tampilan
                          left: x * displaySize,
                          top: y * displaySize,
                          child: Container(
                            width: w * displaySize,
                            height: h * displaySize,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                color: Colors.red,
                                padding: const EdgeInsets.all(2),
                                child: Text(
                                  "$label $confidence%",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
            // 2. Kartu Detail Hasil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 0,
                color: const Color(0xFFF0F7F0), // Hijau sangat muda
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: Color(0xFF2E5959), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E5959),
                        ),
                      ),
                      const Divider(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tingkat Akurasi",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "$confidence%",
                            style: TextStyle(
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

            // 3. Tombol Aksi
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
