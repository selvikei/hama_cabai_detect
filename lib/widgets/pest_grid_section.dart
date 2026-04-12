import 'package:flutter/material.dart';

class PestGridSection extends StatelessWidget {
  const PestGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kita gunakan SingleChildScrollView agar jika hamanya bertambah, 
        // aplikasinya tidak error "overflow" ke samping.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              PestCard(name: "Kutu Daun"),
              PestCard(name: "Kutu Kebul"),
              PestCard(name: "Thrips"),
              // Kamu bisa tambah kartu lagi di sini nanti
            ],
          ),
        ),
      ],
    );
  }
}

class PestCard extends StatelessWidget {
  final String name;

  const PestCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    String imageName = name.toLowerCase().replaceAll(' ', '_');

    return Container(
      width: 110, // Lebar kartu disesuaikan
      height: 160, // Tinggi kartu agar terlihat vertikal seperti di gambar
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey[300], // Warna placeholder sebelum ada gambar asli
        borderRadius: BorderRadius.circular(12),
        // Nanti kalau sudah ada gambar, gunakan dekorasi di bawah ini:
        
        image: DecorationImage(
          image: AssetImage('assets/images/$imageName.jpg'),
          fit: BoxFit.cover,
        ),
        
      ),
      child: Stack(
        children: [
          // Label Nama Hama di bagian bawah
          Positioned(
            bottom: 10,
            left: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Color(0xFFE9EFEF).withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF265F61),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}