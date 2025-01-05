import 'dart:math';

import 'package:nepak_bulu_2/models/player_firestore_model.dart';
import 'package:nepak_bulu_2/models/team_match_model.dart';
import 'package:nepak_bulu_2/models/team_model.dart';

import 'matchmaking_result.dart';

isOdd(int number) {
  return number % 2 == 1;
}

List<T> shuffleArray<T>(List<T> list) {
  final random = Random
      .secure(); // Menggunakan Random.secure() untuk keacakan yang lebih tinggi
  for (var i = list.length - 1; i > 0; i--) {
    final j = random.nextInt(i + 1);
    final temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }
  return list;
}

MatchmakingResult createMatchmaking(List<PlayerFirestoreModel> players) {
  int totalTeams = (players.length / 2).floor();
  bool isPlayerOdd = isOdd(players.length);

  List<TeamModel> teams = <TeamModel>[];
  var playerTmp = shuffleArray(players);

  int playerLastIndex = 0;
  for (var i = 0; i < totalTeams; i++) {
    PlayerFirestoreModel player1 = playerTmp[playerLastIndex];
    playerLastIndex++;
    PlayerFirestoreModel player2 = playerTmp[playerLastIndex];
    TeamModel team = TeamModel(player1, player2, "Pasangan ${i + 1}");
    teams.add(team);
    playerLastIndex++;
  }

  for (var team in teams) {
    final player1 = team.player1;
    final player2 = team.player2;
    if (player1.dontMatchWith.isNotEmpty) {
      final dontMatch = player1.dontMatchWith
          .any((element) => element.docRef.id == player2.documentRef?.id);

      if (dontMatch) {
        return createMatchmaking(players);
      }
    }

    if (player2.dontMatchWith.isNotEmpty) {
      final dontMatch = player2.dontMatchWith
          .any((element) => element.docRef.id == player1.documentRef?.id);

      if (dontMatch) {
        return createMatchmaking(players);
      }
    }
  }

  bool isTeamOdd = isOdd(teams.length);
  int totalMatch = (teams.length / 2).floor();
  List<TeamMatchModel> teamMatches = <TeamMatchModel>[];
  int teamLastIndex = 0;
  for (var i = 0; i < totalMatch; i++) {
    final team1 = teams[teamLastIndex];
    teamLastIndex++;
    final team2 = teams[teamLastIndex];
    final TeamMatchModel teamMatchModel = TeamMatchModel(team1, team2);
    teamMatches.add(teamMatchModel);
    teamLastIndex++;
  }

  PlayerFirestoreModel? noTeam;
  TeamModel? noMatch;

  if (isPlayerOdd) {
    noTeam = playerTmp[playerLastIndex];
  }

  if (isTeamOdd) {
    noMatch = teams[teamLastIndex];
  }

  return MatchmakingResult(
    teams: teams,
    teamMatches: teamMatches,
    noTeam: noTeam,
    noMatch: noMatch,
  );
}
