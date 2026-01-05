import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_background.dart';
import '../widgets/weather_metric_card.dart';
import '../models/weather_data.dart';

class DetailsScreen extends StatelessWidget {
  final WeatherData weather;

  const DetailsScreen({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Enhanced App Bar with Glassmorphic Effect
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(AppTheme.spacing16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing12,
                    vertical: AppTheme.spacing8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    border: Border.all(color: AppTheme.cardBorder, width: 1),
                    boxShadow: AppTheme.subtleShadow,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Column(
                        children: [
                          Text(
                            weather.location,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            weather.condition,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert, size: 20),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),

              // Temperature Hero Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing16,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: AppTheme.spacing8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${weather.temperature.toInt()}',
                            style: Theme.of(context).textTheme.displayLarge
                                ?.copyWith(
                                  fontSize: 88,
                                  fontWeight: FontWeight.w200,
                                  letterSpacing: -4,
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              '°C',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacing16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing16,
                          vertical: AppTheme.spacing8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.accentBlue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusMedium,
                          ),
                          border: Border.all(
                            color: AppTheme.accentBlue.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          'Feels like ${weather.feelsLike.toInt()}° • ${weather.description}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing32),
                    ],
                  ),
                ),
              ),

              // Section Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing20,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppTheme.accentBlue,
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusSmall,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacing12),
                      Text(
                        'Weather Details',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppTheme.spacing20),
              ),

              // Weather Metrics List (Mobile-Friendly)
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing16,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(<Widget>[
                    // Row 1: Precipitation + Wind
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 200,
                            child: WeatherMetricCard(
                              icon: Icons.water_drop_outlined,
                              title: 'Precipitation',
                              value: weather.precipitation.toStringAsFixed(1),
                              unit: 'mm | ${weather.precipitationChance}%',
                              description: 'Currently no precipitation',
                            ),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacing12),
                        Expanded(
                          child: SizedBox(
                            height: 200,
                            child: WeatherMetricCard(
                              icon: Icons.air,
                              title: 'Wind',
                              value: weather.windScale.toString(),
                              unit:
                                  '${weather.windDirection} | ${weather.windSpeed} km/h',
                              description:
                                  'The breeze make you feel comfortable.',
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppTheme.spacing12),

                    // Row 2: Air Quality + UV Index
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 200,
                            child: WeatherMetricCard(
                              icon: Icons.masks_outlined,
                              title: 'Air Quality',
                              value: weather.airQuality.toString(),
                              unit: '| ${weather.airQualityLevel}',
                              description: 'Please wear a face mask.',
                            ),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacing12),
                        Expanded(
                          child: SizedBox(
                            height: 200,
                            child: WeatherMetricCard(
                              icon: Icons.wb_sunny_outlined,
                              title: 'UV Index',
                              value: weather.uvIndex.toString(),
                              unit: '| ${weather.uvLevel}',
                              description: 'The current UV light is weak.',
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppTheme.spacing12),

                    // Row 3: Humidity + Sun
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 200,
                            child: WeatherMetricCard(
                              icon: Icons.water_drop,
                              title: 'Humidity',
                              value: '${weather.humidity}',
                              unit: '%',
                              description:
                                  'Moderate humidity in the current environment.',
                            ),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacing12),
                        Expanded(
                          child: SizedBox(
                            height: 200,
                            child: WeatherMetricCard(
                              icon: Icons.wb_twilight,
                              title: 'Sun',
                              value: '',
                              customContent: SunArcWidget(
                                sunrise: weather.sunrise,
                                sunset: weather.sunset,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
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

    final dayLength = sunsetMinutes - sunriseMinutes;
    final hours = dayLength ~/ 60;
    final minutes = dayLength % 60;

    return Column(
      children: [
        SizedBox(
          height: 100,
          child: CustomPaint(
            painter: SunArcPainter(progress: progress),
            child: Container(),
          ),
        ),
        const SizedBox(height: AppTheme.spacing12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.accentBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.wb_sunny,
                    size: 14,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(sunrise),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Sunrise',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing12,
                vertical: AppTheme.spacing4,
              ),
              decoration: BoxDecoration(
                color: AppTheme.accentBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Text(
                '${hours}h ${minutes}m',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(sunset),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Sunset',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(width: AppTheme.spacing8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.accentBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.wb_twilight,
                    size: 14,
                    color: Colors.deepOrange,
                  ),
                ),
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
    final center = Offset(size.width / 2, size.height - 10);
    final radius = size.width / 2.2;

    // Draw arc background
    final arcPaint = Paint()
      ..color = AppTheme.secondaryText.withOpacity(0.15)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      arcPaint,
    );

    // Draw progress arc with gradient effect
    if (progress > 0) {
      final progressPaint = Paint()
        ..shader = LinearGradient(
          colors: [AppTheme.accentBlue, AppTheme.accentBlue.withOpacity(0.6)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        math.pi,
        math.pi * progress,
        false,
        progressPaint,
      );
    }

    // Draw sun icon with glow effect
    if (progress > 0 && progress < 1) {
      final angle = math.pi + (math.pi * progress);
      final sunX = center.dx + radius * math.cos(angle);
      final sunY = center.dy + radius * math.sin(angle);

      // Glow effect
      final glowPaint = Paint()
        ..color = Colors.amber.withOpacity(0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(Offset(sunX, sunY), 14, glowPaint);

      // Sun outer ring
      final outerRingPaint = Paint()
        ..color = Colors.amber.withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(Offset(sunX, sunY), 12, outerRingPaint);

      // Sun
      final sunPaint = Paint()
        ..shader = RadialGradient(
          colors: [Colors.amber.shade100, Colors.amber],
        ).createShader(Rect.fromCircle(center: Offset(sunX, sunY), radius: 10))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(sunX, sunY), 10, sunPaint);
    } else if (progress == 0) {
      // Sunrise indicator
      final sunriseX = center.dx + radius * math.cos(math.pi);
      final sunriseY = center.dy + radius * math.sin(math.pi);

      final markerPaint = Paint()
        ..color = AppTheme.accentBlue
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(sunriseX, sunriseY), 6, markerPaint);
    } else if (progress >= 1) {
      // Sunset indicator
      final sunsetX = center.dx + radius * math.cos(2 * math.pi);
      final sunsetY = center.dy + radius * math.sin(2 * math.pi);

      final markerPaint = Paint()
        ..color = Colors.deepOrange
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(sunsetX, sunsetY), 6, markerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
