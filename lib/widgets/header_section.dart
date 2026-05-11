import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFE9EFEF),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFF265F61),
            child: Icon(
              Icons.bug_report,
              color: Colors.pinkAccent, //bisa diganti images asset
            ),
          ),
          const SizedBox(width: 15.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Hallo, Teman Cabai!",
                  style: TextStyle(fontFamily: 'LeagueSpartan',fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Periksa kondisi tanaman cabaimu",
                  style: TextStyle(fontFamily: 'LeagueSpartan', fontWeight: FontWeight.w200, fontSize: 14,color: Colors.grey),
                )
              ],
            ),
          ),
          const Icon(Icons.info_outline, size: 28,)
        ],
      ),
    );
  }
}
