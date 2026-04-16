class Meal {
  final String id;
  final String name;
  final String description;
  final String whyItHelps;
  final List<String> ingredients;
  final List<String> recipe;
  final String mealType;
  final String riskCategory;
  final bool isVeg;
  final int? calories;
  final int? carbs;
  final String? prepTime;

  Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.whyItHelps,
    required this.ingredients,
    required this.recipe,
    required this.mealType,
    required this.riskCategory,
    required this.isVeg,
    this.calories,
    this.carbs,
    this.prepTime,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    id: json['id'],
    name: json['name'],
    description: json['description'] ?? '',
    whyItHelps: json['whyItHelps'] ?? '', 
    ingredients: List<String>.from(json['ingredients'] ?? []),
    recipe: List<String>.from(json['recipe'] ?? []),
    mealType: json['mealType'] ?? '', 
    riskCategory: json['riskCategory'] ?? '', 
    isVeg: json['isVeg'] ?? false,
    calories: json['calories'],
    carbs: json['carbs'],
    prepTime: json['prepTime'],
  );
}

class MealPlanDay {
  final String id;
  final int dayNumber;
  final Meal? breakfast;
  final Meal? lunch;
  final Meal? dinner;
  final Meal? snack;

  MealPlanDay({
    required this.id,
    required this.dayNumber,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.snack,
  });

  factory MealPlanDay.fromJson(Map<String, dynamic> json) => MealPlanDay(
    id: json['id'],
    dayNumber: json['dayNumber'],
    breakfast: json['breakfast'] != null
        ? Meal.fromJson(json['breakfast'])
        : null,
    lunch: json['lunch'] != null ? Meal.fromJson(json['lunch']) : null,
    dinner: json['dinner'] != null ? Meal.fromJson(json['dinner']) : null,
    snack: json['snack'] != null ? Meal.fromJson(json['snack']) : null,
  );
}

class MealPlan {
  final String id;
  final String userId;
  final String riskCategory;
  final bool isActive;
  final List<MealPlanDay> days;

  MealPlan({
    required this.id,
    required this.userId,
    required this.riskCategory,
    required this.isActive,
    required this.days,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) => MealPlan(
    id: json['id'],
    userId: json['userId'],
    riskCategory: json['riskCategory'],
    isActive: json['isActive'],
    days: (json['days'] as List).map((d) => MealPlanDay.fromJson(d)).toList(),
  );
}
