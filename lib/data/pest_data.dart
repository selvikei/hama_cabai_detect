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
      description: "Kutu kebul, atau Bemisia tabaci, merupakan salah satu hama utama pada tanaman cabai yang menyerang dengan cara mengisap cairan sel daun. Aktivitas makan ini menyebabkan daun mengalami klorosis (menguning), pertumbuhan tanaman menjadi kerdil, dan penurunan produktivitas yang signifikan. Selain kerusakan langsung, kutu kebul sangat diwaspadai karena perannya sebagai vektor utama virus gemini (Pepper Yellow Leaf Curl Virus) yang menyebabkan penyakit bule atau kuning pada cabai, dengan potensi kehilangan hasil mencapai 20% hingga 100% pada serangan berat. Hama ini mengekskresikan embun madu yang memicu pertumbuhan jamur jelaga (embun jelaga) pada permukaan daun, sehingga menghambat proses fotosintesis. Secara morfologis, kutu kebul dewasa berukuran sangat kecil (1-1,5 mm), berwarna putih karena tubuhnya tertutup lapisan lilin tepung, dan biasanya berkerumun di sisi bawah daun.",
      gallery: [],
    ),
    Pest(
      name: "Thrips",
      scientificName: "Thrips parvispinus",
      imagePath: "assets/images/thrips.jpg",
      description: "Thrips, khususnya spesies Thrips parvispinus, adalah hama penghisap cairan daun yang sangat merusak pada berbagai fase pertumbuhan tanaman cabai. Gejala serangan khas ditandai dengan adanya bercak-bercak keperakan pada permukaan bawah daun yang kemudian berubah menjadi cokelat tembaga, serta menyebabkan tepi daun melengkung ke atas atau mengeriting. Serangan pada pucuk tanaman dapat menyebabkan tunas baru terhenti pertumbuhannya (stagnan) dan bunga menjadi rontok. Serupa dengan hama penghisap lainnya, Thrips berperan sebagai vektor virus penting seperti Tomato Spotted Wilt Virus (TSWV). Secara visual, Thrips memiliki tubuh yang sangat ramping, berwarna kuning pucat hingga cokelat kehitaman, dan sangat aktif bergerak sehingga sulit dideteksi dengan mata telanjang tanpa bantuan alat pembesar.",
      gallery: [],
    ),
  ];
}