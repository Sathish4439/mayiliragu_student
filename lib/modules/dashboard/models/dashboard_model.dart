class DashboardModel {
  final List<EnrolledCourse> enrolledCourses;
  final ContinueLearning? continueLearning;
  final List<RecentlyWatched> recentlyWatched;
  final UserProfile? profile;

  DashboardModel({
    required this.enrolledCourses,
    this.continueLearning,
    required this.recentlyWatched,
    this.profile,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json, {UserProfile? profile}) {
    final coursesList = json['enrolledCourses'] as List? ?? [];
    final List<EnrolledCourse> courses = coursesList
        .map((c) => EnrolledCourse.fromJson(c as Map<String, dynamic>))
        .toList();

    ContinueLearning? contLearn;
    if (json['continueLearning'] != null) {
      contLearn = ContinueLearning.fromJson(json['continueLearning'] as Map<String, dynamic>);
    }

    final recentList = json['recentlyWatched'] as List? ?? [];
    final List<RecentlyWatched> recent = recentList
        .map((r) => RecentlyWatched.fromJson(r as Map<String, dynamic>))
        .toList();

    return DashboardModel(
      enrolledCourses: courses,
      continueLearning: contLearn,
      recentlyWatched: recent,
      profile: profile,
    );
  }
}

class EnrolledCourse {
  final String id;
  final String title;
  final String thumbnail;
  final int totalLessons;
  final double progressPercentage;

  EnrolledCourse({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.totalLessons,
    required this.progressPercentage,
  });

  factory EnrolledCourse.fromJson(Map<String, dynamic> json) {
    return EnrolledCourse(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      totalLessons: json['totalLessons'] as int? ?? 0,
      progressPercentage: (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ContinueLearning {
  final String lessonId;
  final String lessonTitle;
  final String courseId;
  final int watchedSeconds;
  final int duration;

  ContinueLearning({
    required this.lessonId,
    required this.lessonTitle,
    required this.courseId,
    required this.watchedSeconds,
    required this.duration,
  });

  double get progress => duration > 0 ? watchedSeconds / duration : 0.0;
  int get progressPercentage => (progress * 100).toInt();

  factory ContinueLearning.fromJson(Map<String, dynamic> json) {
    return ContinueLearning(
      lessonId: json['lessonId'] as String? ?? '',
      lessonTitle: json['lessonTitle'] as String? ?? '',
      courseId: json['courseId'] as String? ?? '',
      watchedSeconds: json['watchedSeconds'] as int? ?? 0,
      duration: json['duration'] as int? ?? 1,
    );
  }
}

class RecentlyWatched {
  final String lessonId;
  final String lessonTitle;
  final String lastViewedAt;

  RecentlyWatched({
    required this.lessonId,
    required this.lessonTitle,
    required this.lastViewedAt,
  });

  factory RecentlyWatched.fromJson(Map<String, dynamic> json) {
    return RecentlyWatched(
      lessonId: json['lessonId'] as String? ?? '',
      lessonTitle: json['lessonTitle'] as String? ?? '',
      lastViewedAt: json['lastViewedAt'] as String? ?? '',
    );
  }
}

class UserProfile {
  final String name;
  final String email;

  UserProfile({
    required this.name,
    required this.email,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }
}
