import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio_lib;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path_lib;

class VideoDownloadService extends GetxService {
  late final String _manifestPath;
  final Map<String, String> _manifest = {};
  final dio_lib.Dio _dio = dio_lib.Dio();

  // Observable download progress map: lessonId -> progress (0.0 to 1.0)
  final downloadProgress = <String, double>{}.obs;
  // Observable downloading state map: lessonId -> bool
  final isDownloading = <String, bool>{}.obs;

  Future<VideoDownloadService> init() async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final downloadDir = Directory(path_lib.join(docDir.path, 'offline_videos'));
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }
      _manifestPath = path_lib.join(downloadDir.path, 'downloads_manifest.json');
      await _loadManifest();
    } catch (e) {
      debugPrint('Error initializing VideoDownloadService: $e');
    }
    return this;
  }

  Future<void> _loadManifest() async {
    try {
      final file = File(_manifestPath);
      if (await file.exists()) {
        final content = await file.readAsString();
        final jsonMap = json.decode(content) as Map<String, dynamic>;
        jsonMap.forEach((key, value) {
          _manifest[key] = value.toString();
        });
      }
    } catch (e) {
      debugPrint('Error loading downloads manifest: $e');
    }
  }

  Future<void> _saveManifest() async {
    try {
      final file = File(_manifestPath);
      await file.writeAsString(json.encode(_manifest));
    } catch (e) {
      debugPrint('Error saving downloads manifest: $e');
    }
  }

  bool isDownloaded(String lessonId) {
    if (!_manifest.containsKey(lessonId)) return false;
    final filePath = _manifest[lessonId]!;
    final file = File(filePath);
    return file.existsSync();
  }

  String? getLocalVideoPath(String lessonId) {
    if (!isDownloaded(lessonId)) return null;
    return _manifest[lessonId];
  }

  Future<bool> downloadVideo(
    String lessonId,
    String videoUrl, {
    Map<String, String>? headers,
    required VoidCallback onComplete,
    required Function(String error) onError,
  }) async {
    if (isDownloading[lessonId] == true) return false;

    isDownloading[lessonId] = true;
    downloadProgress[lessonId] = 0.0;

    try {
      final docDir = await getApplicationDocumentsDirectory();
      final localFilePath = path_lib.join(
        docDir.path,
        'offline_videos',
        '$lessonId.mp4',
      );

      await _dio.download(
        videoUrl,
        localFilePath,
        options: dio_lib.Options(headers: headers),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;
            downloadProgress[lessonId] = progress;
          }
        },
      );

      // Verify file downloaded successfully and is not empty
      final file = File(localFilePath);
      if (await file.exists() && await file.length() > 0) {
        _manifest[lessonId] = localFilePath;
        await _saveManifest();
        onComplete();
        return true;
      } else {
        throw Exception('Downloaded file is empty or missing');
      }
    } catch (e) {
      debugPrint('Error downloading video: $e');
      onError(e.toString());
      return false;
    } finally {
      isDownloading[lessonId] = false;
      downloadProgress.remove(lessonId);
    }
  }

  Future<void> deleteVideo(String lessonId) async {
    try {
      if (_manifest.containsKey(lessonId)) {
        final filePath = _manifest[lessonId]!;
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
        }
        _manifest.remove(lessonId);
        await _saveManifest();
      }
    } catch (e) {
      debugPrint('Error deleting video: $e');
    }
  }
}
