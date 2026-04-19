import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoint.dart';
import '../../core/api/api_exception.dart';
import '../../models/content/content_model.dart';

class ContentService {
  final Dio _dio = ApiClient().dio;

  Future<List<ContentModel>> getAllContent() async {
    try {
      final response = await _dio.get(ApiEndpoints.content);
      final List data = response.data['data'];
      return data.map((c) => ContentModel.fromJson(c)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<ContentModel>> getContentByCategory(String category) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.content,
        queryParameters: {'category': category},
      );
      final List data = response.data['data'];
      return data.map((c) => ContentModel.fromJson(c)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
