import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../courses/controllers/course_controller.dart';
import '../../courses/repositories/course_repository.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../profile/repositories/profile_repository.dart';
import '../repositories/dashboard_repository.dart';
import '../controllers/dashboard_controller.dart';
import '../../tests/controllers/tests_controller.dart';
import '../../tests/repositories/tests_repository.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardRepository>(() => DashboardRepository(), fenix: true);
    Get.lazyPut<DashboardController>(() => DashboardController(Get.find<DashboardRepository>()), fenix: true);

    // Tests Dependencies for Tests Tab
    Get.lazyPut<TestsRepository>(() => TestsRepository(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<TestsController>(() => TestsController(Get.find<TestsRepository>()), fenix: true);

    // Course Dependencies for Learn Tab
    Get.lazyPut<CourseRepository>(() => CourseRepository(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<CourseController>(() => CourseController(Get.find<CourseRepository>()), fenix: true);

    // Profile Dependencies for More/Profile Tab
    Get.lazyPut<ProfileRepository>(() => ProfileRepository(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(Get.find<ProfileRepository>()), fenix: true);
  }
}
