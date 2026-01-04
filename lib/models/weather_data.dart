import 'package:flutter/material.dart';

class WeatherData {
  final String location;
  final double temperature;
  final double feelsLike;
  final String condition;
  final String description;
  final double windSpeed;
  final String windDirection;
  final int windScale;
  final double precipitation;
  final int precipitationChance;
  final int humidity;
  final int airQuality;
  final String airQualityLevel;
  final int uvIndex;
  final String uvLevel;
  final DateTime sunrise;
  final DateTime sunset;
  final String lifeIndexActivity;
  final String lifeIndexClothing;

  WeatherData({
    required this.location,
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.description,
    required this.windSpeed,
    required this.windDirection,
    required this.windScale,
    required this.precipitation,
    required this.precipitationChance,
    required this.humidity,
    required this.airQuality,
    required this.airQualityLevel,
    required this.uvIndex,
    required this.uvLevel,
    required this.sunrise,
    required this.sunset,
    required this.lifeIndexActivity,
    required this.lifeIndexClothing,
  });
}

class HourlyForecast {
  final DateTime time;
  final double temperature;
  final String condition;
  final IconData icon;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.condition,
    required this.icon,
  });
}

class DailyForecast {
  final DateTime date;
  final double highTemp;
  final double lowTemp;
  final String condition;
  final IconData icon;

  DailyForecast({
    required this.date,
    required this.highTemp,
    required this.lowTemp,
    required this.condition,
    required this.icon,
  });
}

class CityWeather {
  final String cityName;
  final String? subtitle;
  final double temperature;
  final double highTemp;
  final double lowTemp;
  final String condition;
  final bool isCurrentLocation;

  CityWeather({
    required this.cityName,
    this.subtitle,
    required this.temperature,
    required this.highTemp,
    required this.lowTemp,
    required this.condition,
    this.isCurrentLocation = false,
  });
}
