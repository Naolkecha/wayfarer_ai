abstract class WeatherRepository {
  /// Get weather forecast for a location
  Future<Map<String, dynamic>> getWeatherForecast({
    required double latitude,
    required double longitude,
    required int days,
  });

  /// Get current weather
  Future<Map<String, dynamic>> getCurrentWeather({
    required double latitude,
    required double longitude,
  });
}

