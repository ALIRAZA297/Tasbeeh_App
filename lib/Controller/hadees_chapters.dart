import 'package:get/get.dart';
import 'package:tasbeeh_app/Api/api_service.dart';
import 'package:tasbeeh_app/Model/hadees_chapters_model.dart';

class HadithChaptersController extends GetxController {
  var chapters = <HadithChapter>[].obs;
  var isLoading = true.obs;

  void fetchHadithChapters(String bookSlug) async {
    try {
      isLoading(true);
      final data = await ApiService.get("$bookSlug/chapters");

      if (data != null) {
        chapters.value = HadithChaptersResponse.fromJson(data).chapters;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load Hadith chapters");
    } finally {
      isLoading(false);
    }
  }
}
