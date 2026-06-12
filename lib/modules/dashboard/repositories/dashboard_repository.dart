import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';

class DashboardRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> getStudentDashboard() {
    return _apiClient.get(ApiConstants.dashboard);
  }

  Future<Response> getStudentProfile() {
    return _apiClient.get(ApiConstants.profile);
  }
}
