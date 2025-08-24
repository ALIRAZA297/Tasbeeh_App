// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:tasbeeh_app/Controller/quran_controller.dart';
// import 'package:tasbeeh_app/Controller/surah_controller.dart';
// import 'package:tasbeeh_app/Model/quran_model.dart';
// import 'package:tasbeeh_app/Utils/app_colors.dart';

// import '../../../Controller/quran_audio_controller.dart';
// import '../../../Model/surah_e_quran_model.dart';

// class SurahDetailView extends StatefulWidget {
//   final Surah surah;
//   final int? lastReadAyah;

//   const SurahDetailView({
//     super.key,
//     required this.surah,
//     this.lastReadAyah,
//   });

//   @override
//   State<SurahDetailView> createState() => _SurahDetailViewState();
// }

// class _SurahDetailViewState extends State<SurahDetailView> {
//   final QuranController controller = Get.find<QuranController>();
//   final SurahController surahController = Get.put(SurahController());
//   late ScrollController _scrollController;
//   final Map<int, GlobalKey> _ayahKeys = {};
//   bool _isScrolling = false;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();

//     for (var i = 0; i < widget.surah.ayahs.length; i++) {
//       _ayahKeys[i] = GlobalKey();
//     }

//     if (widget.lastReadAyah != null && widget.lastReadAyah! > 0) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Future.delayed(const Duration(milliseconds: 500), () {
//           if (mounted && !_isScrolling) {
//             _startScrollingToLastReadAyah();
//           }
//         });
//       });
//     }
//   }

//   void _startScrollingToLastReadAyah() {
//     if (!_scrollController.hasClients ||
//         widget.lastReadAyah == null ||
//         widget.lastReadAyah! <= 0) {
//       log('Scroll aborted: invalid conditions');
//       return;
//     }

//     _isScrolling = true;

//     // Pixels to scroll per step
//     const double scrollIncrement = 150.0;

//     const Duration scrollInterval = Duration(milliseconds: 50);

//     void scrollToNextPosition() {
//       if (!_scrollController.hasClients || !_isScrolling) {
//         _isScrolling = false;
//         return;
//       }

//       final currentPosition = _scrollController.position.pixels;
//       final maxExtent = _scrollController.position.maxScrollExtent;

//       // Check if target is in view
//       final targetIndex = widget.lastReadAyah! - 1;
//       final targetKey = _ayahKeys[targetIndex];
//       if (targetKey != null && targetKey.currentContext != null) {
//         final RenderBox? renderBox =
//             targetKey.currentContext!.findRenderObject() as RenderBox?;
//         if (renderBox != null) {
//           final position = renderBox.localToGlobal(Offset.zero);
//           final screenHeight = MediaQuery.of(context).size.height;
//           final targetTop = position.dy;
//           final targetBottom = targetTop + renderBox.size.height;

//           // Stop if target is visible
//           if (targetTop >= 0 && targetBottom <= screenHeight * 0.8) {
//             _isScrolling = false;
//             final centeredOffset = currentPosition -
//                 (screenHeight * 0.5 - renderBox.size.height / 2);
//             _scrollController.animateTo(
//               centeredOffset > 0 ? centeredOffset : currentPosition,
//               duration: const Duration(milliseconds: 300),
//               curve: Curves.easeOut,
//             );
//             log('Stopped at ayah ${widget.lastReadAyah} at position: $centeredOffset');
//             return;
//           }
//         }
//       }

//       // Continue scrolling if not at max and target not found
//       if (currentPosition < maxExtent) {
//         _scrollController.jumpTo(currentPosition + scrollIncrement);
//         Future.delayed(scrollInterval, scrollToNextPosition);
//       } else {
//         _isScrolling = false;
//         log('Reached end of list at: $currentPosition');
//       }
//     }

//     // Start scrolling
//     log('Starting scroll to find ayah ${widget.lastReadAyah}');
//     scrollToNextPosition();
//   }

