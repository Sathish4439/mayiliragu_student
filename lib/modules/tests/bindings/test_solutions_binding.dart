import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controllers/test_solutions_controller.dart';
import '../repositories/tests_repository.dart';

class TestSolutionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestsRepository>(() => TestsRepository(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<TestSolutionsController>(
      () => TestSolutionsController(Get.find<TestsRepository>()),
      fenix: true,
    );
  }
}
