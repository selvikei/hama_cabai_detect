import 'package:flutter/material.dart';
import 'package:hama_cabai_detect/widgets/detection_banner.dart';
import 'package:hama_cabai_detect/widgets/header_section.dart';
import 'package:hama_cabai_detect/widgets/history_item_card.dart';
import 'package:hama_cabai_detect/widgets/pest_grid_section.dart';
import 'package:hama_cabai_detect/screens/detector_screen.dart';
import 'package:hama_cabai_detect/screens/history_list_screen.dart';

import '../data/database_helper.dart';
import '../models/history_mode.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Fungsi untuk memicu refresh halaman
  void _refreshData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderSection(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DetectorScreen(),
                          ),
                        ).then(
                          (_) => _refreshData(),
                        ); // Refresh saat kembali dari kamera
                      },
                      child: const DetectionBanner(),
                    ),
                    const SizedBox(height: 20.0),
                    const PestGridSection(),
                    const SizedBox(height: 20.0),

                    // --- HEADER RIWAYAT DENGAN IKON PANAH ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Box Teks "Riwayat Deteksi"
                        Container(
                          height: 36, // Tentukan tinggi pasti (misal: 36)
                          alignment:
                              Alignment.center, // Pusatkan teks secara vertikal
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E5959),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Riwayat Deteksi",
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize:
                                  13, // Sedikit disesuaikan agar proporsional
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFE9EFEF),
                            ),
                          ),
                        ),

                        // Tombol Bullet Panah
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HistoryListScreen(),
                              ),
                            ).then((_) => _refreshData());
                          },
                          child: Container(
                            height: 36, // Tinggi harus sama dengan box teks
                            width:
                                36, // Lebar sama dengan tinggi agar jadi lingkaran sempurna
                            decoration: const BoxDecoration(
                              color: Color(0xFFE9EFEF),
                              shape: BoxShape
                                  .circle, // Gunakan shape circle untuk bullet
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size:
                                  14, // Ukuran ikon diperkecil sedikit agar manis dalam bullet
                              color: Color(0xFF2E5959),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "(Riwayat hanya tersimpan secara lokal pada ponsel)",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[600],
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 7.0),

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
                                  fontFamily: 'Inter',
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }

                        // MENGAMBIL 3 DATA TERBARU
                        // diasumsikan getAllHistory() mengembalikan data dari yang lama ke baru,
                        // maka kita reverse lalu ambil 3.
                        final historyList = snapshot.data!.take(3).toList();

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
