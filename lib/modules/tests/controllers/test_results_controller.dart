import 'package:get/get.dart';

class TestResultsController extends GetxController {
  TestResultsController();

  // States
  final testId = ''.obs;
  final attemptId = ''.obs;
  final testTitle = 'Practice Test'.obs;
  final score = 0.obs;
  final correctCount = 0.obs;
  final wrongCount = 0.obs;
  final skippedCount = 0.obs;
  final accuracy = 0.obs;
  final timeTakenFormatted = '0m'.obs;
  final rank = 0.obs;
  final passed = false.obs;

  final classAvg = 0.obs;
  final topScore = 0.obs;

  final subjectPerformance = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      testId.value = args['test_id'] ?? '';
      attemptId.value = args['id'] ?? args['attempt_id'] ?? '';
      testTitle.value = args['test_title'] ?? 'Practice Test';
      score.value = args['score'] ?? 0;
      correctCount.value = args['correct'] ?? 0;
      wrongCount.value = args['wrong'] ?? 0;
      skippedCount.value = args['skipped'] ?? 0;
      accuracy.value = args['accuracy'] ?? 0;
      passed.value = args['passed'] ?? false;
      rank.value = args['rank'] ?? 0;
      classAvg.value = args['class_avg'] ?? 0;
      topScore.value = args['top_score'] ?? 0;

      final int timeSeconds = args['time_taken'] ?? 0;
      timeTakenFormatted.value = _formatSeconds(timeSeconds);

      final List<dynamic>? subjPerf = args['subject_performance'];
      if (subjPerf != null) {
        subjectPerformance.assignAll(
          subjPerf.map((e) => Map<String, dynamic>.from(e)).toList(),
        );
      }
    }
  }

  String _formatSeconds(int totalSeconds) {
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    
    if (hours > 0) {
      final String minsStr = minutes.toString().padLeft(2, '0');
      return '${hours}h ${minsStr}m';
    }
    return '${minutes}m';
  }

  void retakeTest() {
    if (testId.value.isNotEmpty) {
      // Clear navigation history and launch test runner
      Get.offNamed('/test-runner', arguments: testId.value);
    }
  }

  void viewSolutions() {
    if (attemptId.value.isNotEmpty) {
      Get.toNamed('/test-solutions', arguments: {
        'attempt_id': attemptId.value,
        'test_title': testTitle.value,
      });
    } else {
      Get.snackbar(
        'Solutions Unavailable',
        'Detailed solutions are not available for offline attempts.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void detailedAnalysis() {
    Get.snackbar(
      'Detailed Analysis',
      'Detailed analysis report is being generated.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
