import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

import '../components/home/home_button.dart';
import '../components/home/download_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  onPlayerListClick() {
    context.go('/player-list');
  }

  onMatchMakingClick() {
    context.go('/select-player');
  }

  onMatchMakingV2Click() {
    context.go('/matchmaking-v2');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  "Selamat datang",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Warga Discord!",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  "Pilih opsi di bawah untuk memulai.",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 60),
                HomeButton(
                  onPressed: onPlayerListClick,
                  icon: Icons.people_outline,
                  label: 'Daftar Pemain',
                ),
                const SizedBox(height: 16),
                HomeButton(
                  onPressed: onMatchMakingClick,
                  icon: Icons.group_add_outlined,
                  label: 'Matchmaking',
                ),
                const SizedBox(height: 16),
                HomeButton(
                  onPressed: onMatchMakingV2Click,
                  icon: Icons.groups_outlined,
                  label: 'Unique Matchmaking',
                ),
                const Spacer(),
                // Download section
                if (kIsWeb) ...[
                  const DownloadSection(),
                  const SizedBox(height: 20),
                ],
                // Footer
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Center(
                    child: Text(
                      "Made with ❤️ for Discord Community",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[500],
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
