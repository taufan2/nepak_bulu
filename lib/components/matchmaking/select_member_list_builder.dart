import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nepak_bulu_2/bloc/select_player_presence/select_player_presence_bloc.dart';
import 'package:nepak_bulu_2/models/player_firestore_model.dart';
import 'package:nepak_bulu_2/theme/app_theme.dart';

class SelectMemberListBuilder extends StatelessWidget {
  const SelectMemberListBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SelectPlayerPresenceBloc, SelectPlayerPresenceState>(
      builder: (context, state) {
        final List<PlayerFirestoreModel> players = [];

        if (state is PlayerListFetched) {
          players.addAll(state.players);
        } else if (state is SelectPlayerPresenceCreatingMatch) {
          players.addAll(state.players);
        }

        if (state is PlayerListFetched ||
            state is SelectPlayerPresenceCreatingMatch) {
          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              final isSelected = player.presence;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Card(
                  elevation: isSelected ? 2 : 0,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : theme.colorScheme.outline.withValues(alpha: 0.2),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: (state is PlayerListFetched &&
                            state.presenceToggleLoading)
                        ? null
                        : () {
                            context.read<SelectPlayerPresenceBloc>().add(
                                  MarkPlayerPresence(player, !player.presence),
                                );
                          },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryColor.withValues(alpha: 0.05)
                            : null,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  player.name,
                                  style: AppTheme.titleLarge.copyWith(
                                    color: isSelected
                                        ? AppTheme.primaryColor
                                        : theme.colorScheme.onSurface,
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                          if (state is PlayerListFetched &&
                              state.presenceToggleLoading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.primaryColor,
                              ),
                            )
                          else
                            Switch(
                              value: isSelected,
                              onChanged: (bool newValue) {
                                context.read<SelectPlayerPresenceBloc>().add(
                                      MarkPlayerPresence(player, newValue),
                                    );
                              },
                              activeColor: AppTheme.primaryColor,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: AppTheme.primaryColor,
            ),
          );
        }
      },
    );
  }
}
