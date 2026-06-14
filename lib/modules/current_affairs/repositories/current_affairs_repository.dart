import 'package:dio/dio.dart' as dio_instance;
import '../../../core/network/api_client.dart';

class CurrentAffairsRepository {
  final ApiClient _apiClient;

  CurrentAffairsRepository(this._apiClient);

  Future<dio_instance.Response> getCurrentAffairs({
    String? date,
    String? category,
    String? search,
  }) async {
    final Map<String, dynamic> queryParams = {};
    if (date != null && date.isNotEmpty) queryParams['date'] = date;
    if (category != null && category.isNotEmpty) queryParams['category'] = category;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    return await _apiClient.get(
      '/current-affairs',
      queryParameters: queryParams,
    );
  }

  Future<dio_instance.Response> getCurrentAffairById(String id) async {
    return await _apiClient.get('/current-affairs/$id');
  }

  Future<dio_instance.Response> getQuizzesByArticleId(String articleId) async {
    return await _apiClient.get('/current-affairs/$articleId/quizzes');
  }

  Future<dio_instance.Response> submitQuizAnswers(List<Map<String, dynamic>> submissions) async {
    return await _apiClient.post(
      '/current-affairs/quizzes/submit',
      data: {'submissions': submissions},
    );
  }

  Future<dio_instance.Response> toggleBookmark(String id) async {
    return await _apiClient.post('/current-affairs/$id/bookmark');
  }

  Future<dio_instance.Response> getBookmarkedArticles() async {
    return await _apiClient.get('/current-affairs/bookmarks');
  }

  Future<dio_instance.Response> getMonthlyMagazines() async {
    return await _apiClient.get('/current-affairs/magazines/all');
  }

  Future<dio_instance.Response> getGovernmentSchemes({String? type}) async {
    final Map<String, dynamic> queryParams = {};
    if (type != null && type.isNotEmpty) queryParams['type'] = type;
    return await _apiClient.get(
      '/current-affairs/schemes/all',
      queryParameters: queryParams,
    );
  }

  Future<dio_instance.Response> getImportantDates({String? type}) async {
    final Map<String, dynamic> queryParams = {};
    if (type != null && type.isNotEmpty) queryParams['type'] = type;
    return await _apiClient.get(
      '/current-affairs/important-dates/all',
      queryParameters: queryParams,
    );
  }

  Future<dio_instance.Response> getStudentAnalytics() async {
    return await _apiClient.get('/current-affairs/analytics');
  }
}
