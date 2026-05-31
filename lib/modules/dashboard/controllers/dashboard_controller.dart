import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/services/secure_storage_service.dart';
import '../repositories/dashboard_repository.dart';

class DashboardController extends GetxController {
  final DashboardRepository _repository;
  final SecureStorageService _storage = Get.find<SecureStorageService>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final enrolledCourses = <dynamic>[].obs;
  final continueLearning = Rxn<dynamic>();
  final recentlyWatched = <dynamic>[].obs;

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
      if (response.statusCode == 200) {
        final data = response.data;
        enrolledCourses.value = data['enrolledCourses'] ?? [];
        continueLearning.value = data['continueLearning'];
        recentlyWatched.value = data['recentlyWatched'] ?? [];
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
