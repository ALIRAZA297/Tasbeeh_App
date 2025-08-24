
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'fav_model.dart';
import 'fav_surah_model.dart';

class FavoritesController extends GetxController {
  final GetStorage _storage = GetStorage();

  // Storage keys
  static const String _favoriteSurahsKey = 'favorite_surahs';
  static const String _favoriteAyatsKey = 'favorite_ayats';

  // Observable lists
  final RxList<FavoriteSurah> _favoriteSurahs = <FavoriteSurah>[].obs;
  final RxList<FavoriteAyat> _favoriteAyats = <FavoriteAyat>[].obs;

  // Getters
  List<FavoriteSurah> get favoriteSurahs => _favoriteSurahs;
  List<FavoriteAyat> get favoriteAyats => _favoriteAyats;

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
        _favoriteSurahs.value = surahsData.map((json) => FavoriteSurah.fromJson(Map<String, dynamic>.from(json))).toList();
      }

      // Load favorite ayats
      final ayatsData = _storage.read<List>(_favoriteAyatsKey);
      if (ayatsData != null) {
        _favoriteAyats.value = ayatsData.map((json) => FavoriteAyat.fromJson(Map<String, dynamic>.from(json))).toList();
      }
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }



  // Save favorites to storage
  void _saveFavorites() {
    try {
      _storage.write(_favoriteSurahsKey, _favoriteSurahs.map((s) => s.toJson()).toList());
      _storage.write(_favoriteAyatsKey, _favoriteAyats.map((a) => a.toJson()).toList());
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

      // Get.snackbar(
      //   'Added to Favorites',
      //   '$title has been added to your favorite Surahs',
      //   snackPosition: SnackPosition.BOTTOM,
      //   duration: const Duration(seconds: 2),
      // );
    }
  }

  void removeSurahFromFavorites(int surahIndex) {
    final removedSurah = _favoriteSurahs.firstWhereOrNull((surah) => surah.index == surahIndex);
    _favoriteSurahs.removeWhere((surah) => surah.index == surahIndex);
    _saveFavorites();

    if (removedSurah != null) {
      // Get.snackbar(
      //   'Removed from Favorites',
      //   '${removedSurah.title} has been removed from your favorite Surahs',
      //   snackPosition: SnackPosition.BOTTOM,
      //   duration: const Duration(seconds: 2),
      // );
    }
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

      // Get.snackbar(
      //   'Added to Favorites',
      //   'Ayat ${ayatNumber} from $surahNameEng has been added to your favorites',
      //   snackPosition: SnackPosition.BOTTOM,
      //   duration: const Duration(seconds: 2),
      // );
    }
  }

  void removeAyatFromFavorites({
    required int surahNumber,
    required int ayatNumber,
    required String language,
  }) {
    final uniqueKey = '${surahNumber}_${ayatNumber}_$language';
    final removedAyat = _favoriteAyats.firstWhereOrNull((ayat) => ayat.uniqueKey == uniqueKey);
    _favoriteAyats.removeWhere((ayat) => ayat.uniqueKey == uniqueKey);
    _saveFavorites();

    if (removedAyat != null) {
      // Get.snackbar(
      //   'Removed from Favorites',
      //   'Ayat ${removedAyat.ayatNumber} from ${removedAyat.surahNameEng} has been removed from your favorites',
      //   snackPosition: SnackPosition.BOTTOM,
      //   duration: const Duration(seconds: 2),
      // );
    }
  }

  // Get favorites by category
  List<FavoriteSurah> getSurahFavorites() {
    return List.from(_favoriteSurahs)..sort((a, b) => b.addedAt.compareTo(a.addedAt));
  }

  List<FavoriteAyat> getAyatFavorites() {
    return List.from(_favoriteAyats)..sort((a, b) => b.addedAt.compareTo(a.addedAt));
  }

  // Get favorites by language
  List<FavoriteAyat> getAyatFavoritesByLanguage(String language) {
    return _favoriteAyats.where((ayat) => ayat.language == language).toList()..sort((a, b) => b.addedAt.compareTo(a.addedAt));
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

  // Get count
  int get favoriteSurahsCount => _favoriteSurahs.length;
  int get favoriteAyatsCount => _favoriteAyats.length;
}
