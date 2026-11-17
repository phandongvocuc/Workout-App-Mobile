class Meal {
  final String id;
  final String name;
  final int calories; // total kcal
  final String description; // short text
  final List<String> ingredients;
  final String category; // e.g. Breakfast, Lunch, Dinner, Snack

  const Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.description,
    required this.ingredients,
    required this.category,
  });
}

