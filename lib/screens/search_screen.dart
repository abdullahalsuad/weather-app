import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_background.dart';
import '../utils/mock_data.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredCities = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _filteredCities = MockData.getTopCities();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredCities = MockData.getTopCities();
      } else {
        _filteredCities = MockData.getTopCities()
            .where((city) => city.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        style: Theme.of(context).textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: 'Search for a country or region',
                          hintStyle: Theme.of(context).textTheme.bodyMedium,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppTheme.secondaryText,
                          ),
                          filled: true,
                          fillColor: AppTheme.cardBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusMedium,
                            ),
                            borderSide: const BorderSide(
                              color: AppTheme.cardBorder,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusMedium,
                            ),
                            borderSide: const BorderSide(
                              color: AppTheme.cardBorder,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusMedium,
                            ),
                            borderSide: const BorderSide(
                              color: AppTheme.accentPurple,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Top Cities Label
              if (!_isSearching)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing16,
                    vertical: AppTheme.spacing8,
                  ),
                  child: Text(
                    'Top',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),

              // City Chips
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing16,
                  ),
                  child: Wrap(
                    spacing: AppTheme.spacing12,
                    runSpacing: AppTheme.spacing12,
                    children: _filteredCities.map((city) {
                      final isSelected = city == 'Uttara';
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusLarge,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacing20,
                              vertical: AppTheme.spacing12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.accentPurple.withOpacity(0.3)
                                  : AppTheme.cardBackground,
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusLarge,
                              ),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.accentPurple
                                    : AppTheme.cardBorder,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  city,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: isSelected
                                            ? AppTheme.accentPurple
                                            : AppTheme.primaryText,
                                      ),
                                ),
                                if (isSelected) ...[
                                  const SizedBox(width: AppTheme.spacing8),
                                  const Icon(
                                    Icons.check_circle,
                                    color: AppTheme.accentPurple,
                                    size: 18,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
