import 'package:flutter/material.dart';

class PestDetailScreen extends StatelessWidget {
  final String name;
  final String description;
  final String imagePath;
  final List<String> sources;

  const PestDetailScreen({
    super.key,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.sources,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F7F3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Gambar Utama
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              // 2. Label Definisi
              const SectionTag(label: "Definisi"),
              const SizedBox(height: 12),

              // 3. Teks Deskripsi
              Text(
                description,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 25),

              // 4. BAGIAN SUMBER DATA
              const SectionTag(label: "Sumber Data"),
              const SizedBox(height: 12),

              // Melakukan mapping dari list sources ke widget Text
              ...sources
                  .map(
                    (source) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "• ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Text(
                              source,
                              style: TextStyle(
                                fontSize: 12,
                                color: const Color.fromARGB(255, 62, 62, 62),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),

              const SizedBox(height: 25),

              // // 4. Label Galeri
              // const SectionTag(label: "Galeri"),
              // const SizedBox(height: 12),

              // // 5. List Galeri Horizontal
              // SizedBox(
              //   height: 100,
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: 5, // Sesuaikan jumlah gambar galeri
              //     itemBuilder: (context, index) {
              //       return Container(
              //         width: 100,
              //         margin: const EdgeInsets.only(right: 12),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(12),
              //           image: DecorationImage(
              //             image: AssetImage(imagePath), // Sementara pakai imagePath yang sama
              //             fit: BoxFit.cover,
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget untuk Label (Definisi & Galeri) agar konsisten
class SectionTag extends StatelessWidget {
  final String label;
  const SectionTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2E5959), // Warna Teal sesuai desain Robopest
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
