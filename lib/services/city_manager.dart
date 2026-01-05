import 'package:flutter/material.dart';
import '../services/weather_api_service.dart';

/// Manages the list of cities dynamically
class CityManager extends ChangeNotifier {
  final WeatherApiService _weatherService = WeatherApiService();

  // List of city names
  List<String> _cityNames = ['Uttara', 'Dhaka', 'Chittagong'];

  // Weather data cache
  Map<String, dynamic> _citiesData = {};

  bool _isLoading = false;
  String? _error;

  List<String> get cityNames => _cityNames;
  Map<String, dynamic> get citiesData => _citiesData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Add a new city
  Future<bool> addCity(String cityName) async {
    if (_cityNames.contains(cityName)) {
      _error = 'City already exists';
      notifyListeners();
      return false;
    }

    try {
      // Validate city exists by fetching weather
      await _weatherService.getWeatherByCity(cityName);
      _cityNames.add(cityName);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'City not found: $e';
      notifyListeners();
      return false;
    }
  }

  /// Remove a city
  void removeCity(String cityName) {
    _cityNames.remove(cityName);
    _citiesData.remove(cityName);
    notifyListeners();
  }

  /// Load weather data for all cities
  Future<void> loadAllCitiesWeather() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final Map<String, dynamic> newData = {};

      for (String cityName in _cityNames) {
        try {
          final weather = await _weatherService.getWeatherByCity(cityName);
          final hourly = await _weatherService.getHourlyForecast(
            23.8103,
            90.4125,
          );
          final daily = await _weatherService.getDailyForecast(
            23.8103,
            90.4125,
          );

          newData[cityName] = {
            'location': cityName,
            'weather': weather,
            'hourly': hourly,
            'daily': daily,
          };
        } catch (e) {
          print('Error loading $cityName: $e');
        }
      }

      _citiesData = newData;
      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load weather data';
      notifyListeners();
    }
  }

  /// Get cities as list for display
  List<Map<String, dynamic>> getCitiesAsList() {
    return _cityNames.map((cityName) {
      return (_citiesData[cityName] ??
              {
                'location': cityName,
                'weather': null,
                'hourly': [],
                'daily': [],
              })
          as Map<String, dynamic>;
    }).toList();
  }
}
