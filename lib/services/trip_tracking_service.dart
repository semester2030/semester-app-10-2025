import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/enums/booking_status.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/services/driver_location_service.dart';
import 'package:semester_student_ride_app/services/google_directions_service.dart';
import 'package:semester_student_ride_app/utils/distance_utils.dart';

class TripTrackingService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get collection references
  static CollectionReference get _bookingsCollection =>
      FirebaseFirestore.instance.collection('bookings');
  static CollectionReference get _usersCollection =>
      FirebaseFirestore.instance.collection('users');

  /// Driver indicates they are coming to pickup location
  static Future<bool> driverIsComing(
      {required RequestBookingModel booking}) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        dev.log('No authenticated user found', name: 'TripTrackingService');
        return false;
      }

      if (booking.id == null || booking.id!.isEmpty) {
        dev.log('Invalid booking ID', name: 'TripTrackingService');
        return false;
      }

      // Ensure driver location tracking is active
      if (!DriverLocationService.isTracking) {
        final trackingStarted =
            await DriverLocationService.startLocationTracking();
        if (!trackingStarted) {
          dev.log('Failed to start location tracking',
              name: 'TripTrackingService');
          return false;
        }
      }

      // Update booking in Firestore to mark driver as coming
      await _bookingsCollection.doc(booking.id).update({
        'isDriverComing': true,
        'driverComingAt': DateTime.now().toIso8601String(),
        'driverId': currentUser.uid,
        'status': BookingStatus.driverComing.value,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      dev.log('Driver marked as coming for booking: ${booking.id}',
          name: 'TripTrackingService');
      return true;
    } catch (e) {
      dev.log('Error marking driver as coming: $e',
          name: 'TripTrackingService');
      return false;
    }
  }

  /// Start a trip by driver
  static Future<bool> startTrip({required RequestBookingModel booking}) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        dev.log('No authenticated user found', name: 'TripTrackingService');
        return false;
      }

      if (booking.id == null || booking.id!.isEmpty) {
        dev.log('Invalid booking ID', name: 'TripTrackingService');
        return false;
      }

      // Ensure driver location tracking is active
      if (!DriverLocationService.isTracking) {
        final trackingStarted =
            await DriverLocationService.startLocationTracking();
        if (!trackingStarted) {
          dev.log('Failed to start location tracking',
              name: 'TripTrackingService');
          return false;
        }
      }

      // Update booking in Firestore to mark trip as started
      await _bookingsCollection.doc(booking.id).update({
        'isTripStarted': true,
        'tripStartedAt': DateTime.now().toIso8601String(),
        'status': BookingStatus.tripStarted.value,
        'driverId': currentUser.uid,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      dev.log('Trip started successfully for booking: ${booking.id}',
          name: 'TripTrackingService');
      return true;
    } catch (e) {
      dev.log('Error starting trip: $e', name: 'TripTrackingService');
      return false;
    }
  }

  /// End a trip by driver
  static Future<bool> endTrip({required RequestBookingModel booking}) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        dev.log('No authenticated user found', name: 'TripTrackingService');
        return false;
      }

      if (booking.id == null || booking.id!.isEmpty) {
        dev.log('Invalid booking ID', name: 'TripTrackingService');
        return false;
      }

      // Check if this is a daily service type
      final isDailyService =
          booking.serviceType == TransportationServiceType.daily;

      // For daily services, set status back to active instead of completed
      // For other services, mark as completed
      final newStatus = isDailyService
          ? BookingStatus.active.value
          : BookingStatus.completed.value;

      // Update booking in Firestore to mark trip as ended
      await _bookingsCollection.doc(booking.id).update({
        'isTripStarted': false,
        'tripEndedAt': DateTime.now().toIso8601String(),
        'status': newStatus,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      dev.log(
          'Trip ended successfully for booking: ${booking.id}, Status: $newStatus',
          name: 'TripTrackingService');
      return true;
    } catch (e) {
      dev.log('Error ending trip: $e', name: 'TripTrackingService');
      return false;
    }
  }

  /// Get live driver location for a specific booking
  static Stream<Map<String, dynamic>?> getLiveDriverLocation(
      {required String driverId}) {
    return _usersCollection.doc(driverId).snapshots().map((driverSnapshot) {
      try {
        if (!driverSnapshot.exists) {
          dev.log('Driver not found: $driverId', name: 'TripTrackingService');
          return null;
        }

        final driverData = driverSnapshot.data() as Map<String, dynamic>;
        final currentLocation =
            driverData['currentLocation'] as Map<String, dynamic>?;

        if (currentLocation == null) {
          dev.log('Driver location not available', name: 'TripTrackingService');
          return null;
        }

        return {
          'currentLocation': {
            'latitude': currentLocation['latitude']?.toDouble() ?? 0.0,
            'longitude': currentLocation['longitude']?.toDouble() ?? 0.0,
            'lastUpdated': currentLocation['lastUpdated'],
          },
        };
      } catch (e) {
        dev.log('Error getting live driver location: $e',
            name: 'TripTrackingService');
        return null;
      }
    });
  }

  /// Get trip route polyline points using Google Directions API
  static Future<List<LatLng>> getTripRoute({
    required LatLng driverLocation,
    required LatLng pickupLocation,
  }) async {
    try {
      // Use Google Directions API to get actual route
      final routePoints = await GoogleDirectionsService.getRoute(
        origin: driverLocation,
        destination: pickupLocation,
        travelMode: 'driving',
      );

      if (routePoints.isNotEmpty) {
        dev.log('Successfully fetched route with ${routePoints.length} points',
            name: 'TripTrackingService');
        return routePoints;
      } else {
        // Fallback to straight line if API fails
        dev.log('Using fallback route', name: 'TripTrackingService');
        return [driverLocation, pickupLocation];
      }
    } catch (e) {
      dev.log('Error getting trip route: $e', name: 'TripTrackingService');
      // Return straight line as fallback
      return [driverLocation, pickupLocation];
    }
  }

  /// Get trip route to destination (for when driver is coming)
  static Future<List<LatLng>> getTripRouteToDestination({
    required LatLng driverLocation,
    required LatLng destinationLocation,
  }) async {
    try {
      // Use Google Directions API to get actual route to destination
      final routePoints = await GoogleDirectionsService.getRoute(
        origin: driverLocation,
        destination: destinationLocation,
        travelMode: 'driving',
      );

      if (routePoints.isNotEmpty) {
        dev.log(
            'Successfully fetched route to destination with ${routePoints.length} points',
            name: 'TripTrackingService');
        return routePoints;
      } else {
        // Fallback to straight line if API fails
        dev.log('Using fallback route to destination',
            name: 'TripTrackingService');
        return [driverLocation, destinationLocation];
      }
    } catch (e) {
      dev.log('Error getting trip route to destination: $e',
          name: 'TripTrackingService');
      // Return straight line as fallback
      return [driverLocation, destinationLocation];
    }
  }

  /// Get route information (duration, distance)
  static Future<Map<String, dynamic>?> getRouteInfo({
    required LatLng driverLocation,
    required LatLng pickupLocation,
  }) async {
    try {
      return await GoogleDirectionsService.getRouteInfo(
        origin: driverLocation,
        destination: pickupLocation,
        travelMode: 'driving',
      );
    } catch (e) {
      dev.log('Error getting route info: $e', name: 'TripTrackingService');
      return null;
    }
  }

  /// Check if a booking has an active trip
  static Stream<bool> isTripActive({required String bookingId}) {
    return _bookingsCollection.doc(bookingId).snapshots().map((snapshot) {
      if (!snapshot.exists) return false;

      final data = snapshot.data() as Map<String, dynamic>;
      final isTripStarted = data['isTripStarted'] as bool? ?? false;
      final status = data['status'] as String?;

      return isTripStarted && status == BookingStatus.tripStarted.value;
    });
  }

  /// Check if driver is coming to pickup location
  static Stream<bool> isDriverComing({required String bookingId}) {
    return _bookingsCollection.doc(bookingId).snapshots().map((snapshot) {
      if (!snapshot.exists) return false;

      final data = snapshot.data() as Map<String, dynamic>;
      final isDriverComing = data['isDriverComing'] as bool? ?? false;
      final status = data['status'] as String?;

      // Only return true if explicitly set AND status is appropriate
      // AND driver coming timestamp exists (proving it was set by user action)
      final driverComingAt = data['driverComingAt'] as String?;

      return isDriverComing &&
          driverComingAt != null && // Must have timestamp proving user clicked
          (status == BookingStatus.active.value ||
              status == BookingStatus.driverComing.value ||
              status == BookingStatus.tripStarted.value);
    });
  }

  /// Check if driver is within pickup range (500 meters)
  static Stream<bool> isDriverWithinPickupRange({
    required String bookingId,
    required String driverId,
    required LatLng pickupLocation,
  }) {
    dev.log('Setting up stream for driver: $driverId, pickup: $pickupLocation',
        name: 'TripTrackingService');

    return _usersCollection
        .doc(driverId)
        .snapshots()
        .distinct()
        .map((snapshot) {
      if (!snapshot.exists) {
        dev.log('Driver document does not exist', name: 'TripTrackingService');
        return false;
      }

      try {
        final data = snapshot.data() as Map<String, dynamic>;
        final currentLocation =
            data['currentLocation'] as Map<String, dynamic>?;

        if (currentLocation == null) {
          dev.log('No current location found for driver',
              name: 'TripTrackingService');
          return false;
        }

        final driverLatLng = LatLng(
          currentLocation['latitude']?.toDouble() ?? 0.0,
          currentLocation['longitude']?.toDouble() ?? 0.0,
        );

        // Use DistanceUtils to calculate distance
        final distance =
            DistanceUtils.calculateDistance(driverLatLng, pickupLocation);
        final isWithinRange = distance <= 1000.0; // 1000 meters for testing

        dev.log(
            'Distance check: ${distance.toStringAsFixed(1)}m, Within range: $isWithinRange, Driver: ${driverLatLng.latitude}, ${driverLatLng.longitude}',
            name: 'TripTrackingService');

        return isWithinRange;
      } catch (e) {
        dev.log('Error checking driver proximity: $e',
            name: 'TripTrackingService');
        return false;
      }
    });
  }

  /// Get booking status stream
  static Stream<BookingStatus?> getBookingStatusStream(
      {required String bookingId}) {
    return _bookingsCollection.doc(bookingId).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;

      final data = snapshot.data() as Map<String, dynamic>;
      final statusString = data['status'] as String?;

      if (statusString == null) return null;
      return BookingStatus.fromString(statusString);
    });
  }

  /// Get driver details for a booking
  static Future<Map<String, dynamic>?> getDriverDetails(
      {required String bookingId}) async {
    try {
      final bookingSnapshot = await _bookingsCollection.doc(bookingId).get();
      if (!bookingSnapshot.exists) return null;

      final bookingData = bookingSnapshot.data() as Map<String, dynamic>;
      final driverId = bookingData['driverId'] as String?;

      if (driverId == null) return null;

      final driverSnapshot = await _usersCollection.doc(driverId).get();
      if (!driverSnapshot.exists) return null;

      final driverData = driverSnapshot.data() as Map<String, dynamic>;

      // Construct vehicle name from separate fields
      final vehicleMake = driverData['vehicleMake'] as String?;
      final vehicleModel = driverData['vehicleModel'] as String?;
      final vehicleYear = driverData['vehicleYear'] as String?;

      final vehicleParts = <String>[];
      if (vehicleMake?.isNotEmpty == true) vehicleParts.add(vehicleMake!);
      if (vehicleModel?.isNotEmpty == true) vehicleParts.add(vehicleModel!);
      if (vehicleYear?.isNotEmpty == true) vehicleParts.add(vehicleYear!);
      final fullVehicleName =
          vehicleParts.isEmpty ? 'Unknown Vehicle' : vehicleParts.join(' ');

      return {
        'id': driverId,
        'name': driverData['name'] ?? 'Unknown Driver',
        'phoneNumber': driverData['phoneNumber'],
        'profilePicture': driverData['profilePicture'],
        'vehicleModel': fullVehicleName,
        'vehicleType': driverData['vehicleType'] ?? 'Car',
        'licensePlate': driverData['licensePlate'],
        'rating': (driverData['rating'] ?? 4.0).toDouble(),
      };
    } catch (e) {
      dev.log('Error getting driver details: $e', name: 'TripTrackingService');
      return null;
    }
  }

  /// Check if driver is within destination range (500 meters)
  static Stream<bool> isDriverWithinDestinationRange({
    required String bookingId,
    required String driverId,
    required LatLng destinationLocation,
  }) {
    return _usersCollection
        .doc(driverId)
        .snapshots()
        .distinct()
        .map((snapshot) {
      if (!snapshot.exists) return false;

      try {
        final data = snapshot.data() as Map<String, dynamic>;
        final currentLocation =
            data['currentLocation'] as Map<String, dynamic>?;

        if (currentLocation == null) return false;

        final driverLatLng = LatLng(
          currentLocation['latitude']?.toDouble() ?? 0.0,
          currentLocation['longitude']?.toDouble() ?? 0.0,
        );

        // Use DistanceUtils to calculate distance
        final distance =
            DistanceUtils.calculateDistance(driverLatLng, destinationLocation);
        final isWithinRange = distance <= 500.0; // 500 meters

        dev.log(
            'Destination distance check: ${distance.toStringAsFixed(1)}m, Within range: $isWithinRange',
            name: 'TripTrackingService');

        return isWithinRange;
      } catch (e) {
        dev.log('Error checking driver proximity to destination: $e',
            name: 'TripTrackingService');
        return false;
      }
    });
  }

  /// Complete ride by driver when reaching destination
  static Future<bool> completeRide(
      {required RequestBookingModel booking}) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        dev.log('No authenticated user found', name: 'TripTrackingService');
        return false;
      }

      if (booking.id == null || booking.id!.isEmpty) {
        dev.log('Invalid booking ID', name: 'TripTrackingService');
        return false;
      }

      // Update booking in Firestore to mark ride as completed
      await _bookingsCollection.doc(booking.id).update({
        'isTripStarted': false,
        'tripCompletedAt': DateTime.now().toIso8601String(),
        'status': BookingStatus.completed.value,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      dev.log('Ride completed successfully for booking: ${booking.id}',
          name: 'TripTrackingService');
      return true;
    } catch (e) {
      dev.log('Error completing ride: $e', name: 'TripTrackingService');
      return false;
    }
  }
}
