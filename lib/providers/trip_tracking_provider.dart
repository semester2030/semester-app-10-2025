import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/services/trip_tracking_service.dart';
import 'package:semester_student_ride_app/services/local_notification_service.dart';
import 'package:semester_student_ride_app/utils/distance_utils.dart';
import 'package:semester_student_ride_app/enums/booking_status.dart';

// Trip tracking state
class TripTrackingState {
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? driverData;
  final LatLng? driverLocation;
  final List<LatLng> routePolyline;
  final bool isTripActive;
  final BookingStatus? bookingStatus;
  final Map<String, dynamic>? routeInfo; // Duration and distance info
  final bool isDriverNearby; // New field for proximity detection
  final bool
      proximityNotificationSent; // Track if notification was already sent
  final bool isDriverComing; // Track if driver clicked "I'm Coming"
  final bool isDriverWithinRange; // Track if driver is within 500m of pickup

  const TripTrackingState({
    this.isLoading = false,
    this.error,
    this.driverData,
    this.driverLocation,
    this.routePolyline = const [],
    this.isTripActive = false,
    this.bookingStatus,
    this.routeInfo,
    this.isDriverNearby = false,
    this.proximityNotificationSent = false,
    this.isDriverComing = false,
    this.isDriverWithinRange = false,
  });

  TripTrackingState copyWith({
    bool? isLoading,
    String? error,
    Map<String, dynamic>? driverData,
    LatLng? driverLocation,
    List<LatLng>? routePolyline,
    bool? isTripActive,
    BookingStatus? bookingStatus,
    Map<String, dynamic>? routeInfo,
    bool? isDriverNearby,
    bool? proximityNotificationSent,
    bool? isDriverComing,
    bool? isDriverWithinRange,
  }) {
    return TripTrackingState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      driverData: driverData ?? this.driverData,
      driverLocation: driverLocation ?? this.driverLocation,
      routePolyline: routePolyline ?? this.routePolyline,
      isTripActive: isTripActive ?? this.isTripActive,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      routeInfo: routeInfo ?? this.routeInfo,
      isDriverNearby: isDriverNearby ?? this.isDriverNearby,
      proximityNotificationSent:
          proximityNotificationSent ?? this.proximityNotificationSent,
      isDriverComing: isDriverComing ?? this.isDriverComing,
      isDriverWithinRange: isDriverWithinRange ?? this.isDriverWithinRange,
    );
  }
}

// Trip tracking notifier
class TripTrackingNotifier extends StateNotifier<TripTrackingState> {
  TripTrackingNotifier() : super(const TripTrackingState());

  StreamSubscription<Map<String, dynamic>?>? _driverLocationSubscription;
  StreamSubscription<bool>? _tripActiveSubscription;
  StreamSubscription<BookingStatus?>? _bookingStatusSubscription;

