import 'package:flutter/material.dart';
import 'dart:io';
import '../models/history_mode.dart';
import '../data/database_helper.dart';

class HistoryDetailScreen extends StatelessWidget {
  final HistoryModel history;

  const HistoryDetailScreen({super.key, required this.history});

  // Fungsi untuk menampilkan dialog konfirmasi dan menghapus data
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Hapus Riwayat"),
          content: const Text("Apakah Anda yakin ingin menghapus riwayat ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                // Pastikan model HistoryModel memiliki field 'id'
                if (history.id != null) {
                  await DatabaseHelper.instance.deleteHistory(history.id!);
                  // Tutup dialog
                  if (context.mounted) Navigator.pop(dialogContext);
                  // Kembali ke halaman sebelumnya (List Riwayat)
                  if (context.mounted) Navigator.pop(context);

                  // Opsional: Tampilkan SnackBar
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Riwayat berhasil dihapus")),
                    );
                  }
                }
              },
              child: const Text("Hapus", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

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
    print("Data Bounding Boxes: ${history.boundingBoxes}");
    // Format Waktu
    DateTime dateTime = DateTime.parse(history.detectedAt);
    String formattedDate =
        "${dateTime.day} Mei ${dateTime.year}"; // Bisa sesuaikan bulan
    String formattedTime =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

    double displaySize = MediaQuery.of(context).size.width - 40;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        title: const Text("Detail Riwayat"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        // ikon delete history
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => _confirmDelete(context),
          ),
        ],
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
                  child: Stack(
                    // WAJIB MENGGUNAKAN STACK UNTUK OVERLAY
                    children: [
                      // 1. Gambar Dasar
                      Image.file(
                        File(history.imagePath),
                        width: displaySize,
                        height: displaySize,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      // 2. Overlay Bounding Boxes
                      // 2. Overlay Bounding Boxes
                      // 2. Overlay Bounding Boxes (Logika disamakan dengan ResultScreen)
                      ...?history.boundingBoxes?.map((det) {
                        if (det == null || det is! Map)
                          return const SizedBox.shrink();

                        // Ambil koordinat sesuai kunci yang ada di console/ResultScreen
                        // Kita gunakan ?? 0.0 sebagai antisipasi jika data null
                        double x = (det['x'] ?? 0.0).toDouble();
                        double y = (det['y'] ?? 0.0).toDouble();
                        double w = (det['w'] ?? 0.0).toDouble();
                        double h = (det['h'] ?? 0.0).toDouble();

                        // Ambil label untuk menentukan warna
                        String label = det['label'] ?? history.detectedClass;
                        Color color = _getBoxColor(label);

                        // Perkalian dengan displaySize (factor)
                        // Karena di ResultScreen kamu mengalikan x, y, w, h langsung dengan displaySize
                        return Positioned(
                          left: x * displaySize,
                          top: y * displaySize,
                          child: Container(
                            width: w * displaySize,
                            height: h * displaySize,
                            decoration: BoxDecoration(
                              border: Border.all(color: color, width: 1),
                              borderRadius: BorderRadius.circular(0),
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
                      _buildInfoRow(
                        Icons.analytics_outlined,
                        "Keyakinan",
                        "${history.confidenceScore}%",
                      ),
                      _buildInfoRow(
                        Icons.calendar_today_outlined,
                        "Tanggal",
                        formattedDate,
                      ),
                      _buildInfoRow(
                        Icons.access_time_outlined,
                        "Waktu",
                        formattedTime,
                      ),
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
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
