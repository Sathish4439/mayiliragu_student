import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../app/routes/app_routes.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard', style: AppTextStyles.heading.copyWith(fontSize: 20)),
        backgroundColor: AppColors.backgroundStart,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.textPrimary),
            onPressed: () => Get.toNamed(Routes.PROFILE),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textPrimary),
            onPressed: controller.logout,
          ),
        ],
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
              child: Text(
                controller.errorMessage.value,
                style: AppTextStyles.body.copyWith(color: AppColors.error),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.fetchDashboardData,
            color: AppColors.accent,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContinueLearning(),
                  const SizedBox(height: 24),
                  _buildMyCourses(),
                  const SizedBox(height: 24),
                  _buildRecentlyWatched(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildContinueLearning() {
    final continueLearning = controller.continueLearning.value;
    if (continueLearning == null) return const SizedBox.shrink();

    final watched = continueLearning['watchedSeconds'] ?? 0;
    final duration = continueLearning['duration'] ?? 1;
    final progress = watched / duration;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Continue Learning', style: AppTextStyles.subheading.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          color: AppColors.cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.accentDark.withAlpha(50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow, color: AppColors.accent, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        continueLearning['lessonTitle'] ?? '',
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.border,
                        color: AppColors.accent,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(progress * 100).toInt()}% completed',
                        style: AppTextStyles.subheading.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMyCourses() {
    final courses = controller.enrolledCourses;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('My Courses', style: AppTextStyles.subheading.copyWith(fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => Get.toNamed(Routes.COURSES),
              child: const Text('See All', style: TextStyle(color: AppColors.accent)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (courses.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'No enrolled courses yet.',
                style: AppTextStyles.subheading.copyWith(fontSize: 14),
              ),
            ),
          )
        else
          ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            final progress = (course['progressPercentage'] ?? 0.0) / 100.0;

            return Card(
              color: AppColors.cardBg,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    course['thumbnail'] ?? '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 50,
                      height: 50,
                      color: AppColors.border,
                      child: const Icon(Icons.book, color: AppColors.textSecondary),
                    ),
                  ),
                ),
                title: Text(
                  course['title'] ?? '',
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      '${course['totalLessons'] ?? 0} lessons',
                      style: AppTextStyles.subheading.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: AppColors.border,
                            color: AppColors.accent,
                            minHeight: 4,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(progress * 100).toStringAsFixed(1)}%',
                          style: AppTextStyles.subheading.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentlyWatched() {
    final recent = controller.recentlyWatched;
    if (recent.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recently Watched', style: AppTextStyles.subheading.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recent.length,
          itemBuilder: (context, index) {
            final lesson = recent[index];
            return Card(
              color: AppColors.cardBg,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.history, color: AppColors.textSecondary),
                title: Text(
                  lesson['lessonTitle'] ?? '',
                  style: AppTextStyles.body,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
