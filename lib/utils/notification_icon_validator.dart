import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

/// A utility class to validate notification icons at runtime
/// This helps identify if the notification icon files exist and may warn about potential issues
class NotificationIconValidator {
  /// Check if notification icons exist in the expected locations
  static bool checkNotificationIcons(BuildContext context) {
    if (!Platform.isAndroid) {
      return true; // Only applicable for Android
    }

    final List<String> iconPaths = [
      'drawable/notification_icon.png',
      'drawable-mdpi/notification_icon.png',
      'drawable-hdpi/notification_icon.png',
      'drawable-xhdpi/notification_icon.png',
      'drawable-xxhdpi/notification_icon.png',
      'drawable-xxxhdpi/notification_icon.png',
    ];

    bool allIconsExist = true;
    List<String> missingIcons = [];

    // This is an approximation - can't directly access drawable resources at runtime
    // but we can at least show a warning in debug mode
    for (String iconPath in iconPaths) {
      String assetPath = 'android/app/src/main/res/$iconPath';
      if (!File(assetPath).existsSync()) {
        allIconsExist = false;
        missingIcons.add(iconPath);
      }
    }

    if (!allIconsExist) {
      debugPrint(
          '⚠️ Warning: Some notification icons may be missing: $missingIcons');
      debugPrint(
          '⚠️ This may cause notification icons to appear as white squares');
      debugPrint(
          'ℹ️ See lib/utils/notification_icon_guide.md for instructions');
      debugPrint('💡 Try running the create_notification_icons.sh script');
    } else {
      debugPrint('✅ Notification icons exist in expected locations');
    }

    return allIconsExist;
  }

  /// Show a dialog with guidance on fixing notification icons
  static void showNotificationIconHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Icon Help'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Android notification icons must be white with transparent backgrounds to display correctly.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Why they show as white squares:'),
              const SizedBox(height: 8),
              _buildBulletPoint(
                  'Icons with colors are displayed as solid white shapes'),
              _buildBulletPoint(
                  'Icons with non-transparent backgrounds appear as squares'),
              _buildBulletPoint(
                  'Icons must be properly sized for each density'),
              const SizedBox(height: 16),
              const Text('How to fix:'),
              const SizedBox(height: 8),
              _buildBulletPoint(
                  'Run the create_notification_icons.sh script in the project root'),
              _buildBulletPoint(
                  'Use a white logo on transparent background as the source image'),
              _buildBulletPoint(
                  'Test the app after creating new notification icons'),
              const SizedBox(height: 16),
              const Text(
                  'See lib/utils/notification_icon_guide.md for detailed instructions.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Show a snackbar with instructions to run the script
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Run create_notification_icons.sh script from your project root',
                  ),
                  duration: const Duration(seconds: 5),
                  action: SnackBarAction(
                    label: 'OK',
                    onPressed: () {},
                  ),
                ),
              );
            },
            child: const Text('Fix Icons'),
          ),
        ],
      ),
    );
  }

  /// Helper to build a bullet point
  static Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
