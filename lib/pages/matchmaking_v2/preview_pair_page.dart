import 'package:flutter/material.dart';
import 'package:nepak_bulu_2/models/player_pair_model.dart';

class PreviewPairPage extends StatefulWidget {
  final PairModel pair;
  const PreviewPairPage({super.key, required this.pair});

  @override
  State<PreviewPairPage> createState() => _PreviewPairPageState();
}

class _PreviewPairPageState extends State<PreviewPairPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Pasangan'),
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
            _buildPairDetails(context),
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
            color: Colors.indigo.withValues(alpha: 0.3),
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
              Icon(Icons.people_alt_rounded,
                  color: Colors.white.withValues(alpha: 0.9), size: 28),
              const SizedBox(width: 12),
              Text(
                'Informasi Pasangan',
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
                  '${widget.pair.pairs.length}',
                  'Total Pasangan',
                  Icons.people_alt_rounded,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  context,
                  widget.pair.createdAt.toString().substring(0, 10),
                  'Tanggal Dibuat',
                  Icons.calendar_today_rounded,
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
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
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
                  color: Colors.white.withValues(alpha: 0.9),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPairDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline_rounded,
                  color: Colors.indigo.shade700, size: 24),
              const SizedBox(width: 12),
              Text(
                'Daftar Pasangan',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo.shade700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...widget.pair.pairs.asMap().entries.map((entry) {
            final index = entry.key;
            final pair = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
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
                    '${pair.player1.name} & ${pair.player2.name}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Pasangan ${index + 1}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
          if (widget.pair.noTeam?.isNotEmpty ?? false) ...[
            const SizedBox(height: 32),
            Row(
              children: [
                Icon(Icons.person_off_outlined,
                    color: Colors.orange.shade700, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Pemain Tanpa Pasangan',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.orange.shade200,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.pair.noTeam ?? '',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.orange.shade900,
                          height: 1.5,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pemain ini tidak mendapatkan pasangan dalam sesi ini',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.orange.shade800,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
