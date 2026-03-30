import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoint.dart';
import '../../core/api/api_exception.dart';
import '../../models/appointments/appointment_model.dart';

class AppointmentService {
  final Dio _dio = ApiClient().dio;

  Future<AppointmentModel> bookAppointment({
    required String doctorId,
    required String date,
    required String timeSlot,
    String? reason,
    String? reportFilePath,
  }) async {
    try {
      if (reportFilePath != null) {
        final formData = FormData.fromMap({
          'doctorId': doctorId,
          'date': date,
          'timeSlot': timeSlot,
          if (reason != null) 'reason': reason,
          'reportFile': await MultipartFile.fromFile(reportFilePath),
        });

        final response = await _dio.post(
          ApiEndpoints.bookAppointment,
          data: formData,
          options: Options(contentType: 'multipart/form-data'),
        );
        return AppointmentModel.fromJson(response.data['data']);
      }

      final response = await _dio.post(
        ApiEndpoints.bookAppointment,
        data: {
          'doctorId': doctorId,
          'date': date,
          'timeSlot': timeSlot,
          if (reason != null) 'reason': reason,
        },
      );
      return AppointmentModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<AppointmentModel>> getMyAppointments() async {
    try {
      final response = await _dio.get(ApiEndpoints.myAppointments);
      final List data = response.data['data'];
      return data.map((a) => AppointmentModel.fromJson(a)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> cancelAppointment(String id) async {
    try {
      await _dio.delete(ApiEndpoints.cancelAppointment(id));
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
