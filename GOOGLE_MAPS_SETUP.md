# Live Driver Tracking Setup Guide

## Google Maps API Configuration

To enable proper road-based routing for the live driver tracking feature, you need to configure Google Maps API:

### 1. Get Google Maps API Key

1. Go to [Google Cloud Console](https://console.developers.google.com/)
2. Create a new project or select an existing one
3. Enable the following APIs:
   - **Directions API** (for route calculation)
   - **Maps SDK for Android** (for Android maps)
   - **Maps SDK for iOS** (for iOS maps)

4. Create credentials:
   - Go to "Credentials" → "Create Credentials" → "API Key"
   - Copy the generated API key

### 2. Configure API Key in the App

1. Open `lib/config/google_maps_config.dart`
2. Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API key:

```dart
static const String apiKey = 'your_actual_api_key_here';
```

### 3. Secure Your API Key (Recommended)

For production apps, restrict your API key:

1. In Google Cloud Console, go to "Credentials"
2. Click on your API key
3. Under "Application restrictions":
   - For Android: Select "Android apps" and add your package name and SHA-1 certificate fingerprint
   - For iOS: Select "iOS apps" and add your bundle identifier

4. Under "API restrictions":
   - Select "Restrict key"
   - Choose only the APIs you need (Directions API, Maps SDK)

### 4. Alternative: Environment Variables (More Secure)

For better security, you can use environment variables or build-time configuration:

1. Add to your `.env` file (create if doesn't exist):
```
GOOGLE_MAPS_API_KEY=your_actual_api_key_here
```

2. Modify `google_maps_config.dart` to read from environment:
```dart
static const String apiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY', 
                                                    defaultValue: 'YOUR_GOOGLE_MAPS_API_KEY_HERE');
```

3. Build your app with:
```bash
flutter build --dart-define=GOOGLE_MAPS_API_KEY=your_actual_api_key_here
```

## Features Enabled

With proper API configuration, the live tracking will show:

✅ **Real road-based routes** instead of straight lines  
✅ **Turn-by-turn polylines** following actual roads  
✅ **Distance and duration estimates** from Google Directions  
✅ **Optimized route updates** (only when driver moves significantly)  
✅ **Fallback to straight lines** if API fails or is not configured  

## Testing

1. **Without API Key**: The app will show straight lines with a fallback message in logs
2. **With API Key**: The app will show proper road-based routes with distance/duration info

## Troubleshooting

- **Straight lines instead of roads**: Check if API key is properly configured
- **No route updates**: Check API quotas and billing in Google Cloud Console
- **API errors**: Check logs for specific error messages from Google Directions API

## Cost Considerations

- Google Directions API has usage limits and costs
- Consider implementing request caching and rate limiting for production
- Monitor usage in Google Cloud Console to avoid unexpected charges
