import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../models/cycle/cycle_model.dart';

class CycleService {
  final Dio _dio = ApiClient().dio;

  // ═══ LOG PERIOD ═══
  Future<CycleLogModel> logPeriod({
    required String startDate,
    String? endDate,
    required List<String> symptoms,
    String? notes,
  }) async {
    try {
      final response = await _dio.post(
        '/user/cycles',
        data: {
          'startDate': startDate,
          if (endDate != null) 'endDate': endDate,
          'symptoms': symptoms,
          if (notes != null) 'notes': notes,
        },
      );
      return CycleLogModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ═══ GET HISTORY ═══
  Future<List<CycleLogModel>> getCycleHistory() async {
    try {
      final response = await _dio.get('/user/cycles');
      final List data = response.data['data'];
      return data.map((e) => CycleLogModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ═══ UPDATE CYCLE ═══
  Future<CycleLogModel> updateCycleLog(
    String id, {
    String? startDate,
    String? endDate,
    List<String>? symptoms,
    String? notes,
  }) async {
    try {
      final response = await _dio.put(
        '/user/cycles/$id',
        data: {
          if (startDate != null) 'startDate': startDate,
          if (endDate != null) 'endDate': endDate,
          if (symptoms != null) 'symptoms': symptoms,
          if (notes != null) 'notes': notes,
        },
      );
      return CycleLogModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ═══ DELETE CYCLE ═══
  Future<void> deleteCycleLog(String id) async {
    try {
      await _dio.delete('/user/cycles/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ═══ PREDICTION ═══
  Future<CyclePredictionModel> getPrediction() async {
    try {
      final response = await _dio.get('/user/cycles/prediction');
      return CyclePredictionModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ═══ LOG SYMPTOMS ═══
  Future<void> logSymptoms(List<String> symptoms) async {
    try {
      await _dio.post('/user/cycles/symptoms', data: {'symptoms': symptoms});
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ═══ GET TODAY'S SYMPTOMS ═══
  Future<List<String>> getTodaySymptoms() async {
    try {
      final response = await _dio.get('/user/cycles/symptoms/today');
      final data = response.data['data'];
      if (data == null) return [];
      return List<String>.from(data['symptoms'] ?? []);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ═══ SYMPTOM INSIGHTS ═══
  Future<SymptomInsightModel> getSymptomInsights() async {
    try {
      final response = await _dio.get('/user/cycles/symptoms/insights');
      return SymptomInsightModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
