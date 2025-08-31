import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../Model/quran_model.dart';
import '../Utils/surah_list.dart';
import '../Utils/surah_name_list.dart';
import '../View/Home Items/Quran/Model/surah_model.dart';
import '../View/Home Items/Quran/all_quran_screen.dart';
import '../View/Home Items/Quran/urdu_quran.dart';

class AllQuranController extends GetxController {
  final RxList<QuranSurah> quranSurahList = <QuranSurah>[].obs;
  final RxList<QuranVerse> quranVerseList = <QuranVerse>[].obs;
  RxString selectedSurahIndex = ''.obs;
  RxString selectedAudioIndex = ''.obs;
  RxInt selectPlayingIndex = 1.obs;
  RxString place = ''.obs;
  RxString type = ''.obs;
  RxString titleAr = ''.obs;
  RxString title = ''.obs;
  RxString url = ''.obs;
  RxBool loading = false.obs;

  // GetxStorage instance
  final _storage = GetStorage();

  // Keys for storage
  static const String _lastReadSurahKey = 'last_read_surah';
  static const String _lastReadAyatKey = 'last_read_ayat';
  static const String _lastReadLanguageKey = 'last_read_language';
  static const String _lastReadSurahNameArKey = 'last_read_surah_name_ar';
  static const String _lastReadSurahNameEngKey = 'last_read_surah_name_eng';
  static const String _lastReadTimestampKey = 'last_read_timestamp';

  // Observable for last read info
  final RxMap<String, dynamic> lastReadInfo = <String, dynamic>{}.obs;
  final RxBool hasLastRead = false.obs;

  onSelect(String surahIndex) {
    selectedSurahIndex.value = surahIndex;
    debugPrint(selectedSurahIndex.value);
    if (selectedSurahIndex.value != '') {
      getAllSurah();
      debugPrint('No surah found');
    }
  }

  onAudioSelect(String audioIndex) {
    selectedAudioIndex.value = audioIndex;
    debugPrint("selected audio index ${selectedAudioIndex.value}");
    if (selectedAudioIndex.value != '') {
      debugPrint('No audio found');
    }
  }

  // Save last read ayat information
  void saveLastReadAyat({
    required int surahNumber,
    required int ayatNumber,
    required String surahNameAr,
    required String surahNameEng,
    required String language,
  }) {
    try {
      _storage.write(_lastReadSurahKey, surahNumber);
      _storage.write(_lastReadAyatKey, ayatNumber);
      _storage.write(_lastReadLanguageKey, language);
      _storage.write(_lastReadSurahNameArKey, surahNameAr);
      _storage.write(_lastReadSurahNameEngKey, surahNameEng);
      _storage.write(
          _lastReadTimestampKey, DateTime.now().millisecondsSinceEpoch);

      // Update observable
      _updateLastReadInfo();

      debugPrint(
          'Saved last read: Surah $surahNumber, Ayat $ayatNumber, Language: $language');
    } catch (e) {
      debugPrint('Error saving last read ayat: $e');
    }
  }

  // Get last read ayat information
  Map<String, dynamic>? getLastReadAyat() {
    try {
      final surahNumber = _storage.read(_lastReadSurahKey);
      final ayatNumber = _storage.read(_lastReadAyatKey);
      final language = _storage.read(_lastReadLanguageKey);
      final surahNameAr = _storage.read(_lastReadSurahNameArKey);
      final surahNameEng = _storage.read(_lastReadSurahNameEngKey);
      final timestamp = _storage.read(_lastReadTimestampKey);

      if (surahNumber != null && ayatNumber != null && language != null) {
        return {
          'surahNumber': surahNumber,
          'ayatNumber': ayatNumber,
          'language': language,
          'surahNameAr': surahNameAr ?? '',
          'surahNameEng': surahNameEng ?? '',
          'timestamp': timestamp ?? 0,
        };
      }
    } catch (e) {
      debugPrint('Error getting last read ayat: $e');
    }
    return null;
  }

