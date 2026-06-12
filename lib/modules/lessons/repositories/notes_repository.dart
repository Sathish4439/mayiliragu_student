import 'package:dio/dio.dart' as dio_instance;
import '../../../core/network/api_client.dart';

class NotesRepository {
  final ApiClient _apiClient;

  NotesRepository(this._apiClient);

  Future<dio_instance.Response> getNotesByLesson(String lessonId) async {
    return await _apiClient.get('/notes/lesson/$lessonId');
  }

  Future<dio_instance.Response> createNote({
    required String lessonId,
    required int timestamp,
    required String content,
  }) async {
    return await _apiClient.post(
      '/notes',
      data: {
        'lessonId': lessonId,
        'timestamp': timestamp,
        'content': content,
      },
    );
  }

  Future<dio_instance.Response> updateNote({
    required String id,
    required String content,
  }) async {
    return await _apiClient.put(
      '/notes/$id',
      data: {
        'content': content,
      },
    );
  }

  Future<dio_instance.Response> deleteNote(String id) async {
    return await _apiClient.delete('/notes/$id');
  }
}
