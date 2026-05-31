import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:better_player_enhanced/better_player.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/lesson_controller.dart';

class LessonDetailView extends GetView<LessonController> {
  const LessonDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final data = controller.lessonData.value;
          return Text(
            data?['title'] ?? 'Lesson Playback',
            style: AppTextStyles.heading.copyWith(fontSize: 18),
          );
        }),
        backgroundColor: AppColors.backgroundStart,
        elevation: 0,
      ),
      body: Container(
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

          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.errorMessage.value,
                      style: AppTextStyles.body.copyWith(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final String? lessonId = Get.parameters['id'] ?? Get.arguments?.toString();
                        if (lessonId != null) {
                          controller.fetchLessonDetail(lessonId);
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final lesson = controller.lessonData.value;
          if (lesson == null) {
            return Center(
              child: Text(
                'No lesson details found.',
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              ),
            );
          }

          final durationMinutes = ((lesson['duration'] as int? ?? 0) / 60).toStringAsFixed(1);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video Player Container
                if (controller.isVideoPlayerSupported)
                  if (controller.betterPlayerController != null)
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: BetterPlayer(controller: controller.betterPlayerController!),
                    )
                  else
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color: Colors.black87,
                        child: const Center(
                          child: CircularProgressIndicator(color: AppColors.accent),
                        ),
                      ),
                    )
                else
                  // AspectRatio(
                  //   aspectRatio: 16 / 9,
                  //   child: MockVideoPlayer(
                  //     videoUrl: lesson['driveFileId']?.toString() ?? '',
                  //     lessonTitle: lesson['title']?.toString() ?? 'Lesson Video',
                  //     durationSeconds: lesson['duration'] as int? ?? 300,
                  //   ),
                  // ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        lesson['title'] ?? 'Untitled Lesson',
                        style: AppTextStyles.heading.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),

                      // Duration Row
                      Row(
                        children: [
                          const Icon(Icons.access_time, color: AppColors.accent, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            '$durationMinutes minutes duration',
                            style: AppTextStyles.body.copyWith(
                              fontSize: 14,
                              color: AppColors.accent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Description Section
                      Text(
                        'About this Lesson',
                        style: AppTextStyles.subheading.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          lesson['description'] ?? 'No description provided.',
                          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, height: 1.5),
                        ),
                      ),
                    ],
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
