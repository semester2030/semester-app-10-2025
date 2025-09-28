import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  /// Initialize the notification service
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Android settings
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('notification_icon');

      // iOS settings
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _notifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Request permissions for iOS
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await _notifications
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
      }

      // Request permissions for Android 13+
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _notifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      }

      _initialized = true;
      log('✅ Local notifications initialized successfully',
          name: 'LocalNotificationService');
    } catch (e) {
      log('❌ Error initializing local notifications: $e',
          name: 'LocalNotificationService');
    }
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    log('Notification tapped: ${response.payload}',
        name: 'LocalNotificationService');
    // Handle notification tap based on payload
  }

  /// Show proximity notification when driver is near pickup
  static Future<void> showProximityNotification({
    required String driverName,
    required String estimatedArrival,
    String? payload,
  }) async {
    if (!_initialized) await initialize();

    try {
      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'proximity_alerts',
        'Driver Proximity Alerts',
        channelDescription:
            'Notifications when driver is approaching pickup location',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
        icon: '@mipmap/ic_launcher',
        color: const Color(0xFF6B46C1), // accentPurple
        styleInformation: const BigTextStyleInformation(''),
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        interruptionLevel: InterruptionLevel.timeSensitive,
      );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        1, // Notification ID
        'Driver Approaching!',
        '$driverName is nearby and will arrive in $estimatedArrival. Get ready for pickup!',
        notificationDetails,
        payload: payload,
      );

      log('📱 Proximity notification sent for driver: $driverName',
          name: 'LocalNotificationService');
    } catch (e) {
      log('❌ Error showing proximity notification: $e',
          name: 'LocalNotificationService');
    }
  }

  /// Show general trip notification
  static Future<void> showTripNotification({
    required String title,
    required String body,
    String? payload,
    int id = 0,
  }) async {
    if (!_initialized) await initialize();

    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'trip_updates',
        'Trip Updates',
        channelDescription: 'Notifications for trip status updates',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFF6B46C1), // accentPurple
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      log('📱 Trip notification sent: $title',
          name: 'LocalNotificationService');
    } catch (e) {
      log('❌ Error showing trip notification: $e',
          name: 'LocalNotificationService');
    }
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    log('🗑️ All notifications cancelled', name: 'LocalNotificationService');
  }

  /// Cancel specific notification
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
    log('🗑️ Notification $id cancelled', name: 'LocalNotificationService');
  }
}
