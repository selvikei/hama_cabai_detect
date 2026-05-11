import 'package:flutter/material.dart';
import 'dart:io';
import '../models/history_mode.dart';

class HistoryDetailScreen extends StatelessWidget {
  final HistoryModel history;

  const HistoryDetailScreen({super.key, required this.history});

  // Gunakan logika warna yang sama dengan ResultScreen
  Color _getBoxColor(String label) {
    String cleanLabel = label.trim().toLowerCase();
    if (cleanLabel.contains('daun')) return Colors.purple;
    if (cleanLabel.contains('kebul')) return Colors.red;
    if (cleanLabel.contains('thrips')) return Colors.blue;
    return const Color(0xFF2E5959);
  }

  @override
  Widget build(BuildContext context) {
    // Format Waktu
    DateTime dateTime = DateTime.parse(history.detectedAt);
    String formattedDate = "${dateTime.day} Mei ${dateTime.year}"; // Bisa sesuaikan bulan
    String formattedTime = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

    double displaySize = MediaQuery.of(context).size.width - 40;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        title: const Text("Detail Riwayat"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // --- TAMPILAN GAMBAR ---
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
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    File(history.imagePath),
                    width: displaySize,
                    height: displaySize,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // --- KARTU INFORMASI ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hasil Identifikasi",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        history.detectedClass,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _getBoxColor(history.detectedClass),
                        ),
                      ),
                      const Divider(height: 30),
                      
                      // Info Detail
                      _buildInfoRow(Icons.analytics_outlined, "Keyakinan", "${history.confidenceScore}%"),
                      _buildInfoRow(Icons.calendar_today_outlined, "Tanggal", formattedDate),
                      _buildInfoRow(Icons.access_time_outlined, "Waktu", formattedTime),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF2E5959)),
          const SizedBox(width: 15),
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.black54)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }
}