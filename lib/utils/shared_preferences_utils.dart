import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:semester_student_ride_app/services/providers/location_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPUtils {
  SharedPreferencesWithCache? sharedPreferences;

  static final SPUtils _instance = SPUtils._internal();

  factory SPUtils() => _instance;

  SPUtils._internal();

  final String _locationPermissionStatus = 'locationPermissionStatus';
  final String _userLatitude = 'userlatitude';
  final String _userLongitude = 'userlongitude';

  Future init() async {
    sharedPreferences ??= await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
  }

  set UserLocation(LatLng latLng) {
    sharedPreferences!.setDouble(_userLatitude, latLng.latitude);
    sharedPreferences!.setDouble(_userLongitude, latLng.longitude);
  }

  set locationPermissionStatus(String status) {
    sharedPreferences!.setString(_locationPermissionStatus, status);
  }

  String get locationPermissionStatus {
    return sharedPreferences!.getString(_locationPermissionStatus) ?? '';
  }

  LatLng get userlocation => LatLng(
        sharedPreferences!.getDouble(_userLatitude) ?? 0,
        sharedPreferences!.getDouble(_userLongitude) ?? 0,
      );
}
