import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controllers/study_materials_controller.dart';
import '../repositories/study_materials_repository.dart';

class StudyMaterialsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudyMaterialsRepository>(
      () => StudyMaterialsRepository(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<StudyMaterialsController>(
      () => StudyMaterialsController(Get.find<StudyMaterialsRepository>()),
      fenix: true,
    );
  }
}
