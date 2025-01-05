import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nepak_bulu_2/dataSources/firestore_collections.dart';
import 'package:nepak_bulu_2/models/player_firestore_model.dart';

part 'player_list_event.dart';

part 'player_list_state.dart';

class PlayerListBloc extends Bloc<PlayerListEvent, PlayerListState> {
  PlayerListBloc() : super(PlayerListInitial()) {
    on<PlayerListEvent>((event, emit) async {
      if (event is FetchPlayers) {
        await fetchPlayer(emit);
      } else if (event is DeletePlayer) {
        final DocumentReference ref = event.ref;
        final BuildContext context = event.context;
        await deletePlayer(ref, context, emit);
      } else if(event is MarkPlayerPresence) {
        await togglePresence(event.player, event.presence, emit);
      }
    });
  }

  fetchPlayer(Emitter<PlayerListState> emit) async {
    final QuerySnapshot<PlayerFirestoreModel> get = await playerCollection
        .orderBy("createdAt", descending: true)
        .withConverter<PlayerFirestoreModel>(
          fromFirestore: (snapshot, options) =>
              PlayerFirestoreModel.fromFirestore(
                  snapshot.data()!, snapshot.reference),
          toFirestore: (value, options) => value.toFirestore(),
        )
        .get();

    final List<PlayerFirestoreModel> players = [];

    for (var element in get.docs) {
      players.add(element.data());
    }

    emit(
      PlayerListFetched(players),
    );
  }

  deletePlayer(
    DocumentReference ref,
    BuildContext context,
    Emitter<PlayerListState> emitter,
  ) async {
    await ref.delete();

    const snack = SnackBar(
      content: Text(
        "Pemain berhasil di hapus",
        style: TextStyle(
          color: Colors.orange,
        ),
      ),
    );

    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(snack);
    await fetchPlayer(emitter);
  }

  togglePresence(PlayerFirestoreModel player, bool presence, Emitter<PlayerListState> emit) async {
    player.presence = presence;
    await player.documentRef!
        .withConverter<PlayerFirestoreModel>(
          fromFirestore: (snapshot, options) =>
              PlayerFirestoreModel.fromFirestore(
                  snapshot.data()!, snapshot.reference),
          toFirestore: (value, options) => value.toFirestore(),
        )
        .set(player);
    await fetchPlayer(emit);
  }
}
