# Nepak Bulu 2

Aplikasi Flutter untuk manajemen pertandingan bulutangkis dengan fitur matchmaking otomatis.

> **Catatan**: 
> - Saat ini aplikasi hanya mendukung platform Android dan Web.
> - Ini adalah proyek pribadi dan tidak menerima kolaborasi langsung, tapi Anda dapat mem-fork repository ini untuk pengembangan sendiri.

## Daftar Isi
- [Deskripsi](#deskripsi)
- [Alur Aplikasi](#alur-aplikasi)
- [Detail Algoritma](#detail-algoritma)
- [Fitur Utama](#fitur-utama)
- [Snippet Kode](#snippet-kode-utama)
- [Teknologi](#teknologi)
- [Cara Memulai](#cara-memulai)

## Deskripsi

Nepak Bulu 2 adalah aplikasi Flutter yang dirancang untuk memudahkan pengelolaan pertandingan bulutangkis. Dengan fokus utama pada sistem matchmaking otomatis yang canggih, aplikasi ini memastikan setiap pemain mendapatkan pengalaman bermain yang adil dan bervariasi.

## Alur Aplikasi

1. **[Pendaftaran Pemain](#detail-pendaftaran-pemain)**
   - Admin mendaftarkan pemain baru
   - Mengisi data pemain (nama, status aktif)
   - Mengatur preferensi "Don't Match" jika ada

2. **[Persiapan Sesi](#detail-persiapan-sesi)**
   - Admin memilih pemain yang akan bermain
   - Sistem memvalidasi jumlah pemain (minimal 2)
   - Pemain yang dipilih harus berstatus aktif

3. **[Proses Matchmaking](#detail-proses-matchmaking)**
   - Sistem menjalankan algoritma matchmaking
   - Melalui 3 tingkat prioritas jika diperlukan
   - Menghasilkan pasangan yang optimal

4. **[Hasil Matchmaking](#detail-hasil-matchmaking)**
   - Menampilkan pasangan yang terbentuk
   - Menandai pemain tanpa tim (jika ada)
   - Menyimpan hasil ke database

5. **[Riwayat dan Statistik](#detail-riwayat-statistik)**
   - Menyimpan setiap sesi pertandingan
   - Mencatat semua pasangan yang terbentuk
   - Menggunakan data untuk validasi sesi berikutnya

## Detail Algoritma

### Detail Pendaftaran Pemain
1. **Validasi Data**
   - Nama pemain harus unik
   - Status aktif default adalah true
   - Preferensi don't match awalnya kosong

2. **Penyimpanan Data**
   ```dart
   // Struktur data di Firestore
   players/{player_id}:
     name: string
     isActive: boolean
     dontMatchWith: array<reference>
     createdAt: timestamp
   ```

### Detail Persiapan Sesi
1. **Validasi Pemilihan**
   - Minimal 2 pemain harus dipilih
   - Semua pemain harus aktif
   - Sistem mengecek kompatibilitas don't match

2. **Optimasi Pemilihan**
   ```dart
   // Algoritma validasi pemilihan
   bool validateSelection(List<Player> players) {
     if (players.length < 2) return false;
     if (players.any((p) => !p.isActive)) return false;
     
     // Cek apakah ada kemungkinan match
     int totalPlayers = players.length;
     int totalDontMatch = players
         .fold(0, (sum, p) => sum + p.dontMatchWith.length);
     
     return totalDontMatch < (totalPlayers * (totalPlayers - 1)) / 2;
   }
   ```

### Detail Proses Matchmaking
1. **Prioritas Pertama**
   - Menggunakan algoritma [Hungarian Algorithm](https://en.wikipedia.org/wiki/Hungarian_algorithm) yang dimodifikasi
   - Mempertimbangkan preferensi don't match
   - Validasi unique pairs dari history

2. **Prioritas Kedua**
   - Mengabaikan preferensi don't match
   - Tetap memvalidasi unique pairs
   - Menggunakan pendekatan greedy algorithm

3. **Prioritas Ketiga**
   - Random matching tanpa batasan
   - Menggunakan Fisher-Yates shuffle
   - Fallback terakhir untuk memastikan game berjalan

### Detail Hasil Matchmaking
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
   - Pemain Ganjil: Ditandai sebagai noTeam
   - Tim Ganjil: Tim terakhir ditandai noMatch
   - No More Unique Pairs: Flag untuk tracking

### Detail Riwayat Statistik
1. **Tracking Pasangan**
   - Menyimpan setiap pasangan yang terbentuk
   - Menggunakan composite key untuk pencarian cepat
   - Membersihkan history untuk pemain tidak aktif

2. **Analisis Data**
   ```dart
   // Contoh query analisis
   Future<Map<String, int>> getPlayerStats(String playerId) async {
     final matches = await sessionsRef
         .where('pairs', arrayContains: playerId)
         .get();
     
     return {
       'totalMatches': matches.length,
       'uniquePartners': _countUniquePartners(matches),
       'noTeamCount': _countNoTeam(matches),
     };
   }
   ```

## Fitur Utama

### 1. Manajemen Pemain
- Pendaftaran dan pengelolaan data pemain
- Status keaktifan pemain
- Pengaturan preferensi "Don't Match" antar pemain

### 2. Sistem Matchmaking V2
Menggunakan algoritma 3 tingkat prioritas:

**Prioritas Pertama (1000 percobaan)**
- Menghormati preferensi "Don't Match"
- Memastikan pasangan unik (belum pernah dipasangkan)
- Pengacakan pemain untuk keadilan

**Prioritas Kedua (1000 percobaan)**
- Mengabaikan preferensi "Don't Match"
- Tetap mempertahankan pasangan unik
- Digunakan jika Prioritas Pertama gagal

**Prioritas Ketiga (Fallback)**
- Pengacakan total tanpa batasan
- Mengabaikan semua preferensi
- Solusi terakhir untuk memastikan permainan tetap berjalan

### 3. Penanganan Kasus Khusus
- Pemain Ganjil: Satu pemain ditandai sebagai "noTeam"
- Tim Ganjil: Tim terakhir ditandai sebagai "noMatch"
- Riwayat Pertandingan: Pencatatan lengkap setiap sesi
- Status "noMoreUniquePairs" untuk tracking pasangan

## Snippet Kode Utama

### 1. Algoritma Matchmaking
```dart
// Mencoba membuat pasangan dengan prioritas tertinggi
Future<PairSession?> _tryCreateWithPriorityOne() async {
  for (int attempt = 0; attempt < MAX_VALIDATION_ATTEMPTS; attempt++) {
    // Reset state untuk percobaan baru
    teams.clear();
    noTeam = null;
    noMoreUniquePairs = false;
    
    // Acak pemain yang tersedia
    availablePlayers.shuffle();
    List<Player> remainingPlayers = List.from(availablePlayers);

    while (remainingPlayers.length >= 2) {
      Player player1 = remainingPlayers[0];
      
      // Cari pasangan yang valid (tidak di dontMatch & belum pernah dipasangkan)
      Player? player2 = _findValidPartner(player1, remainingPlayers);
      
      if (player2 != null) {
        teams.add(Team(player1, player2));
        remainingPlayers.remove(player1);
        remainingPlayers.remove(player2);
      } else {
        break; // Tidak ada pasangan valid
      }
    }

    // Berhasil jika semua pemain terpasangkan atau tersisa 1
    if (remainingPlayers.isEmpty || remainingPlayers.length == 1) {
      if (remainingPlayers.length == 1) {
        noTeam = remainingPlayers[0];
      }
      return _createPairSession();
    }
  }
  return null; // Gagal setelah MAX_VALIDATION_ATTEMPTS
}
```

### 2. Validasi Pasangan Unik
```dart
bool _isUniquePair(Player player1, Player player2) {
  // Cek di history pairs
  String pair1 = '${player1.docRef.id}-${player2.docRef.id}';
  String pair2 = '${player2.docRef.id}-${player1.docRef.id}';
  
  return !historyPairs.contains(pair1) && 
         !historyPairs.contains(pair2);
}
```

### 3. Pengelolaan Sesi
```dart
class PairSession {
  final List<Team> teams;
  final Player? noTeam;
  final bool noMoreUniquePairs;
  final DateTime createdAt;
  
  // Simpan sesi ke Firestore
  Future<void> save() async {
    final doc = await sessionsRef.add({
      'createdAt': createdAt,
      'noMoreUniquePairs': noMoreUniquePairs,
      'noTeam': noTeam?.toJson(),
    });
    
    // Simpan tim sebagai sub-collection
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

## Teknologi

- Flutter SDK
- Firebase (Backend & Database)
- BLoC Pattern (State Management)
- Cloud Firestore

## Cara Memulai

1. **Clone Repository**
   ```bash
   git clone https://github.com/taufan2/nepak_bulu.git
   cd nepak_bulu
   ```

2. **Setup Firebase**
   - Buat project di Firebase Console
   - Salin `lib/firebase_options.template.dart` ke `lib/firebase_options.dart`
   - Update kredensial Firebase di `firebase_options.dart`

3. **Instalasi Dependensi**
   ```bash
   flutter pub get
   ```

4. **Jalankan Aplikasi**
   ```bash
   flutter run
   ```

## Struktur Proyek

```
lib/
├── bloc/                 # State management
├── components/           # Widget reusable
│   ├── matchmaking/     # Komponen matchmaking
│   └── memberList/      # Komponen daftar pemain
├── helpers/             # Fungsi utilitas
│   └── matchmakePlayers/# Algoritma matchmaking
├── models/              # Model data
├── pages/              # Halaman UI
│   ├── matchmaking_v2/ # Fitur matchmaking
│   └── members/        # Manajemen pemain
└── main.dart           # Entry point
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