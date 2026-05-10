# Menjaga TensorFlow Lite agar tidak dihapus atau diacak oleh R8
-keep class org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.gpu.** { *; }

# Mengabaikan peringatan class yang hilang yang menghentikan build
-dontwarn org.tensorflow.lite.gpu.**
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.**