import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class WeatherMetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String unit;
  final String? description;
  final Widget? customContent;

  const WeatherMetricCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.unit = '',
    this.description,
    this.customContent,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppTheme.iconColor),
              const SizedBox(width: AppTheme.spacing8),
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: AppTheme.spacing16),

          if (customContent != null)
            customContent!
          else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                if (unit.isNotEmpty) ...[
                  const SizedBox(width: AppTheme.spacing4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      unit,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ],
            ),
            if (description != null) ...[
              const SizedBox(height: AppTheme.spacing8),
              Text(
                description!,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ],
      ),
    );
  }
}
