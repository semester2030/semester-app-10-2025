import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'package:semester_student_ride_app/services/driver_service.dart';

part 'all_drivers_provider.g.dart';

/// Provider to fetch all available drivers
/// Returns a list of UserSignupModel where isDriver is true
@riverpod
Future<List<UserSignupModel>> allDrivers(AllDriversRef ref) async {
  log('AllDriversProvider: Starting to fetch drivers...',
      name: 'AllDriversProvider');

  try {
    final drivers = await DriverService.getAvailableDrivers();
    log('AllDriversProvider: Received ${drivers.length} drivers',
        name: 'AllDriversProvider');

    for (final driver in drivers) {
      log('AllDriversProvider: Driver - Name: ${driver.name}, ID: ${driver.id}, isDriver: ${driver.isDriver}, hasLocation: ${driver.currentLocation != null}',
          name: 'AllDriversProvider');
    }

    return drivers;
  } catch (e, stackTrace) {
    log('AllDriversProvider: Error occurred: $e',
        name: 'AllDriversProvider', error: e, stackTrace: stackTrace);
    return [];
  }
}

/// Provider to fetch all available drivers with real-time updates
/// This provider automatically refreshes when driver data changes
@riverpod
Stream<List<UserSignupModel>> allDriversStream(AllDriversStreamRef ref) async* {
  // You can implement real-time streaming here if needed
  // For now, we'll yield the current data
  yield await DriverService.getAvailableDrivers();
}
