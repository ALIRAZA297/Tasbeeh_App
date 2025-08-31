// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../Controller/quran_controller.dart';
import '../../../Model/quran_model.dart';
import '../../../Utils/app_colors.dart';

class AllQuranScreen extends StatelessWidget {
  final quranController = Get.find<AllQuranController>();

  AllQuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: AppBar(
                centerTitle: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(quranController.title.value),
              ),
            ),
            Obx(() {
              if (quranController.quranVerseList.isEmpty ||
                  quranController.loading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.83,
                  child: ListView.builder(
                    itemCount: quranController.quranVerseList.length,
                    itemBuilder: (context, index) {
                      final quran = quranController.quranVerseList[index];
                      // final audio = quranController.quranAudioList[index];
                      return QuranVerseCard(
                        quran: quran,
                        // audio: audio,
                      );
                    },
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}

class QuranVerseCard extends StatelessWidget {
  final QuranVerse quran;
  // final AudioModel audio;

  QuranVerseCard({
    super.key,
    required this.quran,
    // required this.audio,
  });
  final quranController = Get.put(AllQuranController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 5,
          ),
          // padding: EdgeInsets.all(Dimensions.defaultPaddingSize * 0.5),
          // decoration: BoxDecoration(
          color: grey100,
          //   borderRadius: BorderRadius.circular(8 * 1.4),
          // ),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      quran.index.toString(),
                      style: TextStyle(
                        color: primary,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      quranController.titleAr.value,
                      style: TextStyle(
                        color: primary,
                        fontSize: 20,
                      ),
                    ).paddingSymmetric(vertical: 5),
                    Text(
                      quranController.type.value,
                      style: TextStyle(color: primary, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Visibility(
          child: Card(
            color: grey100,
            margin: EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 3,
            ),
            elevation: 3,
            shadowColor: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: primary,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          // Obx(
                          //   () => InkWell(
                          //     onTap: () {
                          //       quranController.playBismillah();
                          //     },
                          //     child: Icon(
                          //         size: 26,
                          //         color: primary,
                          //         quranController.isPlaying.value
                          //             ? Icons.pause_circle_outlined
                          //             : Icons.play_circle_outline),
                          //   ),
                          // ),
                        ],
                      ),
                      Opacity(
                        opacity: 0.8,
                        child: Text(
                          'Bismillah Hir Rahman Nir Rahim',
                          style: TextStyle(fontSize: 18, color: primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Column(
          children: List.generate(
            quran.verse.length,
            (index) {
              final verseKey = 'verse_${index + 1}';
              final verseText = quran.verse[verseKey] ?? '';
              final verseTextEn = quran.translationBn[verseKey] ?? '';
//final

              return Card(
                color: grey100,
                margin: EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 3,
                ),
                elevation: 3,
                shadowColor: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text((index + 1).toString()),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                        text:
                                            "${index + 1} $verseText \n $verseTextEn"),
                                  ).then((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Copied to your clipboard!")));
                                  });
                                },
                                child: Icon(Icons.copy),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              //!play && pause button
                              // Obx(
                              //   () => InkWell(
                              //     onTap: () {
                              //       //! functional work here
                              //       final verseKey2 = 'verse_${index + 1}';
                              //       quranController.url.value =
                              //           audio.audios[verseKey2] ?? '';

                              //       quranController.playAudio(
                              //         quranController.url.value,
                              //       );

                              //       quranController.selectPlayingIndex.value =
                              //           index + 1;
                              //     },
                              //     child: Icon(
                              //       size: 26,
                              //       quranController.selectPlayingIndex.value ==
                              //                   index + 1 &&
                              //               quranController.isPlayingAudio.value
                              //           ? Icons.pause_circle_outlined
                              //           : Icons.play_circle_outline,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        alignment: Alignment.bottomRight,
                        child: Text(
                          verseText,
                          style: TextStyle(
                            color: primary,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          verseTextEn,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
