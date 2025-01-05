import 'package:flutter/material.dart';

import '../../../helpers/matchmakePlayers/matchmaking_result.dart';
import '../../../models/team_match_model.dart';
import '../../../models/team_model.dart';

class MatchmakingResultPageV2 extends StatelessWidget {
  final MatchmakingResult matchmakingResult;

  const MatchmakingResultPageV2({super.key, required this.matchmakingResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Matchmaking'),
        elevation: 0,
        backgroundColor: Colors.indigo.shade600,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            if (matchmakingResult.noMoreUniquePairs)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withValues(alpha: .1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Colors.orange.shade700, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Semua pemain sudah pernah dipasangkan satu sama lain. Pasangan dibuat secara acak.',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            _buildTeamsList(context),
            _buildMatchSchedule(context),
            _buildUnmatchedInfo(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.indigo.shade500,
            Colors.indigo.shade700,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withValues(alpha: .3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.summarize_rounded,
                  color: Colors.white.withValues(alpha: .9), size: 28),
              const SizedBox(width: 12),
              Text(
                'Ringkasan',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  context,
                  '${matchmakingResult.teams.length}',
                  'Tim Terbentuk',
                  Icons.group_rounded,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  context,
                  '${matchmakingResult.teamMatches.length}',
                  'Pertandingan',
                  Icons.sports_tennis_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: .2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: .9),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamsList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people_alt_outlined,
                  color: Colors.indigo.shade700, size: 24),
              const SizedBox(width: 12),
              Text(
                'Pasangan Tim',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo.shade700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...matchmakingResult.teams.asMap().entries.map(
                (entry) => _buildTeamCard(context, entry.key, entry.value),
              ),
        ],
      ),
    );
  }

  Widget _buildTeamCard(BuildContext context, int index, TeamModel team) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.shade50,
          radius: 24,
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: Colors.indigo.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        title: Text(
          team.teamName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '${team.player1.name} & ${team.player2.name}',
            style: TextStyle(
              color: Colors.grey.shade600,
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMatchSchedule(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule_outlined,
                  color: Colors.grey.shade700, size: 24),
              const SizedBox(width: 12),
              Text(
                'Jadwal Pertandingan',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...matchmakingResult.teamMatches
              .asMap()
              .entries
              .map((entry) => _buildMatchCard(context, entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildMatchCard(
      BuildContext context, int index, TeamMatchModel match) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade100,
          child: Text('${index + 1}',
              style: TextStyle(color: Colors.teal.shade800)),
        ),
        title: Text('${match.team1.teamName} vs ${match.team2.teamName}'),
        subtitle: Text('Pertandingan ${index + 1}'),
      ),
    );
  }

  Widget _buildUnmatchedInfo(BuildContext context) {
    final theme = Theme.of(context);

    if (matchmakingResult.noTeam == null && matchmakingResult.noMatch == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.secondary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: theme.colorScheme.secondary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Informasi Tambahan',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (matchmakingResult.noTeam != null)
                  _buildInfoItem(
                    context,
                    icon: Icons.person_off_outlined,
                    label: 'Pemain tanpa pasangan:',
                    value: matchmakingResult.noTeam!.name,
                  ),
                if (matchmakingResult.noTeam != null &&
                    matchmakingResult.noMatch != null)
                  const SizedBox(height: 12),
                if (matchmakingResult.noMatch != null)
                  _buildInfoItem(
                    context,
                    icon: Icons.groups_outlined,
                    label: 'Tim tanpa lawan:',
                    value: matchmakingResult.noMatch!.teamName,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.secondary.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
