import 'package:flutter/material.dart';
import 'package:hama_cabai_detect/widgets/detection_banner.dart';
import 'package:hama_cabai_detect/widgets/header_section.dart';
import 'package:hama_cabai_detect/widgets/history_item_card.dart';
import 'package:hama_cabai_detect/widgets/pest_grid_section.dart';
import 'package:hama_cabai_detect/screens/detector_screen.dart';

// Import sesuai path yang kamu berikan
import '../data/database_helper.dart';
import '../models/history_mode.dart'; // Jika ini typo dari history_model, pastikan namanya sesuai filemu

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // PADDING UTAMA DIHAPUS agar HeaderSection bisa full width
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER SECTION (Full Width / Tanpa Padding)
              const HeaderSection(),

              // 2. KONTEN LAINNYA (Diberi Padding 16.0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25.0),

                    // Banner untuk Navigasi ke Kamera
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DetectorScreen(),
                          ),
                        ).then((value) {
                          // Opsional: Refresh halaman saat kembali dari deteksi
                          // (Mengingat ini StatelessWidget, kamu mungkin perlu
                          // mengubahnya ke StatefulWidget jika ingin refresh otomatis)
                        });
                      },
                      child: const DetectionBanner(),
                    ),

                    const SizedBox(height: 25.0),
                    const PestGridSection(),
                    const SizedBox(height: 25.0),

                    // --- BAGIAN RIWAYAT DETEKSI ---
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E5959),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "Riwayat Deteksi",
                        style: TextStyle(
                          fontFamily:
                              'PlusJakartaSans', // Menggunakan font baru
                          fontSize: 14,
                          fontWeight: FontWeight.w500, // Medium sesuai pubspec
                          color: Color(0xFFE9EFEF),
                        ),
                      ),
                    ),
                    Text(
                      "(Riwayat hanya tersimpan secara lokal pada ponsel)",
                      style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey[600], fontSize: 10, fontFamily: 'Inter', fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 15.0),

                    // FutureBuilder untuk menarik data dari SQLite
                    FutureBuilder<List<HistoryModel>>(
                      future: DatabaseHelper.instance.getAllHistory(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: CircularProgressIndicator(
                                color: Color(0xFF2E5959),
                              ),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: Text(
                                "Belum ada riwayat deteksi",
                                style: TextStyle(
                                  fontFamily: 'Inter', // Menggunakan font Inter
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }

                        final historyList = snapshot.data!;

                        // Tampilkan daftar history secara dinamis
                        return Column(
                          children: historyList.map((item) {
                            return HistoryItemCard(history: item);
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 30.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
