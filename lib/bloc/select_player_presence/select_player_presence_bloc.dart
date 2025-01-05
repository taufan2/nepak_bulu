import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nepak_bulu_2/dataSources/firestore_collections.dart';
import 'package:nepak_bulu_2/helpers/matchmakePlayers/create_matchmaking_v2.dart';
import 'package:nepak_bulu_2/models/player_firestore_model.dart';

import '../../helpers/matchmakePlayers/matchmaking_result.dart';
import '../../models/pair_session_model.dart';

part 'select_player_presence_event.dart';
part 'select_player_presence_state.dart';

class SelectPlayerPresenceBloc
    extends Bloc<SelectPlayerPresenceEvent, SelectPlayerPresenceState> {
  SelectPlayerPresenceBloc() : super(SelectPlayerPresenceInitial()) {
    on<FetchPlayers>((event, emit) async {
      await fetchPlayer(emit);
    });

    on<MarkPlayerPresence>((event, emit) async {
      await togglePresence(event.player, event.presence, emit);
    });

    on<SelectPlayerPresenceCreateMatchMake>((event, emit) async {
      final currentState = state as PlayerListFetched;
      emit(SelectPlayerPresenceCreatingMatch(currentState.players));
      final pair = await createMatchmakingV2(
        event.players,
        pairSession: event.pairSession,
      );
      emit(SelectPlayerPresenceMatchCreated(pair, pair.pairSession));
    });
  }

  fetchPlayer(
    Emitter<SelectPlayerPresenceState> emit,
  ) async {
    final QuerySnapshot<PlayerFirestoreModel> get = await playerCollection
        .orderBy("presence", descending: true)
        .withConverter<PlayerFirestoreModel>(
          fromFirestore: (snapshot, options) =>
              PlayerFirestoreModel.fromFirestore(
                  snapshot.data()!, snapshot.reference),
          toFirestore: (value, options) => value.toFirestore(),
        )
        .get();

    List<PlayerFirestoreModel> players = [];
    for (var element in get.docs) {
      players.add(element.data());
    }

    emit(PlayerListFetched(players));
  }

  togglePresence(
    PlayerFirestoreModel player,
    bool presence,
    Emitter<SelectPlayerPresenceState> emit,
  ) async {
    PlayerListFetched currentState = state as PlayerListFetched;

    currentState = currentState.copyWith(presenceToggleLoading: true);
    emit(currentState);

    player.presence = presence;

    await player.documentRef!
        .withConverter<PlayerFirestoreModel>(
          fromFirestore: (snapshot, options) =>
              PlayerFirestoreModel.fromFirestore(
                  snapshot.data()!, snapshot.reference),
          toFirestore: (value, options) => value.toFirestore(),
        )
        .set(player);

    final findIndex =
        currentState.players.indexWhere((element) => element.id == player.id);

    currentState.players[findIndex] = player;
    currentState = currentState.copyWith(
      players: currentState.players,
      presenceToggleLoading: false,
    );
    emit(currentState);
  }
}
