import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/providers/booking_flow_provider.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/models/address_model.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/enums/booking_status.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookingService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference for bookings
  final CollectionReference _bookingsCollection =
      FirebaseFirestore.instance.collection('bookings');

  /// Submit a complete booking to Firestore
  Future<String?> submitBooking({
    required BookingFlowState bookingState,
    required UserSignupModel? currentUser,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        log('Error: No authenticated user found');
        return null;
      }

      if (currentUser == null) {
        log('Error: Current user data is null');
        return null;
      }

      if (bookingState.selectedDriver == null) {
        log('Error: No driver selected');
        return null;
      }

      // Log the booking state for debugging
      log('Submitting booking with state: ${bookingState.toString()}');

      // Generate a unique booking ID
      final bookingId = _bookingsCollection.doc().id;

      // Convert BookingFlowState to RequestBookingModel
      final requestBooking = _convertToRequestBookingModel(bookingState);

      // Add additional metadata for submission
      final submissionData = requestBooking.copyWith(
        status: BookingStatus.pending,
      );

      // Convert to JSON and handle complex objects
      final bookingData = submissionData.toJson();
      bookingData['id'] = bookingId;
      bookingData['userId'] = user.uid;
      bookingData['driverId'] =
          bookingState.selectedDriver!.id; // Using ID as driver ID

      // Convert AddressModel objects to Maps to avoid serialization issues
      if (bookingData['pickupAddress'] != null) {
        bookingData['pickupAddress'] =
            _convertAddressToMap(bookingState.pickupAddress!);
      }
      if (bookingData['dropOffAddress'] != null) {
        bookingData['dropOffAddress'] =
            _convertAddressToMap(bookingState.dropOffAddress!);
      }

      // Log the final data being sent to Firestore
      log('Booking data to be saved: ${bookingData.toString()}');

      // Save to Firestore
      await _bookingsCollection.doc(bookingId).set(bookingData);

      log('Booking submitted successfully with ID: $bookingId');
      return bookingId;
    } catch (e, stackTrace) {
      log('Error submitting booking: $e');
      log('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Convert BookingFlowState to RequestBookingModel
  RequestBookingModel _convertToRequestBookingModel(
      BookingFlowState bookingState) {
    try {
      log('Converting BookingFlowState to RequestBookingModel');
      log('Service Type: ${bookingState.serviceType}');
      log('Selected Driver: ${bookingState.selectedDriver?.name}');
      log('Final Price: ${bookingState.finalPrice}');

      return RequestBookingModel(
          serviceType: bookingState.serviceType,

          // Address Information
          addressType: bookingState.addressType.isNotEmpty
              ? bookingState.addressType
              : null,
          city: bookingState.city.isNotEmpty ? bookingState.city : null,
          schoolName: bookingState.schoolName.isNotEmpty
              ? bookingState.schoolName
              : null,
          areaDistrict: bookingState.areaDistrict.isNotEmpty
              ? bookingState.areaDistrict
              : null,
          pickupAddress: bookingState.pickupAddress,
          dropOffAddress: bookingState.dropOffAddress,

          // Daily Transport specific
          selectedDate: bookingState.selectedDate.isNotEmpty
              ? bookingState.selectedDate
              : null,
          startTime:
              bookingState.startTime.isNotEmpty ? bookingState.startTime : null,
          endTime:
              bookingState.endTime.isNotEmpty ? bookingState.endTime : null,

          // Driver Information
          driverId: bookingState.selectedDriver?.email,

          // Student Transport specific
          selectedVehicleType: bookingState.selectedVehicleType.isNotEmpty
              ? bookingState.selectedVehicleType
              : null,
          selectedServiceType: bookingState.selectedServiceType.isNotEmpty
              ? bookingState.selectedServiceType
              : null,
          selectedTripType: bookingState.selectedTripType.isNotEmpty
              ? bookingState.selectedTripType
              : null,
          transportStartDate: bookingState.transportStartDate.isNotEmpty
              ? bookingState.transportStartDate
              : null,
          transportStartTime: bookingState.transportStartTime.isNotEmpty
              ? bookingState.transportStartTime
              : null,
          transportEndTime: bookingState.transportEndTime.isNotEmpty
              ? bookingState.transportEndTime
              : null,
          userId: FirebaseAuth.instance.currentUser?.uid,
          // Teacher/Employee Transport specific
          selectedDriverGender: bookingState.selectedDriverGender.isNotEmpty
              ? bookingState.selectedDriverGender
              : null,
          selectedSubscriptionPlan: 'monthly',
          selectedWorkSchedule: bookingState.selectedWorkSchedule.isNotEmpty
              ? bookingState.selectedWorkSchedule
              : null,

          // Pricing
          basePrice: bookingState.basePrice,
          finalPrice: bookingState.finalPrice,
          priceUnit:
              bookingState.priceUnit.isNotEmpty ? bookingState.priceUnit : null,
          numberOfHours: bookingState.numberOfHours,
          pricePerHour: bookingState.pricePerHour,
          createdAt: DateTime.now());
    } catch (e, stackTrace) {
      log('Error converting BookingFlowState to RequestBookingModel: $e');
      log('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Get all bookings for the current user
  Stream<List<Map<String, dynamic>>> getUserBookings() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.empty();
    }

    return _bookingsCollection
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    });
  }

  /// Update booking status
  Future<bool> updateBookingStatus(String bookingId, String status) async {
    try {
      await _bookingsCollection.doc(bookingId).update({
        'status': status,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      log('Error updating booking status: $e');
      return false;
    }
  }

  /// Accept a booking by driver
  Future<bool> acceptBooking({required RequestBookingModel booking}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        log('Error: No authenticated driver found for accepting booking');
        return false;
      }

      await _bookingsCollection.doc(booking.id).update({
        'status': BookingStatus.active.value,
        'acceptedAt': DateTime.now().toIso8601String(),
        'acceptedBy': user.uid,
        'isDriverComing': false, // Reset driver coming status when accepting
        'updatedAt': DateTime.now().toIso8601String(),
      });

      log('Booking ${booking.id} accepted successfully by driver ${user.uid}');
      return true;
    } catch (e) {
      log('Error accepting booking: $e');
      return false;
    }
  }

  /// Decline a booking by driver
  Future<bool> declineBooking(
      {required RequestBookingModel booking, String reason = ''}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        log('Error: No authenticated driver found for declining booking');
        return false;
      }

      await _bookingsCollection.doc(booking.id).update({
        'status': BookingStatus.cancelled.value,
        'declinedAt': DateTime.now().toIso8601String(),
        'declinedBy': user.uid,
        'declineReason': reason.isNotEmpty ? reason : 'Declined by driver',
        'updatedAt': DateTime.now().toIso8601String(),
      });

      log('Booking ${booking.id} declined successfully by driver ${user.uid}');
      return true;
    } catch (e) {
      log('Error declining booking: $e');
      return false;
    }
  }

  /// Cancel a booking
  Future<bool> cancelBooking(
      {required RequestBookingModel booking, String reason = ''}) async {
    try {
      await _bookingsCollection.doc(booking.id).update({
        'status': BookingStatus.cancelled.value,
        'cancellationReason': reason,
        'cancelledAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      log('Error cancelling booking: $e');
      return false;
    }
  }

  /// Helper method to convert AddressModel to Map for Firestore
  Map<String, dynamic> _convertAddressToMap(AddressModel addressModel) {
    return {
      'address': addressModel.address,
      'city': addressModel.city,
      'state': addressModel.state,
      'zipCode': addressModel.zipCode,
      'coordinates': {
        'latitude': addressModel.coordinates.latitude,
        'longitude': addressModel.coordinates.longitude,
      },
    };
  }
}
