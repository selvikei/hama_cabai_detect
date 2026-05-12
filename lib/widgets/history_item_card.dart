import 'package:flutter/material.dart';
import 'dart:io';
import '../models/history_mode.dart'; // Pastikan import model kamu
import '../screens/history_detail_screen.dart'; // Pastikan import screen detail

class HistoryItemCard extends StatelessWidget {
  final HistoryModel history;
  final VoidCallback? onDelete; // Opsional: untuk fitur hapus

  const HistoryItemCard({
    super.key, 
    required this.history,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Parsing tanggal dan waktu
    DateTime dateTime = DateTime.parse(history.detectedAt);
    String datePart = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    String timePart = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

    return GestureDetector(
      onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HistoryDetailScreen(history: history),
        ),
      );
    },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: const Color(0xFFE9EFEF),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            // Tampilkan Gambar dari File Path
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 90,
                height: 90,
                child: Image.file(
                  File(history.imagePath),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.white,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    history.detectedClass,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16, 
                      color: Color(0xFF265F61),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("Tanggal : $datePart", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(height: 6),
                  Text("Jam : $timePart", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            // Ikon Hapus jika diperlukan
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}