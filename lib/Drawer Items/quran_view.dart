// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:tasbeeh_app/Components/animated_loader.dart';
// import 'package:tasbeeh_app/Controller/quran_controller.dart';
// import 'package:tasbeeh_app/Drawer%20Items/surah_view.dart';

// class QuranView extends StatelessWidget {
//   const QuranView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final QuranController controller = Get.find<QuranController>();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//         title: Text(
//           "Al-Quran",
//           style: GoogleFonts.poppins(
//             // English Font
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//       ),
//       body: Column(
//         children: [
//           Obx(() {
//             if (controller.isLoading.value) {
//               return const SizedBox.shrink();
//             }
//             if (controller.lastReadSurah.value > 0) {
//               return Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green.shade700,
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 15, horizontal: 20),
//                   ),
//                   onPressed: () {
//                     final lastSurah = controller.quranModel.value.surahs
//                         .firstWhere(
//                             (s) => s.number == controller.lastReadSurah.value);
//                     Get.to(
//                       () => SurahDetailView(
//                         surah: lastSurah,
//                         lastReadAyah: controller.lastReadAyah.value,
//                       ),
//                     );
//                   },
//                   child: const Text("Resume Last Reading",
//                       style: TextStyle(color: Colors.white)),
//                 ),
//               );
//             } else {
//               return const SizedBox(); // Hide button if no saved progress
//             }
//           }),
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(
//                   child: AnimatedLoader(
//                     color: Colors.green,
//                   ),
//                 );
//               }
//               return ListView.builder(
//                 shrinkWrap: true,
//                 physics: const BouncingScrollPhysics(),
//                 itemCount: controller.quranModel.value.surahs.length,
//                 itemBuilder: (context, index) {
//                   final surah = controller.quranModel.value.surahs[index];
//                   return Card(
//                     margin:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: Colors.green.shade700,
//                         child: Text(
//                           surah.number.toString(),
//                           style: GoogleFonts.poppins(
//                             // English Font for numbers
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       title: Text(
//                         surah.englishName,
//                         style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text(
//                         surah.englishNameTranslation,
//                         style: GoogleFonts.poppins(color: Colors.grey.shade700),
//                       ),
//                       trailing: Text(
//                         surah.name, // Arabic text
//                         style: GoogleFonts.amiriQuran(
//                           // Arabic Font
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       onTap: () => Get.to(() => SurahDetailView(surah: surah)),
//                     ),
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Components/animated_loader.dart';
import 'package:tasbeeh_app/Components/animation.dart';
import 'package:tasbeeh_app/Controller/quran_controller.dart';
import 'package:tasbeeh_app/Drawer%20Items/surah_view.dart';

class QuranView extends StatelessWidget {
  const QuranView({super.key});

  @override
  Widget build(BuildContext context) {
    final QuranController controller = Get.find<QuranController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          "Al-Quran",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return const SizedBox.shrink();
            }
            if (controller.lastReadSurah.value > 0) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                  ),
                  onPressed: () {
                    final lastSurah = controller.quranModel.value.surahs
                        .firstWhere(
                            (s) => s.number == controller.lastReadSurah.value);
                    Get.to(
                      () => SurahDetailView(
                        surah: lastSurah,
                        lastReadAyah: controller.lastReadAyah.value,
                      ),
                    );
                  },
                  child: const Text("Resume Last Reading",
                      style: TextStyle(color: Colors.white)),
                ),
              );
            } else {
              return const SizedBox(); // Hide button if no saved progress
            }
          }),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: AnimatedLoader(
                    color: Colors.green,
                  ),
                );
              }
              if (controller.quranModel.value.surahs.isEmpty) {
                return const Center(
                  child: Text("No Surahs loaded. Check data source."),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.quranModel.value.surahs.length,
                itemBuilder: (context, index) {
                  final surah = controller.quranModel.value.surahs[index];
                  return AppButtonAnimation(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      child: ListTile(
                        splashColor: Colors.transparent,
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.shade700,
                          child: Text(
                            surah.number.toString(),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          surah.englishName,
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          surah.englishNameTranslation,
                          style:
                              GoogleFonts.poppins(color: Colors.grey.shade700),
                        ),
                        trailing: Text(
                          surah.name,
                          style: GoogleFonts.amiriQuran(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        onTap: () =>
                            Get.to(() => SurahDetailView(surah: surah)),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
