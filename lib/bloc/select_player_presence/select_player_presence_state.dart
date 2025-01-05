part of 'select_player_presence_bloc.dart';

@immutable
abstract class SelectPlayerPresenceState extends Equatable {
  const SelectPlayerPresenceState();

  @override
  List<Object?> get props => [];
}

class SelectPlayerPresenceInitial extends SelectPlayerPresenceState {
  @override
  List<Object?> get props => [];
}

class PlayerListFetched extends SelectPlayerPresenceState {
  final List<PlayerFirestoreModel> players;
  final bool presenceToggleLoading;

  const PlayerListFetched(this.players,
      {this.presenceToggleLoading = false});

  PlayerListFetched copyWith({
    List<PlayerFirestoreModel>? players,
    bool? presenceToggleLoading,
  }) {
    return PlayerListFetched(
      players ?? this.players,
      presenceToggleLoading:
          presenceToggleLoading ?? this.presenceToggleLoading,
    );
  }

  @override
  List<Object?> get props => [players, presenceToggleLoading];
}

class SelectPlayerPresenceCreatingMatch extends SelectPlayerPresenceState {
  final List<PlayerFirestoreModel> players;

  const SelectPlayerPresenceCreatingMatch(this.players);

  @override
  List<Object?> get props => [players];
}

class SelectPlayerPresenceMatchCreated extends SelectPlayerPresenceState {
  final PairSessionModel? pairSession;  
  final MatchmakingResult pair;

  const SelectPlayerPresenceMatchCreated(this.pair, this.pairSession);

  @override
  List<Object?> get props => [pair, pairSession];
}
