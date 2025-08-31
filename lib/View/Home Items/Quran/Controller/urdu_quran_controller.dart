import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:tasbeeh_app/Api/api_service.dart';

import '../../../../Model/audio_model.dart';
import '../Model/surah_e_quran_model.dart';
import '../../../../Utils/quran_audios.dart';

class UrduQuranController extends GetxController {
  var surahList = <Surah>[].obs;
  var isLoading = false.obs;

  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _currentlyPlayingIndex;
  var isPlaying = false.obs;
  var isBufferingAudio = <int, bool>{}.obs;
  var isDownloadingAudio = <int, bool>{}.obs;

  final List<AudioModel> _audioData =
      AudioModel.fromJsonList(jsonDecode(surahAudioData));

  Directory? _audioCacheDirectory;
  Directory? _surahCacheDirectory;
  bool _isCacheInitialized = false;

  @override
  void onInit() {
    super.onInit();
    _setupAudioListeners();
  }

  Future<void> initialize(int id, String lang) async {
    await _initializeCacheDirectories();
    await getUrduQuran(id, lang);
  }

  Future<void> _initializeCacheDirectories() async {
    if (_isCacheInitialized) return;
    try {
      final appDir = await getApplicationDocumentsDirectory();
      _audioCacheDirectory = Directory('${appDir.path}/quran_audio_cache');
      _surahCacheDirectory = Directory('${appDir.path}/quran_surah_cache');
      if (!await _audioCacheDirectory!.exists()) {
        await _audioCacheDirectory!.create(recursive: true);
      }
      if (!await _surahCacheDirectory!.exists()) {
        await _surahCacheDirectory!.create(recursive: true);
      }
      _isCacheInitialized = true;
    } catch (_) {
      _isCacheInitialized = false;
    }
  }

  String _getSurahCacheFilePath(int surahNumber, String lang) {
    return '${_surahCacheDirectory?.path}/surah_${surahNumber}_$lang.json';
  }

  Future<bool> _isSurahCached(int surahNumber, String lang) async {
    final file = File(_getSurahCacheFilePath(surahNumber, lang));
    return file.exists();
  }

  Future<List<Surah>?> _readSurahFromCache(int surahNumber, String lang) async {
    try {
      final file = File(_getSurahCacheFilePath(surahNumber, lang));
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final jsonData = jsonDecode(jsonString) as List;
        return jsonData.map((e) => Surah.fromJson(e)).toList();
      }
    } catch (_) {}
    return null;
  }

  Future<void> _writeSurahToCache(int surahNumber, String lang, List<Surah> data) async {
    try {
      final file = File(_getSurahCacheFilePath(surahNumber, lang));
      await file.writeAsString(jsonEncode(data.map((e) => e.toJson()).toList()));
    } catch (_) {}
  }

  Future<void> getUrduQuran(int id, String lang) async {
    isLoading.value = true;
    try {
      final normalizedLang = lang.toLowerCase();
      if (await _isSurahCached(id, normalizedLang)) {
        final cached = await _readSurahFromCache(id, normalizedLang);
        if (cached != null && cached.isNotEmpty) {
          surahList.assignAll(cached);
        } else {
          final fetched = await ApiService.getSurah(id, normalizedLang);
          surahList.assignAll(fetched);
          if (fetched.isNotEmpty) {
            await _writeSurahToCache(id, normalizedLang, fetched);
          }
        }
      } else {
        final fetched = await ApiService.getSurah(id, normalizedLang);
        surahList.assignAll(fetched);
        if (fetched.isNotEmpty) {
          await _writeSurahToCache(id, normalizedLang, fetched);
        }
      }
    } catch (_) {
      surahList.clear();
      Get.snackbar("Error", "Failed to load surah data");
    }
    isLoading.value = false;
  }

  void _setupAudioListeners() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.playing) {
        isPlaying.value = true;
        if (_currentlyPlayingIndex != null) {
          isBufferingAudio[_currentlyPlayingIndex!] = false;
          isDownloadingAudio[_currentlyPlayingIndex!] = false;
        }
      } else if (state == PlayerState.paused || state == PlayerState.stopped) {
        isPlaying.value = false;
        _currentlyPlayingIndex = null;
      }
      update();
    });
    _audioPlayer.onPlayerComplete.listen((_) => stopAudio());
  }

  String _getCacheFilePath(int surahNumber, int verseIndex) {
    return '${_audioCacheDirectory?.path}/surah_${surahNumber}_verse_${verseIndex + 1}.mp3';
  }

  Future<bool> _isAudioCached(int surahNumber, int verseIndex) async {
    final file = File(_getCacheFilePath(surahNumber, verseIndex));
    return file.exists();
  }

  Future<String?> _downloadAndCacheAudio(String url, int surahNumber, int verseIndex) async {
    try {
      isDownloadingAudio[verseIndex] = true;
      update();
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final filePath = _getCacheFilePath(surahNumber, verseIndex);
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        isDownloadingAudio[verseIndex] = false;
        update();
        return filePath;
      }
    } catch (_) {}
    return null;
  }

  Future<void> fetchAndPlayAudio(int index, int surahNumber) async {
    if (_currentlyPlayingIndex == index && isPlaying.value) {
      await _audioPlayer.pause();
      isPlaying.value = false;
      return;
    }

    if (isPlaying.value) {
      await _audioPlayer.stop();
      isPlaying.value = false;
      _currentlyPlayingIndex = null;
    }

    final model = _audioData.firstWhere(
      (e) => e.index == surahNumber.toString(),
      orElse: () => AudioModel(index: '', name: '', audios: {}),
    );

    final url = model.audios['verse_${index + 1}'] ?? '';
    if (url.isEmpty) return;

    _currentlyPlayingIndex = index;
    isPlaying.value = true;
    isBufferingAudio[index] = true;
    update();

    final cachedPath = (await _isAudioCached(surahNumber, index)
        ? _getCacheFilePath(surahNumber, index)
        : await _downloadAndCacheAudio(url, surahNumber, index));

    if (cachedPath != null) {
      await _audioPlayer.play(DeviceFileSource(cachedPath));
    } else {
      await _audioPlayer.play(UrlSource(url));
    }

    isBufferingAudio[index] = false;
    update();
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    isPlaying.value = false;
    _currentlyPlayingIndex = null;
    update();
  }

  Future<void> clearCache() async {
    if (_audioCacheDirectory != null && await _audioCacheDirectory!.exists()) {
      await _audioCacheDirectory!.delete(recursive: true);
      await _audioCacheDirectory!.create();
    }
    if (_surahCacheDirectory != null && await _surahCacheDirectory!.exists()) {
      await _surahCacheDirectory!.delete(recursive: true);
      await _surahCacheDirectory!.create();
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
