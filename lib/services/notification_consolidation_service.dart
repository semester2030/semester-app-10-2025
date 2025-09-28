import 'dart:developer';
import 'package:semester_student_ride_app/models/notification_model.dart';

/// Service for consolidating notifications to prevent spam and improve user experience
class NotificationConsolidationService {
  /// Consolidates a list of notifications by grouping similar ones and keeping only the latest
  ///
  /// Rules:
  /// - For messages: Keep only the latest message notification from each sender
  /// - For meetup events: Keep only the latest event notification per user-meetup combination
  /// - For other types: Keep all notifications
  static List<NotificationModel> consolidateNotifications(
      List<NotificationModel> notifications) {
    if (notifications.isEmpty) return [];

    final Map<String, NotificationModel> consolidatedMap = {};

    for (final notification in notifications) {
      final key = _getConsolidationKey(notification);

      // Keep the latest notification for each key
      // Since notifications are ordered by timestamp desc, the first occurrence is the latest
      if (!consolidatedMap.containsKey(key)) {
        consolidatedMap[key] = notification;
      }
    }

    // Convert back to list and sort by timestamp (latest first)
    final consolidatedList = consolidatedMap.values.toList();
    consolidatedList.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    log('Consolidated ${notifications.length} notifications to ${consolidatedList.length}',
        name: 'NotificationConsolidation');

    return consolidatedList;
  }

  /// Generates a consolidation key for grouping similar notifications
  static String _getConsolidationKey(NotificationModel notification) {
    switch (notification.type) {
      case 'message':
      case 'group_message':
        // Group by sender for message notifications
        return 'message_${notification.senderUserId}';

      case 'meetup_join':
      case 'meetup_leave':
        // Group by sender + meetup combination for meetup events
        return 'meetup_${notification.senderUserId}_${notification.meetupId}';

      default:
        // Keep all other notification types separate
        return 'other_${notification.id}';
    }
  }

  /// Checks if two notifications should be consolidated
  static bool shouldConsolidate(
      NotificationModel notification1, NotificationModel notification2) {
    return _getConsolidationKey(notification1) ==
        _getConsolidationKey(notification2);
  }

  /// Gets a summary of how many notifications were consolidated
  static Map<String, int> getConsolidationSummary(
      List<NotificationModel> original, List<NotificationModel> consolidated) {
    final messageConsolidated = original
            .where((n) => n.type == 'message' || n.type == 'group_message')
            .length -
        consolidated
            .where((n) => n.type == 'message' || n.type == 'group_message')
            .length;

    final meetupConsolidated = original
            .where((n) => n.type == 'meetup_join' || n.type == 'meetup_leave')
            .length -
        consolidated
            .where((n) => n.type == 'meetup_join' || n.type == 'meetup_leave')
            .length;

    return {
      'totalOriginal': original.length,
      'totalConsolidated': consolidated.length,
      'messageConsolidated': messageConsolidated,
      'meetupConsolidated': meetupConsolidated,
    };
  }
}
