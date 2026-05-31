import 'package:dio/dio.dart' as dio_instance;
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';

class CourseRepository {
  final ApiClient _apiClient;

  CourseRepository(this._apiClient);

  Future<dio_instance.Response> getCourses({required int page, required int limit}) async {
    return await _apiClient.get(
      ApiConstants.courses,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
  }

  Future<dio_instance.Response> getCourseById(String id) async {
    return await _apiClient.get('${ApiConstants.courses}/$id');
  }
}
