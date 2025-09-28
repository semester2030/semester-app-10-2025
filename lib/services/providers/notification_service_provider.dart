import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:semester_student_ride_app/services/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref);
});
