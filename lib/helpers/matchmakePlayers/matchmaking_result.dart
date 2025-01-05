import 'package:nepak_bulu_2/models/pair_session_model.dart';

import '../../models/player_firestore_model.dart';
import '../../models/team_match_model.dart';
import '../../models/team_model.dart';

/// Hasil dari proses matchmaking yang berisi informasi tentang:
/// - Daftar tim yang terbentuk
/// - Daftar pertandingan antar tim
/// - Pemain tanpa tim (jika ada)
/// - Tim tanpa lawan (jika ada)
/// - Status apakah masih bisa membuat pasangan unik
class MatchmakingResult {
  /// Daftar tim yang berhasil dibentuk
  final List<TeamModel> teams;

  /// Daftar pertandingan antar tim
  final List<TeamMatchModel> teamMatches;

  /// Pemain yang tidak mendapat tim (jika jumlah pemain ganjil)
  final PlayerFirestoreModel? noTeam;

  /// Tim yang tidak mendapat lawan (jika jumlah tim ganjil)
  final TeamModel? noMatch;

  /// Menandakan bahwa tidak ada lagi kemungkinan membuat pasangan unik
  /// `true` jika semua pemain sudah pernah dipasangkan satu sama lain
  final bool noMoreUniquePairs;

  /// Pair session yang sudah dihasilkan
  final PairSessionModel? pairSession;

  MatchmakingResult({
    required this.teams,
    required this.teamMatches,
    this.noTeam,
    this.noMatch,
    this.noMoreUniquePairs = false,
    this.pairSession,
  });

  /// Membuat salinan objek dengan memperbarui nilai tertentu
  MatchmakingResult copyWith({
    List<TeamModel>? teams,
    List<TeamMatchModel>? teamMatches,
    PlayerFirestoreModel? noTeam,
    TeamModel? noMatch,
    bool? noMoreUniquePairs,
    PairSessionModel? pairSession,
  }) {
    return MatchmakingResult(
      teams: teams ?? this.teams,
      teamMatches: teamMatches ?? this.teamMatches,
      noTeam: noTeam ?? this.noTeam,
      noMatch: noMatch ?? this.noMatch,
      noMoreUniquePairs: noMoreUniquePairs ?? this.noMoreUniquePairs,
      pairSession: pairSession ?? this.pairSession,
    );
  }

}
