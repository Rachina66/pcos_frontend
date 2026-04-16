import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../models/cycle/cycle_model.dart';

class CycleService {
  final Dio _dio = ApiClient().dio;

  Future<DailyLogModel> upsertDailyLog({
    required String date,
    required bool isPeriod,
    String? flow,
    String? mood,
    int? energy,
    List<String>? symptoms,
    String? notes,
  }) async {
    try {
      final response = await _dio.post(
        '/user/cycles/log',
        data: {
          'date': date,
          'isPeriod': isPeriod,
          if (flow != null) 'flow': flow,
          if (mood != null) 'mood': mood,
          if (energy != null) 'energy': energy,
          'symptoms': symptoms ?? [],
          if (notes != null) 'notes': notes,
        },
      );
      return DailyLogModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<DailyLogModel?> getDailyLog(String date) async {
    try {
      final response = await _dio.get('/user/cycles/log/$date');
      final data = response.data['data'];
      if (data == null) return null;
      return DailyLogModel.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<DailyLogModel>> getDailyLogsInRange(
      String from, String to) async {
    try {
      final response = await _dio.get(
        '/user/cycles/log/range',
        queryParameters: {'from': from, 'to': to},
      );
      final List data = response.data['data'];
      return data.map((e) => DailyLogModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<CycleLogModel>> getCycleHistory() async {
    try {
      final response = await _dio.get('/user/cycles/history');
      final List data = response.data['data'];
      return data.map((e) => CycleLogModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<CyclePredictionModel> getPrediction() async {
    try {
      final response = await _dio.get('/user/cycles/prediction');
      return CyclePredictionModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<CycleInsightsModel> getInsights() async {
    try {
      final response = await _dio.get('/user/cycles/insights');
      return CycleInsightsModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}