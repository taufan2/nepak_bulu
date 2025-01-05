part of 'player_list_bloc.dart';

@immutable
abstract class PlayerListState {}

class PlayerListInitial extends PlayerListState {}

class PlayerListFetched extends PlayerListState {
  final List<PlayerFirestoreModel> players;

  PlayerListFetched(this.players);
}
