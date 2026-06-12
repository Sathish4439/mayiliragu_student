import 'package:get/get.dart';
import 'package:better_player_enhanced/better_player.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/secure_storage_service.dart';
import '../repositories/lesson_repository.dart';
import '../repositories/notes_repository.dart';

class LessonController extends GetxController {
  final LessonRepository _repository;
  final NotesRepository _notesRepository;

  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final lessonData = Rxn<Map<String, dynamic>>();

  // Tab index: 0 = Notes, 1 = Resources
  final activeTabIndex = 0.obs;

  // Completion status
  final isCompleted = false.obs;

  // Study notes list state
  final notes = <Map<String, dynamic>>[].obs;
  final isLoadingNotes = false.obs;

  BetterPlayerController? betterPlayerController;
  
  String? _currentLessonId;
  int _lastSyncedPosition = 0;
  int _latestPosition = 0;

  LessonController(this._repository, this._notesRepository);

  @override
  void onInit() {
    super.onInit();
    final String? lessonId = Get.parameters['id'] ?? Get.arguments?.toString();
    if (lessonId != null) {
      fetchLessonDetail(lessonId);
    } else {
      errorMessage.value = 'No lesson ID provided';
      isLoading.value = false;
    }
  }

  Future<void> fetchLessonDetail(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      _currentLessonId = id;
      _lastSyncedPosition = 0;

      final response = await _repository.getLessonById(id);

      if (response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.data);
        lessonData.value = data;

        int startSeconds = 0;
        if (data['progress'] != null && data['progress']['watchedSeconds'] != null) {
          startSeconds = data['progress']['watchedSeconds'] as int;
          _lastSyncedPosition = startSeconds;
        }
        _latestPosition = startSeconds;

        if (data['progress'] != null && data['progress']['completed'] != null) {
          isCompleted.value = data['progress']['completed'] as bool;
        }

        final driveFileId = data['driveFileId']?.toString() ?? '';
        await _initializeVideoPlayer(driveFileId, startSeconds: startSeconds);
        fetchNotes(id);
      } else {
        errorMessage.value = 'Failed to load lesson details';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  bool get isVideoPlayerSupported => GetPlatform.isAndroid || GetPlatform.isIOS || GetPlatform.isWeb;

  Future<void> _initializeVideoPlayer(String driveFileId, {int startSeconds = 0}) async {
    if (!isVideoPlayerSupported) {
      return;
    }

    // If the driveFileId is already a full URL (or for fallback test stream)
    String videoUrl = driveFileId;
    Map<String, String>? headers;

    if (driveFileId.isEmpty) {
      // Fallback test video stream if none provided
      videoUrl = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
    } else {
      String extractedId = driveFileId;
      final bool isGoogleDriveUrl = driveFileId.contains('drive.google.com');

      if (isGoogleDriveUrl) {
        // Extract the file ID from Google Drive URL patterns:
        // 1. /file/d/FILE_ID/view...
        final regExp1 = RegExp(r'/file/d/([a-zA-Z0-9-_]+)');
        final match1 = regExp1.firstMatch(driveFileId);
        if (match1 != null && match1.groupCount >= 1) {
          extractedId = match1.group(1)!;
        } else {
          // 2. ?id=FILE_ID or &id=FILE_ID
          final regExp2 = RegExp(r'[?&]id=([a-zA-Z0-9-_]+)');
          final match2 = regExp2.firstMatch(driveFileId);
          if (match2 != null && match2.groupCount >= 1) {
            extractedId = match2.group(1)!;
          }
        }
      }

      if (isGoogleDriveUrl || !driveFileId.startsWith('http')) {
        // Use backend proxy streaming endpoint
        videoUrl = '${ApiConstants.baseUrl}/lessons/stream/$extractedId';
        final token = await Get.find<SecureStorageService>().getAccessToken();
        if (token != null) {
          headers = {
            'Authorization': 'Bearer $token',
          };
        }
      }
    }

    final BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      videoUrl,
      headers: headers,
    );

    betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        autoPlay: false,
        looping: false,
        startAt: Duration(seconds: startSeconds),
        placeholder: const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      ),
      betterPlayerDataSource: dataSource,
    );

    betterPlayerController!.addEventsListener((BetterPlayerEvent event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        if (startSeconds > 0) {
          betterPlayerController!.seekTo(Duration(seconds: startSeconds));
        }
      }
      if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
        final videoPlayerController = betterPlayerController!.videoPlayerController;
        if (videoPlayerController != null) {
          final currentPos = videoPlayerController.value.position.inSeconds;
          if (currentPos > 0) {
            _latestPosition = currentPos;
            if ((currentPos - _lastSyncedPosition).abs() >= 30) {
              _syncProgress(currentPos);
            }
          }
        }
      }
    });
  }

  Future<void> _syncProgress(int currentPos) async {
    if (_currentLessonId == null) return;
    _lastSyncedPosition = currentPos;
    try {
      await _repository.updateProgress(_currentLessonId!, currentPos);
    } catch (e) {
      debugPrint('Failed to sync progress: $e');
    }
  }

  void _syncProgressOnClose() {
    if (_currentLessonId != null && _latestPosition > 0 && _latestPosition != _lastSyncedPosition) {
      _syncProgress(_latestPosition);
    }
  }

  Future<void> fetchNotes(String lessonId) async {
    try {
      isLoadingNotes.value = true;
      final response = await _notesRepository.getNotesByLesson(lessonId);
      if (response.statusCode == 200) {
        notes.value = List<Map<String, dynamic>>.from(response.data);
      }
    } catch (e) {
      debugPrint('Error fetching notes: $e');
    } finally {
      isLoadingNotes.value = false;
    }
  }

  Future<void> addNote(String content) async {
    if (_currentLessonId == null || content.trim().isEmpty) return;
    try {
      final currentPos = betterPlayerController?.videoPlayerController?.value.position.inSeconds ?? 0;
      final response = await _notesRepository.createNote(
        lessonId: _currentLessonId!,
        timestamp: currentPos,
        content: content.trim(),
      );
      if (response.statusCode == 201) {
        fetchNotes(_currentLessonId!);
        Get.snackbar(
          'Success',
          'Note added successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.brandPurple.withValues(alpha: 0.1),
          colorText: AppColors.brandPurple,
        );
      }
    } catch (e) {
      debugPrint('Error adding note: $e');
    }
  }

  Future<void> editNote(String id, String content) async {
    if (_currentLessonId == null || content.trim().isEmpty) return;
    try {
      final response = await _notesRepository.updateNote(
        id: id,
        content: content.trim(),
      );
      if (response.statusCode == 200) {
        fetchNotes(_currentLessonId!);
        Get.snackbar(
          'Success',
          'Note updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.brandPurple.withValues(alpha: 0.1),
          colorText: AppColors.brandPurple,
        );
      }
    } catch (e) {
      debugPrint('Error editing note: $e');
    }
  }

  Future<void> deleteNote(String id) async {
    if (_currentLessonId == null) return;
    try {
      final response = await _notesRepository.deleteNote(id);
      if (response.statusCode == 200) {
        fetchNotes(_currentLessonId!);
        Get.snackbar(
          'Success',
          'Note deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.brandPurple.withValues(alpha: 0.1),
          colorText: AppColors.brandPurple,
        );
      }
    } catch (e) {
      debugPrint('Error deleting note: $e');
    }
  }

  void seekToTimestamp(int seconds) {
    if (isVideoPlayerSupported && betterPlayerController != null) {
      betterPlayerController!.seekTo(Duration(seconds: seconds));
      betterPlayerController!.play();
    }
  }

  Future<void> markLessonAsComplete() async {
    if (_currentLessonId == null) return;
    try {
      final response = await _repository.markAsComplete(_currentLessonId!);
      if (response.statusCode == 200) {
        isCompleted.value = true;
        Get.snackbar(
          'Success',
          'Lesson marked as complete!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.brandPurple.withValues(alpha: 0.1),
          colorText: AppColors.brandPurple,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to mark lesson as complete: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    }
  }

  @override
  void onClose() {
    _syncProgressOnClose();
    if (isVideoPlayerSupported) {
      betterPlayerController?.dispose();
    }
    super.onClose();
  }
}