  /// Start tracking a trip
  Future<void> startTracking(
      String driverId, LatLng pickupLocation, String bookingId,
      {LatLng? destinationLocation}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Subscribe to driver location updates
      _driverLocationSubscription?.cancel();
      _driverLocationSubscription = TripTrackingService.getLiveDriverLocation(
        driverId: driverId,
      ).listen(
        (driverData) async {
          if (driverData != null) {
            final currentLocation =
                driverData['currentLocation'] as Map<String, dynamic>;
            final driverLatLng = LatLng(
              currentLocation['latitude'] as double,
              currentLocation['longitude'] as double,
            );

            // Always fetch new route and route info on every driver location update
            log('🗺️ Fetching route between driver and target location...',
                name: 'TripTrackingNotifier');

            List<LatLng> route = [];
            Map<String, dynamic>? routeInfo;

            try {
              // Determine target location based on trip status
              LatLng targetLocation;
              if (state.isTripActive && destinationLocation != null) {
                // If trip has started, route to destination
                targetLocation = destinationLocation;
                route = await TripTrackingService.getTripRouteToDestination(
                  driverLocation: driverLatLng,
                  destinationLocation: targetLocation,
                );
              } else {
                // Route to pickup location
                targetLocation = pickupLocation;
                route = await TripTrackingService.getTripRoute(
                  driverLocation: driverLatLng,
                  pickupLocation: targetLocation,
                );
              }

              routeInfo = await TripTrackingService.getRouteInfo(
                driverLocation: driverLatLng,
                pickupLocation: targetLocation,
              );

              log('✅ Updated route: ${route.length} points, Distance: ${routeInfo?['distance']}, Duration: ${routeInfo?['duration']}',
                  name: 'TripTrackingNotifier');
            } catch (e) {
              log('❌ Error fetching route: $e', name: 'TripTrackingNotifier');
              // Use fallback route if API fails
              final targetLocation =
                  state.isTripActive && destinationLocation != null
                      ? destinationLocation
                      : pickupLocation;
              route = [driverLatLng, targetLocation];
            }

            // Check proximity to pickup (within 500 meters for showing start trip button)
            final distanceToPickup = DistanceUtils.calculateDistance(
              driverLatLng,
              pickupLocation,
            );
            final isWithinRange = distanceToPickup <= 500.0; // 500 meters

            // distance to change
            final isNearby =
                distanceToPickup <= 1000.0; // 100 meters for general proximity

            log('📍 Distance to pickup: ${DistanceUtils.formatDistance(distanceToPickup)}, Within range: $isWithinRange, Is nearby: $isNearby',
                name: 'TripTrackingNotifier');

            state = state.copyWith(
              driverData: driverData,
              driverLocation: driverLatLng,
              routePolyline: route,
              routeInfo: routeInfo,
              isLoading: false,
              isDriverNearby: isNearby,
              isDriverWithinRange: isWithinRange,
            );
          } else {
            state = state.copyWith(
              driverData: null,
              driverLocation: null,
              routePolyline: [],
              routeInfo: null,
              isLoading: false,
            );
          }
        },
        onError: (error) {
          log('Error in driver location stream: $error',
              name: 'TripTrackingNotifier');
          state = state.copyWith(
            error: 'Failed to get driver location: $error',
            isLoading: false,
          );
        },
      );

      // Subscribe to trip active status
      _tripActiveSubscription?.cancel();
      _tripActiveSubscription = TripTrackingService.isTripActive(
        bookingId: bookingId,
      ).listen(
        (isActive) {
          state = state.copyWith(isTripActive: isActive);
        },
        onError: (error) {
          log('Error in trip active stream: $error',
              name: 'TripTrackingNotifier');
        },
      );

      // Subscribe to booking status
      _bookingStatusSubscription?.cancel();
      _bookingStatusSubscription = TripTrackingService.getBookingStatusStream(
        bookingId: bookingId,
      ).listen(
        (status) {
          state = state.copyWith(bookingStatus: status);
        },
        onError: (error) {
          log('Error in booking status stream: $error',
              name: 'TripTrackingNotifier');
        },
      );

      log('Started tracking trip for booking: $bookingId',
          name: 'TripTrackingNotifier');
    } catch (e) {
      log('Error starting trip tracking: $e', name: 'TripTrackingNotifier');
      state = state.copyWith(
        error: 'Failed to start tracking: $e',
        isLoading: false,
      );
    }
  }

  /// Stop tracking
  void stopTracking() {
    _driverLocationSubscription?.cancel();
    _tripActiveSubscription?.cancel();
    _bookingStatusSubscription?.cancel();

    // Only reset state if the notifier is still mounted
    if (mounted) {
      state = const TripTrackingState();
    }

    log('Stopped tracking trip', name: 'TripTrackingNotifier');
  }

  /// Start trip (for drivers)
  Future<bool> startTrip(RequestBookingModel booking) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final success = await TripTrackingService.startTrip(booking: booking);

      if (success) {
        state = state.copyWith(
          isTripActive: true,
          bookingStatus: BookingStatus.tripStarted,
          isLoading: false,
        );

        // Force route update to destination when trip starts
        if (state.driverLocation != null &&
            booking.dropOffAddress?.coordinates != null) {
          log('🚗 Trip started - updating route to destination',
              name: 'TripTrackingNotifier');
          try {
            final route = await TripTrackingService.getTripRouteToDestination(
              driverLocation: state.driverLocation!,
              destinationLocation: booking.dropOffAddress!.coordinates,
            );
            state = state.copyWith(routePolyline: route);
            log('✅ Route updated to destination: ${route.length} points',
                name: 'TripTrackingNotifier');
          } catch (e) {
            log('❌ Error updating route to destination: $e',
                name: 'TripTrackingNotifier');
            // Fallback to straight line
            state = state.copyWith(routePolyline: [
              state.driverLocation!,
              booking.dropOffAddress!.coordinates
            ]);
          }
        }

        log('Trip started successfully', name: 'TripTrackingNotifier');
      } else {
        state = state.copyWith(
          error: 'Failed to start trip',
          isLoading: false,
        );
      }

      return success;
    } catch (e) {
      log('Error starting trip: $e', name: 'TripTrackingNotifier');
      state = state.copyWith(
        error: 'Error starting trip: $e',
        isLoading: false,
      );
      return false;
    }
  }

  /// Driver indicates they are coming (for drivers)
  Future<bool> driverIsComing(RequestBookingModel booking) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final success =
          await TripTrackingService.driverIsComing(booking: booking);

      if (success) {
        state = state.copyWith(
          isDriverComing: true,
          isLoading: false,
        );
        log('Driver marked as coming successfully',
            name: 'TripTrackingNotifier');
      } else {
        state = state.copyWith(
          error: 'Failed to mark driver as coming',
          isLoading: false,
        );
      }

      return success;
    } catch (e) {
      log('Error marking driver as coming: $e', name: 'TripTrackingNotifier');
      state = state.copyWith(
        error: 'Error marking driver as coming: $e',
        isLoading: false,
      );
      return false;
    }
  }

  /// End trip (for drivers)
  Future<bool> endTrip(RequestBookingModel booking) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final success = await TripTrackingService.endTrip(booking: booking);

      if (success) {
        state = state.copyWith(
          isTripActive: false,
          bookingStatus: BookingStatus.completed,
          isLoading: false,
        );
        log('Trip ended successfully', name: 'TripTrackingNotifier');
      } else {
        state = state.copyWith(
          error: 'Failed to end trip',
          isLoading: false,
        );
      }

      return success;
    } catch (e) {
      log('Error ending trip: $e', name: 'TripTrackingNotifier');
      state = state.copyWith(
        error: 'Error ending trip: $e',
        isLoading: false,
      );
      return false;
    }
  }

  /// Complete ride (for drivers)
  Future<bool> completeRide(RequestBookingModel booking) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final success = await TripTrackingService.completeRide(booking: booking);

      if (success) {
        state = state.copyWith(
          isTripActive: false,
          bookingStatus: BookingStatus.completed,
          isLoading: false,
        );
        log('Ride completed successfully', name: 'TripTrackingNotifier');
      } else {
        state = state.copyWith(
          error: 'Failed to complete ride',
          isLoading: false,
        );
      }

      return success;
    } catch (e) {
      log('Error completing ride: $e', name: 'TripTrackingNotifier');
      state = state.copyWith(
        error: 'Error completing ride: $e',
        isLoading: false,
      );
      return false;
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Force route update - useful for manual refresh
  Future<void> forceRouteUpdate(
      LatLng driverLocation, LatLng pickupLocation) async {
    try {
      log('🔄 Force updating route...', name: 'TripTrackingNotifier');

      final route = await TripTrackingService.getTripRoute(
        driverLocation: driverLocation,
        pickupLocation: pickupLocation,
      );

      final routeInfo = await TripTrackingService.getRouteInfo(
        driverLocation: driverLocation,
        pickupLocation: pickupLocation,
      );

      state = state.copyWith(
        routePolyline: route,
        routeInfo: routeInfo,
      );

      log('✅ Force updated route: ${route.length} points',
          name: 'TripTrackingNotifier');
    } catch (e) {
      log('❌ Error force updating route: $e', name: 'TripTrackingNotifier');
      // Use fallback route if API fails
      state = state.copyWith(
        routePolyline: [driverLocation, pickupLocation],
      );
    }
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }
}

