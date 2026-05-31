import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controllers/lesson_controller.dart';
import '../repositories/lesson_repository.dart';

class LessonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LessonRepository>(() => LessonRepository(Get.find<ApiClient>()));
    Get.lazyPut<LessonController>(() => LessonController(Get.find<LessonRepository>()));
  }
}
