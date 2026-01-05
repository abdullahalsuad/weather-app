import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/forecast_card.dart';
import '../widgets/hourly_forecast_item.dart';
import '../services/weather_api_service.dart';
import 'details_screen.dart';
import 'city_management_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final WeatherApiService _weatherService = WeatherApiService();

  // Multiple cities data
  List<Map<String, dynamic>> cities = [];
  List<String> savedCityNames = []; // Cities added by user
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final List<Map<String, dynamic>> citiesData = [];

      // Try to get user location first (this is always the first page)
      try {
        final position = await _getCurrentLocation();
        if (position != null) {
          // Get location name from coordinates using reverse geocoding
          String locationName = await _weatherService.getLocationName(
            position.latitude,
            position.longitude,
          );

          final userWeather = await _weatherService.getWeatherByCoordinates(
            position.latitude,
            position.longitude,
            locationName,
          );
          final hourlyForecast = await _weatherService.getHourlyForecast(
            position.latitude,
            position.longitude,
          );
          final dailyForecast = await _weatherService.getDailyForecast(
            position.latitude,
            position.longitude,
          );

          citiesData.add({
            'location': locationName,
            'weather': userWeather,
            'hourly': hourlyForecast,
            'daily': dailyForecast,
            'isUserLocation': true,
          });
        }
      } catch (e) {
        print('Failed to get user location: $e');
        // Continue without user location if it fails
      }

      // Load saved cities that user has added
      for (String cityName in savedCityNames) {
        try {
          final weatherData = await _weatherService.getWeatherByCity(cityName);
          final coords = await _weatherService.getCityCoordinates(cityName);

          final hourlyForecast = await _weatherService.getHourlyForecast(
            coords?['lat'] ?? 23.8103,
            coords?['lon'] ?? 90.4125,
          );
          final dailyForecast = await _weatherService.getDailyForecast(
            coords?['lat'] ?? 23.8103,
            coords?['lon'] ?? 90.4125,
          );

          citiesData.add({
            'location': cityName,
            'weather': weatherData,
            'hourly': hourlyForecast,
            'daily': dailyForecast,
            'isUserLocation': false,
          });
        } catch (e) {
          print('Error loading weather for $cityName: $e');
        }
      }

      // If no cities loaded at all, show error
      if (citiesData.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Unable to load weather data. Please check your internet connection.';
        });
        return;
      }

      setState(() {
        cities = citiesData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load weather data: $e';
      });
    }
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  void _addCity(String cityName) {
    if (!savedCityNames.contains(cityName)) {
      setState(() {
        savedCityNames.add(cityName);
      });
      _loadWeatherData();
    }
  }

  void _removeCity(String cityName) {
    setState(() {
      savedCityNames.remove(cityName);
    });
    _loadWeatherData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryText),
              )
            : _errorMessage != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppTheme.iconColor,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        _errorMessage!,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _loadWeatherData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : cities.isEmpty
            ? const Center(child: Text('No cities loaded'))
            : ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    final cityData = cities[index];
                    final weather = cityData['weather'];
                    final hourlyForecast = cityData['hourly'];
                    final dailyForecast = cityData['daily'];

                    return SafeArea(
                      child: CustomScrollView(
                        slivers: [
                          // App Bar with Page Indicators
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(AppTheme.spacing16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          // Show location icon for user's current location
                                          if (cityData['isUserLocation'] ==
                                              true)
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                right: AppTheme.spacing8,
                                              ),
                                              child: Icon(
                                                Icons.my_location,
                                                size: 20,
                                                color: AppTheme.iconColor,
                                              ),
                                            ),
                                          Text(
                                            cityData['location'],
                                            style: Theme.of(
                                              context,
                                            ).textTheme.headlineMedium,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppTheme.spacing4),
                                      // Page Indicator Dots - only show if multiple locations
                                      if (cities.length > 1)
                                        Row(
                                          children: List<Widget>.generate(
                                            cities.length,
                                            (dotIndex) => Container(
                                              width: dotIndex == _currentPage
                                                  ? 8
                                                  : 4,
                                              height: 4,
                                              margin: const EdgeInsets.only(
                                                right: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: dotIndex == _currentPage
                                                    ? AppTheme.primaryText
                                                    : AppTheme.tertiaryText
                                                          .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.my_location),
                                        onPressed: _loadWeatherData,
                                        tooltip: 'Refresh location',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.menu),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CityManagementScreen(
                                                    savedCities: savedCityNames,
                                                    onCityAdded: _addCity,
                                                    onCityRemoved: _removeCity,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Main Temperature Display
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacing16,
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: AppTheme.spacing32),
                                  Text(
                                    '${weather.temperature.toInt()}°',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.displayLarge,
                                  ),
                                  const SizedBox(height: AppTheme.spacing16),
                                  Text(
                                    weather.condition,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineSmall,
                                  ),
                                  const SizedBox(height: AppTheme.spacing8),
                                  Text(
                                    'Feels like ${weather.feelsLike.toInt()}°  ${weather.description}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: AppTheme.spacing40),
                                ],
                              ),
                            ),
                          ),

                          // Next 72 Hours Section
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacing16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GlassCard(
                                    padding: const EdgeInsets.all(
                                      AppTheme.spacing16,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.access_time,
                                              size: 20,
                                              color: AppTheme.iconColor,
                                            ),
                                            const SizedBox(
                                              width: AppTheme.spacing8,
                                            ),
                                            Text(
                                              'Next 72 Hours',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: AppTheme.spacing20,
                                        ),

                                        // Forecast Cards
                                        if (dailyForecast.isNotEmpty)
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                ForecastCard(
                                                  day: 'Today',
                                                  highTemp:
                                                      '${dailyForecast[0].highTemp.toInt()}°',
                                                  lowTemp:
                                                      '${dailyForecast[0].lowTemp.toInt()}°',
                                                  condition: dailyForecast[0]
                                                      .condition,
                                                  icon: dailyForecast[0].icon,
                                                ),
                                                const SizedBox(
                                                  width: AppTheme.spacing12,
                                                ),
                                                if (dailyForecast.length > 1)
                                                  ForecastCard(
                                                    day: 'Tomorrow',
                                                    highTemp:
                                                        '${dailyForecast[1].highTemp.toInt()}°',
                                                    lowTemp:
                                                        '${dailyForecast[1].lowTemp.toInt()}°',
                                                    condition: dailyForecast[1]
                                                        .condition,
                                                    icon: dailyForecast[1].icon,
                                                  ),
                                                const SizedBox(
                                                  width: AppTheme.spacing12,
                                                ),
                                                if (dailyForecast.length > 2)
                                                  ForecastCard(
                                                    day: DateFormat('E').format(
                                                      dailyForecast[2].date,
                                                    ),
                                                    highTemp:
                                                        '${dailyForecast[2].highTemp.toInt()}°',
                                                    lowTemp:
                                                        '${dailyForecast[2].lowTemp.toInt()}°',
                                                    condition: dailyForecast[2]
                                                        .condition,
                                                    icon: dailyForecast[2].icon,
                                                  ),
                                              ],
                                            ),
                                          ),

                                        const SizedBox(
                                          height: AppTheme.spacing24,
                                        ),

                                        // Temperature Chart
                                        SizedBox(
                                          height: 100,
                                          child: CustomPaint(
                                            painter: TemperatureChartPainter(),
                                            child: Container(),
                                          ),
                                        ),

                                        const SizedBox(
                                          height: AppTheme.spacing16,
                                        ),

                                        // Hourly Forecast
                                        if (hourlyForecast.isNotEmpty)
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: hourlyForecast.map<Widget>((
                                                forecast,
                                              ) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right:
                                                            AppTheme.spacing12,
                                                      ),
                                                  child: HourlyForecastItem(
                                                    time: DateFormat(
                                                      'h:mm a',
                                                    ).format(forecast.time),
                                                    temperature:
                                                        '${forecast.temperature.toInt()}°',
                                                    condition:
                                                        forecast.condition,
                                                    icon: forecast.icon,
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: AppTheme.spacing24),
                                ],
                              ),
                            ),
                          ),

                          // Next 7 Days Section
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacing16,
                              ),
                              child: GlassCard(
                                padding: const EdgeInsets.all(
                                  AppTheme.spacing16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 20,
                                          color: AppTheme.iconColor,
                                        ),
                                        const SizedBox(
                                          width: AppTheme.spacing8,
                                        ),
                                        Text(
                                          'Next 7 Day(s)',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: AppTheme.spacing20),

                                    // 7-Day Forecast
                                    if (dailyForecast.isNotEmpty)
                                      SizedBox(
                                        height: 150,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: dailyForecast.length,
                                          itemBuilder: (context, index) {
                                            final day = dailyForecast[index];
                                            return Container(
                                              width: 120,
                                              margin: EdgeInsets.only(
                                                right:
                                                    index <
                                                        dailyForecast.length - 1
                                                    ? AppTheme.spacing12
                                                    : 0,
                                              ),
                                              padding: const EdgeInsets.all(
                                                AppTheme.spacing12,
                                              ),
                                              decoration: BoxDecoration(
                                                // Darker glass background
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    const Color(
                                                      0xFF5B6B9E,
                                                    ).withOpacity(0.65),
                                                    const Color(
                                                      0xFF4A5A8A,
                                                    ).withOpacity(0.55),
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      AppTheme.radiusMedium,
                                                    ),
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.2),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const SizedBox(height: 4),
                                                  Icon(
                                                    _getWeatherIcon(
                                                      day.condition,
                                                    ),
                                                    size: 32,
                                                    color: Colors.white,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 4,
                                                        ),
                                                    child: Text(
                                                      day.condition,
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        height: 1.2,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Text(
                                                    DateFormat(
                                                      'M/d',
                                                    ).format(day.date),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${day.highTemp.toInt()}°',
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Text(
                                                        '/',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white
                                                              .withOpacity(0.5),
                                                        ),
                                                      ),
                                                      Text(
                                                        '${day.lowTemp.toInt()}°',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white
                                                              .withOpacity(0.7),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    const SizedBox(height: AppTheme.spacing16),

                                    // View More Details Button
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailsScreen(weather: weather),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Display More',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyLarge,
                                          ),
                                          const Icon(
                                            Icons.chevron_right,
                                            color: AppTheme.iconColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Spacing at bottom
                          const SliverToBoxAdapter(
                            child: SizedBox(height: AppTheme.spacing24),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    if (condition.toLowerCase().contains('clear') ||
        condition.toLowerCase().contains('fair') ||
        condition.toLowerCase().contains('sunny')) {
      return Icons.wb_sunny;
    } else if (condition.toLowerCase().contains('cloud')) {
      return Icons.wb_cloudy;
    } else if (condition.toLowerCase().contains('rain')) {
      return Icons.grain;
    } else if (condition.toLowerCase().contains('snow')) {
      return Icons.ac_unit;
    }
    return Icons.wb_sunny;
  }
}

// Temperature Chart Painter
class TemperatureChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accentBlue.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppTheme.accentBlue.withOpacity(0.3),
          AppTheme.accentBlue.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final fillPath = Path();

    // Mock temperature data points
    final points = [
      Offset(0, size.height * 0.5),
      Offset(size.width * 0.25, size.height * 0.5),
      Offset(size.width * 0.5, size.height * 0.4),
      Offset(size.width * 0.75, size.height * 0.3),
      Offset(size.width, size.height * 0.2),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    fillPath.moveTo(points[0].dx, size.height);
    fillPath.lineTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
      fillPath.lineTo(points[i].dx, points[i].dy);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = AppTheme.primaryText
      ..style = PaintingStyle.fill;

    for (var point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
