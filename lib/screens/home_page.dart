import 'package:flutter/material.dart';
import 'package:hama_cabai_detect/widgets/detection_banner.dart';
import 'package:hama_cabai_detect/widgets/header_section.dart';
import 'package:hama_cabai_detect/widgets/history_item_card.dart';
import 'package:hama_cabai_detect/widgets/pest_grid_section.dart';
import 'package:hama_cabai_detect/screens/detector_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderSection(),
              const SizedBox(height: 25.0),
              // const DetectionBanner(

              // ),
              // Di dalam file home_page.dart atau di widget DetectionBanner
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetectorScreen(),
                    ),
                  );
                },
                child:
                    const DetectionBanner(), // Widget banner hijau yang sudah dibuat
              ),
              const SizedBox(height: 25.0),
              const PestGridSection(),
              const SizedBox(height: 25.0),
              const HistoryItemCard(),
            ],
          ),
        ),
      ),
    );
  }
}
