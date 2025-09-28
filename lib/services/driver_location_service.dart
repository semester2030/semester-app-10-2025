import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:semester_student_ride_app/config/firebase_collections.dart';

class DriverLocationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static StreamSubscription<Position>? _locationStream;
  static Timer? _locationUpdateTimer;
  static const Duration _updateInterval =
      Duration(seconds: 10); // Update every 10 seconds
  static bool _isTracking = false;
  static DateTime? _lastLogTime; // Track last log time to reduce frequency

  /// Check if location permissions are granted for drivers
  static Future<bool> hasLocationPermission() async {
    try {
      final permission = await Geolocator.checkPermission();

      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e) {
      log('Error checking location permission: $e',
          name: 'DriverLocationService');
      return false;
    }
  }

  /// Request location permissions specifically for drivers
  /// Returns true if permission is granted, false otherwise
  static Future<bool> requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        // Open app settings to allow user to enable location manually
        await Geolocator.openAppSettings();
        return false;
      }

      // For drivers, we prefer 'always' permission for background tracking
      if (permission == LocationPermission.whileInUse) {
        // Try to request 'always' permission
        permission = await Geolocator.requestPermission();
      }

      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e) {
      log('Error requesting location permission: $e',
          name: 'DriverLocationService');
      return false;
    }
  }

  /// Check if location services are enabled on the device
  static Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      log('Error checking location service: $e', name: 'DriverLocationService');
      return false;
    }
  }

  /// Get current driver's location once
  static Future<LatLng?> getCurrentLocation() async {
    try {
      final hasPermission = await hasLocationPermission();
      if (!hasPermission) {
        log('Location permission not granted', name: 'DriverLocationService');
        return null;
      }

      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        log('Location service not enabled', name: 'DriverLocationService');
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      log('Error getting current location: $e', name: 'DriverLocationService');
      return null;
    }
  }

  /// Start continuous location tracking for drivers
  /// Updates driver location in Firestore every 10 seconds
  static Future<bool> startLocationTracking() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        log('No authenticated user found', name: 'DriverLocationService');
        return false;
      }

      // Check permissions first
      final hasPermission = await hasLocationPermission();
      if (!hasPermission) {
        log('Location permission not granted for tracking',
            name: 'DriverLocationService');
        return false;
      }

      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        log('Location service not enabled for tracking',
            name: 'DriverLocationService');
        return false;
      }

      // Stop any existing tracking
      await stopLocationTracking();

      _isTracking = true;

      // Set up periodic location updates
      _locationUpdateTimer = Timer.periodic(_updateInterval, (timer) async {
        if (!_isTracking) {
          timer.cancel();
          return;
        }

        try {
          final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            timeLimit: const Duration(seconds: 8),
          );

          await _updateDriverLocationInFirestore(
            currentUser.uid,
            LatLng(position.latitude, position.longitude),
          );

          // Only log every 30 seconds to reduce spam
          final now = DateTime.now();
          if (_lastLogTime == null ||
              now.difference(_lastLogTime!).inSeconds >= 30) {
            log('Driver location updated: ${position.latitude}, ${position.longitude}',
                name: 'DriverLocationService');
            _lastLogTime = now;
          }
        } catch (e) {
          log('Error updating location: $e', name: 'DriverLocationService');
        }
      });

      // Also set up a position stream for more real-time updates
      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter:
            20, // Update only when moved 20 meters (reduced frequency)
      );

      _locationStream = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) async {
          if (_isTracking) {
            await _updateDriverLocationInFirestore(
              currentUser.uid,
              LatLng(position.latitude, position.longitude),
            );
          }
        },
        onError: (error) {
          log('Location stream error: $error', name: 'DriverLocationService');
        },
      );

      log('Driver location tracking started', name: 'DriverLocationService');

      // Verify tracking state
      log('Tracking state after start: $_isTracking',
          name: 'DriverLocationService');

      return true;
    } catch (e) {
      log('Error starting location tracking: $e',
          name: 'DriverLocationService');
      return false;
    }
  }

  /// Stop location tracking
  static Future<void> stopLocationTracking() async {
    try {
      log('stopLocationTracking called - current tracking state: $_isTracking',
          name: 'DriverLocationService');

      _isTracking = false;

      _locationStream?.cancel();
      _locationStream = null;

      _locationUpdateTimer?.cancel();
      _locationUpdateTimer = null;

      log('Driver location tracking stopped', name: 'DriverLocationService');
    } catch (e) {
      log('Error stopping location tracking: $e',
          name: 'DriverLocationService');
    }
  }

  /// Update driver's location in Firestore
  static Future<void> _updateDriverLocationInFirestore(
      String driverId, LatLng location) async {
    try {
      await _firestore.collection('users').doc(driverId).update({
        'currentLocation': {
          'latitude': location.latitude,
          'longitude': location.longitude,
          'lastUpdated': DateTime.now().toIso8601String(),
        },
        'isOnline': true,
        'lastSeen': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      log('Error updating driver location in Firestore: $e',
          name: 'DriverLocationService');
    }
  }

  /// Set driver as offline
  static Future<void> setDriverOffline() async {
    try {
      log('setDriverOffline called - checking if tracking should be stopped',
          name: 'DriverLocationService');

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        log('No current user found, skipping offline operation',
            name: 'DriverLocationService');
        return;
      }

      log('Setting driver ${currentUser.uid} as offline',
          name: 'DriverLocationService');

      await _firestore.collection('users').doc(currentUser.uid).update({
        'isOnline': false,
        'lastSeen': DateTime.now().toIso8601String(),
      });

      await stopLocationTracking();
      log('Driver set as offline', name: 'DriverLocationService');
    } catch (e) {
      log('Error setting driver offline: $e', name: 'DriverLocationService');
    }
  }

  /// Get live driver locations for displaying on passenger map
  static Stream<List<Map<String, dynamic>>> getLiveDriverLocations() {
    return userCollection
        .where('isDriver', isEqualTo: true)
        .where('isOnline', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            final currentLocation =
                data['currentLocation'] as Map<String, dynamic>?;

            if (currentLocation != null) {
              // Construct vehicle name from separate fields
              final vehicleMake = data['vehicleMake'] as String?;
              final vehicleModel = data['vehicleModel'] as String?;
              final vehicleYear = data['vehicleYear'] as String?;

              final vehicleParts = <String>[];
              if (vehicleMake?.isNotEmpty == true)
                vehicleParts.add(vehicleMake!);
              if (vehicleModel?.isNotEmpty == true)
                vehicleParts.add(vehicleModel!);
              if (vehicleYear?.isNotEmpty == true)
                vehicleParts.add(vehicleYear!);
              final fullVehicleName = vehicleParts.isEmpty
                  ? 'Unknown Vehicle'
                  : vehicleParts.join(' ');

              return {
                'driverId': doc.id,
                'driverName': data['name'] ?? 'Unknown Driver',
                'driverPhoto': data['profilePicture'] ?? '',
                'vehicleModel': fullVehicleName,
                'vehicleType': data['vehicleType'] ?? 'Car',
                'rating': (data['rating'] ?? 4.0).toDouble(),
                'location': LatLng(
                  currentLocation['latitude']?.toDouble() ?? 0.0,
                  currentLocation['longitude']?.toDouble() ?? 0.0,
                ),
                'lastUpdated': currentLocation['lastUpdated'],
              };
            }
            return null;
          })
          .where((driver) => driver != null)
          .cast<Map<String, dynamic>>()
          .toList();
    });
  }

  /// Check if driver location tracking is currently active
  static bool get isTracking => _isTracking;

  /// Force location update immediately
  static Future<void> updateLocationNow() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null || !_isTracking) return;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );

      await _updateDriverLocationInFirestore(
        currentUser.uid,
        LatLng(position.latitude, position.longitude),
      );

      log('Driver location force updated', name: 'DriverLocationService');
    } catch (e) {
      log('Error force updating location: $e', name: 'DriverLocationService');
    }
  }
}
