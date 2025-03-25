// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:tasbeeh_app/Controller/quran_controller.dart';
// import 'package:tasbeeh_app/Controller/surah_controller.dart';
// import 'package:tasbeeh_app/Model/quran_model.dart';

// class SurahDetailView extends StatelessWidget {
//   final Surah surah;
//   final int? lastReadAyah;

//   SurahDetailView({
//     super.key,
//     required this.surah,
//     this.lastReadAyah,
//   });

//   final QuranController controller = Get.find<QuranController>();
//   final SurahController surahController = Get.put(SurahController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//         title: Text(
//           surah.englishName,
//           style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         centerTitle: true,
//       ),
//       body: ListView.builder(
//         physics: const BouncingScrollPhysics(),
//         padding: const EdgeInsets.all(12),
//         itemCount: surah.ayahs.length,
//         itemBuilder: (context, index) {
//           final ayah = surah.ayahs[index];

//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 5),
//             color: (lastReadAyah != null && ayah.numberInSurah == lastReadAyah)
//                 ? Colors.green.shade100 // Highlight the last read ayah
//                 : Colors.white,
//             child: ListTile(
//               contentPadding: const EdgeInsets.all(16),
//               title: Text(
//                 ayah.text,
//                 textAlign: TextAlign.right,
//                 style: GoogleFonts.amiriQuran(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(
//                     height: 25,
//                   ),
//                   Text(
//                     "Ayah ${ayah.numberInSurah} | Page ${ayah.page}",
//                     textAlign: TextAlign.left,
//                     style: GoogleFonts.poppins(
//                       fontSize: 14,
//                       color: Colors.green.shade700,
//                     ),
//                   ),
//                 ],
//               ),
//               onTap: () {
//                 surahController.clearSharedPreferences();
//                 controller.saveLastRead(surah.number, ayah.numberInSurah);
//                 Get.snackbar(
//                   "Saved",
//                   "Reading progress updated",
//                   snackPosition: SnackPosition.TOP,
//                   backgroundColor: Colors.green,
//                   colorText: Colors.white,
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Controller/quran_controller.dart';
import 'package:tasbeeh_app/Controller/surah_controller.dart';
import 'package:tasbeeh_app/Model/quran_model.dart';

class SurahDetailView extends StatefulWidget {
  final Surah surah;
  final int? lastReadAyah;

  const SurahDetailView({
    super.key,
    required this.surah,
    this.lastReadAyah,
  });

  @override
  State<SurahDetailView> createState() => _SurahDetailViewState();
}

class _SurahDetailViewState extends State<SurahDetailView> {
  final QuranController controller = Get.find<QuranController>();
  final SurahController surahController = Get.put(SurahController());
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Scroll to lastReadAyah after the first frame is built
    if (widget.lastReadAyah != null && widget.lastReadAyah! > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToLastReadAyah();
      });
    }
  }

  void _scrollToLastReadAyah() {
    // Estimate item height based on your ListTile design
    const double itemHeight =
        150.0; // Adjust this based on your Card/ListTile height
    final double offset = (widget.lastReadAyah! - 1) * itemHeight;

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          widget.surah.englishName,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView.builder(
        controller: _scrollController, // Attach the ScrollController
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(12),
        itemCount: widget.surah.ayahs.length,
        itemBuilder: (context, index) {
          final ayah = widget.surah.ayahs[index];

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: (widget.lastReadAyah != null &&
                      ayah.numberInSurah == widget.lastReadAyah)
                  ? Colors.green.shade200 // Highlight the last read ayah
                  : Colors.green.shade50,
            ),
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              splashColor: Colors.transparent,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                ayah.text,
                textAlign: TextAlign.right,
                style: GoogleFonts.amiriQuran(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Ayah ${ayah.numberInSurah} | Page ${ayah.page}",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
              onTap: () {
                // surahController.clearSharedPreferences();
                controller.saveLastRead(
                    widget.surah.number, ayah.numberInSurah);
                Get.snackbar(
                  "Saved",
                  "Reading progress updated",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
