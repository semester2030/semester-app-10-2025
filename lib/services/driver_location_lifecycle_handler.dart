import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:semester_student_ride_app/services/driver_location_service.dart';

/// App lifecycle handler to manage driver location tracking
class DriverLocationLifecycleHandler extends WidgetsBindingObserver {
  bool _hasBeenResumed = false; // Track if app has been actively used

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    log('App lifecycle state changed to: $state', name: 'LocationLifecycle');

    switch (state) {
      case AppLifecycleState.resumed:
        log('App resumed - driver location tracking continues',
            name: 'LocationLifecycle');
        _hasBeenResumed = true;
        // Optionally restart tracking if it was stopped
        break;

      case AppLifecycleState.paused:
        log('App paused - location tracking continues in background',
            name: 'LocationLifecycle');
        // Keep tracking active in background for drivers
        break;

      case AppLifecycleState.detached:
        // Only stop tracking if app has been actively used and is now being detached
        if (_hasBeenResumed) {
          log('App detached - stopping location tracking',
              name: 'LocationLifecycle');
          DriverLocationService.setDriverOffline();
        }
        break;

      case AppLifecycleState.inactive:
        // Don't stop tracking on inactive - this happens during app startup and transitions
        log('App inactive - keeping location tracking active',
            name: 'LocationLifecycle');
        break;

      case AppLifecycleState.hidden:
        log('App hidden - location tracking continues',
            name: 'LocationLifecycle');
        break;
    }
  }
}
