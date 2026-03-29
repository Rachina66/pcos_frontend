import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoint.dart';
import '../../core/api/api_exception.dart';
import '../../models/doctor/doctor_model.dart';

class DoctorService {
  final Dio _dio = ApiClient().dio;

  Future<List<DoctorModel>> getAllDoctors() async {
    try {
      final response = await _dio.get(ApiEndpoints.doctors);
      final List data = response.data['data'];
      return data.map((d) => DoctorModel.fromJson(d)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<DoctorModel> getDoctorById(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.doctorById(id));
      return DoctorModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<AvailableSlotsModel> getAvailableSlots(
    String doctorId,
    String date,
  ) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.availableSlots(doctorId),
        queryParameters: {'date': date},
      );
      print('SLOTS RESPONSE: ${response.data}');
      return AvailableSlotsModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
