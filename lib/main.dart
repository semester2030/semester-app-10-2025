import 'dart:developer';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:semester_student_ride_app/firebase_options.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/services/notification_service.dart';
import 'package:semester_student_ride_app/services/providers/initial_notification_provider.dart';
import 'package:semester_student_ride_app/services/providers/location_provider.dart';
import 'package:semester_student_ride_app/services/providers/notification_provider.dart';
import 'package:semester_student_ride_app/services/providers/prefs.dart';
import 'package:semester_student_ride_app/services/providers/shared_pref.dart';
import 'package:semester_student_ride_app/services/router.dart';
import 'package:semester_student_ride_app/services/shared_preference_service.dart';
import 'package:semester_student_ride_app/utils/context_provider_widget.dart';
import 'package:semester_student_ride_app/utils/notification_icon_validator.dart';
import 'package:semester_student_ride_app/utils/provider_observer.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:semester_student_ride_app/providers/language_provider.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/services/driver_location_lifecycle_handler.dart';

// App theme configuration
class AppTheme {
  static ThemeData get theme => ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: false,
      );
}

// Screen utility configuration
class ScreenConfig {
  static const Size designSize = Size(430, 932);
  static const bool minTextAdapt = true;
  static const bool splitScreenMode = true;
}

// Constants for notification configuration
class NotificationConstants {
  static const String channelId = 'high_importance_channel';
  static const String channelName = 'High Importance Notifications';
  static const String channelDescription =
      'This channel is used for important notifications.';
  static const String notificationIcon = 'notification_icon';
  static const String launcherIcon = '@mipmap/ic_launcher';
  static const double avatarSize = 96.0;
  static const Duration initializationDelay = Duration(milliseconds: 2000);
  static const Duration markerIconLoadDelay = Duration(seconds: 1);
  static const Duration splashDelay = Duration(milliseconds: 2000);
}

final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>();
});

late WidgetRef globalRef;

// Map to store recently shown notification IDs in the background handler
// This needs to be at the file level to persist across message handler calls
final Map<String, int> _backgroundShownNotificationIds = {};
// Time window in seconds to consider a notification as duplicate in background
const int _backgroundDeduplicationTimeWindow = 10;

// Generate a consistent notification ID based on message content
String _generateBackgroundNotificationKey(RemoteMessage message) {
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
    // Don't include timestamp to catch duplicates with identical content
    return 'content-$title-$body';
  }
}

// Clean old notification records to prevent memory leaks
void _cleanupOldBackgroundNotificationIds() {
  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  _backgroundShownNotificationIds.removeWhere((_, timestamp) {
    return now - timestamp > _backgroundDeduplicationTimeWindow;
  });
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase for background context
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, name: "naybrzdbx");

  // First, clean up old notification records
  _cleanupOldBackgroundNotificationIds();

  // Generate notification key for deduplication
  final notificationKey = _generateBackgroundNotificationKey(message);
  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  // Skip notifications that might be duplicates from FCM

  // Check if we've shown this notification recently
  if (_backgroundShownNotificationIds.containsKey(notificationKey)) {
    final lastShownTimestamp =
        _backgroundShownNotificationIds[notificationKey]!;
    final timeSinceLastShown = now - lastShownTimestamp;

    if (timeSinceLastShown < _backgroundDeduplicationTimeWindow) {
      // Skip this notification as it's a duplicate within our time window
      return;
    }
  }

  // Record this notification as shown
  _backgroundShownNotificationIds[notificationKey] = now;

  // Always show our custom notification to ensure consistent format
  // regardless of whether message has notification payload or not
  await _showBackgroundIndividualNotification(message);
}

// Fallback method for individual background notifications
Future<void> _showBackgroundIndividualNotification(
    RemoteMessage message) async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialize the plugin for background context
  await _initializeNotificationPlugin(flutterLocalNotificationsPlugin);

  // Extract notification data - prioritize data payload over notification payload
  final notificationData = _extractNotificationData(message);

  if (notificationData.title != null && notificationData.body != null) {
    final notificationDetails = await _buildNotificationDetails(
      notificationData.title!,
      notificationData.body!,
      notificationData.imageUrl,
      notificationData.senderName,
    );

    // Generate a unique ID for the notification
    final int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      notificationData.title,
      notificationData.body,
      notificationDetails,
      payload: jsonEncode(message.data),
    );
  }
}

