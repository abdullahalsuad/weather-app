import 'package:flutter/material.dart';

class WeatherIcons {
  static IconData getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
      case 'sunny':
      case 'fair':
        return Icons.wb_sunny;
      case 'cloudy':
      case 'mostly sunny':
        return Icons.wb_cloudy;
      case 'partly cloudy':
        return Icons.cloud;
      case 'rain':
      case 'rainy':
        return Icons.umbrella;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'night':
      case 'clear night':
        return Icons.nightlight_round;
      default:
        return Icons.wb_sunny;
    }
  }

  static IconData getTimeIcon(int hour) {
    if (hour >= 6 && hour < 18) {
      return Icons.wb_sunny;
    } else {
      return Icons.nightlight_round;
    }
  }
}
