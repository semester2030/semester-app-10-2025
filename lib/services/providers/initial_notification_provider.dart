import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to store the initial notification that launched the app
final initialNotificationProvider =
    StateProvider<Map<String, dynamic>?>((ref) => null);

// Flag to indicate if we've handled the initial notification
final initialNotificationHandledProvider = StateProvider<bool>((ref) => false);
