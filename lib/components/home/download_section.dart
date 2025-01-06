import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

const String appVersion = '1.0.0';

class DownloadSection extends StatelessWidget {
  const DownloadSection({super.key});

  void _launchDownloadUrl() {
    launchUrl(
      Uri.parse(
          'https://drive.google.com/drive/folders/1kJghZcTJjHhITDdxbH_oRMZvOeFyzO6U?usp=drive_link'),
      mode: LaunchMode.externalApplication,
    );
  }

  void _launchWebUrl() {
    launchUrl(
      Uri.parse('https://badminton-wd.web.app/'),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isAndroid = !kIsWeb;

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
              isAndroid ? Icons.web : Icons.android_rounded,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAndroid ? "Versi Web" : "Aplikasi Android",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  isAndroid
                      ? "Buka aplikasi di browser"
                      : "Unduh APK langsung dari Google Drive",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: isAndroid ? _launchWebUrl : _launchDownloadUrl,
            icon: Icon(isAndroid ? Icons.open_in_new : Icons.download),
            label: Text(isAndroid ? "Buka" : "APK"),
          ),
        ],
      ),
    );
  }
}
