import 'package:get/get.dart';
import '../repositories/tests_repository.dart';

class TestSolutionsController extends GetxController {
  final TestsRepository _repository;

  TestSolutionsController(this._repository);

  // Arguments
  late final String attemptId;
  late final String testTitle;

  // States
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final attemptData = Rxn<Map<String, dynamic>>();
  final questions = <Map<String, dynamic>>[].obs;
  
  // Filter Tab: 'all', 'correct', 'wrong'
  final activeFilter = 'all'.obs;

  // Expandable Explanations map: questionId -> isExpanded
  final expandedExplanations = <String, bool>{}.obs;

  // Bookmark states
  final bookmarkedQuestions = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    attemptId = args?['attempt_id'] ?? '';
    testTitle = args?['test_title'] ?? 'Solutions';
    
    if (attemptId.isNotEmpty) {
      fetchAttemptDetails();
    } else {
      errorMessage.value = 'Invalid attempt ID';
    }
  }

  Future<void> fetchAttemptDetails() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.getAttemptDetails(attemptId);

      if (response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.data['data'] ?? {});
        attemptData.value = data;
        
        final List<dynamic>? qList = data['questions'];
        if (qList != null) {
          questions.assignAll(
            qList.map((e) => Map<String, dynamic>.from(e)).toList(),
          );
        }
      } else {
        errorMessage.value = 'Failed to load solutions';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void setFilter(String filter) {
    activeFilter.value = filter;
  }

  void toggleExplanation(String questionId) {
    final bool current = expandedExplanations[questionId] ?? false;
    expandedExplanations[questionId] = !current;
  }

  void toggleBookmark(String questionId) {
    if (bookmarkedQuestions.contains(questionId)) {
      bookmarkedQuestions.remove(questionId);
      Get.snackbar(
        'Bookmark Removed',
        'Question removed from your saved list.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      bookmarkedQuestions.add(questionId);
      Get.snackbar(
        'Question Bookmarked',
        'Question saved for review in your profile.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Getters for counts
  int get totalCount => questions.length;
  
  int get correctCount {
    return questions.where((q) {
      final ua = q['user_answer'];
      return ua != null && ua['is_correct'] == true;
    }).length;
  }

  int get wrongCount {
    return questions.where((q) {
      final ua = q['user_answer'];
      return ua == null || ua['is_correct'] == false;
    }).length;
  }

  // Filtered list getter
  List<Map<String, dynamic>> get filteredQuestions {
    if (activeFilter.value == 'correct') {
      return questions.where((q) {
        final ua = q['user_answer'];
        return ua != null && ua['is_correct'] == true;
      }).toList();
    } else if (activeFilter.value == 'wrong') {
      return questions.where((q) {
        final ua = q['user_answer'];
        return ua == null || ua['is_correct'] == false;
      }).toList();
    }
    return questions;
  }
}
