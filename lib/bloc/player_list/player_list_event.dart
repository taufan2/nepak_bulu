part of 'player_list_bloc.dart';

@immutable
abstract class PlayerListEvent {}


class FetchPlayers extends PlayerListEvent {}

class DeletePlayer extends PlayerListEvent {
  final DocumentReference ref;
  final BuildContext context;

  DeletePlayer(this.ref, this.context);
}

class MarkPlayerPresence extends PlayerListEvent {
  final PlayerFirestoreModel player;
  final bool presence;

  MarkPlayerPresence(this.player, this.presence);
}
