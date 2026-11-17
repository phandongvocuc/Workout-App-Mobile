import 'package:flutter/material.dart';
import '../../core/strings.dart';
import '../../data/models/meal.dart';
import '../../data/seed/meals.dart';
import '../../widgets/empty_state_view.dart';
import 'meal_detail_sheet.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  RangeValues _calorieRange = const RangeValues(150, 900);
  String _selectedCategory = AppStrings.allFilter;

  static const List<String> categories = [
    AppStrings.allFilter,
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
  ];

  List<Meal> get _filteredMeals {
    return seedMeals.where((meal) {
      final matchesCategory = _selectedCategory == AppStrings.allFilter ||
          meal.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesCalories = meal.calories >= _calorieRange.start &&
          meal.calories <= _calorieRange.end;
      return matchesCategory && matchesCalories;
    }).toList();
  }

  void _resetFilters() {
    setState(() {
      _selectedCategory = AppStrings.allFilter;
      _calorieRange = const RangeValues(150, 900);
    });
  }

  Color _getCategoryColor(String category, ColorScheme colorScheme) {
    switch (category.toLowerCase()) {
      case 'breakfast':
        return Colors.orange;
      case 'lunch':
        return Colors.blue;
      case 'dinner':
        return Colors.deepPurple;
      case 'snack':
        return Colors.teal;
      default:
        return colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final meals = _filteredMeals;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.dietTitle),
            Text(
              'Explore healthy meal ideas & calories',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filter section
          Container(
            color: theme.scaffoldBackgroundColor,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Chips
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final isSelected = _selectedCategory == cat;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // Calorie Range Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.caloriesRange,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${_calorieRange.start.round()} - ${_calorieRange.end.round()} ${AppStrings.kcalSuffix}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),

                // Range Slider
                RangeSlider(
                  values: _calorieRange,
                  min: 100,
                  max: 1000,
                  divisions: 18,
                  labels: RangeLabels(
                    '${_calorieRange.start.round()}',
                    '${_calorieRange.end.round()}',
                  ),
                  onChanged: (values) {
                    setState(() {
                      _calorieRange = values;
                    });
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Meals List or Empty State
          Expanded(
            child: meals.isEmpty
                ? EmptyStateView(
                    icon: Icons.restaurant_outlined,
                    title: AppStrings.noMealsFound,
                    subtitle: 'Try widening your calorie range or selecting "All" categories.',
                    actionLabel: AppStrings.resetFilters,
                    onAction: _resetFilters,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      final catColor = _getCategoryColor(meal.category, colorScheme);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () => MealDetailSheet.show(context, meal),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top row: Category badge & Calories
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: catColor.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        meal.category.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: catColor,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${meal.calories} ${AppStrings.kcalSuffix}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Meal name
                                Text(
                                  meal.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // Short description
                                Text(
                                  meal.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.textTheme.bodyMedium?.color
                                        ?.withValues(alpha: 0.75),
                                    fontSize: 13,
                                    height: 1.35,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Bottom ingredients hint
                                Row(
                                  children: [
                                    Icon(
                                      Icons.format_list_bulleted,
                                      size: 14,
                                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${meal.ingredients.length} ingredients • Tap for recipe',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
