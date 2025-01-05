import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nepak_bulu_2/bloc/pair_session_history/pair_session_history_cubit.dart';
import 'package:nepak_bulu_2/components/matchmaking/pair_model_list_builder.dart';
import 'package:nepak_bulu_2/models/pair_session_model.dart';
import 'package:intl/intl.dart';

class PairSessionHistoryPage extends StatefulWidget {
  final PairSessionModel pairSession;
  const PairSessionHistoryPage({super.key, required this.pairSession});

  @override
  State<PairSessionHistoryPage> createState() => _PairSessionHistoryPageState();
}

class _PairSessionHistoryPageState extends State<PairSessionHistoryPage> {
  final PairSessionHistoryCubit pairSessionHistoryCubit =
      PairSessionHistoryCubit();

  @override
  void initState() {
    super.initState();
    pairSessionHistoryCubit.fetchPairSessionHistory(widget.pairSession);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => pairSessionHistoryCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("History Pasangan"),
          elevation: 0,
        ),
        body: Column(
          spacing: 20,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: .8),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.history_rounded,
                            color: theme.colorScheme.onPrimary,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.pairSession.name,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.onPrimary.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              color: theme.colorScheme.onPrimary
                                  .withValues(alpha: .8),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('dd MMM yyyy, HH:mm')
                                  .format(widget.pairSession.createdAt),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimary
                                    .withValues(alpha: .8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const PairModelListBuilder(),
          ],
        ),
      ),
    );
  }
}