// Helper class to hold notification data
class NotificationData {
  final String? title;
  final String? body;
  final String? imageUrl;
  final String? senderName;

  NotificationData({
    this.title,
    this.body,
    this.imageUrl,
    this.senderName,
  });
}

// Extract notification data from RemoteMessage
NotificationData _extractNotificationData(RemoteMessage message) {
  String? title;
  String? body;

  // First check data payload (for consistent formatting)
  if (message.data['title'] != null && message.data['body'] != null) {
    title = message.data['title'];
    body = message.data['body'];
  }
  // Fallback to notification payload if data is not available
  else if (message.notification != null) {
    title = message.notification!.title;
    body = message.notification!.body;
  }

  final String? imageUrl =
      message.data['imageUrl'] ?? message.data['senderProfileUrl'];
  final String? senderName =
      message.data['title'] ?? message.data['senderName'] ?? title;

  return NotificationData(
    title: title,
    body: body,
    imageUrl: imageUrl,
    senderName: senderName,
  );
}

// Initialize notification plugin
Future<void> _initializeNotificationPlugin(
    FlutterLocalNotificationsPlugin plugin) async {
  const androidSettings =
      AndroidInitializationSettings(NotificationConstants.launcherIcon);
  const iosSettings = DarwinInitializationSettings();
  const initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await plugin.initialize(initSettings);
}

// Build notification details
Future<NotificationDetails> _buildNotificationDetails(
  String title,
  String body,
  String? imageUrl,
  String? senderName,
) async {
  AndroidNotificationDetails androidDetails;

  if (imageUrl != null && imageUrl.isNotEmpty) {
    try {
      final imageBytes = await _getByteArrayFromUrl(imageUrl);
      final circularImageBytes =
          await _createBackgroundCircularAvatar(imageBytes);

      androidDetails = _createMessagingNotificationDetails(
        title,
        body,
        senderName,
        circularImageBytes,
      );
    } catch (e) {
      androidDetails =
          _createMessagingNotificationDetails(title, body, senderName, null);
    }
  } else {
    androidDetails =
        _createMessagingNotificationDetails(title, body, senderName, null);
  }

  // iOS notification configuration
  final DarwinNotificationDetails darwinDetails =
      _createDarwinNotificationDetails(imageUrl);

  return NotificationDetails(
    android: androidDetails,
    iOS: darwinDetails,
  );
}

// Create messaging notification details
AndroidNotificationDetails _createMessagingNotificationDetails(
  String title,
  String body,
  String? senderName,
  Uint8List? circularImageBytes,
) {
  final messagingStyle = MessagingStyleInformation(
    const Person(name: 'You', key: 'user'),
    conversationTitle: title,
    groupConversation: false,
    messages: [
      Message(
        body,
        DateTime.now(),
        Person(
          name: senderName ?? 'Sender',
          key: 'sender',
          icon: circularImageBytes != null
              ? ByteArrayAndroidIcon(circularImageBytes)
              : null,
        ),
      ),
    ],
  );

  return AndroidNotificationDetails(
    NotificationConstants.channelId,
    NotificationConstants.channelName,
    channelDescription: NotificationConstants.channelDescription,
    importance: Importance.high,
    priority: Priority.high,
    icon: NotificationConstants.notificationIcon,
    styleInformation: messagingStyle,
    color: Colors.black,
    category: AndroidNotificationCategory.message,
    visibility: NotificationVisibility.public,
  );
}

// Create Darwin notification details
DarwinNotificationDetails _createDarwinNotificationDetails(String? imageUrl) {
  if (imageUrl != null && imageUrl.isNotEmpty) {
    return DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      attachments: [DarwinNotificationAttachment(imageUrl)],
    );
  } else {
    return const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
  }
}

// Get byte array from URL (same as NotificationService)
Future<Uint8List> _getByteArrayFromUrl(String url) async {
  final http.Response response = await http.get(Uri.parse(url));
  return response.bodyBytes;
}

