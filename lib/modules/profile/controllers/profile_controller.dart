import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../repositories/profile_repository.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../app/routes/app_routes.dart';

class ProfileController extends GetxController {
  final ProfileRepository _repository;

  ProfileController(this._repository);

  final nameController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  final isLoading = false.obs;
  final isUpdatingName = false.obs;
  final isChangingPassword = false.obs;

  final userName = ''.obs;
  final userEmail = ''.obs;
  final userRole = ''.obs;
  final userCreatedAt = ''.obs;

  final obscureCurrentPassword = true.obs;
  final obscureNewPassword = true.obs;
  final obscureConfirmPassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final response = await _repository.getProfile();
      if (response.statusCode == 200) {
        final data = response.data['data'];
        userName.value = data['name'] ?? '';
        userEmail.value = data['email'] ?? '';
        userRole.value = data['role'] ?? '';
        userCreatedAt.value = data['createdAt'] ?? '';
        nameController.text = userName.value;
      } else {
        AppToast.error('Failed to load profile details');
      }
    } catch (e) {
      AppToast.error('Error loading profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateName() async {
    final newName = nameController.text.trim();
    if (newName.isEmpty || newName.length < 2) {
      AppToast.validation('Name must be at least 2 characters long');
      return;
    }

    try {
      isUpdatingName.value = true;
      final response = await _repository.updateName(newName);
      if (response.statusCode == 200) {
        userName.value = newName;
        AppToast.success('Display name updated successfully');
      } else {
        AppToast.error('Failed to update display name');
      }
    } catch (e) {
      AppToast.error('Error updating name: $e');
    } finally {
      isUpdatingName.value = false;
    }
  }

  Future<void> changePassword() async {
    final currentPassword = currentPasswordController.text;
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmNewPasswordController.text;

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      AppToast.validation('All password fields are required');
      return;
    }

    if (newPassword.length < 6) {
      AppToast.validation('New password must be at least 6 characters long');
      return;
    }

    if (newPassword != confirmPassword) {
      AppToast.validation('New passwords do not match');
      return;
    }

    try {
      isChangingPassword.value = true;
      final response = await _repository.changePassword(currentPassword, newPassword);
      if (response.statusCode == 200) {
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmNewPasswordController.clear();
        AppToast.success('Password changed successfully');
      } else {
        AppToast.error(response.data['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      String msg = 'Error changing password: $e';
      if (e is DioException && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map && data['message'] != null) {
          msg = data['message'].toString();
        }
      }
      AppToast.error(msg);
    } finally {
      isChangingPassword.value = false;
    }
  }

  Future<void> logout() async {
    try {
      final apiClient = Get.find<ApiClient>();
      await apiClient.post(ApiConstants.logout);
    } catch (_) {}
    try {
      final storage = Get.find<SecureStorageService>();
      await storage.clearAll();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      AppToast.error('Logout failed: $e');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.onClose();
  }
}
