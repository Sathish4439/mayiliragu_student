class StudentAnswer {
  final String questionId;
  List<String>? selectedOptionIds; // For single/multi choice
  bool? booleanAnswer;             // For true/false
  String? textAnswer;              // For fill in blank
  String? descriptiveText;          // For essay/descriptive
  String? attachmentUrl;            // For handwritten scan/photo
  bool isFlagged;                  // Flagged for review
  bool isVisited;                  // Visited state

  StudentAnswer({
    required this.questionId,
    this.selectedOptionIds,
    this.booleanAnswer,
    this.textAnswer,
    this.descriptiveText,
    this.attachmentUrl,
    this.isFlagged = false,
    this.isVisited = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'selected_option_ids': selectedOptionIds,
      'boolean_answer': booleanAnswer,
      'text_answer': textAnswer,
      'descriptive_text': descriptiveText,
      'attachment_url': attachmentUrl,
      'is_flagged': isFlagged,
    };
  }

  // Helper to check if any answer is filled
  bool get hasAnswer {
    if (selectedOptionIds != null && selectedOptionIds!.isNotEmpty) return true;
    if (booleanAnswer != null) return true;
    if (textAnswer != null && textAnswer!.trim().isNotEmpty) return true;
    if (descriptiveText != null && descriptiveText!.trim().isNotEmpty) return true;
    if (attachmentUrl != null && attachmentUrl!.trim().isNotEmpty) return true;
    return false;
  }
}
