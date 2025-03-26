import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasbeeh_app/Api/api_service.dart';
import 'package:tasbeeh_app/Model/quran_model.dart';

class QuranController extends GetxController {
  var quranModel = QuranModel(surahs: []).obs;
  var isLoading = true.obs;
  var lastReadSurah = 0.obs;
  var lastReadAyah = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuranData();
    loadLastRead(); // Load the last reading point
  }

  Future<void> fetchQuranData() async {
    final prefs = await SharedPreferences.getInstance();
    isLoading.value = true;

    // Check if Quran data is already saved in SharedPreferences
    final String? savedQuran = prefs.getString('quranData');
    if (savedQuran != null) {
      try {
        log("Loading from SharedPreferences");
        quranModel.value = QuranModel.fromJson(jsonDecode(savedQuran));
        log("Surahs loaded from cache: ${quranModel.value.surahs.length}");
        isLoading.value = false;
        return; // Exit early since we loaded from cache
      } catch (e) {
        log("Error loading cached Quran data: $e");
        Get.snackbar("Error", "Failed to load cached Quran data: $e",
            snackPosition: SnackPosition.TOP);
        // Proceed to fetch from API if cached data fails
      }
    }

    // Fetch from API if not cached or cache failed
    try {
      log("Fetching from API: ${ApiService.quranApi}");
      final response = await http.get(Uri.parse(ApiService.quranApi));

      if (response.statusCode == 200) {
        quranModel.value = QuranModel.fromJson(json.decode(response.body));
        log("Surahs loaded from API: ${quranModel.value.surahs.length}");
        // Save to SharedPreferences after successful fetch
        await prefs.setString('quranData', jsonEncode(quranModel.value.toJson()));
        log("Quran data saved to SharedPreferences");
      } else {
        Get.snackbar("Error", "Failed to fetch Quran data: ${response.statusCode}",
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      log("Error fetching Quran data: $e");
      Get.snackbar("Error", "Something went wrong: ${e.toString()}",
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveLastRead(int surahNumber, int ayahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("lastReadSurah", surahNumber);
    await prefs.setInt("lastReadAyah", ayahNumber);
    lastReadSurah.value = surahNumber;
    lastReadAyah.value = ayahNumber;
  }

  Future<void> loadLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    lastReadSurah.value = prefs.getInt("lastReadSurah") ?? 0;
    lastReadAyah.value = prefs.getInt("lastReadAyah") ?? 0;
  }
}