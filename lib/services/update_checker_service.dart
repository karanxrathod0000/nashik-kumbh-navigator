import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service to check the official GitHub repository for direct APK updates.
/// Especially useful for volunteers and pilgrims who sideloaded the app.
class UpdateCheckerService {
  static const String _githubOwner = 'karanparanox';
  static const String _githubRepo = 'nashik-kumbh-navigator';
  static const String _releasesApiUrl =
      'https://api.github.com/repos/$_githubOwner/$_githubRepo/releases/latest';

  /// Checks if a newer version is available on GitHub Releases compared to [currentVersion].
  static Future<void> checkForUpdates(BuildContext context, {bool quiet = true}) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version; // e.g., "1.0.0"

      final response = await http
          .get(Uri.parse(_releasesApiUrl))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String? tag = data['tag_name'] as String?;
        final String? htmlUrl = data['html_url'] as String?;

        if (tag != null && htmlUrl != null) {
          final String latestVersion = tag.replaceFirst('v', '').trim();
          if (_isNewerVersion(latestVersion, currentVersion)) {
            if (context.mounted) {
              _showUpdateDialog(context, latestVersion, htmlUrl);
            }
          } else if (!quiet && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Nashik Kumbh Navigator v$currentVersion is up to date.'),
                backgroundColor: const Color(0xFF1E1B4B),
              ),
            );
          }
        }
      }
    } catch (_) {
      // Fail silently if offline or API unreachable
    }
  }

  static bool _isNewerVersion(String latest, String current) {
    final lParts = latest.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final cParts = current.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    for (int i = 0; i < 3; i++) {
      final l = i < lParts.length ? lParts[i] : 0;
      final c = i < cParts.length ? cParts[i] : 0;
      if (l > c) return true;
      if (l < c) return false;
    }
    return false;
  }

  static void _showUpdateDialog(BuildContext context, String newVersion, String url) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.system_update_alt, color: Color(0xFFFF8C42)),
            SizedBox(width: 8),
            Text('Update Available'),
          ],
        ),
        content: Text(
          'A newer version (v$newVersion) of Nashik Kumbh Navigator is available on GitHub Releases.\n\n'
          'Would you like to download the updated APK now?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Later'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8C42),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: const Text('Download APK'),
          ),
        ],
      ),
    );
  }
}
