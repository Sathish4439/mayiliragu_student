import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controllers/lesson_controller.dart';
import '../repositories/lesson_repository.dart';
import '../repositories/notes_repository.dart';

class LessonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LessonRepository>(() => LessonRepository(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<NotesRepository>(() => NotesRepository(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<LessonController>(
      () => LessonController(
        Get.find<LessonRepository>(),
        Get.find<NotesRepository>(),
      ),
      fenix: true,
    );
  }
}
