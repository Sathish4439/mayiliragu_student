import 'package:dio/dio.dart' as dio_instance;
import '../../../core/network/api_client.dart';

class LessonRepository {
  final ApiClient _apiClient;

  LessonRepository(this._apiClient);

  Future<dio_instance.Response> getLessonById(String id) async {
    return await _apiClient.get('/lessons/$id');
  }

  Future<dio_instance.Response> updateProgress(String lessonId, int watchedSeconds) async {
    return await _apiClient.post(
      '/progress/update',
      data: {
        'lessonId': lessonId,
        'watchedSeconds': watchedSeconds,
      },
    );
  }
}