//   @override
//   void dispose() {
//     _isScrolling = false;
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//         title: Text(
//           widget.surah.englishName,
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.bold,
//             color: Get.isDarkMode ? white : black,
//           ),
//         ),
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         centerTitle: true,
//       ),
//       body: GetBuilder<QuranAudioController>(
//         init: QuranAudioController(),
//         builder: (audioController) {
//           return ListView.builder(
//             controller: _scrollController,
//             physics: const BouncingScrollPhysics(),
//             padding: const EdgeInsets.all(12),
//             itemCount: widget.surah.ayahs.length,
//             cacheExtent: 3000.0,
//             itemBuilder: (context, index) {
//               final ayah = widget.surah.ayahs[index];
//               final isLastRead = widget.lastReadAyah != null &&
//                   ayah.numberInSurah == widget.lastReadAyah;

//               return Container(
//                 key: _ayahKeys[index],
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: isLastRead ? primary200 : secondary,
//                   border: Border.all(
//                     color: isLastRead
//                         ? primary700.withOpacity(0.3)
//                         : Colors.transparent,
//                     width: 1,
//                   ),
//                 ),
//                 margin: const EdgeInsets.symmetric(vertical: 5),
//                 child: Column(
//                   children: [
//                     // Main Ayah Content
//                     ListTile(
//                       splashColor: transparent,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//                       title: Text(
//                         ayah.text,
//                         textAlign: TextAlign.right,
//                         style: GoogleFonts.amiri(
//                           fontSize: 26,
//                           height: 2.5,
//                           fontWeight: FontWeight.bold,
//                           color: black,
//                         ),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(height: 20),
//                           Text(
//                             "Ayah ${ayah.numberInSurah} | Page ${ayah.page} | Juz ${ayah.juz} | Manzil ${ayah.manzil}",
//                             textAlign: TextAlign.left,
//                             style: GoogleFonts.poppins(
//                               fontSize: 14,
//                               color: primary700,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                       onTap: () {
//                         controller.saveLastRead(
//                             widget.surah.number, ayah.numberInSurah);
//                         Get.snackbar(
//                           "Saved",
//                           "Reading progress updated",
//                           snackPosition: SnackPosition.TOP,
//                           backgroundColor: primary,
//                           colorText: white,
//                         );
//                       },
//                     ),

//                     // Audio Controls Row
//                     Align(
//                       alignment: Alignment.bottomRight,
//                       child: Container(
//                         padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
//                         child: InkWell(
//                           onTap: () {
//                             audioController.fetchAndPlayAudio(
//                                 index, widget.surah.number);
//                           },
//                           borderRadius: BorderRadius.circular(25),
//                           child: Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: audioController.isPlaying(index)
//                                   ? primary700
//                                   : audioController.isLoadingAudio(index)
//                                       ? Colors.orange.withOpacity(0.2)
//                                       : Colors.black.withOpacity(0.15),
//                               shape: BoxShape.circle,
//                               boxShadow: audioController.isPlaying(index)
//                                   ? [
//                                       BoxShadow(
//                                         color: primary700.withOpacity(0.3),
//                                         blurRadius: 8,
//                                         offset: const Offset(0, 2),
//                                       ),
//                                     ]
//                                   : null,
//                             ),
//                             child: _buildAudioIcon(audioController, index),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildAudioIcon(QuranAudioController audioController, int index) {
//     if (audioController.isDownloadingAudio(index)) {
//       return SizedBox(
//         width: 20,
//         height: 20,
//         child: CircularProgressIndicator(
//           strokeWidth: 2,
//           valueColor: AlwaysStoppedAnimation<Color>(
//             Get.isDarkMode ? Colors.white70 : primary700,
//           ),
//         ),
//       );
//     }

//     if (audioController.isBufferingAudio(index)) {
//       return SizedBox(
//         width: 20,
//         height: 20,
//         child: CircularProgressIndicator(
//           strokeWidth: 2,
//           valueColor: AlwaysStoppedAnimation<Color>(
//             audioController.isPlaying(index) ? white : primary700,
//           ),
//         ),
//       );
//     }

//     if (audioController.isPlaying(index)) {
//       return const Icon(
//         Icons.pause,
//         size: 20,
//         color: white,
//       );
//     }

//     return Icon(
//       Icons.play_arrow,
//       size: 20,
//       color: Get.isDarkMode ? Colors.white70 : primary700,
//     );
//   }
// }
