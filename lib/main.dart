import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hama_cabai_detect/screens/home_page.dart'; // Pastikan path ini benar
import 'package:hama_cabai_detect/services/tflite_service.dart'; // Import TfliteService untuk digunakan di DetectorScreen

// 1. Variabel global untuk menampung daftar kamera HP
List<CameraDescription> cameras = [];

TfliteService tfliteService = TfliteService();
Future<void> main() async {
  // 2. Pastikan inisialisasi binding Flutter sudah siap
  WidgetsFlutterBinding.ensureInitialized();

  // Pastikan baris ini ada dan menggunakan 'await'
  await tfliteService.loadModel();
  
  try {
    // 3. Ambil daftar kamera sebelum aplikasi dijalankan
    cameras = await availableCameras();
  } catch (e) {
    print("Error saat mengambil kamera: $e");
  }
  
  // 4. Jalankan satu aplikasi utama saja
  runApp(const RobopestApp());
}

class RobopestApp extends StatelessWidget {
  const RobopestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      title: 'Robopest',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F9F5), // Warna background tema kamu
        useMaterial3: true,
        primaryColor: const Color(0xFF2E5959),
      ),
      // 5. Langsung arahkan ke HomePage
      home: const HomePage(),
    );
  }
}