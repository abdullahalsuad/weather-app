import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class ForecastCard extends StatelessWidget {
  final String day;
  final String highTemp;
  final String lowTemp;
  final String condition;
  final IconData icon;

  const ForecastCard({
    super.key,
    required this.day,
    required this.highTemp,
    required this.lowTemp,
    required this.condition,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: 160,
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(day, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppTheme.spacing12),
          Row(
            children: [
              Text(
                highTemp,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                '/${lowTemp}',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppTheme.secondaryText),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(condition, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
