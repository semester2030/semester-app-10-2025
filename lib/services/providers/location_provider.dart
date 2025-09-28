import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:semester_student_ride_app/services/providers/prefs.dart';
import 'package:semester_student_ride_app/utils/shared_preferences_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

part 'location_provider.g.dart';

// Helper provider to check location permission status
final locationProvider = Provider<LocationService>((ref) {
  return LocationService();
});

class LocationService {
  // Check the current location permission status
  Future<String> checkLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.deniedForever) {
        return 'deniedForever';
      } else if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        return 'allowed';
      } else {
        return 'denied';
      }
    } catch (e) {
      log('Error checking location permission: $e');
      return 'denied';
    }
  }
}

@riverpod
class UserLocation extends _$UserLocation {
  @override
  Future<void> build() async {
    await _initializeUserLocation();
  }

  Future<void> _initializeUserLocation() async {
    final AsyncValue<SPUtils> sharedPref = await ref.watch(prefsProvider);

    sharedPref.when(
      data: (prefs) async {
        await requestAndSaveLocation();
      },
      loading: () {
        log('Loading shared preferences...');
      },
      error: (err, stack) {
        log('Error loading shared preferences: $err');
      },
    );
  }

  Future<void> _saveCurrentLocation(SPUtils pref) async {
    try {
      final position = await Geolocator.getCurrentPosition();

      pref.UserLocation = LatLng(position.latitude, position.longitude);

      log('Saved current location: Lat ${position.latitude}, '
          'Lng ${position.longitude}');
    } catch (e) {
      log('Failed to get current location: $e');
    }
  }

  Future<void> requestAndSaveLocation() async {
    final SPUtils pref = SPUtils();
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        pref.locationPermissionStatus = 'denied';
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        // Use default location
        pref.locationPermissionStatus = 'deniedForever';
        log('Location permission denied forever.');
      } else if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        pref.locationPermissionStatus = 'allowed';
        await _saveCurrentLocation(pref);
      } else {
        log('Location permission denied.');
      }
    } catch (e) {
      log('Failed to get location permission: $e');
    }
  }
}
