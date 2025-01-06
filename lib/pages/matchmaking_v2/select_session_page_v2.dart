import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nepak_bulu_2/bloc/select_session/select_session_bloc_bloc.dart';
import 'package:nepak_bulu_2/components/matchmaking/session_list_view.dart';
import 'package:nepak_bulu_2/models/pair_session_model.dart';
import 'package:nepak_bulu_2/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';

class SelectSession extends StatefulWidget {
  const SelectSession({super.key});

  @override
  State<SelectSession> createState() => _SelectSessionState();
}

class _SelectSessionState extends State<SelectSession> {
  final SelectSessionBloc _selectSessionBlocBloc = SelectSessionBloc();

  @override
  void initState() {
    super.initState();
    _selectSessionBlocBloc.add(const SelectSessionBlocFetch());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => _selectSessionBlocBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Pilih Sesi',
            style: AppTheme.titleLarge.copyWith(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () =>
                  _selectSessionBlocBloc.add(const SelectSessionBlocFetch()),
              tooltip: 'Refresh Data',
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Daftar Sesi",
                      style: AppTheme.headlineMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<SelectSessionBloc, SelectSessionBlocState>(
                  builder: (context, state) {
                    if (state is SelectSessionBlocError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              color: theme.colorScheme.error,
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              style: AppTheme.titleLarge.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                context
                                    .read<SelectSessionBloc>()
                                    .add(const SelectSessionBlocFetch());
                              },
                              icon: const Icon(Icons.refresh_rounded,
                                  color: Colors.white),
                              label: const Text('Coba Lagi',
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is SelectSessionBlocLoading) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Card(
                              elevation: 0,
                              margin: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: theme.colorScheme.outline
                                      .withValues(alpha: 0.1),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 52,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 20,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            height: 14,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }

                    final List<PairSessionModel> sessions = [];

                    if (state is SelectSessionBlocLoaded) {
                      sessions.addAll(state.sessions);
                    }

                    if (sessions.isNotEmpty) {
                      return SessionListView(sessions: sessions);
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              size: 64,
                              color: theme.colorScheme.outline,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Belum ada sesi tersedia',
                              style: AppTheme.titleLarge.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
