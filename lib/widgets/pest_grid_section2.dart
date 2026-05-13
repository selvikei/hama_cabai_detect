import 'package:flutter/material.dart';
import '../data/pest_data.dart';
import '../screens/pest_detail_screen.dart';

class PestGridSection extends StatelessWidget {
  const PestGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- HEADER SEKSI ---
        // const Text(
        //   "Hama pada Cabai",
        //   style: TextStyle(
        //     fontFamily: 'LeagueSpartan',
        //     fontSize: 22,
        //     fontWeight: FontWeight.bold,
        //     color: Color(0xFF2E5959),
        //   ),
        // ),
        // const SizedBox(height: 15),

        // --- LIST VERTIKAL KREATIF ---
        // Menggunakan Column agar mengikuti scroll utama di HomePage
        Column(
          children: [
            _buildListCard(context, "Kutu Daun"),
            _buildListCard(context, "Kutu Kebul"),
            _buildListCard(context, "Thrips"),
          ],
        ),
      ],
    );
  }

  Widget _buildListCard(BuildContext context, String name) {
    // Mencari data hama untuk mendapatkan ringkasan singkat
    final pest = PestData.allPests.firstWhere((p) => p.name == name);
    String imageName = name.toLowerCase().replaceAll(' ', '_');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PestDetailScreen(
              name: pest.name,
              description: pest.description,
              imagePath: pest.imagePath,
              sources: pest.sources,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // 1. Gambar Hama (Kiri)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.asset(
                'assets/images/$imageName.jpg',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 120,
                  color: Colors.grey[200],
                  child: const Icon(Icons.bug_report, color: Colors.grey),
                ),
              ),
            ),

            // 2. Info Singkat (Kanan)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E5959),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Menyerang bagian daun, batang, dan buah tanaman.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    const Row(
                      children: [
                        Text(
                          "Pelajari Penanganan",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E5959),
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.arrow_forward, size: 12, color: Color(0xFF2E5959)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}