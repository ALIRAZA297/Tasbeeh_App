import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasbeeh_app/Api/api_service.dart';
import 'package:tasbeeh_app/Model/hadees_model.dart';

class HadithsController extends GetxController {
  var allHadiths = <Hadith>[].obs; // Store all Hadiths
  var filteredHadiths = <Hadith>[].obs; // Store filtered Hadiths
  var isLoading = false.obs; // Show loading indicator
  var hasMore = true.obs; // Check if more pages exist
  int currentPage = 1;
  int totalPages = 1;

  /// Fetch paginated Hadiths and filter them
  Future<void> fetchHadiths(String bookSlug, int chapterId) async {
    if (!hasMore.value || isLoading.value)
      return; // Stop if last page is reached or already loading

    try {
      isLoading(true);
      final data = await ApiService.getHadiths(currentPage);

      if (data == null ||
          !data.containsKey("hadiths") ||
          data["hadiths"]["data"] == null) {
        debugPrint("❌ Invalid API response format");
        return;
      }

      var response = HadithResponse.fromJson(data);
      totalPages = response.totalPages;
      allHadiths.addAll(response.hadiths); // Store all Hadiths

      // Filter Hadiths by bookSlug & chapterId
      final newFilteredHadiths = response.hadiths
          .where((hadith) =>
              hadith.bookSlug == bookSlug && hadith.chapterId == chapterId)
          .toList();

      if (newFilteredHadiths.isNotEmpty) {
        filteredHadiths.addAll(newFilteredHadiths); // Append new Hadiths
      }

      currentPage++;
      hasMore.value = currentPage <= totalPages;

      debugPrint(
          "✅ Total Hadiths Loaded: ${allHadiths.length}, Filtered: ${filteredHadiths.length}");
    } catch (e) {
      debugPrint("❌ Error fetching Hadiths: $e");
    } finally {
      isLoading(false);
    }
  }
}
