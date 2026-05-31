import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/course_controller.dart';
import 'course_detail_view.dart';

class CourseListView extends GetView<CourseController> {
  const CourseListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Courses', style: AppTextStyles.heading.copyWith(fontSize: 20)),
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
          if (controller.isLoading.value && controller.coursesList.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }

          if (controller.errorMessage.value.isNotEmpty && controller.coursesList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.errorMessage.value,
                    style: AppTextStyles.body.copyWith(color: AppColors.error),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.fetchCourses,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (controller.coursesList.isEmpty) {
            return Center(
              child: Text(
                'No courses available.',
                style: AppTextStyles.body,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.fetchCourses,
            color: AppColors.accent,
            child: ListView.builder(
              controller: controller.scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: controller.coursesList.length + (controller.hasMore.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == controller.coursesList.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    ),
                  );
                }

                final course = controller.coursesList[index];
                return _buildCourseCard(context, course);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, dynamic course) {
    final title = course['title'] ?? 'No Title';
    final thumbnail = course['thumbnail'] ?? '';
    final totalLessons = course['totalLessons'] ?? 0;

    return Card(
      color: AppColors.cardBg,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Get.to(
            () => CourseDetailView(courseId: course['id']),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: thumbnail.isNotEmpty
                  ? Image.network(
                      thumbnail,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(color: AppColors.accent),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.secondary,
                          child: const Icon(
                            Icons.broken_image,
                            color: AppColors.textSecondary,
                            size: 48,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: AppColors.secondary,
                      child: const Icon(
                        Icons.image,
                        color: AppColors.textSecondary,
                        size: 48,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.heading.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (course['completionPercentage'] != null) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (course['completionPercentage'] as num).toDouble() / 100,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(course['completionPercentage'] as num).toStringAsFixed(0)}% Completed',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 12,
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.video_library, color: AppColors.accent, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            '$totalLessons Lessons',
                            style: AppTextStyles.body.copyWith(fontSize: 14, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.accent, Colors.blueAccent],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'View Course',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
