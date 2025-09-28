import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

class DriverService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch all available drivers from Firestore
  /// Returns list of UserSignupModel where isDriver is true
  static Future<List<UserSignupModel>> getAvailableDrivers() async {
    try {
      print('DriverService: Starting to fetch drivers...');

      // First, let's check if we can get ANY users at all
      final allUsersSnapshot = await userCollection.limit(5).get();
      print(
          'DriverService: Total users in collection: ${allUsersSnapshot.docs.length}');

      for (final doc in allUsersSnapshot.docs) {
        final data = doc.data();
        print(
            'DriverService: User - Name: ${data['name']}, isDriver: ${data['isDriver']}');
      }

      // Now try the specific query
      final querySnapshot =
          await userCollection.where('isDriver', isEqualTo: true).get();

      print('DriverService: Found ${querySnapshot.docs.length} drivers');

      final drivers = querySnapshot.docs.map((doc) {
        final data = doc.data();
        print(
            'DriverService: Processing driver: ${data['name']} - isDriver: ${data['isDriver']}');

        try {
          // Convert Firestore Timestamps to DateTime objects
          final processedData = <String, dynamic>{
            ...data,
            'id': doc.id, // Include document ID
          };

          // Handle Timestamp fields - convert to DateTime objects
          if (data['createdAt'] is Timestamp) {
            processedData['createdAt'] =
                (data['createdAt'] as Timestamp).toDate();
          }
          if (data['updatedAt'] is Timestamp) {
            processedData['updatedAt'] =
                (data['updatedAt'] as Timestamp).toDate();
          }
          if (data['tokenUpdatedAt'] is Timestamp) {
            processedData['tokenUpdatedAt'] =
                (data['tokenUpdatedAt'] as Timestamp).toDate();
          }
          if (data['lastSeen'] is Timestamp) {
            processedData['lastSeen'] =
                (data['lastSeen'] as Timestamp).toDate();
          }

          // Handle currentLocation lastUpdated if it exists
          if (data['currentLocation'] is Map<String, dynamic>) {
            final currentLocation = Map<String, dynamic>.from(
                data['currentLocation'] as Map<String, dynamic>);
            if (currentLocation['lastUpdated'] is Timestamp) {
              currentLocation['lastUpdated'] =
                  (currentLocation['lastUpdated'] as Timestamp).toDate();
            }
            processedData['currentLocation'] = currentLocation;
          }

          final driver = UserSignupModel.fromJson(processedData);
          print('DriverService: Successfully parsed driver: ${driver.name}');
          return driver;
        } catch (e) {
          print(
              'DriverService: Error parsing driver data for ${data['name']}: $e');
          print('DriverService: Raw data: $data');
          rethrow;
        }
      }).toList();

      print('DriverService: Returning ${drivers.length} drivers');
      return drivers;
    } catch (e) {
      print('Error fetching drivers: $e');
      return [];
    }
  }

  /// Fetch drivers within a specific radius from a location
  /// Uses Haversine formula to calculate distance
  static Future<List<UserSignupModel>> getDriversNearLocation({
    required LatLng userLocation,
    required double radiusInKm,
  }) async {
    try {
      // Get all available drivers with current location data
      final querySnapshot = await userCollection
          .where('isDriver', isEqualTo: true)
          .where('isOnline', isEqualTo: true)
          .get();

      final List<UserSignupModel> nearbyDrivers = [];

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final currentLocation =
            data['currentLocation'] as Map<String, dynamic>?;

        if (currentLocation != null) {
          final driverLat = currentLocation['latitude']?.toDouble();
          final driverLng = currentLocation['longitude']?.toDouble();

          if (driverLat != null && driverLng != null) {
            final driverLocation = LatLng(driverLat, driverLng);
            final distance = _calculateDistance(userLocation, driverLocation);

            // Include driver if within specified radius
            if (distance <= radiusInKm) {
              final driver = UserSignupModel.fromJson({
                ...data,
                'id': doc.id,
                'currentLocation': currentLocation,
              });
              nearbyDrivers.add(driver);
            }
          }
        }
      }

      // Sort by distance (closest first) - using a simple approach
      // For production, you might want to add distance as a field to the model
      return nearbyDrivers;
    } catch (e) {
      print('Error fetching nearby drivers: $e');
      return [];
    }
  }

  /// Calculate distance between two coordinates using Haversine formula
  static double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371; // Earth radius in kilometers

    final double lat1Rad = point1.latitude * (pi / 180);
    final double lat2Rad = point2.latitude * (pi / 180);
    final double deltaLatRad = (point2.latitude - point1.latitude) * (pi / 180);
    final double deltaLngRad =
        (point2.longitude - point1.longitude) * (pi / 180);

    final double a = sin(deltaLatRad / 2) * sin(deltaLatRad / 2) +
        cos(lat1Rad) *
            cos(lat2Rad) *
            sin(deltaLngRad / 2) *
            sin(deltaLngRad / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Get only online drivers with live location tracking
  static Future<List<UserSignupModel>> getOnlineDrivers() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('isDriver', isEqualTo: true)
          .where('isOnline', isEqualTo: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return UserSignupModel.fromJson({
          ...data,
          'id': doc.id,
        });
      }).toList();
    } catch (e) {
      print('Error fetching online drivers: $e');
      return [];
    }
  }

  /// Get driver by ID
  static Future<UserSignupModel?> getDriverById(String driverId) async {
    try {
      final searchDocs = await userCollection.doc(driverId).get();

      if (searchDocs.exists) {
        final data = searchDocs.data();
        return UserSignupModel.fromJson(data!);
      }

      return null;
    } catch (e) {
      print('Error fetching driver by ID: $e');
      return null;
    }
  }

  /// Get driver by email
  static Future<UserSignupModel?> getDriverByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .where('isDriver', isEqualTo: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data();
        return UserSignupModel.fromJson({
          ...data,
          'id': doc.id,
        });
      }

      return null;
    } catch (e) {
      print('Error fetching driver by email: $e');
      return null;
    }
  }

  /// Filter drivers by gender preference
  static List<UserSignupModel> filterDriversByGender(
    List<UserSignupModel> drivers,
    String? genderPreference,
  ) {
    if (genderPreference == null || genderPreference.isEmpty) {
      return drivers;
    }

    return drivers
        .where((driver) => driver.gender == genderPreference)
        .toList();
  }

  /// Filter drivers by role
  static List<UserSignupModel> filterDriversByRole(
    List<UserSignupModel> drivers,
    String? rolePreference,
  ) {
    if (rolePreference == null || rolePreference.isEmpty) {
      return drivers;
    }

    return drivers.where((driver) => driver.role == rolePreference).toList();
  }

  /// Sort drivers by distance (mock implementation)
  /// In a real app, you'd calculate actual distances
  static List<UserSignupModel> sortDriversByDistance(
    List<UserSignupModel> drivers,
    LatLng userLocation,
  ) {
    // Mock implementation - in reality you'd calculate actual distances
    // For now, just return the list as is
    return List.from(drivers);
  }

  /// Get driver statistics (mock data)
  /// In a real app, you'd have these in the database
  static Map<String, dynamic> getDriverStats(UserSignupModel driver) {
    return {
      'rating': 4.5, // Default rating
      'totalTrips': 50, // Default trip count
      'yearsOfExperience': 2, // Default experience
      'distance': 2.5, // Default distance in km
    };
  }
}
