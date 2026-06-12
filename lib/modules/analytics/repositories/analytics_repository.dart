import 'package:dio/dio.dart' as dio_instance;
import '../../../core/network/api_client.dart';

class AnalyticsRepository {
  final ApiClient _apiClient;

  AnalyticsRepository(this._apiClient);

  Future<dio_instance.Response> getStudentAnalytics() async {
    return await _apiClient.get('/analytics/student');
  }

  Future<dio_instance.Response> getSubjectAnalytics() async {
    return await _apiClient.get('/analytics/subjects');
  }

  Future<dio_instance.Response> getTopicAnalytics() async {
    return await _apiClient.get('/analytics/topics');
  }

  Future<dio_instance.Response> getTrends() async {
    return await _apiClient.get('/analytics/trends');
  }

  Future<dio_instance.Response> sendHeartbeat(double hours) async {
    return await _apiClient.post(
      '/analytics/heartbeat',
      data: {'hours': hours},
    );
  }

  // --- Goals ---
  Future<dio_instance.Response> getGoals() async {
    return await _apiClient.get('/analytics/goals');
  }

  Future<dio_instance.Response> createGoal(String goalTitle, double targetValue) async {
    return await _apiClient.post(
      '/analytics/goals',
      data: {
        'goalTitle': goalTitle,
        'targetValue': targetValue,
      },
    );
  }

  Future<dio_instance.Response> updateGoalProgress(String id, double completedValue) async {
    return await _apiClient.put(
      '/analytics/goals/$id',
      data: {'completedValue': completedValue},
    );
  }

  Future<dio_instance.Response> deleteGoal(String id) async {
    return await _apiClient.delete('/analytics/goals/$id');
  }
}
