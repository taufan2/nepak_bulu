import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nepak_bulu_2/bloc/select_player_presence/select_player_presence_bloc.dart';
import 'package:nepak_bulu_2/components/matchmaking/matchmaking_submit_button.dart';
import 'package:nepak_bulu_2/components/matchmaking/select_member_list_builder.dart';
import 'package:nepak_bulu_2/models/pair_session_model.dart';
import 'package:nepak_bulu_2/models/player_firestore_model.dart';
import 'package:nepak_bulu_2/components/matchmaking/pair_session_status_header.dart';

class SelectPlayerVer2 extends StatefulWidget {
  final PairSessionModel? pairSession;

  const SelectPlayerVer2({super.key, this.pairSession});

  @override
  State<SelectPlayerVer2> createState() => _SelectPlayerVer2State();
}

class _SelectPlayerVer2State extends State<SelectPlayerVer2> {
  late SelectPlayerPresenceBloc playerListBloc;
  @override
  void initState() {
    super.initState();
    playerListBloc = SelectPlayerPresenceBloc();
    playerListBloc.add(FetchPlayers());
  }

  onSubmitMatchMake(List<PlayerFirestoreModel> checkedPlayers) {
    playerListBloc.add(SelectPlayerPresenceCreateMatchMake(
      checkedPlayers,
      pairSession: widget.pairSession,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => playerListBloc,
      child: BlocListener<SelectPlayerPresenceBloc, SelectPlayerPresenceState>(
        listener: (context, state) async {
          if (state is SelectPlayerPresenceMatchCreated) {
            if (widget.pairSession != null) {
              context.push("/matchmaking-result-v2", extra: state.pair);
            } else {
              context.pushReplacement("/select-player-v2",
                  extra: state.pairSession);
              if (context.mounted) {
                context.push("/matchmaking-result-v2", extra: state.pair);
              }
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Pilih Pemain"),
          ),
          body: Column(
            children: [
              SessionStatusHeader(pairSession: widget.pairSession),
              const Expanded(
                child: SelectMemberListBuilder(),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: BlocBuilder<SelectPlayerPresenceBloc,
                SelectPlayerPresenceState>(
              builder: (context, state) {
                final List<PlayerFirestoreModel> players = [];
                bool buttonDisabled = false;
                bool buttonLoading = false;

                if (state is PlayerListFetched) {
                  players.addAll(state.players);
                } else if (state is SelectPlayerPresenceCreatingMatch) {
                  players.addAll(state.players);
                }

                if (state is SelectPlayerPresenceCreatingMatch ||
                    (state is PlayerListFetched &&
                        state.presenceToggleLoading)) {
                  buttonDisabled = true;
                  buttonLoading = true;
                }

                final List<PlayerFirestoreModel> checkedPlayers =
                    players.where((element) => element.presence).toList();

                if (checkedPlayers.length < 2) {
                  buttonDisabled = true;
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pemain Terpilih",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        Text(
                          "${checkedPlayers.length} pemain",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    MatchmakingSubmitButton(
                      disabled: buttonDisabled,
                      loading: buttonLoading,
                      onSubmit: onSubmitMatchMake,
                      checkedPlayers: checkedPlayers,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
