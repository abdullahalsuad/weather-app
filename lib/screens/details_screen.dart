import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/weather_metric_card.dart';
import '../utils/mock_data.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weather = MockData.getCurrentWeather();

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverToBoxAdapter(
                child: Padding(
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
                            '${weather.location} ${weather.temperature.toInt()}°',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings_outlined),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Weather Metrics Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing16,
                ),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppTheme.spacing12,
                    mainAxisSpacing: AppTheme.spacing12,
                    childAspectRatio: 1.1,
                  ),
                  delegate: SliverChildListDelegate([
                    // Precipitation
                    WeatherMetricCard(
                      icon: Icons.water_drop_outlined,
                      title: 'Precipitation',
                      value: weather.precipitation.toStringAsFixed(1),
                      unit: 'mm | ${weather.precipitationChance}%',
                      description: 'Currently no precipitation',
                    ),

                    // Wind
                    WeatherMetricCard(
                      icon: Icons.air,
                      title: 'Wind',
                      value: weather.windScale.toString(),
                      unit:
                          '${weather.windDirection} | ${weather.windSpeed} km/h',
                      description: 'The breeze make you feel comfortable.',
                    ),

                    // Air Quality
                    WeatherMetricCard(
                      icon: Icons.masks_outlined,
                      title: 'Air Quality',
                      value: weather.airQuality.toString(),
                      unit: '| ${weather.airQualityLevel}',
                      description: 'Please wear a face mask.',
                    ),

                    // UV Index
                    WeatherMetricCard(
                      icon: Icons.wb_sunny_outlined,
                      title: 'UV Index',
                      value: weather.uvIndex.toString(),
                      unit: '| ${weather.uvLevel}',
                      description: 'The current UV light is weak.',
                    ),

                    // Humidity
                    WeatherMetricCard(
                      icon: Icons.water_drop,
                      title: 'Humidity',
                      value: '${weather.humidity}',
                      unit: '%',
                      description:
                          'Moderate humidity in the current environment.',
                    ),

                    // Sun Times
                    WeatherMetricCard(
                      icon: Icons.wb_twilight,
                      title: 'Sun',
                      value: '',
                      customContent: SunArcWidget(
                        sunrise: weather.sunrise,
                        sunset: weather.sunset,
                      ),
                    ),
                  ]),
                ),
              ),

              // Life Index Section
              const SliverToBoxAdapter(
                child: SizedBox(height: AppTheme.spacing16),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing16,
                  ),
                  child: GlassCard(
                    padding: const EdgeInsets.all(AppTheme.spacing16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.favorite_outline,
                              size: 20,
                              color: AppTheme.iconColor,
                            ),
                            const SizedBox(width: AppTheme.spacing8),
                            Text(
                              'Life Index',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacing20),

                        Row(
                          children: [
                            Expanded(
                              child: _buildLifeIndexItem(
                                context,
                                Icons.sports_basketball,
                                weather.lifeIndexActivity,
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacing16),
                            Expanded(
                              child: _buildLifeIndexItem(
                                context,
                                Icons.checkroom,
                                weather.lifeIndexClothing,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppTheme.spacing24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLifeIndexItem(BuildContext context, IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            border: Border.all(color: AppTheme.cardBorder),
          ),
          child: Icon(icon, size: 32, color: AppTheme.iconColor),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class SunArcWidget extends StatelessWidget {
  final DateTime sunrise;
  final DateTime sunset;

  const SunArcWidget({super.key, required this.sunrise, required this.sunset});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final sunriseMinutes = sunrise.hour * 60 + sunrise.minute;
    final sunsetMinutes = sunset.hour * 60 + sunset.minute;
    final currentMinutes = now.hour * 60 + now.minute;

    double progress = 0.0;
    if (currentMinutes >= sunriseMinutes && currentMinutes <= sunsetMinutes) {
      progress =
          (currentMinutes - sunriseMinutes) / (sunsetMinutes - sunriseMinutes);
    }

    return Column(
      children: [
        SizedBox(
          height: 80,
          child: CustomPaint(
            painter: SunArcPainter(progress: progress),
            child: Container(),
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('HH:mm').format(sunrise),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text('AM', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat('HH:mm').format(sunset),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text('PM', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class SunArcPainter extends CustomPainter {
  final double progress;

  SunArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    // Draw arc background
    final arcPaint = Paint()
      ..color = AppTheme.secondaryText.withOpacity(0.2)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      arcPaint,
    );

    // Draw progress arc
    final progressPaint = Paint()
      ..color = AppTheme.accentPurple
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi * progress,
      false,
      progressPaint,
    );

    // Draw sun icon
    if (progress > 0 && progress < 1) {
      final angle = math.pi + (math.pi * progress);
      final sunX = center.dx + radius * math.cos(angle);
      final sunY = center.dy + radius * math.sin(angle);

      final sunPaint = Paint()
        ..color = Colors.amber
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(sunX, sunY), 8, sunPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