// Create circular avatar from image bytes (optimized)
Future<Uint8List> _createBackgroundCircularAvatar(Uint8List imageBytes) async {
  try {
    // Decode the image
    final image = await decodeImageFromList(imageBytes);

    // Create a circular bitmap
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = NotificationConstants.avatarSize;

    // Create a circular clipping path
    final path = Path()..addOval(Rect.fromLTWH(0, 0, size, size));
    canvas.clipPath(path);

    // Draw the image scaled to fit the circle
    final paint = Paint()..isAntiAlias = true;
    final srcRect =
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dstRect = Rect.fromLTWH(0, 0, size, size);

    canvas.drawImageRect(image, srcRect, dstRect, paint);

    // Convert to bytes
    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  } catch (e) {
    // Return original image if circular conversion fails
    return imageBytes;
  }
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, name: "naybrzdbx");

  // Preserve native splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize SharedPreferenceService early
  final sharedPrefService = await SharedPreferenceService.getInstance();

  // Set up HTTP overrides for certificate handling
  HttpOverrides.global = _HttpOverrides();

  // Configure background message handler for FCM
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Register driver location lifecycle handler
  final locationLifecycleHandler = DriverLocationLifecycleHandler();
  WidgetsBinding.instance.addObserver(locationLifecycleHandler);

  // Set preferred orientations and system UI
  await _configureSystemUI();

  runApp(ProviderScope(
    overrides: [
      sharedPreferenceServiceProvider.overrideWithValue(sharedPrefService),
    ],
    observers: [AppProviderObserver()],
    child: const PreBuyApp(),
  ));
}

// Configure system UI settings
Future<void> _configureSystemUI() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
}

class PreBuyApp extends StatelessWidget {
  const PreBuyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MainApp();
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    globalRef = ref;
    
    // Initialize notification service immediately without waiting for prefs
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // Initialize the notification service
        await ref.read(notificationServiceProvider).init();
        
        // Check for any initial notifications
        ref
            .read(notificationServiceProvider)
            .checkAndProcessInitialNotification();

        // Initialize the user block watcher to monitor for blocked users

        // Wait for marker icons to finish loading, but don't block other operations
        try {} catch (e) {
          // Silent catch for marker icons loading errors
        }
      } catch (e) {
        // Silent catch for notification service initialization errors
      }

      // Validate notification icons on Android
      if (Platform.isAndroid) {
        final navigatorKey = ref.read(navigatorKeyProvider);
        if (navigatorKey.currentContext != null) {
          final iconsExist = NotificationIconValidator.checkNotificationIcons(
              navigatorKey.currentContext!);
          if (!iconsExist) {}
        }
      }
    });

    // Always return child, don't block on prefs
    return child;
  }
}

class _MainApp extends StatefulHookConsumerWidget {
  const _MainApp();

  @override
  ConsumerState<_MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<_MainApp> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    _completeSplash();

    // Process any initial notifications after ensuring the app is fully ready
    Future.delayed(NotificationConstants.initializationDelay, () {
      ref.read(notificationServiceProvider).processInitialNotification();
    });
  }

  Future<void> _completeSplash() async {
    FlutterNativeSplash.remove();
    await Future.delayed(NotificationConstants.splashDelay);
    ref.read(splashStateProvider.notifier).completeSplash();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(languageNotifierProvider);
    final textDirection = ref.watch(textDirectionNotifierProvider);

    return ScreenUtilInit(
        designSize: ScreenConfig.designSize,
        minTextAdapt: ScreenConfig.minTextAdapt,
        splitScreenMode: ScreenConfig.splitScreenMode,
        builder: (context, child) {
          return ContextProviderWidget(
            child: Directionality(
              textDirection: textDirection,
              child: MaterialApp.router(
                title: 'NAYBRZ DBX',
                theme: AppTheme.theme,
                routerConfig: router,
                debugShowCheckedModeBanner: false,
                locale: locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('ar', 'AE'), // Arabic (Default)
                  Locale('en', 'US'), // English
                ],
              ),
            ),
          );
        });
  }
}

class _HttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (_, __, ___) => true;
  }
}
