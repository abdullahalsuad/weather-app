import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final String temperature;
  final String condition;
  final IconData icon;

  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.temperature,
    required this.condition,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32, color: AppTheme.iconColor),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            temperature,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: AppTheme.spacing4),
          Text(
            condition,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppTheme.spacing4),
          Text(time, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
