import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nepak_bulu_2/helpers/matchmakePlayers/matchmaking_result.dart';
import 'package:nepak_bulu_2/models/pair_session_model.dart';
import 'package:nepak_bulu_2/models/player_pair_model.dart';
import 'package:nepak_bulu_2/pages/home_page.dart';
import 'package:nepak_bulu_2/pages/matchmaking/select_player.dart';
import 'package:nepak_bulu_2/pages/matchmaking_v2/matchmaking_page_v2.dart';
import 'package:nepak_bulu_2/pages/matchmaking_v2/matchmaking_result_page_v2.dart';
import 'package:nepak_bulu_2/pages/matchmaking_v2/pair_session_history_page.dart';
import 'package:nepak_bulu_2/pages/matchmaking_v2/preview_pair_page.dart';
import 'package:nepak_bulu_2/pages/matchmaking_v2/select_player_page_v2.dart';
import 'package:nepak_bulu_2/pages/matchmaking_v2/select_session_page_v2.dart';
import 'package:nepak_bulu_2/pages/members/player_list_page.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'player-list',
          builder: (BuildContext context, GoRouterState state) {
            return const PlayerListPage();
          },
        ),
        GoRoute(
          path: 'select-player',
          builder: (BuildContext context, GoRouterState state) {
            return const SelectPlayer();
          },
        ),
        GoRoute(
          path: 'matchmaking-result-v2',
          builder: (BuildContext context, GoRouterState state) {
            return MatchmakingResultPageV2(
              matchmakingResult: state.extra as MatchmakingResult,
            );
          },
        ),
        GoRoute(
          path: 'select-player-v2',
          builder: (BuildContext context, GoRouterState state) {
            return SelectPlayerVer2(
              pairSession: (state.extra != null)
                  ? state.extra as PairSessionModel
                  : null,
            );
          },
        ),
        GoRoute(
          path: 'matchmaking-v2',
          builder: (BuildContext context, GoRouterState state) {
            return const MatchmakingV2Page();
          },
        ),
        GoRoute(
          path: "select-session",
          builder: (context, state) {
            return const SelectSession();
          },
        ),
        GoRoute(
          path: "pair-session-history",
          builder: (context, state) {
            final pairSession = state.extra as PairSessionModel;
            return PairSessionHistoryPage(pairSession: pairSession);
          },
        ),
        GoRoute(
          path: "preview-pair",
          builder: (context, state) {
            final pair = state.extra as PairModel;
            return PreviewPairPage(pair: pair);
          },
        ),
        GoRoute(
          path: "diagram",
          builder: (context, state) {
            return DiagramPage();
          },
        ),
      ],
    ),
  ],
);