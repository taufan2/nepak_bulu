# Nepak Bulu 2

Aplikasi Flutter untuk manajemen matchmaking bulutangkis dengan fitur lanjutan.

## Deskripsi Proyek

Nepak Bulu 2 adalah aplikasi Flutter yang dirancang untuk membantu pengelolaan matchmaking bulutangkis secara otomatis dan efisien. Aplikasi ini menggunakan Firebase sebagai backend untuk menyimpan dan mengelola data pemain secara real-time.

## Fitur Utama

- Manajemen Pemain
  - Pendaftaran pemain baru dengan validasi nama
  - Daftar pemain terdaftar dengan status keaktifan
  - Pengaturan preferensi "Don't Match" antar pemain
  
- Matchmaking V2 (Matchmaking Unique)
  - Sistem matchmaking otomatis dengan 3 tingkat prioritas:
    1. Prioritas Pertama: Menghormati preferensi don't match dan unique pairs
    2. Prioritas Kedua: Mengabaikan don't match, tetap menjaga unique pairs
    3. Prioritas Ketiga: Fallback untuk pasangan acak
  - Validasi maksimal 1000 percobaan per prioritas
  - Pembentukan tim berdasarkan riwayat pertandingan
  - Penanganan kasus khusus:
    - Jumlah pemain ganjil (noTeam)
    - Jumlah tim ganjil (noMatch)
    - Preferensi don't match
    - Validasi unique pairs
  - Preview hasil matchmaking
  - Riwayat sesi pertandingan lengkap
  
- Sesi Pertandingan
  - Pembuatan sesi baru dengan validasi
  - Pengelolaan sesi yang sedang berjalan
  - Riwayat pertandingan per sesi
  - Status noMoreUniquePairs untuk tracking pasangan unik

## Persyaratan Sistem

- Flutter SDK: ^3.5.3
- Dart SDK: ^3.5.3
- Firebase account
- Android Studio / VS Code
- Git

## Memulai

1. Clone repositori:
   ```bash
   git clone https://github.com/yourusername/nepak_bulu_2.git
   ```

2. Masuk ke direktori proyek:
   ```bash
   cd nepak_bulu_2
   ```

3. Salin dan sesuaikan file environment:
   ```bash
   cp .env.example .env
   ```

4. Instal dependensi:
   ```bash
   flutter pub get
   ```

5. Konfigurasi Firebase:
   - Buat proyek di [Firebase Console](https://console.firebase.google.com/)
   - Tambahkan platform (Android/iOS/Web)
   - Unduh file konfigurasi:
     - Android: `google-services.json` ke `android/app/`
     - iOS: `GoogleService-Info.plist` ke `ios/Runner/`
     - Web: Konfigurasi otomatis
   - Sesuaikan nilai Firebase di `.env`

6. Jalankan aplikasi:
   ```bash
   flutter run
   ```

## Setup Firebase
1. Buat project di Firebase Console
2. Copy `lib/firebase_options.template.dart` ke `lib/firebase_options.dart`
3. Update credentials di `firebase_options.dart` dengan credentials dari project Firebase Anda

## Struktur Proyek

- `lib/`
  - `bloc/`: State management dengan BLoC pattern
  - `components/`: Widget yang dapat digunakan kembali
    - `matchmaking/`: Komponen terkait matchmaking
    - `memberList/`: Komponen untuk daftar pemain
  - `helpers/`: Fungsi utilitas
    - `matchmakePlayers/`: Algoritma matchmaking dengan 3 prioritas
    - `date_formatter.dart`: Format tanggal
  - `models/`: Model data
  - `pages/`: Halaman UI
    - `matchmaking_v2/`: Fitur matchmaking versi 2
    - `members/`: Manajemen pemain
  - `theme/`: Konfigurasi tema aplikasi
  - `dataSources/`: Konfigurasi sumber data
  - `main.dart`: Entry point aplikasi

## Dependensi Utama

- `flutter_bloc`: State management
- `firebase_core`: Integrasi Firebase
- `cloud_firestore`: Database Firebase
- `go_router`: Navigasi
- `intl`: Internationalization

## Kontribusi

Silakan buat pull request untuk kontribusi. Pastikan untuk:
1. Update dokumentasi yang relevan
2. Ikuti konvensi kode yang ada
3. Uji perubahan sebelum submit

## Lisensi

Copyright © 2024. All rights reserved.