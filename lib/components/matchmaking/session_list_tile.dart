import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nepak_bulu_2/helpers/date_formatter.dart';
import 'package:nepak_bulu_2/models/pair_session_model.dart';
import 'package:nepak_bulu_2/theme/app_theme.dart';

class SessionListTile extends StatelessWidget {
  final PairSessionModel session;

  const SessionListTile({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            context.push(
              '/select-player-v2',
              extra: session,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.group_rounded,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.name,
                        style: AppTheme.titleLarge.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formatDateFromDateTime(
                                session.createdAt, "dd MMM yyyy HH:mm"),
                            style: AppTheme.bodyMedium.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
