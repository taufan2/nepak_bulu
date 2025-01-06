import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadSection extends StatelessWidget {
  const DownloadSection({super.key});

  void _launchDownloadUrl() {
    launchUrl(
      Uri.parse(
          'https://drive.google.com/drive/folders/1kJghZcTJjHhITDdxbH_oRMZvOeFyzO6U?usp=drive_link'),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.android_rounded,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Aplikasi Android",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Unduh APK langsung dari Google Drive",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: _launchDownloadUrl,
            icon: const Icon(Icons.download),
            label: const Text("APK"),
          ),
        ],
      ),
    );
  }
}
