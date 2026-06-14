import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/course_image.dart';
import '../repositories/course_repository.dart';
import '../models/course_detail_model.dart';
import '../../../app/routes/app_routes.dart';

class CourseDetailView extends StatefulWidget {
  final String courseId;

  const CourseDetailView({super.key, required this.courseId});

  @override
  State<CourseDetailView> createState() => _CourseDetailViewState();
}

class _CourseDetailViewState extends State<CourseDetailView> {
  late final CourseRepository _repository;
  bool _isLoading = true;
  String _errorMessage = '';
  CourseDetailModel? _courseData;

  @override
  void initState() {
    super.initState();
    _repository = Get.find<CourseRepository>();
    _fetchCourseDetails();
  }

  Future<void> _fetchCourseDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final response = await _repository.getCourseById(widget.courseId);

      if (response.statusCode == 200) {
        setState(() {
          _courseData = CourseDetailModel.fromJson(response.data['data'] as Map<String, dynamic>);
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load course details';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              )
            : _errorMessage.isNotEmpty || _courseData == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _errorMessage.isNotEmpty ? _errorMessage : 'Course details not found.',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchCourseDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : CustomScrollView(
                slivers: [
                  _buildSliverAppBar(),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About this Course',
                            style: AppTextStyles.subheading.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _courseData?.description ??
                                'No description provided.',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Course Content',
                            style: AppTextStyles.subheading.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                  _buildModulesList(),
                ],
              ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    final title = _courseData?.title ?? 'Course Details';
    final thumbnail = _courseData?.thumbnail ?? '';

    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppColors.backgroundStart,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title,
          style: AppTextStyles.heading.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            shadows: [
              const Shadow(
                offset: Offset(0, 1),
                blurRadius: 4,
                color: Colors.black54,
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            CourseImage(
              imageUrl: thumbnail,
              fit: BoxFit.cover,
              placeholder: const Icon(
                Icons.image,
                size: 80,
                color: AppColors.textSecondary,
              ),
              errorWidget: const Icon(
                Icons.broken_image,
                size: 80,
                color: AppColors.textSecondary,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModulesList() {
    final modules = _courseData?.modules ?? [];

    if (modules.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('No modules available.', style: AppTextStyles.body),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final module = modules[index];
        final lessons = module.lessons;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ExpansionTile(
            shape: const Border(),
            collapsedShape: const Border(),
            title: Text(
              module.title.isNotEmpty ? module.title : 'Module ${index + 1}',
              style: AppTextStyles.heading.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              '${lessons.length} lessons',
              style: AppTextStyles.body.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            iconColor: AppColors.accent,
            collapsedIconColor: AppColors.textSecondary,
            children: lessons
                .map<Widget>((lesson) => _buildLessonItem(lesson))
                .toList(),
          ),
        );
      }, childCount: modules.length),
    );
  }

  Widget _buildLessonItem(LessonModel lesson) {
    final title = lesson.title.isNotEmpty ? lesson.title : 'Untitled Lesson';
    final durationSeconds = lesson.duration;
    final durationMinutes = (durationSeconds / 60).toStringAsFixed(1);
    final isCompleted = lesson.progress?.completed == true;

    return ListTile(
      leading: Icon(
        isCompleted ? Icons.check_circle : Icons.play_circle_outline,
        color: isCompleted ? Colors.green : AppColors.accent,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTextStyles.body.copyWith(
          fontSize: 14,
          color: isCompleted ? AppColors.textSecondary : null,
          decoration: isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Text(
        '$durationMinutes min',
        style: AppTextStyles.body.copyWith(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      onTap: () async {
        await Get.toNamed(Routes.LESSON_DETAIL, arguments: lesson.id);
        _fetchCourseDetails();
      },
    );
  }
}
