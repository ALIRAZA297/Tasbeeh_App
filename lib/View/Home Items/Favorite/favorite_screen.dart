// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../Api/hadith_api_service.dart';
// import '../../../Controller/fav_controller.dart';
// import '../../../Utils/app_colors.dart';
// import '../hadith/hadit_detail_screen.dart';
// import '../hadith/hadith_list_screen.dart';

// class FavoriteScreen extends StatelessWidget {
//   const FavoriteScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final FavoritesController favoritesController =
//         Get.put(FavoritesController());

//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       appBar: AppBar(
//         centerTitle: true,
//         scrolledUnderElevation: 0,
//         elevation: 0,
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         title: Text(
//           'Favorites',
//           style: TextStyle(
//             fontSize: 18,
//             color: Get.isDarkMode ? white : black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               favoritesController.clearAllHadithFavorites();
//             },
//             icon: Icon(
//               Icons.delete_sweep,
//               color: Get.isDarkMode ? white : black,
//               size: 24,
//             ),
//           ),
//         ],
//       ),
//       body: Obx(
//         () => favoritesController.favoriteHadiths.isEmpty
//             ? Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.bookmark_border,
//                       color: white54,
//                       size: 48,
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'No favorite hadiths',
//                       style: TextStyle(
//                         color: white70,
//                         fontSize: 16,
//                       ),
//                     ),
//                     Text(
//                       'Add hadiths to your favorites',
//                       style: TextStyle(
//                         color: white54,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             : ListView.builder(
//                 padding: const EdgeInsets.all(12),
//                 itemCount: favoritesController.favoriteHadiths.length,
//                 itemBuilder: (context, index) {
//                   final hadith = favoritesController.favoriteHadiths[index];
//                   return HadithTile(
//                     hadithItem: HadithItem(
//                       hadithNumber: (hadith['hadithNumber']),
//                       text: hadith['text'],
//                       editionName: hadith['editionName'],
//                       grades: List<String>.from(hadith['grades']),
//                     ),
//                     onTap: () async {
//                       showDialog(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (context) => const Center(
//                           child: CircularProgressIndicator(
//                             color: primary,
//                           ),
//                         ),
//                       );

//                       try {
//                         final hadithDetail =
//                             await HadithApiService.getHadithDetail(
//                           hadith['editionName'],
//                           hadith['hadithNumber'],
//                         );

//                         Navigator.pop(context);

//                         Get.to(() => HadithDetailScreen(
//                               hadithDetail: hadithDetail,
//                               displayName: hadith['displayName'],
//                               language: hadith['language'],
//                               sectionName: hadith['sectionName'],
//                             ));
//                       } catch (e) {
//                         Navigator.pop(context);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('Failed to load hadith details: $e'),
//                             backgroundColor: red,
//                           ),
//                         );
//                       }
//                     },
//                     editionName: hadith['editionName'],
//                     displayName: hadith['displayName'],
//                     language: hadith['language'],
//                     sectionName: hadith['sectionName'],
//                   );
//                 },
//               ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Api/hadith_api_service.dart';
import '../../../Controller/fav_controller.dart';
import '../../../Model/fav_model.dart';
import '../../../Utils/app_colors.dart';
import '../Quran/urdu_quran.dart';
import '../hadith/hadit_detail_screen.dart';
import '../hadith/hadith_list_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesController favoritesController =
        Get.put(FavoritesController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          scrolledUnderElevation: 0,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Favorites',
            style: TextStyle(
              fontSize: 18,
              color: Get.isDarkMode ? white : black,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            labelColor: Get.isDarkMode ? white : black,
            unselectedLabelColor: Get.isDarkMode ? white54 : black54,
            indicatorColor: primary,
            tabs: const [
              Tab(text: 'Ayats'),
              Tab(text: 'Hadiths'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Ayats Tab
            Obx(
              () => favoritesController.favoriteAyats.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border,
                            color: white54,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No favorite ayats',
                            style: TextStyle(
                              color: white70,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Add ayats to your favorites',
                            style: TextStyle(
                              color: white54,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              favoritesController.clearAllAyatFavorites();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: grey100,
                            ),
                            child: const Text(
                              'Clear All',
                              style: TextStyle(color: white),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: favoritesController.favoriteAyats.length,
                      itemBuilder: (context, index) {
                        final ayat = favoritesController.favoriteAyats[index];
                        return AyatTile(
                          ayat: ayat,
                          onTap: () {
                            // Navigate to AyatDetailScreen (adjust as per your app's navigation)
                            Get.to(() => UrduQuranScreen(
                                  surahNumber: ayat.surahNumber,
                                  surahNameAr: ayat.surahNameAr,
                                  surahNameEng: ayat.surahNameEng,
                                  lang: ayat.language,
                                  isLTR: true,

                                  // ayatNumber: ayat.ayatNumber,
                                  // arabicText: ayat.arabicText,
                                  // translation: ayat.translation,
                                  // language: ayat.language,
                                ));
                          },
                        );
                      },
                    ),
            ),
            // Hadiths Tab
            Obx(
              () => favoritesController.favoriteHadiths.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border,
                            color: white54,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No favorite hadiths',
                            style: TextStyle(
                              color: white70,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Add hadiths to your favorites',
                            style: TextStyle(
                              color: white54,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              favoritesController.clearAllHadithFavorites();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: grey100,
                            ),
                            child: const Text(
                              'Clear All',
                              style: TextStyle(color: white),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: favoritesController.favoriteHadiths.length,
                      itemBuilder: (context, index) {
                        final hadith =
                            favoritesController.favoriteHadiths[index];
                        return HadithTile(
                          hadithItem: HadithItem(
                            hadithNumber:
                                int.parse(hadith['hadithNumber'].toString()),
                            text: hadith['text'],
                            editionName: hadith['editionName'],
                            grades: List<String>.from(hadith['grades']),
                          ),
                          onTap: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(
                                  color: primary,
                                ),
                              ),
                            );

                            try {
                              final hadithDetail =
                                  await HadithApiService.getHadithDetail(
                                hadith['editionName'],
                                int.parse(hadith['hadithNumber'].toString()),
                              );

                              Navigator.pop(context);

                              Get.to(() => HadithDetailScreen(
                                    hadithDetail: hadithDetail,
                                    displayName: hadith['displayName'],
                                    language: hadith['language'],
                                    sectionName: hadith['sectionName'],
                                  ));
                            } catch (e) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Failed to load hadith details: $e'),
                                  backgroundColor: red,
                                ),
                              );
                            }
                          },
                          editionName: hadith['editionName'],
                          displayName: hadith['displayName'],
                          language: hadith['language'],
                          sectionName: hadith['sectionName'],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class AyatTile extends StatelessWidget {
  final FavoriteAyat ayat;
  final VoidCallback onTap;

  const AyatTile({
    super.key,
    required this.ayat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final FavoritesController favoritesController =
        Get.find<FavoritesController>();

    return InkWell(
      splashColor: transparent,
      highlightColor: transparent,
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: secondary,
          border: Border.all(color: white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with surah and ayat number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: grey100.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: grey100.withOpacity(0.5),
                    ),
                  ),
                  child: Text(
                    '${ayat.surahNameEng} ${ayat.ayatNumber}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: grey100,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    favoritesController.removeAyatFromFavorites(
                      surahNumber: ayat.surahNumber,
                      ayatNumber: ayat.ayatNumber,
                      language: ayat.language,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Removed from favorites'),
                        backgroundColor: red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.favorite,
                      color: grey100,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Arabic text
            Text(
              ayat.arabicText,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: white70,
                height: 1.5,
                fontFamily: 'Amiri', // Adjust font for Arabic if needed
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            // Translation
            Text(
              ayat.translation.length > 150
                  ? '"${ayat.translation.substring(0, 150)}..."'
                  : '"${ayat.translation}"',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: white70,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tap to read full ayat',
                  style: TextStyle(
                    fontSize: 12,
                    color: white54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: white54,
                  size: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
