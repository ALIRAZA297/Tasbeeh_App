import 'package:get/get.dart';
import 'package:tasbeeh_app/Api/api_service.dart';
import 'package:tasbeeh_app/Model/hadees_books_model.dart';

class HadithBooksController extends GetxController {
  var books = <HadithBook>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHadithBooks();
  }

  Future<void> fetchHadithBooks() async {
    try {
      isLoading(true);
      final data = await ApiService.get("books");

      if (data != null) {
        List<HadithBook> allBooks = HadithBooksResponse.fromJson(data).books;

        // 🔹 Exclude books where hadiths_count is 0
        books.value = allBooks.where((book) => book.hadithsCount > 0).toList();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load Hadith books");
    } finally {
      isLoading(false);
    }
  }
}
