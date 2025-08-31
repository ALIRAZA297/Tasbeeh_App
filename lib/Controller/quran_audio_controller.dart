import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../Model/audio_model.dart';
import '../Utils/quran_audios.dart';

class QuranAudioController extends GetxController {
  final RxBool isLoading = false.obs;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Rx<int?> _currentlyPlayingIndex = Rx<int?>(null);
  final RxBool _isPlaying = false.obs;
  final RxMap<int, bool> _isBufferingAudio = <int, bool>{}.obs;
  final RxMap<int, bool> _isDownloadingAudio = <int, bool>{}.obs;
  late final List<AudioModel> _audioData;
  Directory? _audioCacheDirectory;
  bool _isDisposed = false;
  bool _isCacheInitialized = false;

  QuranAudioController({VoidCallback? onDataLoaded}) {
    debugPrint('QuranAudioController initialized for audio');
    _initializeAudioData();
    _initializeCacheDirectories();
    _setupAudioListeners();
  }

  void _initializeAudioData() {
    try {
      _audioData = AudioModel.fromJsonList(jsonDecode(surahAudioData));
      debugPrint('Audio data initialized with ${_audioData.length} surahs');
    } catch (e) {
      debugPrint('Error initializing audio data: $e');
      _audioData = [];
    }
  }

  Future<void> _initializeCacheDirectories() async {
    if (_isCacheInitialized || _isDisposed) return;
    try {
      final appDir = await getApplicationDocumentsDirectory();
      _audioCacheDirectory = Directory('${appDir.path}/quran_audio_cache');

      if (!await _audioCacheDirectory!.exists()) {
        await _audioCacheDirectory!.create(recursive: true);
        debugPrint(
            'Created audio cache directory: ${_audioCacheDirectory!.path}');
      }
      _isCacheInitialized = true;
      debugPrint('Audio cache directory initialized successfully');
    } catch (e) {
      debugPrint('Error initializing audio cache directory: $e');
      _isCacheInitialized = false;
    }
  }

  void _setupAudioListeners() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (_isDisposed) return;

      final currentIndex = _currentlyPlayingIndex.value;
      if (currentIndex == null) return;