// Provider for trip tracking
final tripTrackingProvider =
    StateNotifierProvider<TripTrackingNotifier, TripTrackingState>((ref) {
  return TripTrackingNotifier();
});

// Provider for checking if a specific booking has an active trip
final bookingTripActiveProvider =
    StreamProvider.family<bool, String>((ref, bookingId) {
  return TripTrackingService.isTripActive(bookingId: bookingId);
});

// Provider for checking if driver is coming for a specific booking
final bookingDriverComingProvider =
    StreamProvider.family<bool, String>((ref, bookingId) {
  return TripTrackingService.isDriverComing(bookingId: bookingId);
});

// Provider for checking if driver is within pickup range
final driverWithinPickupRangeProvider =
    StreamProvider.family<bool, Map<String, dynamic>>((ref, params) {
  // Add keepAlive to prevent frequent rebuilds
  ref.keepAlive();

  return TripTrackingService.isDriverWithinPickupRange(
    bookingId: params['bookingId'] as String,
    driverId: params['driverId'] as String,
    pickupLocation: params['pickupLocation'] as LatLng,
  );
});

// Single-check provider for driver within pickup range
final driverWithinPickupRangeCheckProvider =
    FutureProvider.family<bool, Map<String, dynamic>>((ref, params) async {
  try {
    final driverId = params['driverId'] as String;
    final pickupLocation = params['pickupLocation'] as LatLng;

    // Get current driver location
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(driverId)
        .get();

    if (!userDoc.exists) return false;

    final data = userDoc.data() as Map<String, dynamic>;
    final currentLocation = data['currentLocation'] as Map<String, dynamic>?;

    if (currentLocation == null) return false;

    final driverLatLng = LatLng(
      currentLocation['latitude']?.toDouble() ?? 0.0,
      currentLocation['longitude']?.toDouble() ?? 0.0,
    );

    final distance =
        DistanceUtils.calculateDistance(driverLatLng, pickupLocation);
    return distance <= 1000.0; // 1000 meters for testing
  } catch (e) {
    return false;
  }
});

