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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Hama Pada Cabai",
            style: TextStyle(
              fontFamily: 'LeagueSpartan',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E5959),
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        // --- GRID KREATIF ---
        // Kita gunakan GridView dengan jumlah kolom 2 (CrossAxisCount: 2)
        GridView.builder(
          shrinkWrap: true, // Penting agar bisa masuk dalam SingleChildScrollView Home
          physics: const NeverScrollableScrollPhysics(), // Scroll mengikuti utama
          itemCount: 3, // Kutu Daun, Kutu Kebul, Thrips
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85, // Mengatur rasio tinggi/lebar kartu
          ),
          itemBuilder: (context, index) {
            // List nama hama
            final pestNames = ["Kutu Daun", "Kutu Kebul", "Thrips"];
            return ModernPestCard(name: pestNames[index]);
          },
        ),
      ],
    );
  }
}

class ModernPestCard extends StatelessWidget {
  final String name;

  const ModernPestCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    String imageName = name.toLowerCase().replaceAll(' ', '_');

    return GestureDetector(
      onTap: () {
        final selectedPest = PestData.allPests.firstWhere(
          (p) => p.name == name,
          orElse: () => PestData.allPests[0],
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PestDetailScreen(
              name: selectedPest.name,
              description: selectedPest.description,
              imagePath: selectedPest.imagePath,
              sources: selectedPest.sources,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // 1. Gambar Background
              Image.asset(
                'assets/images/$imageName.jpg',
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.bug_report, color: Colors.white),
                ),
              ),

              // 2. Gradient Overlay (Agar teks terbaca jelas)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),

              // 3. Konten Teks (Nama Hama)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Text(
                          "Lihat Detail",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 8, color: Colors.white70),
                      ],
                    ),
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