      switch (state) {
        case PlayerState.playing:
          _isPlaying.value = true;
          _isBufferingAudio[currentIndex] = false;
          _isDownloadingAudio[currentIndex] = false;
          update();
          break;
        case PlayerState.paused:
          _isPlaying.value = false;
          _isBufferingAudio[currentIndex] = false;
          _isDownloadingAudio[currentIndex] = false;
          update();
          break;
        case PlayerState.stopped:
          _resetAudioState();
          break;
        case PlayerState.completed:
          _resetAudioState();
          break;
        default:
          break;
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (_isDisposed) return;
      _resetAudioState();
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      if (_isDisposed) return;
      debugPrint('Audio duration: ${duration.inSeconds} seconds');
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (_isDisposed) return;
      // You can add progress tracking here if needed
    });
  }

  void _resetAudioState() {
    if (_isDisposed) return;
    final currentIndex = _currentlyPlayingIndex.value;
    if (currentIndex != null) {
      _isBufferingAudio[currentIndex] = false;
      _isDownloadingAudio[currentIndex] = false;
    }
    _isPlaying.value = false;
    _currentlyPlayingIndex.value = null;
    update();
  }

  // Getters
  bool isPlaying(int index) =>
      _currentlyPlayingIndex.value == index && _isPlaying.value;

  bool isBufferingAudio(int index) => _isBufferingAudio[index] ?? false;

  bool isDownloadingAudio(int index) => _isDownloadingAudio[index] ?? false;

  bool isLoadingAudio(int index) =>
      isBufferingAudio(index) || isDownloadingAudio(index);

  bool get hasAnyAudioPlaying =>
      _isPlaying.value && _currentlyPlayingIndex.value != null;

  int? get currentlyPlayingIndex => _currentlyPlayingIndex.value;

  String _getCacheFilePath(int surahNumber, int verseIndex) {
    if (_audioCacheDirectory == null) {
      throw Exception('Cache directory not initialized');
    }
    final path =
        '${_audioCacheDirectory!.path}/surah_${surahNumber}_verse_${verseIndex + 1}.mp3';
    debugPrint(
        'Audio cache file path for surah $surahNumber, verse ${verseIndex + 1}: $path');
    return path;
  }

  Future<bool> _isAudioCached(int surahNumber, int verseIndex) async {
    if (_audioCacheDirectory == null) {
      debugPrint('Audio cache directory is null');
      return false;
    }
    try {
      final filePath = _getCacheFilePath(surahNumber, verseIndex);
      final file = File(filePath);
      final exists = await file.exists();
      if (exists) {
        // Check if file is not empty
        final fileSize = await file.length();
        if (fileSize == 0) {
          await file.delete();
          return false;
        }
      }
      debugPrint(
          'Checking audio cache for surah $surahNumber, verse ${verseIndex + 1}: exists=$exists');
      return exists;
    } catch (e) {
      debugPrint('Error checking audio cache: $e');
      return false;
    }
  }

  Future<String?> _downloadAndCacheAudio(
      String audioUrl, int surahNumber, int verseIndex) async {
    if (_audioCacheDirectory == null || _isDisposed) {
      debugPrint('Cannot download audio: cache directory null or disposed');
      return null;
    }

    try {
      _isDownloadingAudio[verseIndex] = true;
      update();

      debugPrint(
          'Starting download for surah $surahNumber, verse ${verseIndex + 1}');
      final response = await http.get(
        Uri.parse(audioUrl),
        headers: {'Accept': 'audio/*'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 && !_isDisposed) {
        if (response.bodyBytes.isEmpty) {
          debugPrint('Downloaded audio file is empty');
          return null;
        }

        final filePath = _getCacheFilePath(surahNumber, verseIndex);
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        if (!_isDisposed) {
          _isDownloadingAudio[verseIndex] = false;
          update();
          debugPrint(
              'Successfully cached audio for surah $surahNumber, verse ${verseIndex + 1} (${response.bodyBytes.length} bytes)');
          return filePath;
        }
      } else {
        debugPrint(
            'Failed to download audio for surah $surahNumber, verse ${verseIndex + 1}: status=${response.statusCode}');
        if (!_isDisposed) {
          _isDownloadingAudio[verseIndex] = false;
          update();
          Get.snackbar(
            'Error',
            'Failed to download audio',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      debugPrint(
          'Error downloading audio for surah $surahNumber, verse ${verseIndex + 1}: $e');
      if (!_isDisposed) {
        _isDownloadingAudio[verseIndex] = false;
        update();
        Get.snackbar(
          'Error',
          'Audio download failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    }
    return null;
  }

  Future<String?> _getCachedOrDownloadAudio(
      String audioUrl, int surahNumber, int verseIndex) async {
    if (await _isAudioCached(surahNumber, verseIndex)) {
      debugPrint(
          'Using cached audio for surah $surahNumber, verse ${verseIndex + 1}');
      return _getCacheFilePath(surahNumber, verseIndex);
    }
    debugPrint(
        'Downloading audio for surah $surahNumber, verse ${verseIndex + 1}');
    return await _downloadAndCacheAudio(audioUrl, surahNumber, verseIndex);
  }

  Future<void> fetchAndPlayAudio(int index, int surahNumber) async {
    if (_isDisposed) return;
    if (_isDownloadingAudio[index] == true ||
        _isBufferingAudio[index] == true) {
      debugPrint('Audio is already loading for index $index');
      return;
    }

    // If the same audio is playing, pause it
    if (_currentlyPlayingIndex.value == index && _isPlaying.value) {
      await pauseAudio();
      debugPrint('Paused audio for surah $surahNumber, verse ${index + 1}');
      return;
    }

    // Stop any currently playing audio
    if (_isPlaying.value) {
      await stopAudio();
      debugPrint('Stopped previous audio');
    }

    // Find the audio URL
    final audioModel = _audioData.firstWhereOrNull(
      (model) => model.index == surahNumber.toString(),
    );

    if (audioModel == null) {
      debugPrint('No audio model found for surah $surahNumber');
      Get.snackbar(
        'Error',
        'No audio available for this surah',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    final verseKey = 'verse_${index + 1}';
    final audioUrl = audioModel.audios[verseKey] ?? '';

    if (audioUrl.isEmpty) {
      debugPrint('No audio URL for surah $surahNumber, verse ${index + 1}');
      Get.snackbar(
        'Error',
        'No audio available for this verse',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    try {
      _currentlyPlayingIndex.value = index;
      _isBufferingAudio[index] = true;
      update();

      final cachedFilePath =
          await _getCachedOrDownloadAudio(audioUrl, surahNumber, index);

      if (_isDisposed) return;

      if (cachedFilePath != null && File(cachedFilePath).existsSync()) {
        await _audioPlayer.play(DeviceFileSource(cachedFilePath));
        debugPrint(
            'Playing cached audio for surah $surahNumber, verse ${index + 1}');
      } else {
        await _audioPlayer.play(UrlSource(audioUrl));
        debugPrint(
            'Streaming audio for surah $surahNumber, verse ${index + 1}');
      }
    } catch (e) {
      debugPrint('Error playing audio: $e');
      if (!_isDisposed) {
        _isBufferingAudio[index] = false;
        _isDownloadingAudio[index] = false;
        _currentlyPlayingIndex.value = null;
        update();
        Get.snackbar(
          'Error',
          'Failed to play audio',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> pauseAudio() async {
    if (_isPlaying.value) {
      await _audioPlayer.pause();
      _isPlaying.value = false;
      final currentIndex = _currentlyPlayingIndex.value;
      if (currentIndex != null) {
        _isBufferingAudio[currentIndex] = false;
        _isDownloadingAudio[currentIndex] = false;
      }
      update();
      debugPrint('Paused audio');
    }
  }

  Future<void> resumeAudio() async {
    if (!_isPlaying.value && _currentlyPlayingIndex.value != null) {
      await _audioPlayer.resume();
      _isPlaying.value = true;
      update();
      debugPrint('Resumed audio');
    }
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    _resetAudioState();
    debugPrint('Stopped audio');
  }

  Future<void> clearAudioCache() async {
    if (_audioCacheDirectory == null) return;
    try {
      // Stop any playing audio first
      await stopAudio();

      if (await _audioCacheDirectory!.exists()) {
        await _audioCacheDirectory!.delete(recursive: true);
        await _audioCacheDirectory!.create(recursive: true);
        debugPrint('Cleared audio cache');
        Get.snackbar(
          'Success',
          'Audio cache cleared successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error clearing audio cache: $e');
      Get.snackbar(
        'Error',
        'Failed to clear cache',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<int> getCacheSize() async {
    int totalSize = 0;
    try {
      if (_audioCacheDirectory != null &&
          await _audioCacheDirectory!.exists()) {
        await for (FileSystemEntity entity in _audioCacheDirectory!.list()) {
          if (entity is File) {
            totalSize += await entity.length();
          }
        }
      }
      debugPrint('Total audio cache size: $totalSize bytes');
    } catch (e) {
      debugPrint('Error calculating audio cache size: $e');
    }
    return totalSize;
  }

  String formatCacheSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Method to check if audio data is available
  bool hasAudioData() => _audioData.isNotEmpty;

  // Method to get audio model for a specific surah
  AudioModel? getAudioModel(int surahNumber) {
    return _audioData.firstWhereOrNull(
      (model) => model.index == surahNumber.toString(),
    );
  }

  // Method to get total number of cached files
  Future<int> getCachedFilesCount() async {
    int count = 0;
    try {
      if (_audioCacheDirectory != null &&
          await _audioCacheDirectory!.exists()) {
        await for (FileSystemEntity entity in _audioCacheDirectory!.list()) {
          if (entity is File) {
            count++;
          }
        }
      }
    } catch (e) {
      debugPrint('Error counting cached files: $e');
    }
    return count;
  }

  // Method to check if specific audio is cached
  Future<bool> isAudioCached(int surahNumber, int verseIndex) async {
    return await _isAudioCached(surahNumber, verseIndex);
  }

  // Method to preload audio (download without playing)
  Future<void> preloadAudio(int surahNumber, int verseIndex) async {
    if (_isDisposed || await _isAudioCached(surahNumber, verseIndex)) return;

    final audioModel = _audioData.firstWhereOrNull(
      (model) => model.index == surahNumber.toString(),
    );

    if (audioModel == null) return;

    final verseKey = 'verse_${verseIndex + 1}';
    final audioUrl = audioModel.audios[verseKey] ?? '';

    if (audioUrl.isNotEmpty) {
      await _downloadAndCacheAudio(audioUrl, surahNumber, verseIndex);
    }
  }

  @override
  void onClose() {
    _isDisposed = true;
    _audioPlayer.dispose();
    debugPrint('QuranAudioController disposed');
    super.onClose();
  }
}
