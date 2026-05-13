import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hama_cabai_detect/widgets/header_section.dart';
import 'package:hama_cabai_detect/widgets/detection_banner.dart';
import 'package:hama_cabai_detect/widgets/chili_card.dart';
import 'package:hama_cabai_detect/widgets/pest_grid_section.dart';
import 'package:hama_cabai_detect/widgets/history_item_card.dart';
import 'package:hama_cabai_detect/screens/detector_screen.dart';
import 'package:hama_cabai_detect/screens/history_list_screen.dart';
import 'package:hama_cabai_detect/data/database_helper.dart';
import 'package:hama_cabai_detect/models/history_mode.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Fungsi untuk menyegarkan data saat kembali ke halaman ini
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    // List halaman untuk navigasi
    final List<Widget> pages = [
      _buildDashboard(),     // Index 0: Dashboard Utama
      const SizedBox(),      // Index 1: Placeholder untuk Kamera (Tengah)
      const HistoryListScreen(), // Index 2: Halaman Semua Riwayat
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true, // Agar konten terlihat di balik navbar glass
      body: SafeArea(
        bottom: false,
        child: pages[_currentIndex == 1 ? 0 : _currentIndex], // Logika agar index 1 tidak kosong
      ),

      // --- TOMBOL KAMERA MENONJOL ---
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 70,
        width: 70,
        margin: const EdgeInsets.only(top: 20),
        child: FloatingActionButton(
          elevation: 8,
          backgroundColor: const Color(0xFF2E5959),
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DetectorScreen()),
            ).then((_) => _refresh());
          },
          child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 30),
        ),
      ),

      // --- NAVBAR STYLE GLASS ---
      bottomNavigationBar: _buildGlassNavbar(),
    );
  }

  // --- WIDGET DASHBOARD UTAMA (CONTENT) ---
  Widget _buildDashboard() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderSection(), // Full Width
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DetectorScreen()),
                    ).then((_) => _refresh());
                  },
                  child: const DetectionBanner(),
                ),
                const SizedBox(height: 25),
                const ChiliCard(), // Edukasi Cabai
                const SizedBox(height: 25),
                const PestGridSection(), // Info Hama
                const SizedBox(height: 30),
                _buildHistoryHeader(),
                const SizedBox(height: 15),
                _buildHistoryPreview(), // Ambil 3 data terbaru
                const SizedBox(height: 120), // Spasi agar tidak tertutup Navbar
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- LOGIKA NAVBAR GLASS ---
  Widget _buildGlassNavbar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF2E5959).withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navbarItem(Icons.home_rounded, "Home", 0),
                const SizedBox(width: 40), // Ruang Tombol Kamera
                _navbarItem(Icons.history_rounded, "Riwayat", 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navbarItem(IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? const Color(0xFF2E5959) : Colors.black38),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF2E5959) : Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  // Header Riwayat dengan tombol panah (Bullet)
  Widget _buildHistoryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 36,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2E5959),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            "Riwayat Deteksi",
            style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _currentIndex = 2), // Pindah ke tab riwayat
          child: Container(
            height: 36, width: 36,
            decoration: const BoxDecoration(color: Color(0xFFE9EFEF), shape: BoxShape.circle),
            child: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF2E5959)),
          ),
        ),
      ],
    );
  }

  // Preview 3 riwayat terbaru
  Widget _buildHistoryPreview() {
    return FutureBuilder<List<HistoryModel>>(
      future: DatabaseHelper.instance.getAllHistory(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Belum ada riwayat", style: TextStyle(fontFamily: 'Inter', fontSize: 12)));
        }
        final previewList = snapshot.data!.take(3).toList();
        return Column(children: previewList.map((item) => HistoryItemCard(history: item)).toList());
      },
    );
  }
}