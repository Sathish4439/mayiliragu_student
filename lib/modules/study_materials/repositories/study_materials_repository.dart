import 'package:dio/dio.dart' as dio_instance;
import '../../../core/network/api_client.dart';

class StudyMaterialsRepository {
  final ApiClient _apiClient;

  StudyMaterialsRepository(this._apiClient);

  Future<dio_instance.Response> getCategories() async {
    return await _apiClient.get('/study-materials/categories');
  }

  Future<dio_instance.Response> getMaterials({
    String? categoryId,
    String? subjectId,
    String? topicId,
    String? accessType,
    String? search,
  }) async {
    final Map<String, dynamic> queryParams = {};
    if (categoryId != null && categoryId.isNotEmpty) queryParams['categoryId'] = categoryId;
    if (subjectId != null && subjectId.isNotEmpty) queryParams['subjectId'] = subjectId;
    if (topicId != null && topicId.isNotEmpty) queryParams['topicId'] = topicId;
    if (accessType != null && accessType.isNotEmpty) queryParams['accessType'] = accessType;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    return await _apiClient.get(
      '/study-materials',
      queryParameters: queryParams,
    );
  }

  Future<dio_instance.Response> getMaterialById(String id) async {
    return await _apiClient.get('/study-materials/$id');
  }

  Future<dio_instance.Response> toggleBookmark(String materialId) async {
    return await _apiClient.post(
      '/study-materials/bookmark',
      data: {'materialId': materialId},
    );
  }

  Future<dio_instance.Response> getBookmarkedMaterials() async {
    return await _apiClient.get('/study-materials/bookmarks');
  }

  Future<dio_instance.Response> downloadMaterial(String id) async {
    return await _apiClient.post('/study-materials/$id/download');
  }
}
