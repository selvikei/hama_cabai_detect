import 'package:flutter/material.dart';
import 'package:hama_cabai_detect/widgets/detection_banner.dart';
import 'package:hama_cabai_detect/widgets/header_section.dart';
import 'package:hama_cabai_detect/widgets/history_item_card.dart';
import 'package:hama_cabai_detect/widgets/pest_grid_section.dart';
import 'package:hama_cabai_detect/screens/detector_screen.dart';
// Pastikan import database helper dan model
import '../data/database_helper.dart';
import '../models/history_mode.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderSection(),
              const SizedBox(height: 25.0),
              
              // Banner untuk Navigasi ke Kamera
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetectorScreen(),
                    ),
                  );
                },
                child: const DetectionBanner(),
              ),
              
              const SizedBox(height: 25.0),
              const PestGridSection(),
              const SizedBox(height: 25.0),

              // --- BAGIAN RIWAYAT DETEKSI ---
              const Text(
                "Riwayat Deteksi",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E5959),
                ),
              ),
              const SizedBox(height: 15.0),

              // FutureBuilder untuk menarik data dari SQLite
              FutureBuilder<List<HistoryModel>>(
                future: DatabaseHelper.instance.getAllHistory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF2E5959)),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Belum ada riwayat deteksi",
                          style: TextStyle(color: Colors.grey[400]),
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
              const SizedBox(height: 30.0), // Padding bawah agar tidak mepet
            ],
          ),
        ),
      ),
    );
  }
}