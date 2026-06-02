import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../courses/controllers/course_controller.dart';
import '../../courses/repositories/course_repository.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../profile/repositories/profile_repository.dart';
import '../repositories/dashboard_repository.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardRepository>(() => DashboardRepository());
    Get.lazyPut<DashboardController>(() => DashboardController(Get.find<DashboardRepository>()));

    // Course Dependencies for Learn Tab
    Get.lazyPut<CourseRepository>(() => CourseRepository(Get.find<ApiClient>()));
    Get.lazyPut<CourseController>(() => CourseController(Get.find<CourseRepository>()));

    // Profile Dependencies for More/Profile Tab
    Get.lazyPut<ProfileRepository>(() => ProfileRepository(Get.find<ApiClient>()));
    Get.lazyPut<ProfileController>(() => ProfileController(Get.find<ProfileRepository>()));
  }
}
