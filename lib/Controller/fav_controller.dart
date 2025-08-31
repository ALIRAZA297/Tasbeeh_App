

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../Model/fav_model.dart';
import '../View/Home Items/Quran/Model/fav_surah_model.dart';

class FavoritesController extends GetxController {
  final GetStorage _storage = GetStorage();

  // Storage keys
  static const String _favoriteSurahsKey = 'favorite_surahs';
  static const String _favoriteAyatsKey = 'favorite_ayats';
  static const String _favoriteHadithsKey =
      'favorite_hadiths'; // New key for hadiths

  // Observable lists
  final RxList<FavoriteSurah> _favoriteSurahs = <FavoriteSurah>[].obs;
  final RxList<FavoriteAyat> _favoriteAyats = <FavoriteAyat>[].obs;
  final RxList<Map<String, dynamic>> _favoriteHadiths =
      <Map<String, dynamic>>[].obs; // Store hadiths as JSON maps

  // Getters
  List<FavoriteSurah> get favoriteSurahs => _favoriteSurahs;
  List<FavoriteAyat> get favoriteAyats => _favoriteAyats;
  List<Map<String, dynamic>> get favoriteHadiths =>
      _favoriteHadiths; // Getter for hadiths

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  // Load favorites from storage
  void loadFavorites() {
    try {
      // Load favorite surahs
      final surahsData = _storage.read<List>(_favoriteSurahsKey);
      if (surahsData != null) {
        _favoriteSurahs.value = surahsData
            .map((json) =>
                FavoriteSurah.fromJson(Map<String, dynamic>.from(json)))
            .toList();
      }

      // Load favorite ayats
      final ayatsData = _storage.read<List>(_favoriteAyatsKey);
      if (ayatsData != null) {
        _favoriteAyats.value = ayatsData
            .map((json) =>
                FavoriteAyat.fromJson(Map<String, dynamic>.from(json)))
            .toList();
      }

      // Load favorite hadiths
      final hadithsData = _storage.read<List>(_favoriteHadithsKey);
      if (hadithsData != null) {
        _favoriteHadiths.value =
            hadithsData.map((json) => Map<String, dynamic>.from(json)).toList();
      }
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  // Save favorites to storage
  void _saveFavorites() {
    try {
      _storage.write(
          _favoriteSurahsKey, _favoriteSurahs.map((s) => s.toJson()).toList());
      _storage.write(
          _favoriteAyatsKey, _favoriteAyats.map((a) => a.toJson()).toList());
      _storage.write(
          _favoriteHadithsKey, _favoriteHadiths.toList()); // Save hadiths
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  // Surah favorite methods
  bool isSurahFavorite(int surahIndex) {
    return _favoriteSurahs.any((surah) => surah.index == surahIndex);
  }

  void toggleSurahFavorite({
    required int index,
    required String title,
    required String titleAr,
    required String place,
    required int count,
  }) {
    if (isSurahFavorite(index)) {
      removeSurahFromFavorites(index);
    } else {
      addSurahToFavorites(
        index: index,
        title: title,
        titleAr: titleAr,
        place: place,
        count: count,
      );
    }
  }

  void addSurahToFavorites({
    required int index,
    required String title,
    required String titleAr,
    required String place,
    required int count,
  }) {
    if (!isSurahFavorite(index)) {
      final favoriteSurah = FavoriteSurah(
        index: index,
        title: title,
        titleAr: titleAr,
        place: place,
        count: count,
        addedAt: DateTime.now(),
      );

      _favoriteSurahs.add(favoriteSurah);
      _saveFavorites();
    }
  }

  void removeSurahFromFavorites(int surahIndex) {
    final removedSurah =
        _favoriteSurahs.firstWhereOrNull((surah) => surah.index == surahIndex);
    _favoriteSurahs.removeWhere((surah) => surah.index == surahIndex);
    _saveFavorites();
  }

  // Ayat favorite methods
  bool isAyatFavorite({
    required int surahNumber,
    required int ayatNumber,
    required String language,
  }) {
    final uniqueKey = '${surahNumber}_${ayatNumber}_$language';
    return _favoriteAyats.any((ayat) => ayat.uniqueKey == uniqueKey);
  }

  void toggleAyatFavorite({
    required int surahNumber,
    required String surahNameAr,
    required String surahNameEng,
    required int ayatNumber,
    required String arabicText,
    required String translation,
    required String language,
  }) {
    if (isAyatFavorite(
      surahNumber: surahNumber,
      ayatNumber: ayatNumber,
      language: language,
    )) {
      removeAyatFromFavorites(
        surahNumber: surahNumber,
        ayatNumber: ayatNumber,
        language: language,
      );
    } else {
      addAyatToFavorites(
        surahNumber: surahNumber,
        surahNameAr: surahNameAr,
        surahNameEng: surahNameEng,
        ayatNumber: ayatNumber,
        arabicText: arabicText,
        translation: translation,
        language: language,
      );
    }
  }

  void addAyatToFavorites({
    required int surahNumber,
    required String surahNameAr,
    required String surahNameEng,
    required int ayatNumber,
    required String arabicText,
    required String translation,
    required String language,
  }) {
    if (!isAyatFavorite(
      surahNumber: surahNumber,
      ayatNumber: ayatNumber,
      language: language,
    )) {
      final favoriteAyat = FavoriteAyat(
        surahNumber: surahNumber,
        surahNameAr: surahNameAr,
        surahNameEng: surahNameEng,
        ayatNumber: ayatNumber,
        arabicText: arabicText,
        translation: translation,
        language: language,
        addedAt: DateTime.now(),
      );

      _favoriteAyats.add(favoriteAyat);
      _saveFavorites();
    }
  }

  void removeAyatFromFavorites({
    required int surahNumber,
    required int ayatNumber,
    required String language,
  }) {
    final uniqueKey = '${surahNumber}_${ayatNumber}_$language';
    final removedAyat =
        _favoriteAyats.firstWhereOrNull((ayat) => ayat.uniqueKey == uniqueKey);
    _favoriteAyats.removeWhere((ayat) => ayat.uniqueKey == uniqueKey);
    _saveFavorites();
  }

  // Hadith favorite methods
  bool isHadithFavorite({
    required int hadithNumber,
    required String displayName,
    required String language,
  }) {
    final uniqueKey = '${hadithNumber}_${displayName}_$language';
    return _favoriteHadiths.any((hadith) => hadith['uniqueKey'] == uniqueKey);
  }

  void toggleHadithFavorite({
    required int hadithNumber,
    required String text,
    required String displayName,
    required String language,
    required String sectionName,
    required List<String> grades,
    required String reference,
    required String chain,
    required String editionName,
  }) {
    if (isHadithFavorite(
      hadithNumber: hadithNumber,
      displayName: displayName,
      language: language,
    )) {
      removeHadithFromFavorites(
        hadithNumber: hadithNumber,
        displayName: displayName,
        language: language,
      );
    } else {
      addHadithToFavorites(
        hadithNumber: hadithNumber,
        text: text,
        displayName: displayName,
        language: language,
        sectionName: sectionName,
        grades: grades,
        reference: reference,
        chain: chain,
        editionName: editionName,
      );
    }
  }

  void addHadithToFavorites({
    required int hadithNumber,
    required String text,
    required String displayName,
    required String language,
    required String sectionName,
    required List<String> grades,
    required String reference,
    required String chain,
    required String editionName,
  }) {
    if (!isHadithFavorite(
      hadithNumber: hadithNumber,
      displayName: displayName,
      language: language,
    )) {
      final favoriteHadith = {
        'hadithNumber': hadithNumber,
        'text': text,
        'displayName': displayName,
        'language': language,
        'sectionName': sectionName,
        'grades': grades,
        'reference': reference,
        'chain': chain,
        'editionName': editionName,
        'addedAt': DateTime.now().toIso8601String(),
        'uniqueKey': '${hadithNumber}_${displayName}_$language',
      };

      _favoriteHadiths.add(favoriteHadith);
      _saveFavorites();
    }
  }

  void removeHadithFromFavorites({
    required int hadithNumber,
    required String displayName,
    required String language,
  }) {
    final uniqueKey = '${hadithNumber}_${displayName}_$language';
    _favoriteHadiths.removeWhere((hadith) => hadith['uniqueKey'] == uniqueKey);
    _saveFavorites();
  }

  // Get favorites by category
  List<FavoriteSurah> getSurahFavorites() {
    return List.from(_favoriteSurahs)
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt));
  }

  List<FavoriteAyat> getAyatFavorites() {
    return List.from(_favoriteAyats)
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt));
  }

