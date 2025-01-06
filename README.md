# Nepak Bulu 2

Aplikasi Flutter untuk mengatur pertandingan bulutangkis dengan sistem pembagian tim otomatis.

> **Catatan**: 
> - Saat ini aplikasi hanya bisa dijalankan di Android dan Web
> - Ini adalah proyek pribadi dan tidak menerima kontribusi langsung, tapi kamu bisa mem-fork repository ini untuk pengembangan sendiri

## Daftar Isi
- [Penjelasan](#penjelasan)
- [Cara Kerja](#cara-kerja)
- [Setup & Konfigurasi](#setup--konfigurasi)
- [Detail Sistem](#detail-sistem)
- [Fitur Unggulan](#fitur-unggulan)
- [Teknologi](#teknologi)
- [Struktur Proyek](#struktur-proyek)
- [Pengembangan](#pengembangan)
- [Kolaborasi](#kolaborasi)

## Penjelasan
Nepak Bulu 2 adalah aplikasi Flutter yang dibuat untuk memudahkan pengaturan pertandingan bulutangkis. Dengan fokus utama pada sistem pembagian tim otomatis yang canggih, aplikasi ini memastikan setiap pemain mendapat pengalaman bermain yang adil dan bervariasi.

## Cara Kerja
1. **Daftar Pemain**
   - Admin mendaftarkan pemain baru
   - Mengisi data pemain (nama dan status aktif)
   - Mengatur siapa saja yang tidak boleh dipasangkan

2. **Persiapan Main**
   - Admin memilih siapa saja yang akan bermain
   - Sistem mengecek jumlah pemain (minimal 2)
   - Pemain yang dipilih harus yang aktif

3. **Pembagian Tim**
   - Sistem menjalankan pembagian tim
   - Melalui 3 tahap prioritas jika diperlukan
   - Menghasilkan pasangan yang paling optimal

4. **Hasil Pembagian**
   - Menampilkan pasangan yang terbentuk
   - Menandai pemain yang tidak dapat tim (jika ada)
   - Menyimpan hasil ke database

5. **Riwayat dan Data**
   - Menyimpan setiap sesi main
   - Mencatat semua pasangan yang terbentuk
   - Menggunakan data untuk pembagian tim berikutnya

## Setup & Konfigurasi

### 1. Clone Repository
```bash
git clone https://github.com/taufan2/nepak_bulu.git
cd nepak_bulu
```

### 2. Setup Firebase

#### A. Persiapan
1. Buat project di [Firebase Console](https://console.firebase.google.com)
2. Install tools yang diperlukan:
   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools
   
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   ```

#### B. Konfigurasi Firebase
1. Login ke Firebase
   ```bash
   firebase login
   ```

2. Setup FlutterFire
   ```bash
   flutterfire configure
   ```
   > Ini akan:
   > - Menghubungkan project Flutter dengan Firebase
   > - Menghasilkan file `lib/firebase_options.dart`
   > - Mengkonfigurasi Firebase services (Firestore, Auth, dll)

#### C. Setup Firebase Hosting
1. Inisialisasi Firebase di project
   ```bash
   firebase init
   ```
   > Pilih opsi berikut:
   > - ✓ Hosting
   > - ✓ Use existing project
   > - ✓ Pilih project yang sudah dibuat
   > - ✓ build/web sebagai public directory
   > - ✓ Configure as single-page app: Yes
   > - ✓ Setup automatic builds: No

2. Build & Deploy
   ```bash
   # Build web app
   flutter build web
   
   # Deploy ke Firebase Hosting
   firebase deploy
   ```

### 3. Instalasi Dependensi
```bash
flutter pub get
```

### 4. Jalankan Aplikasi
```bash
flutter run
```

## Detail Sistem

### Detail Pendaftaran Pemain
1. **Pengecekan Data**
   - Nama pemain tidak boleh sama
   - Status aktif otomatis diset aktif
   - Daftar pemain yang tidak boleh dipasangkan awalnya kosong

2. **Penyimpanan Data**
   ```dart
   // Struktur data di Firestore
   players/{player_id}:
     name: string
     isActive: boolean
     dontMatchWith: array<reference>
     createdAt: timestamp
   ```

### Detail Persiapan Main
1. **Pengecekan Pemain**
   - Minimal harus ada 2 pemain
   - Semua pemain harus aktif
   - Sistem mengecek aturan "tidak boleh dipasangkan"

2. **Optimasi Pemilihan**
   ```dart
   // Algoritma pengecekan pemilihan
   bool validateSelection(List<Player> players) {
     if (players.length < 2) return false;
     if (players.any((p) => !p.isActive)) return false;
     
     // Cek apakah masih bisa dipasangkan
     int totalPlayers = players.length;
     int totalDontMatch = players
         .fold(0, (sum, p) => sum + p.dontMatchWith.length);
     
     return totalDontMatch < (totalPlayers * (totalPlayers - 1)) / 2;
   }
   ```

### Detail Pembagian Tim
1. **Prioritas Pertama**
   - Menggunakan algoritma [Hungarian](https://en.wikipedia.org/wiki/Hungarian_algorithm) yang dimodifikasi
   - Mempertimbangkan aturan "tidak boleh dipasangkan"
   - Mengecek riwayat pasangan sebelumnya

2. **Prioritas Kedua**
   - Mengabaikan aturan "tidak boleh dipasangkan"
   - Tetap mengecek riwayat pasangan
   - Menggunakan algoritma greedy

3. **Prioritas Ketiga**
   - Pembagian acak tanpa aturan
   - Menggunakan pengacakan Fisher-Yates
   - Jalan terakhir agar permainan tetap bisa berjalan

### Detail Hasil Pembagian
1. **Struktur Data Hasil**
   ```dart
   // Struktur data sesi di Firestore
   sessions/{session_id}:
     createdAt: timestamp
     noMoreUniquePairs: boolean
     noTeam: map<player_data>
     pairs: subcollection [
       {
         player1: map<player_data>
         player2: map<player_data>
         createdAt: timestamp
       }
     ]
   ```

2. **Penanganan Kasus Khusus**
   - Pemain Ganjil: Ditandai sebagai pemain cadangan
   - Tim Ganjil: Tim terakhir ditandai menunggu
   - No More Unique Pairs: Penanda sudah tidak ada pasangan unik

### Detail Riwayat dan Data
1. **Pencatatan Pasangan**
   - Menyimpan setiap pasangan yang terbentuk
   - Menggunakan kunci gabungan untuk pencarian cepat
   - Membersihkan riwayat untuk pemain tidak aktif

2. **Analisis Data**
   ```dart
   // Contoh query analisis
   Future<Map<String, int>> getPlayerStats(String playerId) async {
     final matches = await sessionsRef
         .where('pairs', arrayContains: playerId)
         .get();
     
     return {
       'totalMain': matches.length,
       'totalPasangan': _countUniquePartners(matches),
       'totalJadiCadangan': _countNoTeam(matches),
     };
   }
   ```

## Fitur Unggulan

### 1. Manajemen Pemain
- Pendaftaran dan pengelolaan data pemain
- Status keaktifan pemain
- Pengaturan siapa saja yang tidak boleh dipasangkan

### 2. Sistem Pembagian Tim V2
Menggunakan algoritma 3 tingkat prioritas:

**Prioritas Pertama (1000 percobaan)**
- Menghormati aturan "tidak boleh dipasangkan"
- Memastikan pasangan unik (belum pernah dipasangkan)
- Pengacakan pemain untuk keadilan

**Prioritas Kedua (1000 percobaan)**
- Mengabaikan aturan "tidak boleh dipasangkan"
- Tetap mempertahankan pasangan unik
- Digunakan jika Prioritas Pertama gagal

**Prioritas Ketiga (Fallback)**
- Pengacakan total tanpa batasan
- Mengabaikan semua aturan
- Solusi terakhir untuk memastikan permainan tetap berjalan

### 3. Pengelolaan Sesi
```dart
class PairSession {
  final List<Team> teams;
  final Player? noTeam;
  final bool noMoreUniquePairs;
  final DateTime createdAt;
  
  Future<void> save() async {
    final doc = await sessionsRef.add({
      'createdAt': createdAt,
      'noMoreUniquePairs': noMoreUniquePairs,
      'noTeam': noTeam?.toJson(),
    });
    
    for (var team in teams) {
      await doc.collection('pairs').add({
        'player1': team.player1.toJson(),
        'player2': team.player2.toJson(),
      });
    }
  }
}
```

### 4. Model Player
```dart
class Player {
  final DocumentReference docRef;
  final String name;
  final bool isActive;
  final List<DocumentReference> dontMatchWith;

  bool canMatchWith(Player other) {
    return isActive && 
           other.isActive && 
           !dontMatchWith.contains(other.docRef) &&
           !other.dontMatchWith.contains(docRef);
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'isActive': isActive,
    'docRef': docRef,
    'dontMatchWith': dontMatchWith,
  };
}
```

### 5. Bloc Pattern Implementation
```dart
class MatchmakingBloc extends Bloc<MatchmakingEvent, MatchmakingState> {
  final MatchmakingRepository repository;

  MatchmakingBloc(this.repository) : super(MatchmakingInitial()) {
    on<CreateSession>((event, emit) async {
      emit(MatchmakingLoading());
      try {
        final session = await repository.createSession(event.players);
        emit(MatchmakingSuccess(session));
      } catch (e) {
        emit(MatchmakingError(e.toString()));
      }
    });
  }
}
```

### 6. Firebase Integration
```dart
class FirebaseMatchmakingRepository {
  final CollectionReference sessionsRef;
  final CollectionReference playersRef;

  Future<List<Player>> getActivePlayers() async {
    final snapshot = await playersRef
        .where('isActive', isEqual: true)
        .get();
    
    return snapshot.docs.map((doc) => Player.fromFirestore(doc)).toList();
  }

  Future<void> updatePlayerPreferences(
    String playerId, 
    List<String> dontMatchWith
  ) async {
    await playersRef.doc(playerId).update({
      'dontMatchWith': dontMatchWith.map((id) => 
        playersRef.doc(id)).toList(),
    });
  }
}
```

### 7. Custom Widgets
```dart
class PlayerCard extends StatelessWidget {
  final Player player;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.blue.withValues(0.2) : null,
      child: ListTile(
        leading: CircleAvatar(
          child: Text(player.name[0]),
        ),
        title: Text(player.name),
        trailing: Icon(
          player.isActive ? Icons.check_circle : Icons.cancel,
          color: player.isActive ? Colors.green : Colors.red,
        ),
        onTap: onTap,
      ),
    );
  }
}
```

## Teknologi

- Flutter SDK
- Firebase (Backend & Database)
- BLoC Pattern (State Management)
- Cloud Firestore

## Struktur Proyek

Berikut adalah struktur folder utama dari proyek:

```text
lib/
├── bloc/                  # State management
├── components/           # Widget reusable
│   ├── matchmaking/     # Komponen matchmaking
│   └── memberList/      # Komponen daftar pemain
├── helpers/             # Fungsi utilitas
│   └── matchmakePlayers/# Algoritma matchmaking
├── models/              # Model data
├── pages/               # Halaman UI
│   ├── matchmaking_v2/  # Fitur matchmaking
│   └── members/         # Manajemen pemain
└── main.dart            # Entry point
```

## Dependensi Utama

- `flutter_bloc`: Manajemen state
- `firebase_core`: Integrasi Firebase
- `cloud_firestore`: Database
- `go_router`: Navigasi

## Pengembangan

Proyek ini masih dalam pengembangan aktif. Fokus utama saat ini adalah:
- Penyempurnaan algoritma matchmaking
- Peningkatan UI/UX
- Optimasi performa
- Penambahan fitur statistik pemain

## Kolaborasi

Proyek ini adalah proyek pribadi dan tidak menerima kontribusi langsung. Namun, Anda dapat:
1. Fork repository ini untuk pengembangan sendiri
2. Menggunakan kode sebagai referensi dengan tetap mencantumkan kredit
3. Membuat versi yang lebih baik untuk kebutuhan Anda

## Lisensi

Copyright © 2024. All rights reserved.