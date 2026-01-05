import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_background.dart';
import '../widgets/city_card.dart';
import '../services/weather_api_service.dart';
import '../models/weather_data.dart';
import 'search_screen.dart';

class CityManagementScreen extends StatefulWidget {
  final List<String> savedCities;
  final Function(String) onCityAdded;
  final Function(String) onCityRemoved;

  const CityManagementScreen({
    super.key,
    required this.savedCities,
    required this.onCityAdded,
    required this.onCityRemoved,
  });

  @override
  State<CityManagementScreen> createState() => _CityManagementScreenState();
}

class _CityManagementScreenState extends State<CityManagementScreen> {
  final WeatherApiService _weatherService = WeatherApiService();
  List<CityWeather> cities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  Future<void> _loadCities() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<CityWeather> loadedCities = [];

      for (String cityName in widget.savedCities) {
        try {
          final weather = await _weatherService.getWeatherByCity(cityName);
          final coords = await _weatherService.getCityCoordinates(cityName);
          final daily = await _weatherService.getDailyForecast(
            coords?['lat'] ?? 23.8103,
            coords?['lon'] ?? 90.4125,
          );

          loadedCities.add(
            CityWeather(
              cityName: weather.location,
              subtitle: null,
              temperature: weather.temperature,
              highTemp: daily.isNotEmpty
                  ? daily[0].highTemp
                  : weather.temperature + 5,
              lowTemp: daily.isNotEmpty
                  ? daily[0].lowTemp
                  : weather.temperature - 5,
              condition: weather.condition,
              isCurrentLocation: false,
            ),
          );
        } catch (e) {
          print('Error loading $cityName: $e');
        }
      }

      setState(() {
        cities = loadedCities;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: AppTheme.spacing8),
                        Text(
                          'City Management',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(
                              onCitySelected: (cityName) {
                                widget.onCityAdded(cityName);
                                _loadCities();
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // City List or Loading
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryText,
                        ),
                      )
                    : cities.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_city_outlined,
                              size: 64,
                              color: AppTheme.tertiaryText,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No cities added yet',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap the + button to add cities',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing16,
                        ),
                        itemCount: cities.length,
                        itemBuilder: (context, index) {
                          final city = cities[index];
                          return CityCard(
                            cityName: city.cityName,
                            subtitle: city.subtitle,
                            temperature: '${city.temperature.toInt()}',
                            condition: city.condition,
                            tempRange:
                                '${city.highTemp.toInt()}°/${city.lowTemp.toInt()}°',
                            isCurrentLocation: city.isCurrentLocation,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            onDelete: () {
                              widget.onCityRemoved(city.cityName);
                              _loadCities();
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
