import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../study_materials/repositories/study_materials_repository.dart';
import '../controllers/book_store_controller.dart';
import '../repositories/book_store_repository.dart';

class BookStoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookStoreRepository>(
      () => BookStoreRepository(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<StudyMaterialsRepository>(
      () => StudyMaterialsRepository(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<BookStoreController>(
      () => BookStoreController(
        Get.find<BookStoreRepository>(),
        Get.find<StudyMaterialsRepository>(),
      ),
      fenix: true,
    );
  }
}
