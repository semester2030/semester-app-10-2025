import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semester_student_ride_app/services/booking_service.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/enums/booking_status.dart';

part 'user_bookings_provider.g.dart';

/// Provider that streams user bookings from Firebase
@riverpod
Stream<List<RequestBookingModel>> userBookings(UserBookingsRef ref) {
  final bookingService = BookingService();

  // Check if user is authenticated first
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    log('No authenticated user found');
    return Stream.value(<RequestBookingModel>[]);
  }

  log('Authenticated user: ${currentUser.uid}');

  return bookingService.getUserBookings().handleError((error) {
    log('Firebase stream error: $error');
    // Return empty list on error instead of throwing
    return <Map<String, dynamic>>[];
  }).map((bookingDataList) {
    log('Received ${bookingDataList.length} booking documents from Firebase');

    final validBookings = <RequestBookingModel>[];

    for (final bookingData in bookingDataList) {
      try {
        log('Parsing booking data: ${bookingData.keys}');
        // Log the raw status value from Firebase
        log('Raw status value from Firebase: ${bookingData['status']}');
        final booking = RequestBookingModel.fromJson(bookingData);
        validBookings.add(booking);
        log('Successfully parsed booking with status: ${booking.status}');
        log('Status type: ${booking.status.runtimeType}');
      } catch (e, stackTrace) {
        log('Error parsing booking data: $e');
        log('Stack trace: $stackTrace');
        log('Problematic data: $bookingData');
        // Skip invalid bookings instead of adding error models
        continue;
      }
    }

    log('Successfully parsed ${validBookings.length} valid bookings');
    return validBookings;
  });
}

/// Provider for pending and active bookings specifically
@riverpod
Stream<List<RequestBookingModel>> pendingAndActiveBookings(
  PendingAndActiveBookingsRef ref,
) {
  final bookingService = BookingService();

  // Check if user is authenticated first
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    log('No authenticated user found for pending/active bookings');
    return Stream.value(<RequestBookingModel>[]);
  }

  log('Fetching pending/active bookings for user: ${currentUser.uid}');

  return bookingService.getUserBookings().handleError((error) {
    log('Firebase stream error in pendingAndActiveBookings: $error');
    // Return empty list on error instead of throwing
    return <Map<String, dynamic>>[];
  }).map((bookingDataList) {
    log('Received ${bookingDataList.length} booking documents from Firebase for pending/active filter');

    final validBookings = <RequestBookingModel>[];

    for (final bookingData in bookingDataList) {
      try {
        log('Parsing booking data: ${bookingData.keys}');
        // Log the raw status value from Firebase
        log('Raw status value from Firebase: ${bookingData['status']}');
        final booking = RequestBookingModel.fromJson(bookingData);
        log('Parsed booking with status: ${booking.status} (type: ${booking.status.runtimeType})');

        // Only include pending, active, driverComing, and tripStarted bookings
        if (booking.status == BookingStatus.pending ||
            booking.status == BookingStatus.active ||
            booking.status == BookingStatus.driverComing ||
            booking.status == BookingStatus.tripStarted) {
          validBookings.add(booking);
          log('Added booking with status: ${booking.status}');
        } else {
          log('Skipped booking with status: ${booking.status}');
        }
      } catch (e, stackTrace) {
        log('Error parsing booking data: $e');
        log('Stack trace: $stackTrace');
        log('Problematic data: $bookingData');
        // Skip invalid bookings instead of adding error models
        continue;
      }
    }

    log('Successfully parsed ${validBookings.length} valid pending/active bookings');
    return validBookings;
  });
}
