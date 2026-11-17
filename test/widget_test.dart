import 'package:flutter_test/flutter_test.dart';
import 'package:hydrofit/core/strings.dart';
import 'package:hydrofit/data/seed/exercises.dart';
import 'package:hydrofit/data/seed/meals.dart';

void main() {
  test('Seed exercises contain at least 40 items across all muscle groups', () {
    expect(seedExercises.length, greaterThanOrEqualTo(40));

    final muscleGroups = seedExercises.map((e) => e.muscleGroup).toSet();
    expect(muscleGroups.contains('Chest'), isTrue);
    expect(muscleGroups.contains('Back'), isTrue);
    expect(muscleGroups.contains('Legs'), isTrue);
    expect(muscleGroups.contains('Shoulders'), isTrue);
    expect(muscleGroups.contains('Arms'), isTrue);
    expect(muscleGroups.contains('Core'), isTrue);
    expect(muscleGroups.contains('Full Body'), isTrue);
  });

  test('Seed meals contain at least 25 items spanning ~300 to ~900 kcal', () {
    expect(seedMeals.length, greaterThanOrEqualTo(25));

    final categories = seedMeals.map((m) => m.category).toSet();
    expect(categories.contains('Breakfast'), isTrue);
    expect(categories.contains('Lunch'), isTrue);
    expect(categories.contains('Dinner'), isTrue);
    expect(categories.contains('Snack'), isTrue);

    final calories = seedMeals.map((m) => m.calories).toList();
    expect(calories.any((c) => c <= 350), isTrue);
    expect(calories.any((c) => c >= 650), isTrue);
  });

  test('App strings are non-empty', () {
    expect(AppStrings.appName, 'HydroFit');
    expect(AppStrings.navTraining, isNotEmpty);
    expect(AppStrings.navDiet, isNotEmpty);
    expect(AppStrings.navSchedule, isNotEmpty);
    expect(AppStrings.navAccount, isNotEmpty);
  });
}
