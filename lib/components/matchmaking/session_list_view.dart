import 'package:flutter/material.dart';
import 'package:nepak_bulu_2/models/pair_session_model.dart';
import 'package:nepak_bulu_2/components/matchmaking/session_list_tile.dart';

class SessionListView extends StatelessWidget {
  final List<PairSessionModel> sessions;

  const SessionListView({
    super.key,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final PairSessionModel session = sessions[index];
        return SessionListTile(session: session);
      },
    );
  }
}
