import 'package:get/get.dart';
import '../repositories/dashboard_repository.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardRepository>(() => DashboardRepository());
    Get.lazyPut<DashboardController>(() => DashboardController(Get.find<DashboardRepository>()));
  }
}
