import 'package:flutter/material.dart';

class DetectionBanner extends StatelessWidget {
  const DetectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF265F61),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Deteksi di sini", style: TextStyle(fontFamily: 'Poppins',color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("Mulailah Deteksi Tanaman Cabaimu", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w300,color: Colors.white, fontSize: 12)),
            ],
          ),
          const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 40,)
        ]
      )
      );
  }
}