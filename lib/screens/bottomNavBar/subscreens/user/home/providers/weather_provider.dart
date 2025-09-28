import 'package:riverpod_annotation/riverpod_annotation.dart';
// part 'weather_provider.g.dart';

class WeatherData {
  final int precipitation;
  final int windSpeed;
  final int humidity;
  final int pressure;

  WeatherData({
    required this.precipitation,
    required this.windSpeed,
    required this.humidity,
    required this.pressure,
  });
}

// @riverpod
// WeatherData weatherData(WeatherDataRef ref) {
//   // Simulated dummy data
//   return WeatherData(
//     precipitation: 34,
//     windSpeed: 2,
//     humidity: 74,
//     pressure: 840,
//   );
// }
