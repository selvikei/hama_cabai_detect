import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/history_mode.dart';
import '../widgets/history_item_card.dart';

class HistoryListScreen extends StatefulWidget {
  const HistoryListScreen({super.key});

  @override
  State<HistoryListScreen> createState() => _HistoryListScreenState();
}

class _HistoryListScreenState extends State<HistoryListScreen> {
  // Fungsi untuk menghapus semua riwayat (opsional)
  // Tambahkan/Update fungsi ini di dalam class _HistoryListScreenState
  void _clearAllHistory() async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Semua"),
        content: const Text("Apakah Anda yakin ingin menghapus seluruh riwayat deteksi? Tindakan ini tidak dapat dibatalkan."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus Semua", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // PROSES HAPUS DI DATABASE
      await DatabaseHelper.instance.deleteAllHistory(); 
      
      // REFRESH UI
      setState(() {}); 

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Semua riwayat telah dibersihkan")),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Semua Riwayat",
          style: TextStyle(
            color: Color(0xFF2E5959),
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'PlusJakartaSans',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2E5959)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Tombol Hapus Semua (Opsional)
          IconButton(
            onPressed: _clearAllHistory,
            icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
          ),
        ],
      ),
      body: FutureBuilder<List<HistoryModel>>(
        future: DatabaseHelper.instance.getAllHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2E5959)),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_rounded, size: 60, color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  Text(
                    "Belum ada riwayat",
                    style: TextStyle(color: Colors.grey[400], fontSize: 16),
                  ),
                ],
              ),
            );
          }

          // Urutkan dari yang terbaru ke terlama
          final allHistory = snapshot.data!.reversed.toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            itemCount: allHistory.length,
            itemBuilder: (context, index) {
              final item = allHistory[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: HistoryItemCard(history: item),
              );
            },
          );
        },
      ),
    );
  }
}