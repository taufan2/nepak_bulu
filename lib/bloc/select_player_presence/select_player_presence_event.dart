part of 'select_player_presence_bloc.dart';

@immutable
abstract class SelectPlayerPresenceEvent {}

class FetchPlayers extends SelectPlayerPresenceEvent {
  late final bool isNotFirst;

  FetchPlayers({bool? isNotFirst}) {
    this.isNotFirst = isNotFirst ?? false;
  }
}

class MarkPlayerPresence extends SelectPlayerPresenceEvent {
  final PlayerFirestoreModel player;
  final bool presence;

  MarkPlayerPresence(this.player, this.presence);
}

class SelectPlayerPresenceCreateMatchMake extends SelectPlayerPresenceEvent {
  final List<PlayerFirestoreModel> players;
  final PairSessionModel? pairSession;

  SelectPlayerPresenceCreateMatchMake(this.players, {this.pairSession});
}
