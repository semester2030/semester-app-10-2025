import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:semester_student_ride_app/services/notification_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:semester_student_ride_app/services/providers/notification_provider.dart';

/// A utility class to validate that notifications display correctly at runtime
class NotificationDisplayValidator {
  /// Test if notifications are displaying correctly
  /// This method sends a test notification and shows a UI with feedback options
  static void validateNotificationDisplay(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Notification Icon Test'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'A test notification will be sent in 5 seconds. Please observe how the notification icon appears.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(),
              const SizedBox(height: 16),
              const Text(
                  'After receiving the notification, please indicate how it appears:'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    // Send a test notification after a delay
    Timer(const Duration(seconds: 1), () {
      // ref.read(notificationServiceProvider).scheduleTestNotification(
      //       title: 'Icon Test Notification',
      //       body: 'Does this notification icon display correctly?',
      //       delay: const Duration(seconds: 5),
      //     );

      // After a slightly longer delay, show the feedback dialog
      Timer(const Duration(seconds: 7), () {
        if (context.mounted) {
          Navigator.of(context).pop(); // Close the initial dialog
          _showNotificationFeedbackDialog(context, ref);
        }
      });
    });
  }

  /// Show a dialog to collect feedback about how the notification appears
  static void _showNotificationFeedbackDialog(
      BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('How does the notification icon look?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFeedbackOption(
                context,
                'The icon looks good (app logo is visible)',
                Icons.check_circle,
                Colors.green,
                () => _recordNotificationFeedback(context, ref, 'good'),
              ),
              const SizedBox(height: 8),
              _buildFeedbackOption(
                context,
                'The icon is a white square or shape',
                Icons.warning,
                Colors.orange,
                () => _recordNotificationFeedback(context, ref, 'white_square'),
              ),
              const SizedBox(height: 8),
              _buildFeedbackOption(
                context,
                'No notification appeared',
                Icons.error,
                Colors.red,
                () => _recordNotificationFeedback(
                    context, ref, 'no_notification'),
              ),
              const SizedBox(height: 8),
              _buildFeedbackOption(
                context,
                'Something else/not sure',
                Icons.help_outline,
                Colors.blue,
                () => _recordNotificationFeedback(context, ref, 'other'),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build a feedback option button
  static Widget _buildFeedbackOption(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Record the user's feedback about the notification
  static void _recordNotificationFeedback(
      BuildContext context, WidgetRef ref, String feedbackType) {
    // Close the dialog
    Navigator.of(context).pop();

    // Log the feedback
    log('📱 Notification icon feedback: $feedbackType');

    // Show appropriate guidance based on feedback
    switch (feedbackType) {
      case 'good':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Great! Your notification icons are working correctly.'),
            backgroundColor: Colors.green,
          ),
        );
        break;
      case 'white_square':
        _showIconFixDialog(context);
        break;
      case 'no_notification':
        _showNotificationPermissionDialog(context, ref);
        break;
      case 'other':
        _showGeneralTroubleshootingDialog(context);
        break;
    }
  }

  /// Show a dialog with guidance on fixing icon issues
  static void _showIconFixDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fix Notification Icon'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your notification icon appears as a white shape because Android requires notification icons to be transparent with white content.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'To fix this:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('1. Run the notification icon generator script'),
            const Text('2. Open the app with a properly formatted icon'),
            const Text('3. Test again to verify the fix worked'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Show documentation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Please refer to NOTIFICATION_ICON_FIX.md for detailed instructions'),
                ),
              );
            },
            child: const Text('View Documentation'),
          ),
        ],
      ),
    );
  }

  /// Show a dialog for notification permission issues
  static void _showNotificationPermissionDialog(
      BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Permission Issue'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'It seems your device is not receiving notifications. This could be due to:',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text('1. Notification permissions are denied'),
            Text('2. Battery optimization is blocking notifications'),
            Text('3. App is in Do Not Disturb list'),
            Text('4. Device-specific notification settings'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Try to request notification permission again
              ref.read(notificationServiceProvider).init();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  /// Show general troubleshooting guidance
  static void _showGeneralTroubleshootingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Troubleshooting'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Here are some general steps to troubleshoot notification issues:',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text('1. Restart your device'),
            Text('2. Check notification permissions in device settings'),
            Text('3. Ensure the app is not in battery optimization'),
            Text('4. Update the app to the latest version'),
            Text('5. Clear app cache and data'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
