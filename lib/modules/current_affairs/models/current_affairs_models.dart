class CurrentAffairQuiz {
  final String id;
  final String currentAffairId;
  final String questionEn;
  final String? questionTa;
  final List<String> optionsEn;
  final List<String>? optionsTa;
  final String correctAnswer;
  final String? explanationEn;
  final String? explanationTa;
  final CurrentAffairQuizAttempt? previousAttempt;

  CurrentAffairQuiz({
    required this.id,
    required this.currentAffairId,
    required this.questionEn,
    this.questionTa,
    required this.optionsEn,
    this.optionsTa,
    required this.correctAnswer,
    this.explanationEn,
    this.explanationTa,
    this.previousAttempt,
  });

  factory CurrentAffairQuiz.fromJson(Map<String, dynamic> json) {
    return CurrentAffairQuiz(
      id: json['id'],
      currentAffairId: json['currentAffairId'],
      questionEn: json['questionEn'],
      questionTa: json['questionTa'],
      optionsEn: List<String>.from(json['optionsEn']),
      optionsTa: json['optionsTa'] != null ? List<String>.from(json['optionsTa']) : null,
      correctAnswer: json['correctAnswer'],
      explanationEn: json['explanationEn'],
      explanationTa: json['explanationTa'],
      previousAttempt: json['previousAttempt'] != null 
          ? CurrentAffairQuizAttempt.fromJson(json['previousAttempt'])
          : null,
    );
  }
}

class CurrentAffairQuizAttempt {
  final String id;
  final String quizId;
  final String selectedAnswer;
  final bool isCorrect;

  CurrentAffairQuizAttempt({
    required this.id,
    required this.quizId,
    required this.selectedAnswer,
    required this.isCorrect,
  });

  factory CurrentAffairQuizAttempt.fromJson(Map<String, dynamic> json) {
    return CurrentAffairQuizAttempt(
      id: json['id'],
      quizId: json['quizId'],
      selectedAnswer: json['selectedAnswer'],
      isCorrect: json['isCorrect'],
    );
  }
}

class CurrentAffair {
  final String id;
  final String titleEn;
  final String? titleTa;
  final String summaryEn;
  final String? summaryTa;
  final String contentEn;
  final String? contentTa;
  final String? examImportanceEn;
  final String? examImportanceTa;
  final String? keyFactsEn;
  final String? keyFactsTa;
  final String? prelimsNotesEn;
  final String? prelimsNotesTa;
  final String? mainsNotesEn;
  final String? mainsNotesTa;
  final String? videoUrl;
  final String category;
  final DateTime publishedDate;
  final bool isBookmarked;
  final int quizCount;

  CurrentAffair({
    required this.id,
    required this.titleEn,
    this.titleTa,
    required this.summaryEn,
    this.summaryTa,
    required this.contentEn,
    this.contentTa,
    this.examImportanceEn,
    this.examImportanceTa,
    this.keyFactsEn,
    this.keyFactsTa,
    this.prelimsNotesEn,
    this.prelimsNotesTa,
    this.mainsNotesEn,
    this.mainsNotesTa,
    this.videoUrl,
    required this.category,
    required this.publishedDate,
    required this.isBookmarked,
    required this.quizCount,
  });

  factory CurrentAffair.fromJson(Map<String, dynamic> json) {
    return CurrentAffair(
      id: json['id'],
      titleEn: json['titleEn'],
      titleTa: json['titleTa'],
      summaryEn: json['summaryEn'],
      summaryTa: json['summaryTa'],
      contentEn: json['contentEn'],
      contentTa: json['contentTa'],
      examImportanceEn: json['examImportanceEn'],
      examImportanceTa: json['examImportanceTa'],
      keyFactsEn: json['keyFactsEn'],
      keyFactsTa: json['keyFactsTa'],
      prelimsNotesEn: json['prelimsNotesEn'],
      prelimsNotesTa: json['prelimsNotesTa'],
      mainsNotesEn: json['mainsNotesEn'],
      mainsNotesTa: json['mainsNotesTa'],
      videoUrl: json['videoUrl'],
      category: json['category'],
      publishedDate: DateTime.parse(json['publishedDate']),
      isBookmarked: json['isBookmarked'] ?? false,
      quizCount: json['_count'] != null ? (json['_count']['quizzes'] ?? 0) : 0,
    );
  }
}

class MonthlyMagazine {
  final String id;
  final String title;
  final int month;
  final int year;
  final String pdfUrl;
  final DateTime publishedAt;

  MonthlyMagazine({
    required this.id,
    required this.title,
    required this.month,
    required this.year,
    required this.pdfUrl,
    required this.publishedAt,
  });

  factory MonthlyMagazine.fromJson(Map<String, dynamic> json) {
    return MonthlyMagazine(
      id: json['id'],
      title: json['title'],
      month: json['month'],
      year: json['year'],
      pdfUrl: json['pdfUrl'],
      publishedAt: DateTime.parse(json['publishedAt']),
    );
  }
}

class GovernmentScheme {
  final String id;
  final String titleEn;
  final String? titleTa;
  final String descriptionEn;
  final String? descriptionTa;
  final String type;

  GovernmentScheme({
    required this.id,
    required this.titleEn,
    this.titleTa,
    required this.descriptionEn,
    this.descriptionTa,
    required this.type,
  });

  factory GovernmentScheme.fromJson(Map<String, dynamic> json) {
    return GovernmentScheme(
      id: json['id'],
      titleEn: json['titleEn'],
      titleTa: json['titleTa'],
      descriptionEn: json['descriptionEn'],
      descriptionTa: json['descriptionTa'],
      type: json['type'],
    );
  }
}

class ImportantDate {
  final String id;
  final String titleEn;
  final String? titleTa;
  final DateTime date;
  final String type;

  ImportantDate({
    required this.id,
    required this.titleEn,
    this.titleTa,
    required this.date,
    required this.type,
  });

  factory ImportantDate.fromJson(Map<String, dynamic> json) {
    return ImportantDate(
      id: json['id'],
      titleEn: json['titleEn'],
      titleTa: json['titleTa'],
      date: DateTime.parse(json['date']),
      type: json['type'],
    );
  }
}
