import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../app/routes/app_routes.dart';

class OnboardingController extends GetxController {
  final SecureStorageService _storage = Get.find<SecureStorageService>();
  final PageController pageController = PageController();
  
  final currentPage = 0.obs;

  final List<Map<String, String>> slides = [
    {
      'title': 'Practice with 10,000+ Questions',
      'subtitle': 'Master every subject with our extensive question bank designed by top educators.',
    },
    {
      'title': 'Real-time Performance Analytics',
      'subtitle': 'Identify your strengths and weaknesses with detailed feedback and insights.',
    },
    {
      'title': 'Stay Updated on Government Exams',
      'subtitle': 'Receive notifications, syllabus updates, and tips directly on your device.',
    },
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  Future<void> nextPage() async {
    if (currentPage.value < slides.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      await finishOnboarding();
    }
  }

  Future<void> finishOnboarding() async {
    await _storage.setHasSeenOnboarding();
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
