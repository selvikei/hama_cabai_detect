import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:ui'; // Diperlukan untuk efek Blur (BackdropFilter)
import '../main.dart'; 
import 'result_screen.dart';
import 'package:image_picker/image_picker.dart';

class DetectorScreen extends StatefulWidget {
  const DetectorScreen({super.key});

  @override
  State<DetectorScreen> createState() => _DetectorScreenState();
}

class _DetectorScreenState extends State<DetectorScreen> {
  CameraController? controller;
  int selectedCameraIndex = 0; 

  bool _isProcessing = false; // Indikator loading proses AI
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (cameras.isNotEmpty) {
      initCamera(selectedCameraIndex);
    }
  }

  Future<void> initCamera(int index) async {
    controller = CameraController(
      cameras[index],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await controller!.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      debugPrint("Gagal menyalakan kamera: $e");
    }
  }

  void switchCamera() {
    if (cameras.length < 2) return;
    selectedCameraIndex = selectedCameraIndex == 0 ? 1 : 0;
    initCamera(selectedCameraIndex);
  }

  // --- LOGIKA AMBIL DARI GALERI ---
  Future<void> pickImageFromGallery() async {
  if (_isProcessing) return;

  try {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) return;

    // 1. Aktifkan status loading
    setState(() {
      _isProcessing = true;
    });

    // 2. KUNCI NYA DI SINI: Memberi jeda 100ms agar UI sempat merender 
    // loading overlay sebelum CPU sibuk melakukan inferensi AI.
    await Future.delayed(const Duration(milliseconds: 100));

    // 3. Jalankan prediksi setelah loading muncul di layar
    final results = await tfliteService.predict(pickedFile.path);

    if (!mounted) return;

    // 4. Matikan loading
    setState(() {
      _isProcessing = false;
    });

    // 5. Pindah ke halaman hasil
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          imagePath: pickedFile.path,
          detections: results,
        ),
      ),
    );
  } catch (e) {
    setState(() {
      _isProcessing = false;
    });
    debugPrint("Gagal mengambil gambar dari galeri: $e");
  }
}
  // --- LOGIKA AMBIL DARI KAMERA ---
  Future<void> takePicture() async {
    if (controller == null || !controller!.value.isInitialized || _isProcessing) return;

    try {
      setState(() => _isProcessing = true); // Aktifkan Loading

      final XFile image = await controller!.takePicture();

      // Jalankan Prediksi (Bagian yang memakan waktu lama)
      final results = await tfliteService.predict(image.path);

      if (!mounted) return;
      setState(() => _isProcessing = false); // Matikan Loading

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            imagePath: image.path,
            detections: results,
          ),
        ),
      );
    } catch (e) {
      setState(() => _isProcessing = false);
      debugPrint("Error saat mengambil foto: $e");
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Deteksi", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      // Gunakan Stack agar Loading Overlay bisa tampil di atas Kamera
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: controller!.value.previewSize!.height,
                              height: controller!.value.previewSize!.width,
                              child: CameraPreview(controller!),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.photo_library_outlined, color: Colors.white, size: 32),
                      onPressed: pickImageFromGallery,
                    ),
                    GestureDetector(
                      onTap: takePicture,
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.flip_camera_ios_outlined, color: Colors.white, size: 32),
                      onPressed: switchCamera,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // --- OVERLAY LOADING MODERN ---
          if (_isProcessing)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Efek Blur
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(
                          color: Color(0xFF2E5959),
                          strokeWidth: 5,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "Sedang Menganalisis Hama...",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E5959),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}