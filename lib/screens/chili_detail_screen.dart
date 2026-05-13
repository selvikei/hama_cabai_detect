import 'package:flutter/material.dart';

class ChiliDetailScreen extends StatelessWidget {
  const ChiliDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Informasi Komoditas"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pentingnya Komoditas Cabai",
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontSize: 24,
                fontWeight: FontWeight.w300,
                color: Color(0xFF2E5959),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Cabai merupakan salah satu komoditas hortikultura penting di Indonesia yang memiliki nilai ekonomi tinggi dan menjadi bagian tak terpisahkan dari konsumsi harian masyarakat.",
              style: TextStyle(fontFamily: 'Inter', fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 25),
            
            // TABEL KONSUMSI
            const Text(
              "Data Konsumsi Nasional (2023)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              children: [
                _buildTableRow("Jenis Cabai", "Konsumsi (kg/kapita)", isHeader: true),
                _buildTableRow("Cabai Besar", "2,42"),
                _buildTableRow("Cabai Rawit", "2,19"),
              ],
            ),
            const Text(
              "*Sumber: Bapanas / Katadata (2024)",
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
            ),

            const SizedBox(height: 30),
            const Text(
              "Tantangan Produksi",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              "Produksi cabai sering kali menghadapi kendala serius akibat serangan organisme pengganggu tanaman (OPT), terutama hama seperti kutu daun (Aphids), thrips, dan kutu kebul (Bemisia tabaci). Hama-hama tersebut menyerang bagian daun, batang, dan buah sehingga dapat menurunkan kualitas maupun kuantitas hasil panen.",
              style: TextStyle(fontFamily: 'Inter', fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 10),
            const Text(
              "Serangan thrips misalnya, menyebabkan daun menggulung dan buah gagal tumbuh optimal sehingga menghambat produktivitas.",
              style: TextStyle(fontFamily: 'Inter', fontSize: 15, height: 1.5),
            ),

            const SizedBox(height: 30),
            const Text(
              "Solusi Teknologi",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              "Dibutuhkan sistem deteksi hama berbasis teknologi, seperti model berbasis deep learning, untuk mempercepat proses identifikasi dan mendukung pengendalian hama secara tepat sasaran demi menjaga kelestarian lingkungan serta kesehatan manusia.",
              style: TextStyle(fontFamily: 'Inter', fontSize: 15, height: 1.5),
            ),

            const Divider(height: 60),
            const Text(
              "Daftar Pustaka",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),
            _buildReference("[1] Yasen, N., dkk. (2023). Pemanfaatan YOLO untuk Deteksi Hama dan Penyakit pada Daun Cabai Menggunakan Metode Deep Learning. Elektron: Jurnal Ilmiah."),
            _buildReference("[17] Wardhana, I. M. A., & Wibawa, G. A. (2022). Klasifikasi Jenis Hama pada Tanaman Cabai Menggunakan Metode CNN dan YOLOv5. Jurnal Teknologi Pertanian Unud."),
            _buildReference("[18] Katadata Databoks. (2024). Konsumsi Cabai per Kapita Indonesia Naik, Rekor Tertinggi pada 2023."),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String col1, String col2, {bool isHeader = false}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(col1, style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal)),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(col2, style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal)),
        ),
      ],
    );
  }

  Widget _buildReference(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.black54)),
    );
  }
}