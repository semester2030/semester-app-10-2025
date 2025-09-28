import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semester_student_ride_app/services/booking_service.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/enums/booking_status.dart';

part 'completed_trips_provider.g.dart';

/// Provider that streams the count of completed trips for the current user
@riverpod
Stream<int> completedTripsCount(CompletedTripsCountRef ref) {
  final bookingService = BookingService();

  // Check if user is authenticated first
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    log('No authenticated user found for completed trips count');
    return Stream.value(0);
  }

  log('Fetching completed trips count for user: ${currentUser.uid}');

  return bookingService.getUserBookings().handleError((error) {
    log('Firebase stream error in completedTripsCount: $error');
    // Return 0 on error instead of throwing
    return <Map<String, dynamic>>[];
  }).map((bookingDataList) {
    log('Received ${bookingDataList.length} booking documents from Firebase for completed trips count');

    int completedCount = 0;

    for (final bookingData in bookingDataList) {
      try {
        final booking = RequestBookingModel.fromJson(bookingData);

        // Count only completed bookings
        if (booking.status == BookingStatus.completed) {
          completedCount++;
          log('Found completed booking: ${booking.id}');
        }
      } catch (e, stackTrace) {
        log('Error parsing booking data for completed count: $e');
        log('Stack trace: $stackTrace');
        log('Problematic data: $bookingData');
        // Skip invalid bookings instead of adding error models
        continue;
      }
    }

    log('Successfully counted $completedCount completed trips');
    return completedCount;
  });
}
