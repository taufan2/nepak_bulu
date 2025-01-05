import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nepak_bulu_2/bloc/player_list/player_list_bloc.dart';
import 'package:nepak_bulu_2/models/player_firestore_model.dart';
import 'package:nepak_bulu_2/theme/app_theme.dart';

class MemberListBuilder extends StatefulWidget {
  const MemberListBuilder({
    super.key,
  });

  @override
  State<MemberListBuilder> createState() => _MemberListBuilderState();
}

class _MemberListBuilderState extends State<MemberListBuilder> {
  late final PlayerListBloc playerListBloc;

  @override
  void initState() {
    super.initState();
    playerListBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<PlayerListBloc, PlayerListState>(
      builder: (context, state) {
        final List<PlayerFirestoreModel> players = [];
        if (state is PlayerListFetched) {
          players.addAll(state.players);
        }

        if (players.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 64,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  "Belum ada data pemain",
                  style: AppTheme.titleLarge.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.8,
          ),
          itemCount: players.length,
          itemBuilder: (context, index) {
            final player = players[index];
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onLongPress:
                      !player.readonly ? () => deletePlayer(player) : null,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor:
                              AppTheme.primaryColor.withValues(alpha: .9),
                          child: Text(
                            player.name[0].toUpperCase(),
                            style: AppTheme.titleLarge.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player.name,
                                style: AppTheme.titleLarge.copyWith(
                                  fontSize: 14,
                                  color: theme.colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (player.lowPriority)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      size: 12,
                                      color: theme.colorScheme.error,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      'Low Priority',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.error,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        if (!player.readonly)
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18),
                            color: theme.colorScheme.error,
                            onPressed: () => deletePlayer(player),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            visualDensity: VisualDensity.compact,
                            tooltip: 'Hapus Pemain',
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void deletePlayer(PlayerFirestoreModel player) {
    playerListBloc.add(DeletePlayer(player.documentRef!, context));
  }
}
