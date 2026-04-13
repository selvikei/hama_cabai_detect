import '../models/pest_model.dart';

class PestData {
  static List<Pest> allPests = [
    Pest(
      name: "Kutu Daun",
      scientificName: "Aphis gossypii",
      imagePath: "assets/images/kutu_daun.jpg",
      description: "Kutu daun, seperti Aphis gossypii, merupakan hama penting pada tanaman cabai yang menyerang dengan cara mengisap cairan pada daun, tangkai, bunga, dan buah. Aktivitas tersebut menyebabkan gejala kerusakan seperti daun keriting, pertumbuhan terhambat, dan penurunan kualitas hasil panen. A. gossypii juga berfungsi sebagai vektor virus, seperti virus mosaik dan virus keriting daun, yang dapat menyebar antar tanaman dalam jarak yang relatif jauh. Dampak dari infeksi virus yang dibawa oleh kutu daun ini dapat menyebabkan kerugian hasil hingga lebih dari 90%. Secara morfologis, kutu daun memiliki tubuh kecil dengan variasi warna seperti hijau, hitam, atau cokelat tergantung pada spesiesnya, dan umumnya ditemukan dalam kelompok (koloni) di bagian bawah daun muda.",
      gallery: [
        "assets/images/kutu_daun_1.jpg",
        "assets/images/kutu_daun_2.jpg",
      ],
    ),
    Pest(
      name: "Kutu Kebul",
      scientificName: "Bemisia tabaci",
      imagePath: "assets/images/kutu_kebul.jpg",
      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      gallery: [],
    ),
    Pest(
      name: "Thrips",
      scientificName: "Thrips parvispinus",
      imagePath: "assets/images/thrips.jpg",
      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      gallery: [],
    ),
  ];
}