import 'package:get/get.dart';
import '../repositories/profile_repository.dart';
import '../controllers/profile_controller.dart';
import '../../../core/network/api_client.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRepository>(() => ProfileRepository(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(Get.find<ProfileRepository>()), fenix: true);
  }
}
