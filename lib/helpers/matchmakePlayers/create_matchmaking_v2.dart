library matchmaking;

import 'dart:math';
import 'package:nepak_bulu_2/dataSources/firestore_collections.dart';
import 'package:nepak_bulu_2/models/pair_session_model.dart';
import 'package:nepak_bulu_2/models/player_firestore_model.dart';
import 'package:nepak_bulu_2/models/player_pair_model.dart';
import 'package:nepak_bulu_2/models/team_match_model.dart';
import 'package:nepak_bulu_2/models/team_model.dart';
import 'matchmaking_result.dart';

class MatchmakingService {
  final List<PlayerFirestoreModel> players;
  final PairSessionModel? pairSession;
  List<PairModel> pairs = [];
  List<TeamModel> teams = [];
  PlayerFirestoreModel? noTeam;
  bool noMoreUniquePairs = false;
  List<PlayerFirestoreModel> availablePlayers = [];
  static const int maxValidationAttempts = 1000;

  MatchmakingService(this.players, {this.pairSession});

  /// Mengacak urutan array menggunakan algoritma Fisher-Yates shuffle
  List<T> shuffleArray<T>(List<T> list) {
    final random = Random.secure();
    for (var i = list.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
    return list;
  }

  /// Inisialisasi service dan memuat history pairs
  Future<void> initialize() async {
    if (pairSession != null) {
      await _loadHistoryPairs();
    }
    availablePlayers = shuffleArray(List.from(players));
  }

  /// Memuat dan membersihkan history pairs
  Future<void> _loadHistoryPairs() async {
    final pairModel = await PairModel.withCollectionConverter(
            pairSession!.docRef.collection('pairs'))
        .get();
    pairs = pairModel.docs.map((doc) => doc.data()).toList();

    // Bersihkan history - hanya pertahankan pemain aktif
    pairs = pairs.map((pair) {
      pair.pairs.removeWhere((p) =>
          !_isPlayerActive(p.player1.docRef.path) ||
          !_isPlayerActive(p.player2.docRef.path));
      return pair;
    }).toList();
  }

  bool _isPlayerActive(String playerPath) {
    return players.any((p) => p.documentRef?.path == playerPath);
  }

  /// Membuat pasangan dengan 3 tingkat prioritas
  Future<MatchmakingResult> createMatchesWithPriority() async {
    // PRIORITAS 1: Respect dontMatch + Harus unique pairs
    final priorityOneResult = await _tryCreateWithPriorityOne();
    if (priorityOneResult != null) {
      return _finalizeResult(priorityOneResult);
    }

    // PRIORITAS 2: Abaikan dontMatch + Harus unique pairs
    final priorityTwoResult = await _tryCreateWithPriorityTwo();
    if (priorityTwoResult != null) {
      return _finalizeResult(priorityTwoResult);
    }

    // PRIORITAS 3: Random pairs (tidak ada validasi)
    return _finalizeResult(await _createRandomPairs());
  }

  /// Prioritas 1: Respect dontMatch + Unique pairs
  Future<MatchmakingResult?> _tryCreateWithPriorityOne() async {
    for (var attempt = 0; attempt < maxValidationAttempts; attempt++) {
      teams.clear();
      noTeam = null;
      noMoreUniquePairs = false;
      availablePlayers = shuffleArray(List.from(players));
      List<PlayerFirestoreModel> remainingPlayers = List.from(availablePlayers);

      while (remainingPlayers.length >= 2) {
        var player1 = remainingPlayers[0];
        var player2 =
            _findNonDontMatchPair(player1, remainingPlayers.sublist(1));

        if (player2 == null) {
          // Jika tidak bisa menemukan pasangan, langsung ke prioritas berikutnya
          return null;
        }

        if (!checkHasBeenPaired(pairs, player1, player2)) {
          _createTeam(player1, player2);
          remainingPlayers.remove(player2);
          remainingPlayers.remove(player1);
        } else {
          // Jika sudah pernah dipasangkan, coba kombinasi lain
          break;
        }
      }

      // Jika berhasil memasangkan semua pemain
      if (remainingPlayers.isEmpty || remainingPlayers.length == 1) {
        if (remainingPlayers.length == 1) {
          noTeam = remainingPlayers[0];
        }
        final matches = _createTeamMatches();
        return MatchmakingResult(
          teams: List.from(teams),
          teamMatches: matches.teamMatches,
          noTeam: noTeam,
          noMatch: matches.noMatch,
          noMoreUniquePairs: false,
          pairSession: pairSession,
        );
      }
    }
    return null;
  }

  /// Prioritas 2: Abaikan dontMatch + Unique pairs
  Future<MatchmakingResult?> _tryCreateWithPriorityTwo() async {
    for (var attempt = 0; attempt < maxValidationAttempts; attempt++) {
      teams.clear();
      noTeam = null;
      noMoreUniquePairs = false;
      availablePlayers = shuffleArray(List.from(players));
      List<PlayerFirestoreModel> remainingPlayers = List.from(availablePlayers);

      bool madeProgress = false;
      while (remainingPlayers.length >= 2) {
        madeProgress = false;
        for (int i = 0; i < remainingPlayers.length - 1; i++) {
          for (int j = i + 1; j < remainingPlayers.length; j++) {
            if (!checkHasBeenPaired(
                pairs, remainingPlayers[i], remainingPlayers[j])) {
              _createTeam(remainingPlayers[i], remainingPlayers[j]);
              remainingPlayers.removeAt(j);
              remainingPlayers.removeAt(i);
              madeProgress = true;
              break;
            }
          }
          if (madeProgress) break;
        }
        if (!madeProgress) {
          break; // Jika tidak ada pasangan valid yang ditemukan
        }
      }

      // Jika berhasil memasangkan semua atau tersisa 1
      if (remainingPlayers.isEmpty || remainingPlayers.length == 1) {
        if (remainingPlayers.length == 1) {
          noTeam = remainingPlayers[0];
        }
        final matches = _createTeamMatches();
        return MatchmakingResult(
          teams: List.from(teams),
          teamMatches: matches.teamMatches,
          noTeam: noTeam,
          noMatch: matches.noMatch,
          noMoreUniquePairs: false,
          pairSession: pairSession,
        );
      }
    }
    return null;
  }

  /// Prioritas 3: Random pairs tanpa validasi
  Future<MatchmakingResult> _createRandomPairs() async {
    teams.clear();
    noTeam = null;
    noMoreUniquePairs = true;
    availablePlayers = shuffleArray(List.from(players));
    List<PlayerFirestoreModel> remainingPlayers = List.from(availablePlayers);

    // Pasangkan semua pemain yang tersisa
    while (remainingPlayers.length >= 2) {
      _createTeam(remainingPlayers[0], remainingPlayers[1]);
      remainingPlayers.removeRange(0, 2);
    }

    // Handle pemain terakhir jika ganjil
    if (remainingPlayers.isNotEmpty) {
      noTeam = remainingPlayers[0];
    }

    final matches = _createTeamMatches();
    return MatchmakingResult(
      teams: List.from(teams),
      teamMatches: matches.teamMatches,
      noTeam: noTeam,
      noMatch: matches.noMatch,
      noMoreUniquePairs: true,
      pairSession: pairSession,
    );
  }

  /// Mencari pasangan yang tidak ada di dontMatch
  PlayerFirestoreModel? _findNonDontMatchPair(
      PlayerFirestoreModel player, List<PlayerFirestoreModel> candidates) {
    for (var candidate in candidates) {
      if (!_isDontMatch(player, candidate)) {
        return candidate;
      }
    }
    return null;
  }

  /// Memeriksa apakah dua pemain pernah dipasangkan sebelumnya
  bool checkHasBeenPaired(List<PairModel> pairs, PlayerFirestoreModel player1,
      PlayerFirestoreModel player2) {
    final docRef1 = player1.documentRef;
    final docRef2 = player2.documentRef;

    if (docRef1 == null || docRef2 == null) return false;

    return pairs.any((pair) {
      return pair.pairs.any((p) =>
          (p.player1.docRef.id == docRef1.id &&
              p.player2.docRef.id == docRef2.id) ||
          (p.player1.docRef.id == docRef2.id &&
              p.player2.docRef.id == docRef1.id));
    });
  }

  /// Memeriksa apakah dua pemain memiliki preferensi untuk tidak dipasangkan
  bool _isDontMatch(
      PlayerFirestoreModel player1, PlayerFirestoreModel player2) {
    if (player1.documentRef == null || player2.documentRef == null) {
      return false;
    }

    return player1.dontMatchWith
            .any((e) => e.docRef.id == player2.documentRef?.id && e.enabled) ||
        player2.dontMatchWith
            .any((e) => e.docRef.id == player1.documentRef?.id && e.enabled);
  }

  void _createTeam(PlayerFirestoreModel player1, PlayerFirestoreModel player2) {
    teams.add(TeamModel(player1, player2, "Pasangan ${teams.length + 1}"));
  }

  ({List<TeamMatchModel> teamMatches, TeamModel? noMatch})
      _createTeamMatches() {
    List<TeamMatchModel> teamMatches = [];
    TeamModel? noMatch;

    // Buat copy dari teams untuk menghindari modifikasi list asli
    var teamsToMatch = List.from(teams);

    // Buat pertandingan untuk semua tim yang bisa dipasangkan
    while (teamsToMatch.length >= 2) {
      teamMatches.add(TeamMatchModel(teamsToMatch[0], teamsToMatch[1]));
      teamsToMatch.removeRange(0, 2);
    }

    // Jika ada tim yang tersisa, tandai sebagai noMatch
    if (teamsToMatch.isNotEmpty) {
      noMatch = teamsToMatch[0];
    }

    return (teamMatches: teamMatches, noMatch: noMatch);
  }

  /// Finalisasi hasil dan simpan ke database
  Future<MatchmakingResult> _finalizeResult(MatchmakingResult result) async {
    if (pairSession == null) {
      return result.copyWith(pairSession: await _createNewPairSession(result));
    }

    await _addToPairSession(result, pairSession!);
    return result;
  }

  /// Membuat PairSession baru
  Future<PairSessionModel> _createNewPairSession(
      MatchmakingResult result) async {
    final newPairSession = PairSessionModel(
      name: "Pair Session",
      createdAt: DateTime.now(),
      docRef: mainDb.collection('pair_sessions').doc(),
    );

    await _addToPairSession(result, newPairSession);
    return newPairSession;
  }

  /// Menambahkan hasil ke PairSession yang ada
  Future<void> _addToPairSession(
      MatchmakingResult result, PairSessionModel pairSession) async {
    final batch = mainDb.batch();

    batch.set(pairSession.docRef, pairSession.toJson());

    batch.set(
      pairSession.docRef.collection('pairs').doc(),
      {
        "noMoreUniquePairs": result.noMoreUniquePairs,
        "createdAt": DateTime.now(),
        "pairs": result.teams
            .map((team) => {
                  "player1": {
                    "name": team.player1.name,
                    "docRef": team.player1.documentRef
                  },
                  "player2": {
                    "name": team.player2.name,
                    "docRef": team.player2.documentRef
                  },
                })
            .toList(),
        "noTeam": result.noTeam?.name,
      },
    );

    await batch.commit();
  }
}

/// Fungsi utama yang dipanggil dari luar
Future<MatchmakingResult> createMatchmakingV2(
  List<PlayerFirestoreModel> players, {
  PairSessionModel? pairSession,
}) async {
  final service = MatchmakingService(players, pairSession: pairSession);
  await service.initialize();
  return service.createMatchesWithPriority();
}
