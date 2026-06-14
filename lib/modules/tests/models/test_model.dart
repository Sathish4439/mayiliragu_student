class TestModel {
  final String id;
  final String title;
  final String? description;
  final int duration; // in minutes
  final double cutoffMarks;
  final double totalMarks;
  final String? courseId;
  final String? moduleId;
  final String? categoryId;
  final String? subjectId;
  final String? topicId;
  final bool isPublished;
  final int questionCount;
  final int attemptsCount;
  final bool hasAttempted;
  final Map<String, dynamic>? latestAttempt;

  TestModel({
    required this.id,
    required this.title,
    this.description,
    required this.duration,
    required this.cutoffMarks,
    required this.totalMarks,
    this.courseId,
    this.moduleId,
    this.categoryId,
    this.subjectId,
    this.topicId,
    required this.isPublished,
    required this.questionCount,
    this.attemptsCount = 0,
    this.hasAttempted = false,
    this.latestAttempt,
  });

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
      cutoffMarks: (json['cutoff_marks'] as num).toDouble(),
      totalMarks: (json['total_marks'] as num).toDouble(),
      courseId: json['course_id'],
      moduleId: json['module_id'],
      categoryId: json['category_id'],
      subjectId: json['subject_id'],
      topicId: json['topic_id'],
      isPublished: json['is_published'] ?? false,
      questionCount: json['question_count'] ?? 0,
      attemptsCount: json['attempts_count'] ?? 0,
      hasAttempted: json['has_attempted'] ?? false,
      latestAttempt: json['latest_attempt'],
    );
  }
}
