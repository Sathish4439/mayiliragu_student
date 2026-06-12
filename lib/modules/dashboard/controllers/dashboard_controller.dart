import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/services/secure_storage_service.dart';
import '../repositories/dashboard_repository.dart';
import '../models/dashboard_model.dart';

class DashboardController extends GetxController {
  final DashboardRepository _repository;
  final SecureStorageService _storage = Get.find<SecureStorageService>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Strongly typed dashboard data model
  final dashboardData = Rxn<DashboardModel>();

  DashboardController(this._repository);

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _repository.getStudentDashboard();
      
      UserProfile? profile;
      try {
        final profileResponse = await _repository.getStudentProfile();
        if (profileResponse.statusCode == 200) {
          final profileJson = profileResponse.data['data'] as Map<String, dynamic>?;
          if (profileJson != null) {
            profile = UserProfile.fromJson(profileJson);
          }
        }
      } catch (_) {
        // Suppress profile fetch error so dashboard still loads
      }

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        dashboardData.value = DashboardModel.fromJson(data, profile: profile);
      } else {
        errorMessage.value = response.data['message'] ?? 'Failed to load dashboard';
      }
    } catch (e) {
      errorMessage.value = 'Failed to connect to server';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _storage.clearAll();
    } catch (_) {}
    Get.offAllNamed(Routes.LOGIN);
  }
}
