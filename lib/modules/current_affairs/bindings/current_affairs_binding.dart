import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controllers/current_affairs_controller.dart';
import '../repositories/current_affairs_repository.dart';

class CurrentAffairsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CurrentAffairsRepository>(
      () => CurrentAffairsRepository(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<CurrentAffairsController>(
      () => CurrentAffairsController(Get.find<CurrentAffairsRepository>()),
      fenix: true,
    );
  }
}
