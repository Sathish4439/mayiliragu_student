import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controllers/test_results_controller.dart';
import '../repositories/tests_repository.dart';

class TestResultsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestsRepository>(() => TestsRepository(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<TestResultsController>(
      () => TestResultsController(),
      fenix: true,
    );
  }
}
