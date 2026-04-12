import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoint.dart';
import '../../core/api/api_exception.dart';
import '../../models/prediction/prediction_model.dart';

class PredictionService {
  final Dio _dio = ApiClient().dio;

  Future<PredictionResult> predict({
    required double age,
    required double weight,
    required double height,
    required double bmi,
    required String bloodGroup,
    required double cycleLengthDays,
    required double periodLengthDays,
    required bool regularOvulation,
    required double fshLevel,
    required double lhLevel,
    required double androgenLevel,
    required double cystCount,
    required bool hirsutism,
    required double fastingGlucose,
    required int activityLevel,
    required int stressLevel,
    required bool pregnant,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.predict,
        data: {
          'data': {
            'age': age,
            'weight': weight,
            'height': height,
            'bmi': bmi,
            'bloodGroup': bloodGroup,
            'cycleLengthDays': cycleLengthDays,
            'periodLengthDays': periodLengthDays,
            'regularOvulation': regularOvulation,
            'fshLevel': fshLevel,
            'lhLevel': lhLevel,
            'androgenLevel': androgenLevel,
            'cystCount': cystCount,
            'hirsutism': hirsutism,
            'fastingGlucose': fastingGlucose,
            'activityLevel': activityLevel,
            'stressLevel': stressLevel,
            'pregnant': pregnant,
          },
        },
      );
      return PredictionResult.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<PredictionModel>> getMyPredictions() async {
    try {
      final response = await _dio.get(ApiEndpoints.predictions);
      final List data = response.data['predictions'];
      return data.map((p) => PredictionModel.fromJson(p)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
