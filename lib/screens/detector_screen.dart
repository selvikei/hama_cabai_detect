import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../main.dart'; // Import variabel 'cameras' dari main.dart
import 'result_screen.dart'; // Pastikan sudah membuat file ini
import 'package:image_picker/image_picker.dart';

class DetectorScreen extends StatefulWidget {
  const DetectorScreen({super.key});

  @override
  State<DetectorScreen> createState() => _DetectorScreenState();
}

class _DetectorScreenState extends State<DetectorScreen> {
  CameraController? controller;
  int selectedCameraIndex = 0; // 0 = Kamera Belakang, 1 = Kamera Depan

  final ImagePicker _picker = ImagePicker(); // Instance untuk ambil gambar

  Future<void> pickImageFromGallery() async {
    try {
      // 1. Buka Galeri dan pilih gambar
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile == null) return; // User batal pilih gambar

      // 2. Jalankan prediksi model YOLOv8 pada foto tersebut
      final result = await tfliteService.predict(pickedFile.path);

      if (!mounted) return;

      // 3. Langsung pindah ke ResultScreen membawa data asli deteksi
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            imagePath: pickedFile.path,
            label: result['label'], // Hasil dari TfliteService
            confidence: result['confidence']
                .toString(), // Akurasi dari TfliteService
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
    // Nyalakan kamera pertama kali (biasanya belakang)
    if (cameras.isNotEmpty) {
      initCamera(selectedCameraIndex);
    }
  }

  // Fungsi inisialisasi kamera
  Future<void> initCamera(int index) async {
    controller = CameraController(
      cameras[index],
      ResolutionPreset.high,
      enableAudio: false, // Tidak perlu audio untuk deteksi hama
    );

    try {
      await controller!.initialize();
      if (!mounted) return;
      setState(() {}); // Update tampilan setelah kamera siap
    } catch (e) {
      debugPrint("Gagal menyalakan kamera: $e");
    }
  }

  // Fungsi ganti kamera depan/belakang
  void switchCamera() {
    if (cameras.length < 2) return; // Jika kamera cuma satu, jangan ganti

    selectedCameraIndex = selectedCameraIndex == 0 ? 1 : 0;
    initCamera(selectedCameraIndex);
  }

  bool isTakingPicture =
      false; // Tambahkan variabel ini di dalam _DetectorScreenState

  Future<void> takePicture() async {
    if (controller == null ||
        !controller!.value.isInitialized ||
        isTakingPicture)
      return;

    try {
      setState(() {
        isTakingPicture = true;
      }); // Kunci tombol agar tidak ditekan 2x

      final XFile image = await controller!.takePicture();

      // Jalankan prediksi model YOLOv8 pada foto yang baru diambil
      final result = await tfliteService.predict(image.path);

      if (!mounted) return;

      // Pindah ke ResultScreen sambil membawa path gambarnya
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            imagePath: image.path,
            label: result["label"],
            confidence: result["confidence"].toString(),
          ),
        ),
      );

      setState(() {
        isTakingPicture = false;
      }); // Buka kunci setelah kembali
    } catch (e) {
      setState(() {
        isTakingPicture = false;
      });
      debugPrint("Error saat mengambil foto: $e");
    }
  }

  // Fungsi ambil foto
  // Future<void> takePicture() async {
  //   if (controller == null || !controller!.value.isInitialized) return;

  //   try {
  //     final XFile image = await controller!.takePicture();

  //     if (!mounted) return;

  //     // Setelah foto diambil, langsung pindah ke halaman hasil
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => ResultScreen(imagePath: image.path),
  //       ),
  //     );
  //   } catch (e) {
  //     debugPrint("Error saat mengambil foto: $e");
  //   }
  // }

  @override
  void dispose() {
    controller?.dispose(); // PENTING: Matikan kamera saat keluar halaman
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Jika kamera belum siap, tampilkan loading hitam
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
          // Tampilan kamera asli
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
                        fit: BoxFit
                            .cover, // Ini kuncinya! Gambar akan dipotong dikit tapi tidak penyet
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

          // Kontrol Bawah
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tombol Galeri
                IconButton(
                  icon: const Icon(
                    Icons.photo_library_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () {
                    pickImageFromGallery();
                    // TODO: Implementasi ambil dari galeri
                  },
                ),

                // Tombol Shutter (Ambil Foto)
                GestureDetector(
                  onTap: takePicture, // Panggil fungsi ambil foto
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

                // Tombol Ganti Kamera
                IconButton(
                  icon: const Icon(
                    Icons.flip_camera_ios_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: switchCamera, // Panggil fungsi ganti kamera
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
