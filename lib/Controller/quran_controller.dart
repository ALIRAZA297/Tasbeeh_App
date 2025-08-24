// import 'dart:convert';
// import 'dart:developer';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tasbeeh_app/Api/api_service.dart';
// import 'package:tasbeeh_app/Model/quran_model.dart';

// class QuranController extends GetxController {
//   var quranModel = QuranModel(surahs: []).obs;
//   var isLoading = true.obs;
//   var lastReadSurah = 0.obs;
//   var lastReadAyah = 0.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchQuranData();
//     loadLastRead(); // Load the last reading point
//   }

//   Future<void> fetchQuranData() async {
//     final prefs = await SharedPreferences.getInstance();
//     isLoading.value = true;

//     // Check if Quran data is already saved in SharedPreferences
//     final String? savedQuran = prefs.getString('quranData');
//     if (savedQuran != null) {
//       try {
//         log("Loading from SharedPreferences");
//         quranModel.value = QuranModel.fromJson(jsonDecode(savedQuran));
//         log("Surahs loaded from cache: ${quranModel.value.surahs.length}");
//         isLoading.value = false;
//         return; // Exit early since we loaded from cache
//       } catch (e) {
//         log("Error loading cached Quran data: $e");
//         Get.snackbar("Error", "Failed to load cached Quran data: $e",
//             snackPosition: SnackPosition.TOP);
//         // Proceed to fetch from API if cached data fails
//       }
//     }

//     // Fetch from API if not cached or cache failed
//     try {
//       log("Fetching from API: ${ApiService.quranApi}");
//       final response = await http.get(Uri.parse(ApiService.quranApi));

//       if (response.statusCode == 200) {
//         quranModel.value = QuranModel.fromJson(json.decode(response.body));
//         log("Surahs loaded from API: ${quranModel.value.surahs.length}");
//         // Save to SharedPreferences after successful fetch
//         await prefs.setString('quranData', jsonEncode(quranModel.value.toJson()));
//         log("Quran data saved to SharedPreferences");
//       } else {
//         Get.snackbar("Error", "Failed to fetch Quran data: ${response.statusCode}",
//             snackPosition: SnackPosition.TOP);
//       }
//     } catch (e) {
//       log("Error fetching Quran data: $e");
//       Get.snackbar("Error", "Something went wrong: ${e.toString()}",
//           snackPosition: SnackPosition.TOP);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> saveLastRead(int surahNumber, int ayahNumber) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt("lastReadSurah", surahNumber);
//     await prefs.setInt("lastReadAyah", ayahNumber);
//     lastReadSurah.value = surahNumber;
//     lastReadAyah.value = ayahNumber;
//   }

//   Future<void> loadLastRead() async {
//     final prefs = await SharedPreferences.getInstance();
//     lastReadSurah.value = prefs.getInt("lastReadSurah") ?? 0;
//     lastReadAyah.value = prefs.getInt("lastReadAyah") ?? 0;
//   }
// }

import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../Model/quran_model.dart';
import '../Model/surah_model.dart';
import '../View/Home Items/Quran/all_quran_screen.dart';
import '../View/Home Items/Quran/surah_list.dart';
import '../View/Home Items/Quran/surah_name_list.dart';
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
