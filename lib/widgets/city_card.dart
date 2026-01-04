import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class CityCard extends StatelessWidget {
  final String cityName;
  final String? subtitle;
  final String temperature;
  final String condition;
  final String tempRange;
  final bool isCurrentLocation;
  final VoidCallback? onTap;

  const CityCard({
    super.key,
    required this.cityName,
    this.subtitle,
    required this.temperature,
    required this.condition,
    required this.tempRange,
    this.isCurrentLocation = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing16),
      padding: const EdgeInsets.all(AppTheme.spacing20),
      borderRadius: AppTheme.radiusLarge,
      onTap: onTap,
      child: Stack(
        children: [
          // Decorative gradient overlay
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    AppTheme.accentPurple.withOpacity(0.1),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(AppTheme.radiusLarge),
                  bottomRight: Radius.circular(AppTheme.radiusLarge),
                ),
              ),
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cityName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: AppTheme.spacing4),
                          Text(
                            subtitle!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppTheme.accentPurple),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text(
                    '$temperature°',
                    style: Theme.of(
                      context,
                    ).textTheme.displayMedium?.copyWith(fontSize: 56),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacing16),
              Row(
                children: [
                  Text(condition, style: Theme.of(context).textTheme.bodyLarge),
                  const Spacer(),
                  Text(
                    tempRange,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
