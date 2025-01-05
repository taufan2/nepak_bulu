import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nepak_bulu_2/models/pair_session_model.dart';
import 'package:nepak_bulu_2/helpers/date_formatter.dart';

class SessionStatusHeader extends StatelessWidget {
  final PairSessionModel? pairSession;

  const SessionStatusHeader({
    super.key,
    this.pairSession,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNewSession = pairSession == null;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            isNewSession
                ? theme.colorScheme.primary
                : theme.colorScheme.tertiary,
            isNewSession
                ? theme.colorScheme.primary.withValues(alpha: .9)
                : theme.colorScheme.tertiary.withValues(alpha: .9),
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
                  isNewSession ? Icons.fiber_new : Icons.refresh,
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
                      isNewSession ? "Sesi Baru" : "Lanjutan Sesi",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isNewSession
                          ? "Anda memulai sesi baru untuk memilih pemain."
                          : "Anda melanjutkan sesi pemilihan pemain sebelumnya.",
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
          if (pairSession != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimary.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    color: theme.colorScheme.onPrimary.withValues(alpha: .8),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formatDateFromDateTime(
                      pairSession!.createdAt,
                      'dd MMMM yyyy HH:mm',
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary.withValues(alpha: .8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor:
                    theme.colorScheme.onPrimary.withValues(alpha: .2),
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              onPressed: () {
                context.push("/pair-session-history", extra: pairSession);
              },
              icon: const Icon(Icons.history),
              label: const Text("Lihat History Pasangan"),
            ),
          ],
        ],
      ),
    );
  }
}
