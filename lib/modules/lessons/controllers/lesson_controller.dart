import 'package:get/get.dart';
import 'package:better_player_enhanced/better_player.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/secure_storage_service.dart';
import '../repositories/lesson_repository.dart';

class LessonController extends GetxController {
  final LessonRepository _repository;

  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final lessonData = Rxn<Map<String, dynamic>>();

  BetterPlayerController? betterPlayerController;
  
  String? _currentLessonId;
  int _lastSyncedPosition = 0;

  LessonController(this._repository);

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

        final driveFileId = data['driveFileId']?.toString() ?? '';
        await _initializeVideoPlayer(driveFileId, startSeconds: startSeconds);
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
      if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
        final videoPlayerController = betterPlayerController!.videoPlayerController;
        if (videoPlayerController != null) {
          final currentPos = videoPlayerController.value.position.inSeconds;
          if ((currentPos - _lastSyncedPosition).abs() >= 30) {
            _syncProgress(currentPos);
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
    if (betterPlayerController != null && _currentLessonId != null) {
      final videoPlayerController = betterPlayerController!.videoPlayerController;
      if (videoPlayerController != null) {
        final currentPos = videoPlayerController.value.position.inSeconds;
        if (currentPos != _lastSyncedPosition) {
          _syncProgress(currentPos);
        }
      }
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
