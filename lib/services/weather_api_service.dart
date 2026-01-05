import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/weather_data.dart';

class WeatherApiService {
  // Open-Meteo API - FREE, no API key required!
  static const String _baseUrl = 'https://api.open-meteo.com/v1';
  static const String _geocodingUrl = 'https://geocoding-api.open-meteo.com/v1';

  /// Get weather data for a city
  Future<WeatherData> getWeatherByCity(String cityName) async {
    try {
      // Step 1: Get coordinates for the city
      final coordinates = await getCityCoordinates(cityName);
      if (coordinates == null) {
        throw Exception('City not found');
      }

      // Step 2: Get weather data using coordinates
      return await getWeatherByCoordinates(
        coordinates['lat']!,
        coordinates['lon']!,
        cityName,
      );
    } catch (e) {
      throw Exception('Failed to fetch weather: $e');
    }
  }

  /// Get weather data by coordinates
  Future<WeatherData> getWeatherByCoordinates(
    double latitude,
    double longitude,
    String locationName,
  ) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/forecast?'
        'latitude=$latitude&'
        'longitude=$longitude&'
        'current=temperature_2m,relative_humidity_2m,apparent_temperature,'
        'precipitation,weather_code,wind_speed_10m,wind_direction_10m&'
        'hourly=temperature_2m,weather_code&'
        'daily=temperature_2m_max,temperature_2m_min,weather_code,sunrise,sunset,uv_index_max&'
        'timezone=auto',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseWeatherData(data, locationName);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }

  /// Get hourly forecast
  Future<List<HourlyForecast>> getHourlyForecast(
    double latitude,
    double longitude,
  ) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/forecast?'
        'latitude=$latitude&'
        'longitude=$longitude&'
        'hourly=temperature_2m,weather_code&'
        'timezone=auto&'
        'forecast_days=1',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseHourlyForecast(data);
      } else {
        throw Exception('Failed to load hourly forecast');
      }
    } catch (e) {
      throw Exception('Error fetching hourly forecast: $e');
    }
  }

  /// Get daily forecast
  Future<List<DailyForecast>> getDailyForecast(
    double latitude,
    double longitude,
  ) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/forecast?'
        'latitude=$latitude&'
        'longitude=$longitude&'
        'daily=temperature_2m_max,temperature_2m_min,weather_code&'
        'timezone=auto',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseDailyForecast(data);
      } else {
        throw Exception('Failed to load daily forecast');
      }
    } catch (e) {
      throw Exception('Error fetching daily forecast: $e');
    }
  }

  /// Get city coordinates using geocoding
  Future<Map<String, double>?> getCityCoordinates(String cityName) async {
    try {
      final url = Uri.parse(
        '$_geocodingUrl/search?'
        'name=$cityName&'
        'count=1&'
        'language=en&'
        'format=json',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final result = data['results'][0];
          return {'lat': result['latitude'], 'lon': result['longitude']};
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get location name from coordinates (reverse geocoding)
  Future<String> getLocationName(double latitude, double longitude) async {
    try {
      // Round coordinates to reasonable precision for geocoding
      final lat = latitude.toStringAsFixed(4);
      final lon = longitude.toStringAsFixed(4);

      final url = Uri.parse(
        '$_geocodingUrl/search?'
        'latitude=$lat&'
        'longitude=$lon&'
        'count=1&'
        'language=en&'
        'format=json',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final result = data['results'][0];
          // Try to get the most specific name available
          return result['name'] ?? 'My Location';
        }
      }
      return 'My Location';
    } catch (e) {
      print('Error getting location name: $e');
      return 'My Location';
    }
  }

  /// Parse weather data from API response
  WeatherData _parseWeatherData(Map<String, dynamic> data, String location) {
    final current = data['current'];
    final daily = data['daily'];

    // Parse sunrise and sunset
    final sunriseStr = daily['sunrise'][0];
    final sunsetStr = daily['sunset'][0];
    final sunrise = DateTime.parse(sunriseStr);
    final sunset = DateTime.parse(sunsetStr);

    // Weather code to condition
    final weatherCode = current['weather_code'];
    final condition = _getConditionFromCode(weatherCode);

    // Wind direction
    final windDir = _getWindDirection(current['wind_direction_10m']);

    return WeatherData(
      location: location,
      temperature: current['temperature_2m'].toDouble(),
      feelsLike: current['apparent_temperature'].toDouble(),
      condition: condition,
      description: _getWeatherDescription(weatherCode),
      windSpeed: current['wind_speed_10m'].toDouble(),
      windDirection: windDir,
      windScale: _calculateWindScale(current['wind_speed_10m'].toDouble()),
      precipitation: current['precipitation'].toDouble(),
      precipitationChance: 20, // Open-Meteo doesn't provide this in free tier
      humidity: current['relative_humidity_2m'],
      airQuality: 50, // Not available in free tier
      airQualityLevel: 'Good',
      uvIndex: daily['uv_index_max'][0].toInt(),
      uvLevel: _getUVLevel(daily['uv_index_max'][0].toInt()),
      sunrise: sunrise,
      sunset: sunset,
      lifeIndexActivity: _getActivityIndex(
        current['temperature_2m'].toDouble(),
      ),
      lifeIndexClothing: _getClothingRecommendation(
        current['temperature_2m'].toDouble(),
      ),
    );
  }

  /// Parse hourly forecast
  List<HourlyForecast> _parseHourlyForecast(Map<String, dynamic> data) {
    final hourly = data['hourly'];
    final times = hourly['time'] as List;
    final temps = hourly['temperature_2m'] as List;
    final codes = hourly['weather_code'] as List;

    final List<HourlyForecast> forecasts = [];
    final now = DateTime.now();

    for (int i = 0; i < times.length && i < 24; i++) {
      final time = DateTime.parse(times[i]);
      if (time.isAfter(now)) {
        final weatherCode = codes[i];
        forecasts.add(
          HourlyForecast(
            time: time,
            temperature: temps[i].toDouble(),
            condition: _getConditionFromCode(weatherCode),
            icon: _getWeatherIcon(weatherCode),
          ),
        );

        if (forecasts.length >= 12) break; // Show next 12 hours
      }
    }

    return forecasts;
  }

  /// Parse daily forecast
  List<DailyForecast> _parseDailyForecast(Map<String, dynamic> data) {
    final daily = data['daily'];
    final dates = daily['time'] as List;
    final maxTemps = daily['temperature_2m_max'] as List;
    final minTemps = daily['temperature_2m_min'] as List;
    final codes = daily['weather_code'] as List;

    final List<DailyForecast> forecasts = [];

    for (int i = 0; i < dates.length && i < 7; i++) {
      final weatherCode = codes[i];
      forecasts.add(
        DailyForecast(
          date: DateTime.parse(dates[i]),
          highTemp: maxTemps[i].toDouble(),
          lowTemp: minTemps[i].toDouble(),
          condition: _getConditionFromCode(weatherCode),
          icon: _getWeatherIcon(weatherCode),
        ),
      );
    }

    return forecasts;
  }

  /// Convert WMO weather code to condition string
  String _getConditionFromCode(int code) {
    switch (code) {
      case 0:
        return 'Clear';
      case 1:
      case 2:
        return 'Partly Cloudy';
      case 3:
        return 'Cloudy';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rain';
      case 71:
      case 73:
      case 75:
        return 'Snow';
      case 77:
        return 'Snow Grains';
      case 80:
      case 81:
      case 82:
        return 'Rain Showers';
      case 85:
      case 86:
        return 'Snow Showers';
      case 95:
        return 'Thunderstorm';
      case 96:
      case 99:
        return 'Thunderstorm with Hail';
      default:
        return 'Fair';
    }
  }

  /// Get weather icon based on code
  IconData _getWeatherIcon(int code) {
    switch (code) {
      case 0:
        return Icons.wb_sunny;
      case 1:
      case 2:
        return Icons.wb_cloudy;
      case 3:
        return Icons.cloud;
      case 45:
      case 48:
        return Icons.foggy;
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
      case 80:
      case 81:
      case 82:
        return Icons.water_drop;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return Icons.ac_unit;
      case 95:
      case 96:
      case 99:
        return Icons.thunderstorm;
      default:
        return Icons.wb_sunny;
    }
  }

  /// Get weather description
  String _getWeatherDescription(int code) {
    switch (code) {
      case 0:
        return 'Clear sky';
      case 1:
        return 'Mainly clear';
      case 2:
        return 'Partly cloudy';
      case 3:
        return 'Overcast';
      case 45:
        return 'Fog';
      case 48:
        return 'Depositing rime fog';
      case 51:
        return 'Light drizzle';
      case 53:
        return 'Moderate drizzle';
      case 55:
        return 'Dense drizzle';
      case 61:
        return 'Slight rain';
      case 63:
        return 'Moderate rain';
      case 65:
        return 'Heavy rain';
      case 71:
        return 'Slight snow fall';
      case 73:
        return 'Moderate snow fall';
      case 75:
        return 'Heavy snow fall';
      case 77:
        return 'Snow grains';
      case 80:
        return 'Slight rain showers';
      case 81:
        return 'Moderate rain showers';
      case 82:
        return 'Violent rain showers';
      case 85:
        return 'Slight snow showers';
      case 86:
        return 'Heavy snow showers';
      case 95:
        return 'Thunderstorm';
      case 96:
      case 99:
        return 'Thunderstorm with hail';
      default:
        return 'Fair weather';
    }
  }

  /// Get wind direction from degrees
  String _getWindDirection(double degrees) {
    if (degrees >= 337.5 || degrees < 22.5) return 'N';
    if (degrees >= 22.5 && degrees < 67.5) return 'NE';
    if (degrees >= 67.5 && degrees < 112.5) return 'E';
    if (degrees >= 112.5 && degrees < 157.5) return 'SE';
    if (degrees >= 157.5 && degrees < 202.5) return 'S';
    if (degrees >= 202.5 && degrees < 247.5) return 'SW';
    if (degrees >= 247.5 && degrees < 292.5) return 'W';
    if (degrees >= 292.5 && degrees < 337.5) return 'NW';
    return 'N';
  }

  /// Calculate Beaufort wind scale
  int _calculateWindScale(double windSpeed) {
    // Wind speed in km/h to Beaufort scale
    if (windSpeed < 1) return 0;
    if (windSpeed < 6) return 1;
    if (windSpeed < 12) return 2;
    if (windSpeed < 20) return 3;
    if (windSpeed < 29) return 4;
    if (windSpeed < 39) return 5;
    if (windSpeed < 50) return 6;
    if (windSpeed < 62) return 7;
    if (windSpeed < 75) return 8;
    if (windSpeed < 89) return 9;
    if (windSpeed < 103) return 10;
    if (windSpeed < 118) return 11;
    return 12;
  }

  /// Get UV level description
  String _getUVLevel(int uvIndex) {
    if (uvIndex <= 2) return 'Low';
    if (uvIndex <= 5) return 'Moderate';
    if (uvIndex <= 7) return 'High';
    if (uvIndex <= 10) return 'Very High';
    return 'Extreme';
  }

  /// Get activity recommendation
  String _getActivityIndex(double temp) {
    if (temp < 0) return 'Too cold for outdoor activities';
    if (temp < 10) return 'Cool - dress warmly for activities';
    if (temp < 20) return 'Good for outdoor activities';
    if (temp < 30) return 'Perfect for exercise';
    return 'Hot - stay hydrated during activities';
  }

  /// Get clothing recommendation
  String _getClothingRecommendation(double temp) {
    if (temp < 0) return 'Heavy winter coat';
    if (temp < 10) return 'Warm jacket';
    if (temp < 15) return 'Light jacket';
    if (temp < 20) return 'Long sleeves';
    if (temp < 25) return 'T-shirt';
    return 'Light clothing';
  }
}
