import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_background.dart';
import '../widgets/city_card.dart';
import '../utils/mock_data.dart';
import 'search_screen.dart';

class CityManagementScreen extends StatelessWidget {
  const CityManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cities = MockData.getSavedCities();

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
                            builder: (context) => const SearchScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // City List
              Expanded(
                child: ListView.builder(
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
