import 'dart:developer';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semester_student_ride_app/services/providers/cloud_functions_provider.dart';
import 'package:semester_student_ride_app/services/providers/initial_notification_provider.dart';
import 'package:semester_student_ride_app/services/router.dart';

class NotificationService {
  final Ref ref;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotifications =
      FlutterLocalNotificationsPlugin();

  NotificationService(this.ref);

  // Initialize the notification service
  Future<void> init() async {
    await _configureNotificationPermissions();
    await _configureLocalNotifications();
    _configureFCMHandlers(); // Handle platform-specific token retrieval
    if (Platform.isIOS) {
      // For iOS, wait for the APNS token before getting the FCM token
      try {
        // Wait for APNS token and log it
        final apnsToken = await _firebaseMessaging.getAPNSToken();
        log('APNS Token: ${apnsToken ?? 'No APNS token found'}');

        // Only proceed with getting FCM token if APNS token exists
        if (apnsToken != null) {
          final fcmToken = await _firebaseMessaging.getToken();
          log('FCM Token: ${fcmToken ?? 'No FCM token found'}');
          _saveTokenToBackend(fcmToken);
        } else {
          log('APNS token is null, cannot get FCM token');
        }
      } catch (e) {
        log('Error during iOS notification setup: $e', error: e);
      }
    } else {
      // For Android, get FCM token directly
      try {
        final token = await _firebaseMessaging.getToken();
        _saveTokenToBackend(token);
      } catch (e) {
        log('Error getting Android FCM token: $e', error: e);
      }
    }

    _firebaseMessaging.onTokenRefresh.listen(_saveTokenToBackend);
  }

