import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../main.dart'; // Import variabel 'cameras' dari main.dart
import 'result_screen.dart'; 
import 'package:image_picker/image_picker.dart';

class DetectorScreen extends StatefulWidget {
  const DetectorScreen({super.key});

  @override
  State<DetectorScreen> createState() => _DetectorScreenState();
}

class _DetectorScreenState extends State<DetectorScreen> {
  CameraController? controller;
  int selectedCameraIndex = 0; // 0 = Kamera Belakang, 1 = Kamera Depan

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile == null) return; 

      // 1. Tangkap hasil berupa List dari TfliteService
      final results = await tfliteService.predict(pickedFile.path);

      if (!mounted) return;

      // 2. Kirim List 'results' ke ResultScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            imagePath: pickedFile.path,
            detections: results, // Kirim seluruh list di sini
          ),
        ),
      );
    } catch (e) {
      debugPrint("Gagal mengambil gambar dari galeri: $e");
    }
  }

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

  bool isTakingPicture = false;

  Future<void> takePicture() async {
    if (controller == null ||
        !controller!.value.isInitialized ||
        isTakingPicture) return;

    try {
      setState(() {
        isTakingPicture = true;
      });

      final XFile image = await controller!.takePicture();

      // 1. Tangkap hasil berupa List
      final results = await tfliteService.predict(image.path);

      if (!mounted) return;

      // 2. Pindah ke ResultScreen membawa seluruh data kotak
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            imagePath: image.path,
            detections: results, // Kirim seluruh list di sini
          ),
        ),
      );

      setState(() {
        isTakingPicture = false;
      });
    } catch (e) {
      setState(() {
        isTakingPicture = false;
      });
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
      body: Column(
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
    );
  }
}