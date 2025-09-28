import 'dart:io';

class GoogleMapsConfig {
  // TODO: Replace with your actual Google Maps API key
  // To get an API key:
  // 1. Go to https://console.developers.google.com/
  // 2. Create a new project or select existing one
  // 3. Enable "Directions API" and "Maps SDK for Android/iOS"
  // 4. Create credentials (API Key)
  // 5. Restrict the API key to your app's package name for security

  static String apiKey = Platform.isAndroid
      ? "AIzaSyDVTlHQCpgj5-UZk-iRooJ61sk4m0fLJjU"
      : "AIzaSyDAuH4p3ZMMccFuxdvhTQoEZMJZUPkvEY0";

  // Check if API key is configured
  static bool get isConfigured => apiKey.isNotEmpty;
}
