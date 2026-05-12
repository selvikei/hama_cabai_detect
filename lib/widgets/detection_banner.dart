import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetectionBanner extends StatelessWidget {
  const DetectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Gunakan width: double.infinity agar container mengambil lebar layar yang tersedia
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF265F61),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.max, // Memastikan Row mengambil ruang maksimal
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Beri jarak antara teks dan ikon
        children: [
          // 1. Gunakan Flexible agar Column bisa menyesuaikan diri
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Deteksi di sini",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize:
                        22, // Saya kecilkan sedikit dari 24 ke 22 agar lebih aman
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Mulailah Deteksi Tanaman Cabaimu",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  softWrap: true, // Paksa teks untuk turun ke bawah jika mentok
                ),
              ],
            ),
          ),

          // 2. Beri jarak tetap antara teks dan ikon
          const SizedBox(width: 5),

          // 3. Ikon Kamera (Bungkus dengan SizedBox agar ukurannya kaku/tidak berubah)
          Container(
            padding: const EdgeInsets.all(2), // Beri padding agar ikon tidak terlalu mepet
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5), // Tambahkan latar belakang transparan
              borderRadius: BorderRadius.circular(45), // Tambahkan border radius agar lebih rapi
            ),

            child: SizedBox(
             
              width: 50, // Sedikit diperkecil agar memberi ruang lebih untuk teks
              height: 50,
              child: SvgPicture.asset(
                // Ganti Image.asset menjadi SvgPicture.asset
                'assets/icons/aperture.svg',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
