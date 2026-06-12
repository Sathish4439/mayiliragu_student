class StudentAnalyticsModel {
  final double performanceScore;
  final double readinessScore;
  final double studyHours;
  final int learningStreak;

  StudentAnalyticsModel({
    required this.performanceScore,
    required this.readinessScore,
    required this.studyHours,
    required this.learningStreak,
  });

  factory StudentAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return StudentAnalyticsModel(
      performanceScore: (json['performanceScore'] ?? 0).toDouble(),
      readinessScore: (json['readinessScore'] ?? 0).toDouble(),
      studyHours: (json['studyHours'] ?? 0).toDouble(),
      learningStreak: json['learningStreak'] ?? 0,
    );
  }
}

class SubjectAnalyticsModel {
  final String id;
  final String subjectId;
  final double accuracy;
  final double averageScore;
  final String subjectName;

  SubjectAnalyticsModel({
    required this.id,
    required this.subjectId,
    required this.accuracy,
    required this.averageScore,
    required this.subjectName,
  });

  factory SubjectAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return SubjectAnalyticsModel(
      id: json['id'] ?? '',
      subjectId: json['subjectId'] ?? '',
      accuracy: (json['accuracy'] ?? 0).toDouble(),
      averageScore: (json['averageScore'] ?? 0).toDouble(),
      subjectName: json['subject']?['name'] ?? 'General',
    );
  }
}

class TopicAnalyticsModel {
  final String id;
  final String topicId;
  final double accuracy;
  final double averageScore;
  final String topicName;

  TopicAnalyticsModel({
    required this.id,
    required this.topicId,
    required this.accuracy,
    required this.averageScore,
    required this.topicName,
  });

  factory TopicAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return TopicAnalyticsModel(
      id: json['id'] ?? '',
      topicId: json['topicId'] ?? '',
      accuracy: (json['accuracy'] ?? 0).toDouble(),
      averageScore: (json['averageScore'] ?? 0).toDouble(),
      topicName: json['topic']?['name'] ?? 'General',
    );
  }
}

class PerformanceTrendModel {
  final DateTime date;
  final double score;
  final double accuracy;
  final double studyHours;

  PerformanceTrendModel({
    required this.date,
    required this.score,
    required this.accuracy,
    required this.studyHours,
  });

  factory PerformanceTrendModel.fromJson(Map<String, dynamic> json) {
    return PerformanceTrendModel(
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      score: (json['score'] ?? 0).toDouble(),
      accuracy: (json['accuracy'] ?? 0).toDouble(),
      studyHours: (json['studyHours'] ?? 0).toDouble(),
    );
  }
}

class GoalModel {
  final String id;
  final String goalTitle;
  final double targetValue;
  final double completedValue;
  final String status;

  GoalModel({
    required this.id,
    required this.goalTitle,
    required this.targetValue,
    required this.completedValue,
    required this.status,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] ?? '',
      goalTitle: json['goalTitle'] ?? '',
      targetValue: (json['targetValue'] ?? 0).toDouble(),
      completedValue: (json['completedValue'] ?? 0).toDouble(),
      status: json['status'] ?? 'PENDING',
    );
  }
}
