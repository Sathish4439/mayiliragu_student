import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controllers/course_controller.dart';
import '../repositories/course_repository.dart';

class CourseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseRepository>(() => CourseRepository(Get.find<ApiClient>()));
    Get.lazyPut<CourseController>(() => CourseController(Get.find<CourseRepository>()));
  }
}
