import 'package:flutter/material.dart';
import 'package:semester_student_ride_app/services/notification_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'notification_provider.g.dart';

// Create a StateProvider to keep track of the current BuildContext
final currentContextProvider = StateProvider<BuildContext?>((ref) => null);

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  // Create notification service
  final notificationService = NotificationService(ref);

  return notificationService;
}