// Provider that stops listening once driver is within range (one-shot provider)
final driverWithinPickupRangeOnceShotProvider =
    StreamProvider.family<bool, Map<String, dynamic>>((ref, params) {
  ref.keepAlive();

  bool hasReturnedTrue = false;

  return TripTrackingService.isDriverWithinPickupRange(
    bookingId: params['bookingId'] as String,
    driverId: params['driverId'] as String,
    pickupLocation: params['pickupLocation'] as LatLng,
  ).where((isWithinRange) {
    if (hasReturnedTrue) return false; // Stop emitting after first true
    if (isWithinRange) hasReturnedTrue = true;
    return true;
  });
});

// Provider for checking if driver is within destination range
final driverWithinDestinationRangeProvider =
    StreamProvider.family<bool, Map<String, dynamic>>((ref, params) {
  // Add keepAlive to prevent frequent rebuilds
  ref.keepAlive();

  return TripTrackingService.isDriverWithinDestinationRange(
    bookingId: params['bookingId'] as String,
    driverId: params['driverId'] as String,
    destinationLocation: params['destinationLocation'] as LatLng,
  ).distinct(); // Only emit when value actually changes
});

// Provider for getting booking status
final bookingStatusStreamProvider =
    StreamProvider.family<BookingStatus?, String>((ref, bookingId) {
  return TripTrackingService.getBookingStatusStream(bookingId: bookingId);
});

// Provider for getting driver details for a booking
final bookingDriverDetailsProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, bookingId) {
  return TripTrackingService.getDriverDetails(bookingId: bookingId);
});
