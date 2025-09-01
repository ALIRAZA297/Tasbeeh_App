import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tasbeeh_app/Utils/app_colors.dart';
import 'package:tasbeeh_app/Controller/fav_controller.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../Controller/quran_controller.dart';
import 'Controller/urdu_quran_controller.dart';

class UrduQuranScreen extends StatefulWidget {
  const UrduQuranScreen({
    required this.surahNumber,
    required this.lang,
    required this.surahNameAr,
    required this.surahNameEng,
    required this.isLTR,
    this.scrollToAyat,
    super.key,
  });

  final int surahNumber;
  final bool isLTR;
  final String lang, surahNameAr, surahNameEng;
  final int? scrollToAyat;

  @override
  State<UrduQuranScreen> createState() => _UrduQuranScreenState();
}

class _UrduQuranScreenState extends State<UrduQuranScreen> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  final FavoritesController favoritesController =
      Get.put(FavoritesController());
  final AllQuranController quranController = Get.find<AllQuranController>();
  final UrduQuranController quranTextController =
      Get.put(UrduQuranController());

  final GlobalKey _listViewKey = GlobalKey();
  bool _hasScrolledToTarget = false;
  int _lastVisibleAyat = 1;

  @override
  void initState() {
    super.initState();
    quranTextController.initialize(widget.surahNumber, widget.lang);
  }

  void _onAyatVisibilityChanged(int ayatNumber, VisibilityInfo info) {
    if (info.visibleFraction > 0.5 && mounted) {
      if (ayatNumber > _lastVisibleAyat) {
        _lastVisibleAyat = ayatNumber;
        _saveReadingProgress(ayatNumber);
      }
    }
  }

  void _saveReadingProgress(int ayatNumber) {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        quranController.saveLastReadAyat(
          surahNumber: widget.surahNumber,
          ayatNumber: ayatNumber,
          surahNameAr: widget.surahNameAr,
          surahNameEng: widget.surahNameEng,
          language: widget.lang,
        );
      }
    });
  }

  void _scrollToAyat(int ayatIndex) {
    if (_itemScrollController.isAttached &&
        quranTextController.surahList.isNotEmpty) {
      final validIndex =
          ayatIndex.clamp(0, quranTextController.surahList.length - 1);
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_itemScrollController.isAttached) {
          _itemScrollController.scrollTo(
            index: validIndex,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            alignment: 0.0,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Resumed at Ayat ${validIndex + 1}'),
              backgroundColor: primary,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!quranTextController.isLoading.value &&
          quranTextController.surahList.isNotEmpty &&
          widget.scrollToAyat != null &&
          !_hasScrolledToTarget) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToAyat(widget.scrollToAyat! - 1);
          _hasScrolledToTarget = true;
        });
      }

      return ModalProgressHUD(
        inAsyncCall: quranTextController.isLoading.value,
        progressIndicator: const CircularProgressIndicator(
          color: primary,
        ),
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: AppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    centerTitle: true,
                    toolbarHeight: 60,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.surahNameAr,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.surahNameEng,
                          style: TextStyle(
                            fontSize: 20,
                            color: Get.isDarkMode ? grey400 : grey800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.scrollToAyat != null)
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? white : primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.bookmark,
                          color: primary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Resuming from Ayat ${widget.scrollToAyat}',
                          style: const TextStyle(
                            color: primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                Visibility(
                  visible: widget.surahNumber != 1 && widget.surahNumber != 9,
                  child: Card(
                    color: secondary,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: primary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Opacity(
                            opacity: 0.8,
                            child: Text(
                              'Bismillah Hir Rahman Nir Rahim',
                              style: TextStyle(
                                fontSize: 18,
                                color: primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ScrollablePositionedList.builder(
                    key: _listViewKey,
                    itemScrollController: _itemScrollController,
                    itemPositionsListener: _itemPositionsListener,
                    shrinkWrap: true,
                    itemCount: quranTextController.surahList.length,
                    itemBuilder: (context, index) {
                      final ayat = quranTextController.surahList[index];
                      final ayatNumber = index + 1;

                      return VisibilityDetector(
                        key: Key('ayat_${widget.surahNumber}_$ayatNumber'),
                        onVisibilityChanged: (VisibilityInfo info) {
                          _onAyatVisibilityChanged(ayatNumber, info);
                        },
                        child: Card(
                          color: secondary,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            decoration: widget.scrollToAyat == ayatNumber
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Get.isDarkMode
                                          ? red
                                          : primary.withOpacity(0.5),
                                      width: 3,
                                    ),
                                  )
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: primary.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          ayatNumber.toString(),
                                          style: const TextStyle(
                                            color: primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Obx(() => InkWell(
                                                onTap: () {
                                                  favoritesController
                                                      .toggleAyatFavorite(
                                                    surahNumber:
                                                        widget.surahNumber,
                                                    surahNameAr:
                                                        widget.surahNameAr,
                                                    surahNameEng:
                                                        widget.surahNameEng,
                                                    ayatNumber: ayatNumber,
                                                    arabicText:
                                                        ayat.arabicText ?? '',
                                                    translation:
                                                        ayat.translation ?? '',
                                                    language: widget.lang,
                                                  );
                                                },
                                                child: Icon(
                                                  favoritesController
                                                          .isAyatFavorite(
                                                    surahNumber:
                                                        widget.surahNumber,
                                                    ayatNumber: ayatNumber,
                                                    language: widget.lang,
                                                  )
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: favoritesController
                                                          .isAyatFavorite(
                                                    surahNumber:
                                                        widget.surahNumber,
                                                    ayatNumber: ayatNumber,
                                                    language: widget.lang,
                                                  )
                                                      ? Colors.redAccent
                                                      : primary,
                                                  size: 24,
                                                ),
                                              )),
                                          const SizedBox(width: 8),
                                          InkWell(
                                            onTap: () {
                                              Clipboard.setData(
                                                ClipboardData(
                                                  text:
                                                      "$ayatNumber ${ayat.arabicText} \n ${ayat.translation}",
                                                ),
                                              ).then((_) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Copied to your clipboard!')),
                                                );
                                              });
                                            },
                                            child: const Icon(Icons.copy,
                                                color: primary),
                                          ),
                                          const SizedBox(width: 10),
                                          Obx(() {
                                            final isLoading =
                                                quranTextController
                                                            .isBufferingAudio[
                                                        index] ??
                                                    false;
                                            final isPlaying = quranTextController
                                                    .isPlaying.value &&
                                                quranTextController
                                                            .isBufferingAudio[
                                                        index] ==
                                                    false;
                                            return InkWell(
                                              onTap: isLoading
                                                  ? null
                                                  : () {
                                                      quranTextController
                                                          .fetchAndPlayAudio(
                                                              index,
                                                              widget
                                                                  .surahNumber);
                                                      _saveReadingProgress(
                                                          ayatNumber);
                                                    },
                                              child: isLoading
                                                  ? const SizedBox(
                                                      width: 18,
                                                      height: 18,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 3,
                                                        color: primary,
                                                      ),
                                                    )
                                                  : Icon(
                                                      isPlaying
                                                          ? Icons.pause
                                                          : Icons.play_arrow,
                                                      color: primary,
                                                      size: 24,
                                                    ),
                                            );
                                          }),
                                          const SizedBox(width: 10),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      ayat.arabicText ?? '',
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.amiri(
                                        color: primary,
                                        fontSize: 20,
                                        height: 2,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: widget.isLTR
                                        ? Alignment.bottomLeft
                                        : Alignment.bottomRight,
                                    child: Text(
                                      ayat.translation ?? '',
                                      textAlign: widget.isLTR
                                          ? TextAlign.left
                                          : TextAlign.right,
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: widget.scrollToAyat != null
              ? FloatingActionButton.small(
                  onPressed: () {
                    quranController.clearLastRead();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reading progress cleared'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  backgroundColor: Colors.grey[600],
                  child: const Icon(Icons.clear, color: Colors.white),
                )
              : null,
        ),
      );
    });
  }
}