  // Update last read info observable
  void _updateLastReadInfo() {
    final info = getLastReadAyat();
    if (info != null) {
      lastReadInfo.value = info;
      hasLastRead.value = true;
    } else {
      lastReadInfo.clear();
      hasLastRead.value = false;
    }
  }

  // Clear last read information
  void clearLastRead() {
    try {
      _storage.remove(_lastReadSurahKey);
      _storage.remove(_lastReadAyatKey);
      _storage.remove(_lastReadLanguageKey);
      _storage.remove(_lastReadSurahNameArKey);
      _storage.remove(_lastReadSurahNameEngKey);
      _storage.remove(_lastReadTimestampKey);

      lastReadInfo.clear();
      hasLastRead.value = false;

      debugPrint('Cleared last read information');
    } catch (e) {
      debugPrint('Error clearing last read: $e');
    }
  }

  // Navigate to last read ayat
  void resumeReading() {
    final info = getLastReadAyat();
    if (info != null) {
      final surahNumber = info['surahNumber'] as int;
      final language = info['language'] as String;
      final surahNameAr = info['surahNameAr'] as String;
      final surahNameEng = info['surahNameEng'] as String;

      // Determine if language is LTR
      bool isLTR = language == 'english_saheeh' ||
          language == 'indonesian_affairs' ||
          language == 'bengali_mokhtasar';

      // Navigate to UrduQuranScreen with the saved information
      Get.to(() => UrduQuranScreen(
            isLTR: isLTR,
            surahNameAr: surahNameAr,
            surahNameEng: surahNameEng,
            surahNumber: surahNumber,
            lang: language,
            scrollToAyat: info['ayatNumber'] as int, // Add this parameter
          ));
    }
  }

  // Get formatted time since last read
  String getTimeSinceLastRead() {
    final info = getLastReadAyat();
    if (info != null && info['timestamp'] != null) {
      final timestamp = info['timestamp'] as int;
      final lastReadTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(lastReadTime);

      if (difference.inDays > 0) {
        return '${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hours ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minutes ago';
      } else {
        return 'Just now';
      }
    }
    return '';
  }

  //play audio process
  late AudioPlayer _audioPlayer;
  late AudioPlayer _audioPlayer2;
  RxBool isPlaying = false.obs;
  RxBool isPlayingAudio = false.obs;

  @override
  void onInit() async {
    super.onInit();
    getJuz();
    _updateLastReadInfo(); // Load last read info on init
    _audioPlayer = AudioPlayer();
    _audioPlayer2 = AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      isPlaying.value = state == PlayerState.playing;
    });
    _audioPlayer2.onPlayerStateChanged.listen((PlayerState state) {
      isPlayingAudio.value = state == PlayerState.playing;
    });
  }

  void playBismillah() {
    if (isPlaying.value) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(UrlSource(
          'https://cdn.islamic.network/quran/audio/128/ar.alafasy/1.mp3'));
    }
  }

  void playAudio(String audioURl) {
    if (isPlayingAudio.value) {
      _audioPlayer2.pause();
    } else {
      _audioPlayer2.play(UrlSource(audioURl));
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    _audioPlayer2.dispose();
    super.onClose();
  }

  Future<void> getJuz() async {
    final List<QuranSurah> surah =
        QuranSurah.fromJsonList(json.decode(rawJsonJuzData));
    quranSurahList.value = surah;
  }

  /// Get surah by index
  void getAllSurah() {
    final List<QuranVerse> quranData =
        QuranVerse.fromJsonList(json.decode(rawJsonSurahData));
    quranVerseList.value = quranData
        .where((element) => element.index == selectedSurahIndex.value)
        .toList();
    loading = false.obs;
    debugPrint(quranData.toString());
    if (quranVerseList.isNotEmpty) {
      Get.to(() => AllQuranScreen());
    }
  }
}
