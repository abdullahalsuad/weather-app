import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/forecast_card.dart';
import '../widgets/hourly_forecast_item.dart';
import '../utils/mock_data.dart';
import 'details_screen.dart';
import 'city_management_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weather = MockData.getCurrentWeather();
    final hourlyForecast = MockData.getHourlyForecast();
    final dailyForecast = MockData.getDailyForecast();

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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            weather.location,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: AppTheme.spacing4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: AppTheme.accentPurple,
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: AppTheme.secondaryText,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: AppTheme.tertiaryText,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CityManagementScreen(),
                                ),
                              );
                            },
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
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: AppTheme.spacing16),
                      Text(
                        weather.condition,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      Text(
                        'Feels like ${weather.feelsLike.toInt()}°  ${weather.description}',
                        style: Theme.of(context).textTheme.bodyMedium,
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
                        padding: const EdgeInsets.all(AppTheme.spacing16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 20,
                                  color: AppTheme.iconColor,
                                ),
                                const SizedBox(width: AppTheme.spacing8),
                                Text(
                                  'Next 72 Hours',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppTheme.spacing20),

                            // Forecast Cards
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
                                    condition: dailyForecast[0].condition,
                                    icon: dailyForecast[0].icon,
                                  ),
                                  const SizedBox(width: AppTheme.spacing12),
                                  ForecastCard(
                                    day: 'Tomorrow',
                                    highTemp:
                                        '${dailyForecast[1].highTemp.toInt()}°',
                                    lowTemp:
                                        '${dailyForecast[1].lowTemp.toInt()}°',
                                    condition: dailyForecast[1].condition,
                                    icon: dailyForecast[1].icon,
                                  ),
                                  const SizedBox(width: AppTheme.spacing12),
                                  ForecastCard(
                                    day: DateFormat(
                                      'E',
                                    ).format(dailyForecast[2].date),
                                    highTemp:
                                        '${dailyForecast[2].highTemp.toInt()}°',
                                    lowTemp:
                                        '${dailyForecast[2].lowTemp.toInt()}°',
                                    condition: dailyForecast[2].condition,
                                    icon: dailyForecast[2].icon,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: AppTheme.spacing24),

                            // Temperature Chart (Simplified)
                            SizedBox(
                              height: 100,
                              child: CustomPaint(
                                painter: TemperatureChartPainter(),
                                child: Container(),
                              ),
                            ),

                            const SizedBox(height: AppTheme.spacing16),

                            // Hourly Forecast
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: hourlyForecast.map((forecast) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      right: AppTheme.spacing12,
                                    ),
                                    child: HourlyForecastItem(
                                      time: DateFormat(
                                        'h:mm a',
                                      ).format(forecast.time),
                                      temperature:
                                          '${forecast.temperature.toInt()}°',
                                      condition: forecast.condition,
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
                    padding: const EdgeInsets.all(AppTheme.spacing16),
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
                            const SizedBox(width: AppTheme.spacing8),
                            Text(
                              'Next 7 Day(s)',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacing20),

                        // 7-Day Chart
                        SizedBox(
                          height: 120,
                          child: CustomPaint(
                            painter: WeeklyChartPainter(),
                            child: Container(),
                          ),
                        ),

                        const SizedBox(height: AppTheme.spacing16),

                        // View More Details Button
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DetailsScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Display More',
                                style: Theme.of(context).textTheme.bodyLarge,
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

// Temperature Chart Painter
class TemperatureChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accentPurple.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppTheme.accentPurple.withOpacity(0.3),
          AppTheme.accentPurple.withOpacity(0.0),
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

// Weekly Chart Painter
class WeeklyChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accentPurple.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // High temperature line
    final highPath = Path();
    final highPoints = [
      Offset(0, size.height * 0.3),
      Offset(size.width * 0.2, size.height * 0.3),
      Offset(size.width * 0.4, size.height * 0.25),
      Offset(size.width * 0.6, size.height * 0.15),
      Offset(size.width * 0.8, size.height * 0.1),
      Offset(size.width, size.height * 0.05),
    ];

    highPath.moveTo(highPoints[0].dx, highPoints[0].dy);
    for (int i = 1; i < highPoints.length; i++) {
      highPath.lineTo(highPoints[i].dx, highPoints[i].dy);
    }

    canvas.drawPath(highPath, paint);

    // Low temperature line
    final lowPaint = Paint()
      ..color = AppTheme.secondaryText.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final lowPath = Path();
    final lowPoints = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.2, size.height * 0.65),
      Offset(size.width * 0.4, size.height * 0.65),
      Offset(size.width * 0.6, size.height * 0.6),
      Offset(size.width * 0.8, size.height * 0.6),
      Offset(size.width, size.height * 0.6),
    ];

    lowPath.moveTo(lowPoints[0].dx, lowPoints[0].dy);
    for (int i = 1; i < lowPoints.length; i++) {
      lowPath.lineTo(lowPoints[i].dx, lowPoints[i].dy);
    }

    canvas.drawPath(lowPath, lowPaint);

    // Draw points
    final pointPaint = Paint()
      ..color = AppTheme.primaryText
      ..style = PaintingStyle.fill;

    for (var point in highPoints) {
      canvas.drawCircle(point, 3, pointPaint);
    }

    for (var point in lowPoints) {
      canvas.drawCircle(point, 3, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
