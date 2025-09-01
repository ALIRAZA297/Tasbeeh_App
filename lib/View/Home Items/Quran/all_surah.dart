import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Controller/quran_controller.dart';
import 'Model/surah_model.dart';
import '../../../Utils/app_colors.dart';
import '../../../Controller/fav_controller.dart';
import 'urdu_quran.dart';

class SurahScreen extends StatefulWidget {
  const SurahScreen({this.isCameFromNevBar, super.key});
  final bool? isCameFromNevBar;

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen>
    with SingleTickerProviderStateMixin {
  final AllQuranController quranController = Get.find<AllQuranController>();
  final FavoritesController favoritesController =
      Get.put(FavoritesController());
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.arrow_back,
                        color: white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left side - Title Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeTransition(
                            opacity: _animationController,
                            child: Text(
                              "Al-Quran",
                              style: GoogleFonts.poppins(
                                color: white.withOpacity(0.65),
                                fontSize: 14,
                                letterSpacing: 4,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(-0.2, 0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: _animationController,
                              curve: Curves.easeOut,
                            )),
                            child: Text(
                              'The Holy Quran',
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Right side - Menu Icon with glow effect
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: white.withOpacity(0.1),
                          boxShadow: [
                            BoxShadow(
                              color: white.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          color: white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Enhanced Content Section
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Get.isDarkMode ? black : white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Resume Reading Button
                    Obx(() {
                      if (quranController.hasLastRead.value) {
                        final lastRead = quranController.lastReadInfo;
                        return Container(
                          margin: const EdgeInsets.all(20),
                          child: Material(
                            color: transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => quranController.resumeReading(),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      primary,
                                      primary.withOpacity(0.8),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primary.withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow_rounded,
                                        color: white,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Resume Reading",
                                            style: GoogleFonts.poppins(
                                              color: white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${lastRead['surahNameEng']} - Ayat ${lastRead['ayatNumber']}",
                                            style: GoogleFonts.poppins(
                                              color: white.withOpacity(0.9),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            quranController
                                                .getTimeSinceLastRead(),
                                            style: GoogleFonts.poppins(
                                              color: white.withOpacity(0.7),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        lastRead['surahNameAr'] ?? '',
                                        style: GoogleFonts.amiri(
                                          color: white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    // Enhanced Statistics Row
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        gradient: Get.isDarkMode
                            ? LinearGradient(
                                colors: [
                                  white.withOpacity(0.2),
                                  white.withOpacity(0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : LinearGradient(
                                colors: [
                                  primary.withOpacity(0.1),
                                  primary.withOpacity(0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Get.isDarkMode
                              ? secondary
                              : primary.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem("Total", "114", Icons.menu_book),
                          _buildVerticalDivider(),
                          _buildStatItem("Makki", "86", Icons.mosque),
                          _buildVerticalDivider(),
                          _buildStatItem("Madani", "28", Icons.location_on),
                        ],
                      ),
                    ),
                    // Enhanced Surah List
                    Expanded(
                      child: Obx(() {
                        if (quranController.quranSurahList.isEmpty) {
                          return const CircularProgressIndicator(
                            color: primary,
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.only(
                            bottom: 100,
                            top: 10,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemCount: quranController.quranSurahList.length,
                          itemBuilder: (context, index) {
                            final surah = quranController.quranSurahList[index];
                            return _buildEnhancedSurahCard(
                                context, surah, index);
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Get.isDarkMode
          ? secondary.withOpacity(0.5)
          : primary.withOpacity(0.2),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Get.isDarkMode ? primary200 : primary,
          size: 20,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Get.isDarkMode ? primary200 : primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Get.isDarkMode ? grey400 : grey700,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedSurahCard(
      BuildContext context, QuranSurah surah, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: primary.withOpacity(0.1),
        ),
      ),
      child: Stack(
        children: [
          Material(
            color: transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () =>
                  _showEnhancedTranslationBottomSheet(context, surah, index),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    // Enhanced Surah Number
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primary.withOpacity(0.2),
                            primary.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          surah.index.toString(),
                          style: GoogleFonts.poppins(
                            color: primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            surah.title,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${surah.count} Verses • ${surah.place}",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        surah.titleAr,
                        style: GoogleFonts.amiri(
                          color: primary,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Add favorite button
          // Obx(() => Positioned(
          //       right: 5,
          //       top: 0,
          //       child: InkWell(
          //         onTap: () => favoritesController.toggleSurahFavorite(
          //           index: int.tryParse(surah.index.toString()) ?? 0,
          //           title: surah.title,
          //           titleAr: surah.titleAr,
          //           place: surah.place,
          //           count: surah.count,
          //         ),
          //         child: Container(
          //           padding: const EdgeInsets.all(8),
          //           child: Icon(
          //             favoritesController.isSurahFavorite(
          //                     int.tryParse(surah.index.toString()) ?? 0)
          //                 ? Icons.favorite
          //                 : Icons.favorite_border,
          //             color: favoritesController.isSurahFavorite(
          //                     int.tryParse(surah.index.toString()) ?? 0)
          //                 ? red
          //                 : primary.withOpacity(0.5),
          //             size: 22,
          //           ),
          //         ),
          //       ),
          //     )),
        ],
      ),
    );
  }

  void _showEnhancedTranslationBottomSheet(
      BuildContext context, QuranSurah surah, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.50,
        decoration: BoxDecoration(
          color: white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: primary.withOpacity(0.1),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              surah.titleAr,
                              style: GoogleFonts.amiri(
                                fontSize: 32,
                                color: primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              surah.title,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: grey800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        surah.place,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.format_list_numbered,
                        size: 16,
                        color: primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${surah.count} Verses",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Choose Translation",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: grey700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildEnhancedTranslationButton(
                    "English",
                    Icons.translate,
                    () {
                      Get.back();
                      Get.to(
                        () => UrduQuranScreen(
                          isLTR: true,
                          surahNameAr: surah.titleAr,
                          surahNameEng: surah.title,
                          surahNumber: index + 1,
                          lang: "english_saheeh",
                        ),
                      );
                    },
                  ),
                  _buildEnhancedTranslationButton(
                    "Urdu",
                    Icons.translate,
                    () {
                      Get.back();
                      Get.to(() => UrduQuranScreen(
                            isLTR: false,
                            surahNameAr: surah.titleAr,
                            surahNameEng: surah.title,
                            surahNumber: index + 1,
                            lang: "urdu_junagarhi",
                          ));
                    },
                  ),
                  _buildEnhancedTranslationButton(
                    "Pashto",
                    Icons.translate,
                    () {
                      Get.back();
                      Get.to(() => UrduQuranScreen(
                            isLTR: false,
                            surahNameAr: surah.titleAr,
                            surahNameEng: surah.title,
                            surahNumber: index + 1,
                            lang: "pashto_zakaria",
                          ));
                    },
                  ),
                  _buildEnhancedTranslationButton(
                    "Indonesia",
                    Icons.translate,
                    () {
                      Get.back();
                      Get.to(() => UrduQuranScreen(
                            isLTR: true,
                            surahNameAr: surah.titleAr,
                            surahNameEng: surah.title,
                            surahNumber: index + 1,
                            lang: "indonesian_affairs",
                          ));
                    },
                  ),
                  _buildEnhancedTranslationButton(
                    "Bengali",
                    Icons.translate,
                    () {
                      Get.back();
                      Get.to(() => UrduQuranScreen(
                            isLTR: true,
                            surahNameAr: surah.titleAr,
                            surahNameEng: surah.title,
                            surahNumber: index + 1,
                            lang: "bengali_mokhtasar",
                          ));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedTranslationButton(
    String text,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.only(right: 8, left: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primary,
              primary.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: white,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: GoogleFonts.poppins(
                color: white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildGlowingBorder({required Widget child}) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(15),
  //       boxShadow: [
  //         BoxShadow(
  //           color: primary.withOpacity(0.2),
  //           blurRadius: 10,
  //           spreadRadius: 2,
  //         ),
  //       ],
  //     ),
  //     child: child,
  //   );
  // }
}
