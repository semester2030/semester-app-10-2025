import 'package:shared_preferences/shared_preferences.dart';

/// A service to handle all SharedPreferences operations
class SharedPreferenceService {
  static SharedPreferenceService? _instance;
  SharedPreferences? _preferences;

  // Keys for storing data
  static const String locationPermissionKey = 'location_permission_granted';

  // Private constructor
  SharedPreferenceService._();

  // Singleton instance
  static Future<SharedPreferenceService> getInstance() async {
    if (_instance == null) {
      _instance = SharedPreferenceService._();
      await _instance!._init();
    }
    return _instance!;
  }

  // Initialize SharedPreferences
  Future<void> _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Check if SharedPreferences is initialized
  bool get isInitialized => _preferences != null;

  // Get location permission status
  bool? getLocationPermissionStatus() {
    return _preferences?.getBool(locationPermissionKey);
  }

  // Save location permission status
  Future<bool> saveLocationPermissionStatus(bool status) async {
    return await _preferences?.setBool(locationPermissionKey, status) ?? false;
  }

  // Clear all preferences
  Future<bool> clearAll() async {
    return await _preferences?.clear() ?? false;
  }
}
