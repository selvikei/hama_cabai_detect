import 'package:flutter/material.dart';

class DetectionBanner extends StatelessWidget {
  const DetectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF265F61),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Deteksi di sini", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text("Mulailah Deteksi Hama Cabaimu", style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
          const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 40,)
        ]
      )
      );
  }
}