import 'package:flutter/material.dart';
import '../models/weather_data.dart';

class MockData {
  static WeatherData getCurrentWeather() {
    final now = DateTime.now();
    return WeatherData(
      location: 'Uttara',
      temperature: 15,
      feelsLike: 13,
      condition: 'Fair',
      description: 'Northwest wind scale 2',
      windSpeed: 11.2,
      windDirection: 'NNW',
      windScale: 2,
      precipitation: 0.0,
      precipitationChance: 20,
      humidity: 51,
      airQuality: 194,
      airQualityLevel: 'Moderate pollution',
      uvIndex: 4,
      uvLevel: 'Weak',
      sunrise: DateTime(now.year, now.month, now.day, 6, 42),
      sunset: DateTime(now.year, now.month, now.day, 17, 25),
      lifeIndexActivity: 'Very comfortable for exercise',
      lifeIndexClothing: 'Shirt',
    );
  }

  static List<HourlyForecast> getHourlyForecast() {
    final now = DateTime.now();
    return [
      HourlyForecast(
        time: DateTime(now.year, now.month, now.day, 6, 0),
        temperature: 13,
        condition: 'Fair',
        icon: Icons.nightlight_round,
      ),
      HourlyForecast(
        time: DateTime(now.year, now.month, now.day, 7, 0),
        temperature: 13,
        condition: 'Fair',
        icon: Icons.wb_sunny,
      ),
      HourlyForecast(
        time: DateTime(now.year, now.month, now.day, 8, 0),
        temperature: 14,
        condition: 'Fair',
        icon: Icons.wb_sunny,
      ),
      HourlyForecast(
        time: DateTime(now.year, now.month, now.day, 9, 0),
        temperature: 15,
        condition: 'Fair',
        icon: Icons.wb_sunny,
      ),
      HourlyForecast(
        time: DateTime(now.year, now.month, now.day, 10, 0),
        temperature: 17,
        condition: 'Fair',
        icon: Icons.wb_sunny,
      ),
    ];
  }

  static List<DailyForecast> getDailyForecast() {
    final now = DateTime.now();
    return [
      DailyForecast(
        date: now,
        highTemp: 21,
        lowTemp: 12,
        condition: 'Fair',
        icon: Icons.wb_sunny,
      ),
      DailyForecast(
        date: now.add(const Duration(days: 1)),
        highTemp: 21,
        lowTemp: 13,
        condition: 'Mostly sunny',
        icon: Icons.wb_cloudy,
      ),
      DailyForecast(
        date: now.add(const Duration(days: 2)),
        highTemp: 22,
        lowTemp: 13,
        condition: 'Mostly sunny',
        icon: Icons.wb_cloudy,
      ),
      DailyForecast(
        date: now.add(const Duration(days: 3)),
        highTemp: 24,
        lowTemp: 14,
        condition: 'Mostly sunny',
        icon: Icons.wb_cloudy,
      ),
      DailyForecast(
        date: now.add(const Duration(days: 4)),
        highTemp: 25,
        lowTemp: 14,
        condition: 'Mostly sunny',
        icon: Icons.wb_cloudy,
      ),
    ];
  }

  static List<CityWeather> getSavedCities() {
    return [
      CityWeather(
        cityName: 'Uttara',
        subtitle: 'My Location',
        temperature: 15,
        highTemp: 21,
        lowTemp: 12,
        condition: 'Fair',
        isCurrentLocation: true,
      ),
      CityWeather(
        cityName: 'Mymensingh',
        temperature: 14,
        highTemp: 21,
        lowTemp: 10,
        condition: 'Fair',
      ),
      CityWeather(
        cityName: 'Chandpur',
        temperature: 15,
        highTemp: 22,
        lowTemp: 12,
        condition: 'Fair',
      ),
    ];
  }

  static List<String> getTopCities() {
    return [
      'Uttara',
      'New York',
      'Los Angeles County',
      'Houston County',
      'Miami County',
      'Austin County',
    ];
  }
}
