import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile', style: AppTextStyles.heading.copyWith(fontSize: 20)),
        backgroundColor: AppColors.backgroundStart,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundStart,
              AppColors.secondary,
              AppColors.backgroundEnd,
            ],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Summary Card
                Card(
                  color: AppColors.cardBg,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: AppColors.accent.withAlpha(40),
                          child: const Icon(Icons.person, size: 40, color: AppColors.primary),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.userName.value,
                                style: AppTextStyles.heading.copyWith(fontSize: 20),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.userEmail.value,
                                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withAlpha(30),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  controller.userRole.value.toUpperCase(),
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accentDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Update Display Name Section
                Text(
                  'Account Settings',
                  style: AppTextStyles.subheading.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                Card(
                  color: AppColors.cardBg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Update Display Name',
                          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: controller.nameController,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary),
                            filled: true,
                            fillColor: AppColors.textPrimary.withAlpha(12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: controller.isUpdatingName.value ? null : controller.updateName,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentDark,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: controller.isUpdatingName.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : Text(
                                    'Save Changes',
                                    style: AppTextStyles.button.copyWith(color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Change Password Section
                Text(
                  'Security Settings',
                  style: AppTextStyles.subheading.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                Card(
                  color: AppColors.cardBg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Change Password',
                          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: controller.currentPasswordController,
                          obscureText: controller.obscureCurrentPassword.value,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'Current Password',
                            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.obscureCurrentPassword.value ? Icons.visibility_off : Icons.visibility,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () => controller.obscureCurrentPassword.toggle(),
                            ),
                            filled: true,
                            fillColor: AppColors.textPrimary.withAlpha(12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: controller.newPasswordController,
                          obscureText: controller.obscureNewPassword.value,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            prefixIcon: const Icon(Icons.vpn_key_outlined, color: AppColors.textSecondary),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.obscureNewPassword.value ? Icons.visibility_off : Icons.visibility,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () => controller.obscureNewPassword.toggle(),
                            ),
                            filled: true,
                            fillColor: AppColors.textPrimary.withAlpha(12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: controller.confirmNewPasswordController,
                          obscureText: controller.obscureConfirmPassword.value,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'Confirm New Password',
                            prefixIcon: const Icon(Icons.vpn_key_outlined, color: AppColors.textSecondary),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.obscureConfirmPassword.value ? Icons.visibility_off : Icons.visibility,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () => controller.obscureConfirmPassword.toggle(),
                            ),
                            filled: true,
                            fillColor: AppColors.textPrimary.withAlpha(12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: controller.isChangingPassword.value ? null : controller.changePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentDark,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: controller.isChangingPassword.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : Text(
                                    'Update Password',
                                    style: AppTextStyles.button.copyWith(color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
