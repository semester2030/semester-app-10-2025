import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:semester_student_ride_app/services/driver_service.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';

part 'driver_details_provider.g.dart';

/// Provider that fetches driver details by email
@riverpod
Future<UserSignupModel?> driverDetails(DriverDetailsRef ref, String id) async {
  if (id.isEmpty) {
    return null;
  }

  try {
    final driver = await DriverService.getDriverById(id);
    return driver;
  } catch (e) {
    print('Error fetching driver details for id $id: $e');
    return null;
  }
}

/// Provider for driver statistics
@riverpod
Map<String, dynamic> driverStats(DriverStatsRef ref, UserSignupModel? driver) {
  if (driver == null) {
    return {
      'rating': 0.0,
      'totalTrips': 0,
      'yearsOfExperience': 0,
      'distance': 0.0,
    };
  }

  return DriverService.getDriverStats(driver);
}
