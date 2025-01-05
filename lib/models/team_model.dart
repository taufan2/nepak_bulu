import 'package:nepak_bulu_2/models/player_firestore_model.dart';

class TeamModel {
  final String teamName;
  final PlayerFirestoreModel player1;
  final PlayerFirestoreModel player2;

  TeamModel(this.player1, this.player2, this.teamName);
}