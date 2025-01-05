import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nepak_bulu_2/bloc/select_player_presence/select_player_presence_bloc.dart';
import 'package:nepak_bulu_2/components/matchmaking/select_member_list_builder.dart';
import 'package:nepak_bulu_2/helpers/matchmakePlayers/create_matchmaking.dart';
import 'package:nepak_bulu_2/helpers/matchmakePlayers/matchmaking_result.dart';
import 'package:nepak_bulu_2/models/player_firestore_model.dart';

class SelectPlayer extends StatefulWidget {
  const SelectPlayer({super.key});

  @override
  State<SelectPlayer> createState() => _SelectPlayerState();
}

class _SelectPlayerState extends State<SelectPlayer> {
  final SelectPlayerPresenceBloc playerListBloc = SelectPlayerPresenceBloc();

  @override
  void initState() {
    super.initState();
    playerListBloc.add(FetchPlayers());
  }

  onSubmitMatchMake(List<PlayerFirestoreModel> checkedPlayers) {
    final MatchmakingResult result = createMatchmaking(checkedPlayers);
    context.push('/matchmaking-result-v2', extra: result);
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.tertiary,
            theme.colorScheme.tertiary.withValues(alpha: .9),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.shuffle_rounded,
                  color: theme.colorScheme.onPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Matchmaking Biasa",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Matchmaking ini tidak akan menghasilkan pasangan yang unik dan akan menghasilkan pasangan yang sama setiap sesi.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onPrimary.withValues(alpha: .8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => playerListBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Pilih Pemain"),
        ),
        body: Column(
          children: [
            _buildHeader(),
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
          child:
              BlocBuilder<SelectPlayerPresenceBloc, SelectPlayerPresenceState>(
            builder: (context, state) {
              final List<PlayerFirestoreModel> players = [];
              bool buttonDisabled = false;

              if (state is PlayerListFetched) {
                players.addAll(state.players);
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
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      Text(
                        "${checkedPlayers.length} pemain",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: buttonDisabled ? 0 : 2,
                    ),
                    onPressed: buttonDisabled
                        ? null
                        : () => onSubmitMatchMake(checkedPlayers),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "MULAI",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (!buttonDisabled) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
