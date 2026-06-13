import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../app/routes/app_routes.dart';
import '../repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;
  final SecureStorageService _storage = Get.find<SecureStorageService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final obscurePassword = true.obs;

  AuthController(this._authRepository);

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Please enter email and password';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _authRepository.login(email: email, password: password);
      if (response.statusCode == 200) {
        final data = response.data;
        final accessToken = data['accessToken'] as String;
        final refreshToken = data['refreshToken'] as String;
        final role = data['user']['role'] as String;

        if (role != 'STUDENT') {
          errorMessage.value = 'Access denied. Student account required.';
          return;
        }

        await _storage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
          role: role,
        );

        // Sync FCM token
        if (Get.isRegistered<NotificationService>()) {
          await Get.find<NotificationService>().syncToken();
        }

        emailController.clear();
        passwordController.clear();
        
        // Navigate to Dashboard
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        errorMessage.value = response.data['message'] ?? 'Login failed';
      }
    } catch (e) {
      errorMessage.value = 'Invalid email or password';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      if (Get.isRegistered<NotificationService>()) {
        await Get.find<NotificationService>().unregisterToken();
      }
      await _authRepository.logout();
    } catch (_) {}
    await _storage.clearAll();
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
