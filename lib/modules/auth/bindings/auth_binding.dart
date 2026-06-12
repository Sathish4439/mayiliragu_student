import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../controllers/auth_controller.dart';
import '../repositories/auth_repository.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<AuthController>(() => AuthController(Get.find<AuthRepository>()), fenix: true);
  }
}
