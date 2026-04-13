import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../models/meal/meal_model.dart';

class MealService {
  final Dio _dio = ApiClient().dio;

  Future<MealPlan> generateMealPlan({
    required String predictionId,
    required String dietPreference,
  }) async {
    try {
      final response = await _dio.post(
        '/meal-plan/generate',
        data: {'predictionId': predictionId, 'dietPreference': dietPreference},
      );
      return MealPlan.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<MealPlan?> getMyPlan() async {
    try {
      final response = await _dio.get('/meal-plan/my-plan');
      return MealPlan.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw ApiException.fromDioException(e);
    }
  }

  Future<MealPlan> regenerateMealPlan({required String dietPreference}) async {
    try {
      final response = await _dio.post(
        '/meal-plan/regenerate',
        data: {'dietPreference': dietPreference},
      );
      return MealPlan.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<Meal>> getAvailableMeals({
    required String mealType,
    required bool isVeg,
  }) async {
    try {
      final response = await _dio.get(
        '/meal-plan/available-meals',
        queryParameters: {'mealType': mealType, 'isVeg': isVeg.toString()},
      );
      final List data = response.data['data'];
      return data.map((m) => Meal.fromJson(m)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<MealPlan> swapMeal({
    required int dayNumber,
    required String mealType,
    required String newMealId,
  }) async {
    try {
      final response = await _dio.patch(
        '/meal-plan/swap-meal',
        data: {
          'dayNumber': dayNumber,
          'mealType': mealType,
          'newMealId': newMealId,
        },
      );
      return MealPlan.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
