import 'dart:convert';
import 'dart:developer';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:semester_student_ride_app/config/google_maps_config.dart';

class GoogleDirectionsService {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json';

  /// Get route between two points using Google Directions API with flutter_polyline_points
  static Future<List<LatLng>> getRoute({
    required LatLng origin,
    required LatLng destination,
    String travelMode = 'driving',
  }) async {
    try {
      // Check if API key is configured
      if (!GoogleMapsConfig.isConfigured) {
        log('Google Maps API key not configured, using fallback route',
            name: 'GoogleDirectionsService');
        return _fallbackRoute(origin, destination);
      }

      log('🚗 Fetching route from ${origin.latitude},${origin.longitude} to ${destination.latitude},${destination.longitude}',
          name: 'GoogleDirectionsService');

      // Build the URL for Google Directions API
      final url = Uri.parse('$_baseUrl?'
          'origin=${origin.latitude},${origin.longitude}&'
          'destination=${destination.latitude},${destination.longitude}&'
          'mode=$travelMode&'
          'key=${GoogleMapsConfig.apiKey}');

      log('🌍 API URL: $url', name: 'GoogleDirectionsService');

      // Make the HTTP request
      final response = await http.get(url);

      log('📡 HTTP Response Status: ${response.statusCode}',
          name: 'GoogleDirectionsService');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        log('🔍 API Response Status: ${data['status']}',
            name: 'GoogleDirectionsService');

        if (data['status'] == 'OK' &&
            data['routes'] != null &&
            data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final overviewPolyline =
              route['overview_polyline']['points'] as String;

          log('📍 Polyline string length: ${overviewPolyline.length}',
              name: 'GoogleDirectionsService');

          // Use flutter_polyline_points to decode the polyline
          final List<PointLatLng> decodedPoints =
              PolylinePoints.decodePolyline(overviewPolyline);

          // Convert to LatLng list
          final List<LatLng> routePoints = decodedPoints
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();

          log('✅ Successfully decoded route with ${routePoints.length} points',
              name: 'GoogleDirectionsService');
          log('🛣️ First 3 route points: ${routePoints.take(3).toList()}',
              name: 'GoogleDirectionsService');
          return routePoints;
        } else {
          log('❌ Google Directions API error: ${data['status']} - ${data['error_message'] ?? 'Unknown error'}',
              name: 'GoogleDirectionsService');
          if (data['error_message'] != null) {
            log('📝 Error details: ${data['error_message']}',
                name: 'GoogleDirectionsService');
          }
          return _fallbackRoute(origin, destination);
        }
      } else {
        log('❌ HTTP error: ${response.statusCode} - ${response.body}',
            name: 'GoogleDirectionsService');
        return _fallbackRoute(origin, destination);
      }
    } catch (e) {
      log('💥 Error fetching route: $e', name: 'GoogleDirectionsService');
      return _fallbackRoute(origin, destination);
    }
  }

  /// Get estimated duration and distance for a route
  static Future<Map<String, dynamic>?> getRouteInfo({
    required LatLng origin,
    required LatLng destination,
    String travelMode = 'driving',
  }) async {
    try {
      // Check if API key is configured
      if (!GoogleMapsConfig.isConfigured) {
        log('Google Maps API key not configured, cannot get route info',
            name: 'GoogleDirectionsService');
        return null;
      }

      final url = Uri.parse('$_baseUrl?'
          'origin=${origin.latitude},${origin.longitude}&'
          'destination=${destination.latitude},${destination.longitude}&'
          'mode=$travelMode&'
          'key=${GoogleMapsConfig.apiKey}');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' &&
            data['routes'] != null &&
            data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final leg = route['legs'][0];

          final routeInfo = {
            'distance': leg['distance']['text'] as String,
            'duration': leg['duration']['text'] as String,
            'distanceValue': leg['distance']['value'] as int, // in meters
            'durationValue': leg['duration']['value'] as int, // in seconds
          };

          log('Route info: ${routeInfo['distance']}, ${routeInfo['duration']}',
              name: 'GoogleDirectionsService');
          return routeInfo;
        } else {
          log('Failed to get route info: ${data['status']}',
              name: 'GoogleDirectionsService');
        }
      }
      return null;
    } catch (e) {
      log('Error fetching route info: $e', name: 'GoogleDirectionsService');
      return null;
    }
  }

  /// Fallback to straight line if API fails
  static List<LatLng> _fallbackRoute(LatLng origin, LatLng destination) {
    log('⚠️ Using fallback route (straight line) from ${origin.latitude},${origin.longitude} to ${destination.latitude},${destination.longitude}',
        name: 'GoogleDirectionsService');
    return [origin, destination];
  }

  /// Get multiple waypoints route (for complex routes)
  static Future<List<LatLng>> getRouteWithWaypoints({
    required LatLng origin,
    required LatLng destination,
    required List<LatLng> waypoints,
    String travelMode = 'driving',
  }) async {
    try {
      if (!GoogleMapsConfig.isConfigured) {
        return _fallbackRoute(origin, destination);
      }

      // Build waypoints string
      final waypointsStr = waypoints
          .map((point) => '${point.latitude},${point.longitude}')
          .join('|');

      final url = Uri.parse('$_baseUrl?'
          'origin=${origin.latitude},${origin.longitude}&'
          'destination=${destination.latitude},${destination.longitude}&'
          'waypoints=$waypointsStr&'
          'mode=$travelMode&'
          'key=${GoogleMapsConfig.apiKey}');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' &&
            data['routes'] != null &&
            data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final overviewPolyline =
              route['overview_polyline']['points'] as String;

          final List<PointLatLng> decodedPoints =
              PolylinePoints.decodePolyline(overviewPolyline);
          final List<LatLng> routePoints = decodedPoints
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();

          return routePoints;
        }
      }
      return _fallbackRoute(origin, destination);
    } catch (e) {
      log('Error fetching route with waypoints: $e',
          name: 'GoogleDirectionsService');
      return _fallbackRoute(origin, destination);
    }
  }
}
