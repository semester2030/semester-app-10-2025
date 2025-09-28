import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:semester_student_ride_app/services/driver_location_service.dart';

/// State class for driver location permission
class DriverLocationPermissionState {
  final bool hasPermission;
  final bool isServiceEnabled;
  final bool isTracking;
  final bool isLoading;
  final String? error;

  const DriverLocationPermissionState({
    this.hasPermission = false,
    this.isServiceEnabled = false,
    this.isTracking = false,
    this.isLoading = false,
    this.error,
  });

  DriverLocationPermissionState copyWith({
    bool? hasPermission,
    bool? isServiceEnabled,
    bool? isTracking,
    bool? isLoading,
    String? error,
  }) {
    return DriverLocationPermissionState(
      hasPermission: hasPermission ?? this.hasPermission,
      isServiceEnabled: isServiceEnabled ?? this.isServiceEnabled,
      isTracking: isTracking ?? this.isTracking,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  bool get canTrack => hasPermission && isServiceEnabled;
}

/// Notifier for managing driver location permissions
class DriverLocationPermissionNotifier
    extends StateNotifier<DriverLocationPermissionState> {
  DriverLocationPermissionNotifier()
      : super(const DriverLocationPermissionState());

  /// Check current permission status
  Future<void> checkPermissionStatus() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final hasPermission = await DriverLocationService.hasLocationPermission();
      final isServiceEnabled =
          await DriverLocationService.isLocationServiceEnabled();
      final isTracking = DriverLocationService.isTracking;

      state = state.copyWith(
        hasPermission: hasPermission,
        isServiceEnabled: isServiceEnabled,
        isTracking: isTracking,
        isLoading: false,
      );

      log('Permission status checked - Permission: $hasPermission, Service: $isServiceEnabled, Tracking: $isTracking',
          name: 'DriverLocationPermission');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error checking permission: $e',
      );
      log('Error checking permission status: $e',
          name: 'DriverLocationPermission');
    }
  }

  /// Request location permission from user
  Future<bool> requestPermission() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final granted = await DriverLocationService.requestLocationPermission();

      if (granted) {
        await checkPermissionStatus();
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Location permission denied',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error requesting permission: $e',
      );
      log('Error requesting permission: $e', name: 'DriverLocationPermission');
      return false;
    }
  }

  /// Start location tracking
  Future<bool> startTracking() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final success = await DriverLocationService.startLocationTracking();

      if (success) {
        state = state.copyWith(
          isTracking: true,
          isLoading: false,
        );
        log('Location tracking started successfully',
            name: 'DriverLocationPermission');
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to start location tracking',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error starting tracking: $e',
      );
      log('Error starting tracking: $e', name: 'DriverLocationPermission');
      return false;
    }
  }

  /// Stop location tracking
  Future<void> stopTracking() async {
    try {
      await DriverLocationService.stopLocationTracking();
      state = state.copyWith(isTracking: false);
      log('Location tracking stopped', name: 'DriverLocationPermission');
    } catch (e) {
      state = state.copyWith(error: 'Error stopping tracking: $e');
      log('Error stopping tracking: $e', name: 'DriverLocationPermission');
    }
  }

  /// Set driver as offline and stop tracking
  Future<void> setOffline() async {
    try {
      await DriverLocationService.setDriverOffline();
      state = state.copyWith(isTracking: false);
      log('Driver set offline', name: 'DriverLocationPermission');
    } catch (e) {
      state = state.copyWith(error: 'Error setting offline: $e');
      log('Error setting offline: $e', name: 'DriverLocationPermission');
    }
  }

  /// Clear any error messages
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for driver location permission management
final driverLocationPermissionProvider = StateNotifierProvider<
    DriverLocationPermissionNotifier, DriverLocationPermissionState>((ref) {
  return DriverLocationPermissionNotifier();
});

/// Provider for live driver locations (for passenger view)
final liveDriverLocationsProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  return DriverLocationService.getLiveDriverLocations();
});
