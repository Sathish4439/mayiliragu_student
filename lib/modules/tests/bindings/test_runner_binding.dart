import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controllers/test_runner_controller.dart';
import '../repositories/tests_repository.dart';

class TestRunnerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestsRepository>(() => TestsRepository(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<TestRunnerController>(
      () => TestRunnerController(Get.find<TestsRepository>()),
      fenix: true,
    );
  }
}