  List<Map<String, dynamic>> getHadithFavorites() {
    return List.from(_favoriteHadiths)
      ..sort((a, b) =>
          DateTime.parse(b['addedAt']).compareTo(DateTime.parse(a['addedAt'])));
  }

  // Get favorites by language
  List<FavoriteAyat> getAyatFavoritesByLanguage(String language) {
    return _favoriteAyats.where((ayat) => ayat.language == language).toList()
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt));
  }

  List<Map<String, dynamic>> getHadithFavoritesByLanguage(String language) {
    return _favoriteHadiths
        .where((hadith) => hadith['language'] == language)
        .toList()
      ..sort((a, b) =>
          DateTime.parse(b['addedAt']).compareTo(DateTime.parse(a['addedAt'])));
  }

  // Clear all favorites
  void clearAllSurahFavorites() {
    _favoriteSurahs.clear();
    _saveFavorites();
    Get.snackbar(
      'Cleared',
      'All favorite Surahs have been cleared',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void clearAllAyatFavorites() {
    _favoriteAyats.clear();
    _saveFavorites();
    Get.snackbar(
      'Cleared',
      'All favorite Ayats have been cleared',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void clearAllHadithFavorites() {
    _favoriteHadiths.clear();
    _saveFavorites();
    Get.snackbar(
      'Cleared',
      'All favorite Hadiths have been cleared',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  // Get count
  int get favoriteSurahsCount => _favoriteSurahs.length;
  int get favoriteAyatsCount => _favoriteAyats.length;
  int get favoriteHadithsCount => _favoriteHadiths.length; // Count for hadiths
}
