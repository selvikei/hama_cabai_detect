import 'package:flutter/material.dart';

class HistoryItemCard extends StatelessWidget {
  const HistoryItemCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFE9EFEF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(8),
            child: Container(
              width: 70,
              height: 70,
              color: Colors.white,
              child: const Icon(Icons.image),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Kutu daun (Aphis Gossypii)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF265F61)),),
              Text("Tanggal : 16 Juni 20205", style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text("Jam : 07.13", style: TextStyle(color: Colors.grey, fontSize: 12),),
            ],
          )
        ],
      ),
    );
  }
}