  // Configure notification permissions
  Future<void> _configureNotificationPermissions() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (Platform.isIOS || Platform.isMacOS) {
      await _flutterLocalNotifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await _flutterLocalNotifications
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final androidImplementation =
          _flutterLocalNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
    }
  }

  // Configure local notifications
  Future<void> _configureLocalNotifications() async {
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _flutterLocalNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const androidSettings = AndroidInitializationSettings('notification_icon');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // Set to track recently shown notification IDs to prevent duplicates
  final Map<String, DateTime> _recentNotificationIds = {};

  // Time window in seconds to consider a notification as duplicate
  static const int _deduplicationTimeWindowSeconds = 10;

  // Configure FCM handlers
  void _configureFCMHandlers() {
    // FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    FirebaseMessaging.onMessage.listen(
      (event) {
        if (Platform.isIOS) {
          log("received event for iOS : $event");
          return;
        }
        log("received event: $event", name: "NOTIFICATION_RECEIVED");
        if (event.notification == null && event.data.isEmpty) {
          log("No notification or data in message, skipping",
              name: "NOTIFICATION_EMPTY");
          return;
        }
        _handleForegroundMessage(event);
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessageTap);
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    // Skip direct send messages in foreground to prevent duplicates
    // These are meant for background delivery only
    if (message.data['directSend'] == 'true') {
      log('Skipping directSend notification in foreground',
          name: 'NOTIFICATION_DEDUP');
      return;
    }
    _showLocalNotification(message);
  }

  // Handle background messages tap
  void _handleBackgroundMessageTap(RemoteMessage message) {
    _processNotificationData(message.data);
  }

  // Generate a consistent notification ID based on content
  String _generateNotificationKey(RemoteMessage message) {
    // Create a key using available unique identifiers
    final notificationId = message.data['notificationId'] as String?;
    final messageId = message.messageId;

    if (notificationId != null) {
      return 'notification-$notificationId';
    } else if (messageId != null) {
      return 'message-$messageId';
    } else {
      // Create hash from content if no IDs are available
      final title = message.notification?.title ?? message.data['title'];
      final body = message.notification?.body ?? message.data['body'];
      // Don't include timestamp in the key to catch duplicates with identical content
      return 'content-$title-$body';
    }
  }

  // Clean up old notification keys periodically
  void _cleanupNotificationIds() {
    final now = DateTime.now();
    _recentNotificationIds.removeWhere((_, timestamp) {
      final diff = now.difference(timestamp).inSeconds;
      return diff > _deduplicationTimeWindowSeconds;
    });
  }

  // Show local notification with deduplication
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notificationKey = _generateNotificationKey(message);
    final now = DateTime.now();

    // Clean up old entries periodically
    _cleanupNotificationIds();

    // Check if this notification has been shown recently
    if (_recentNotificationIds.containsKey(notificationKey)) {
      final lastShown = _recentNotificationIds[notificationKey]!;
      final diffSeconds = now.difference(lastShown).inSeconds;

      if (diffSeconds < _deduplicationTimeWindowSeconds) {
        log('Skipping duplicate notification: $notificationKey (shown $diffSeconds seconds ago)',
            name: 'NOTIFICATION_DEDUP');
        return;
      }
    }

    // Add to recent notifications to prevent duplicates
    _recentNotificationIds[notificationKey] = now;

    // Log notification info for debugging
    log('Processing notification with key: $notificationKey',
        name: 'NOTIFICATION_PROCESS');

    if (message.notification != null) {
      log('Showing notification: ${message.notification?.title ?? "Untitled"}',
          name: "NOTIFICATION_MESSAGE");
      await _showIndividualNotification(message);
    } else if (message.data['title'] != null && message.data['body'] != null) {
      log('Showing data notification: ${message.data['title']}',
          name: "NOTIFICATION_DATA");
      await _showDataOnlyNotification(message);
    }
  }

  // Handle notification response
  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!) as Map<String, dynamic>;

        log('Notification tapped with data: $data');
        _processNotificationData(data);
      } catch (e) {
        // Handle error silently
      }
    }
  }

  // Process notification data
  void _processNotificationData(Map<String, dynamic> data) {
    final route = data['route'] as String?;
    final threadId = data['threadId'] as String?;
    final notificationId = data['notificationId'] as String?;

    // Mark notification as read when user taps on it
    if (notificationId != null) {
      _markNotificationAsRead(notificationId);
    }

    if (route != null && threadId != null) {
      _handleRouteWithThreadId(route, threadId, data);
    } else if (route != null) {
      _handleSimpleRoute(route);
    }
  }

  // Handle routes with thread ID
  void _handleRouteWithThreadId(
      String route, String threadId, Map<String, dynamic> data) {
    try {
      final router = ref.read(routerProvider);

      switch (route) {
        case "/chatting":
          _handleChatNavigation(threadId, data, router);
          break;

        default:
          router.go(route);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  // Handle chat navigation
  void _handleChatNavigation(
      String threadId, Map<String, dynamic> data, dynamic router) {
    final otherUserId = data['otherUserId'] as String?;
    if (otherUserId != null) {
      // ref.read(userDetailsProvider(otherUserId).future).then((userDetails) {
      //   if (userDetails != null) {
      //     router.go('/chatting', extra: {
      //       'threadId': threadId,
      //       'otherUser': userDetails,
      //     });
      //   }
      // }).catchError((error) {
      //   // Handle error silently
      // });
    }
  }

  // Handle simple route
  void _handleSimpleRoute(String route) {
    try {
      final router = ref.read(routerProvider);
      router.go(route);
    } catch (e) {
      // Handle error silently
    }
  }

  // Get byte array from URL
  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  // Create circular avatar from image bytes
  Future<Uint8List> _createCircularAvatar(Uint8List imageBytes) async {
    try {
      final image = await decodeImageFromList(imageBytes);
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      const size = 96.0;

      final path = Path()..addOval(Rect.fromLTWH(0, 0, size, size));
      canvas.clipPath(path);

      final paint = Paint()..isAntiAlias = true;
      final srcRect =
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
      final dstRect = Rect.fromLTWH(0, 0, size, size);

      canvas.drawImageRect(image, srcRect, dstRect, paint);

      final picture = recorder.endRecording();
      final img = await picture.toImage(size.toInt(), size.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

      return byteData!.buffer.asUint8List();
    } catch (e) {
      return imageBytes;
    }
  }

  // Save FCM token to backend
  Future<void> _saveTokenToBackend(String? token) async {
    if (token == null) return;

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      await userCollection.doc(currentUser.uid).update({
        'fcmToken': token,
        'tokenUpdatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Handle error silently
    }
  }

  // Public method to process a stored initial notification
  void processInitialNotification() {
    final initialNotification =
        ref.read(initialNotificationProvider.notifier).state;
    if (initialNotification != null) {
      ref.read(initialNotificationProvider.notifier).state = null;
      _processNotificationData(initialNotification);
    }
  }

  // Method to check for and process any pending initial notification
  void checkAndProcessInitialNotification() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        ref.read(initialNotificationProvider.notifier).state = message.data;
      }
    }).catchError((error) {
      // Handle error silently
    });
  }

  // Test Notification with Profile Picture
  Future<void> sendTestProfilePictureNotification({
    String title = 'Chat Message',
    String body = 'Hey there! How are you doing today?',
    String senderName = 'John Doe',
    String? profilePictureUrl,
  }) async {
    final imageUrl =
        profilePictureUrl ?? 'https://randomuser.me/api/portraits/men/1.jpg';

    try {
      final notificationData = {
        'title': title,
        'body': body,
        'route': '/notification_test',
        'id': 'test_notification_${DateTime.now().millisecondsSinceEpoch}',
        'imageUrl': imageUrl,
        'senderProfileUrl': imageUrl,
        'senderName': senderName,
        'threadId': 'test_thread_${DateTime.now().millisecondsSinceEpoch}',
        'otherUserId': 'test_sender_${DateTime.now().millisecondsSinceEpoch}',
      };

      final testMessage = RemoteMessage(
        data: notificationData,
        notification: RemoteNotification(
          title: title,
          body: body,
          android: const AndroidNotification(
            channelId: 'high_importance_channel',
          ),
          apple: const AppleNotification(),
        ),
      );

      _handleForegroundMessage(testMessage);
    } catch (e) {
      // Handle error silently
    }
  }

  // Creates notification details with profile image if available
  Future<NotificationDetails> _createNotificationDetails({
    required String title,
    required String body,
    String? imageUrl,
    String? senderName,
  }) async {
    AndroidNotificationDetails androidDetails;
    DarwinNotificationDetails darwinDetails;

    // Handle Android notification details with profile image if available
    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final imageBytes = await _getByteArrayFromUrl(imageUrl);
        final circularImageBytes = await _createCircularAvatar(imageBytes);
        final messageSender = senderName ?? 'User';

        final messagingStyle = MessagingStyleInformation(
          const Person(name: 'You', key: 'user'),
          conversationTitle: title,
          groupConversation: false,
          messages: [
            Message(
              body,
              DateTime.now(),
              Person(
                name: messageSender,
                key: 'sender',
                icon: ByteArrayAndroidIcon(circularImageBytes),
              ),
            ),
          ],
        );

        androidDetails = AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
          icon: 'notification_icon',
          styleInformation: messagingStyle,
          color: black,
        );

        log('Added profile picture to notification',
            name: 'NOTIFICATION_AVATAR');
      } catch (e) {
        log('Failed to process notification image: $e',
            name: 'NOTIFICATION_ERROR');
        androidDetails = const AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
          icon: 'notification_icon',
          color: black,
        );
      }
    } else {
      androidDetails = const AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
        icon: 'notification_icon',
        color: black,
      );
    }

    // Handle iOS notification details with attachment if available
    if (imageUrl != null && imageUrl.isNotEmpty && Platform.isIOS) {
      try {
        final tempDir = await getTemporaryDirectory();
        final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final localPath = '${tempDir.path}/$imageName';

        final imageBytes = await _getByteArrayFromUrl(imageUrl);
        final imageFile = File(localPath);
        await imageFile.writeAsBytes(imageBytes);

        darwinDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          attachments: [DarwinNotificationAttachment(localPath)],
        );
      } catch (e) {
        log('Error creating iOS notification attachment: $e',
            name: 'NOTIFICATION_ERROR');
        darwinDetails = const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );
      }
    } else {
      darwinDetails = const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
    }

    return NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );
  }

  // Individual notification method
  Future<void> _showIndividualNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final title = notification.title ?? 'New notification';
    final body = notification.body ?? 'You have a new message';
    final imageUrl = message.data['imageUrl'] as String? ??
        message.data['senderProfileUrl'] as String?;
    final senderName = message.data['senderName'] as String? ?? 'User';

    final notificationDetails = await _createNotificationDetails(
      title: title,
      body: body,
      imageUrl: imageUrl,
      senderName: senderName,
    );

    final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    log('Displaying notification with ID: $notificationId, Title: $title',
        name: 'NOTIFICATION_DISPLAY');

    await _flutterLocalNotifications.show(
      notificationId,
      title,
      body,
      notificationDetails,
      payload: jsonEncode(message.data),
    );
  }

  // Show notification for data-only messages
  Future<void> _showDataOnlyNotification(RemoteMessage message) async {
    final title = message.data['title'] as String? ?? 'New notification';
    final body = message.data['body'] as String? ?? 'You have a new message';
    final imageUrl = message.data['imageUrl'] as String? ??
        message.data['senderProfileUrl'] as String?;
    final senderName = message.data['senderName'] as String? ??
        message.data['title'] as String? ??
        'User';

    final notificationDetails = await _createNotificationDetails(
      title: title,
      body: body,
      imageUrl: imageUrl,
      senderName: senderName,
    );

    final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    log('Displaying data notification with ID: $notificationId, Title: $title',
        name: 'NOTIFICATION_DISPLAY');

    await _flutterLocalNotifications.show(
      notificationId,
      title,
      body,
      notificationDetails,
      payload: jsonEncode(message.data),
    );
  } // Reset badge count for iOS/macOS

  Future<void> resetBadgeCount() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await _updateBadge(0);
    }
  }

  // Update badge count for iOS/macOS
  Future<void> updateBadgeCount(int count) async {
    if (Platform.isIOS || Platform.isMacOS) {
      await _updateBadge(count);
    }
  }

  // Private method to update badge count
  Future<void> _updateBadge(int count) async {
    try {
      // Create a silent notification with badge update
      final details = NotificationDetails(
        iOS: DarwinNotificationDetails(badgeNumber: count),
        macOS: DarwinNotificationDetails(badgeNumber: count),
      );

      // Use a unique ID for badge notifications
      final badgeNotificationId = -100;

      // Show a "silent" notification that just updates the badge
      await _flutterLocalNotifications.show(
        badgeNotificationId,
        '',
        '',
        details,
      );
    } catch (e) {
      log('Error updating badge count: $e');
    }
  }

  // Mark notification as read when user taps on it
  void _markNotificationAsRead(String notificationId) {
    try {
      notificationsCollection.doc(notificationId).update({
        'isRead': true,
      });
    } catch (e) {
      // Handle error silently
    }
  }
}
