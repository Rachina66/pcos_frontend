import 'package:flutter/material.dart';
import '../../core/api/api_exception.dart';
import '../../models/meal/meal_model.dart';
import '../../services/meal/meal_service.dart';

class MealProvider extends ChangeNotifier {
  final MealService _service = MealService();

  MealPlan? _mealPlan;
  List<Meal> _availableMeals = [];
  bool _isLoading = false;
  bool _isSwapping = false;
  String? _error;
  String _dietPreference = 'NON_VEG';

  MealPlan? get mealPlan => _mealPlan;
  List<Meal> get availableMeals => _availableMeals;
  bool get isLoading => _isLoading;
  bool get isSwapping => _isSwapping;
  String? get error => _error;
  String get dietPreference => _dietPreference;

  void setDietPreference(String pref) {
    _dietPreference = pref;
    notifyListeners();
  }

  Future<bool> generateMealPlan({required String predictionId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _mealPlan = await _service.generateMealPlan(
        predictionId: predictionId,
        dietPreference: _dietPreference,
      );
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMyPlan() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _mealPlan = await _service.getMyPlan();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Something went wrong.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> regenerateMealPlan() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _mealPlan = await _service.regenerateMealPlan(
        dietPreference: _dietPreference,
      );
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Something went wrong.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAvailableMeals({required String mealType}) async {
    try {
      _availableMeals = await _service.getAvailableMeals(
        mealType: mealType,
        isVeg: _dietPreference != 'NON_VEG',
      );
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  Future<bool> swapMeal({
    required int dayNumber,
    required String mealType,
    required String newMealId,
  }) async {
    _isSwapping = true;
    notifyListeners();
    try {
      _mealPlan = await _service.swapMeal(
        dayNumber: dayNumber,
        mealType: mealType,
        newMealId: newMealId,
      );
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Failed to swap meal.';
      return false;
    } finally {
      _isSwapping = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
