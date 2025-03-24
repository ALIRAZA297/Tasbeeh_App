// import 'dart:developer';

// import 'package:get/get.dart';
// import 'package:tasbeeh_app/Api/api_service.dart';
// import 'package:tasbeeh_app/Model/hadees_headings_model.dart';

// class HadithHeadingsController extends GetxController {
//   var headings = <HadithHeading>[].obs;
//   var isLoading = true.obs;

//   void fetchHadithHeadings(String bookSlug) async {
//     try {
//       isLoading(true);
//       final data = await ApiService.get("hadiths/?chapterId=$bookSlug");
//       log('${headings.length}');

//       if (data != null) {
//         headings.value = HadithHeadingsResponse.fromJson(data).headings;
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to load Hadith headings");
//     } finally {
//       isLoading(false);
//     }
//   }
// }
