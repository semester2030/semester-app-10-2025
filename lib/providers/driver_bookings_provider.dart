import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'dart:developer';

/// Provider for driver bookings
/// This provider fetches all bookings assigned to the current driver
final driverBookingsProvider = StreamProvider<List<RequestBookingModel>>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    log('Error: No authenticated user found', name: 'DriverBookingsProvider');
    return Stream.value([]);
  }

  final driverEmail = currentUser.email;
  if (driverEmail == null || driverEmail.isEmpty) {
    log('Error: User email is null or empty', name: 'DriverBookingsProvider');
    return Stream.value([]);
  }

  log('Fetching bookings for driver: $driverEmail',
      name: 'DriverBookingsProvider');

  return FirebaseFirestore.instance
      .collection('bookings')
      .where('driverId', isEqualTo: currentUser.uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
    try {
      final bookings = snapshot.docs.map((doc) {
        final data = doc.data();
        // Ensure the document ID is included
        data['id'] = doc.id;
        return RequestBookingModel.fromJson(data);
      }).toList();

      log('Found ${bookings.length} bookings for driver: $driverEmail',
          name: 'DriverBookingsProvider');

      return bookings;
    } catch (e, stack) {
      log('Error parsing driver bookings: $e', name: 'DriverBookingsProvider');
      log('Stack trace: $stack', name: 'DriverBookingsProvider');
      return [];
    }
  });
});

/// Provider for pending driver bookings
/// This filters the driver bookings to only those with status 'pending'
final pendingDriverBookingsProvider =
    Provider<AsyncValue<List<RequestBookingModel>>>((ref) {
  return ref.watch(driverBookingsProvider).whenData((bookings) {
    final pendingBookings =
        bookings.where((booking) => booking.status == 'pending').toList();
    log('Found ${pendingBookings.length} pending bookings',
        name: 'DriverBookingsProvider');
    return pendingBookings;
  });
});
