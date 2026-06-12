import 'package:get/get.dart';
import '../models/analytics_models.dart';
import '../repositories/analytics_repository.dart';

class AnalyticsController extends GetxController {
  final AnalyticsRepository _repository;

  AnalyticsController(this._repository);

  // Loading states
  final isAnalyticsLoading = false.obs;
  final isTrendsLoading = false.obs;
  final isGoalsLoading = false.obs;

  // Data
  final studentAnalytics = Rxn<StudentAnalyticsModel>();
  final subjectAnalyticsList = <SubjectAnalyticsModel>[].obs;
  final topicAnalyticsList = <TopicAnalyticsModel>[].obs;
  final trendsList = <PerformanceTrendModel>[].obs;
  final goalsList = <GoalModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  void fetchAllData() {
    fetchStudentAnalytics();
    fetchSubjectAnalytics();
    fetchTopicAnalytics();
    fetchTrends();
    fetchGoals();
  }

  Future<void> fetchStudentAnalytics() async {
    try {
      isAnalyticsLoading.value = true;
      final response = await _repository.getStudentAnalytics();
      if (response.statusCode == 200 && response.data['data'] != null) {
        studentAnalytics.value = StudentAnalyticsModel.fromJson(response.data['data']);
      }
    } catch (e) {
      print('Error loading student analytics: $e');
    } finally {
      isAnalyticsLoading.value = false;
    }
  }

  Future<void> fetchSubjectAnalytics() async {
    try {
      final response = await _repository.getSubjectAnalytics();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        subjectAnalyticsList.assignAll(
          data.map((item) => SubjectAnalyticsModel.fromJson(item)).toList(),
        );
      }
    } catch (e) {
      print('Error loading subject analytics: $e');
    }
  }

  Future<void> fetchTopicAnalytics() async {
    try {
      final response = await _repository.getTopicAnalytics();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        topicAnalyticsList.assignAll(
          data.map((item) => TopicAnalyticsModel.fromJson(item)).toList(),
        );
      }
    } catch (e) {
      print('Error loading topic analytics: $e');
    }
  }

  Future<void> fetchTrends() async {
    try {
      isTrendsLoading.value = true;
      final response = await _repository.getTrends();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        trendsList.assignAll(
          data.map((item) => PerformanceTrendModel.fromJson(item)).toList(),
        );
      }
    } catch (e) {
      print('Error loading trends: $e');
    } finally {
      isTrendsLoading.value = false;
    }
  }

  Future<void> fetchGoals() async {
    try {
      isGoalsLoading.value = true;
      final response = await _repository.getGoals();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        goalsList.assignAll(
          data.map((item) => GoalModel.fromJson(item)).toList(),
        );
      }
    } catch (e) {
      print('Error loading goals: $e');
    } finally {
      isGoalsLoading.value = false;
    }
  }

  Future<void> createGoal(String goalTitle, double targetValue) async {
    try {
      final response = await _repository.createGoal(goalTitle, targetValue);
      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Goal created successfully');
        fetchGoals();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create goal');
    }
  }

  Future<void> updateGoalProgress(String id, double completedValue) async {
    try {
      final response = await _repository.updateGoalProgress(id, completedValue);
      if (response.statusCode == 200) {
        fetchGoals();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update progress');
    }
  }

  Future<void> deleteGoal(String id) async {
    try {
      final response = await _repository.deleteGoal(id);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Goal deleted');
        fetchGoals();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete goal');
    }
  }

  Future<void> sendHeartbeat(double hours) async {
    try {
      final response = await _repository.sendHeartbeat(hours);
      if (response.statusCode == 200 && response.data['data'] != null) {
        studentAnalytics.value = StudentAnalyticsModel.fromJson(response.data['data']);
      }
    } catch (e) {
      print('Heartbeat log error: $e');
    }
  }
}
