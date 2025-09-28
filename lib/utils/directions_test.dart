import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:semester_student_ride_app/services/google_directions_service.dart';
import 'dart:developer';

/// Test utility to verify Google Directions API is working correctly
class DirectionsTest {
  static Future<void> testDirections() async {
    // Test coordinates in Dubai (same area as your app)
    final origin = LatLng(25.2084, 55.2719); // Dubai Marina
    final destination = LatLng(25.1972, 55.2744); // JBR

    log('🧪 Starting Directions API test...', name: 'DirectionsTest');

    try {
      final routePoints = await GoogleDirectionsService.getRoute(
        origin: origin,
        destination: destination,
        travelMode: 'driving',
      );

      log('📍 Test route result: ${routePoints.length} points',
          name: 'DirectionsTest');

      if (routePoints.length > 2) {
        log('✅ SUCCESS: Got road-based route with ${routePoints.length} points',
            name: 'DirectionsTest');
      } else if (routePoints.length == 2) {
        log('⚠️ WARNING: Only got straight line (${routePoints.length} points)',
            name: 'DirectionsTest');
      } else {
        log('❌ ERROR: No route points received', name: 'DirectionsTest');
      }

      // Test route info
      final routeInfo = await GoogleDirectionsService.getRouteInfo(
        origin: origin,
        destination: destination,
        travelMode: 'driving',
      );

      if (routeInfo != null) {
        log('📊 Route info: ${routeInfo['distance']}, ${routeInfo['duration']}',
            name: 'DirectionsTest');
      } else {
        log('⚠️ No route info received', name: 'DirectionsTest');
      }
    } catch (e) {
      log('💥 Test failed with error: $e', name: 'DirectionsTest');
    }
  }
}
