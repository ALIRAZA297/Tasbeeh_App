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
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Quran",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Get.isDarkMode ? AppColors.white : AppColors.black,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Container(
            //   padding: const EdgeInsets.all(24),
            //   child: Column(
            //     children: [
            //       Align(
            //         alignment: Alignment.centerLeft,
            //         child: InkWell(
            //           onTap: () => Get.back(),
            //           child: const Icon(
            //             Icons.arrow_back,
            //             color: AppColors.white,
            //           ),
            //         ),
            //       ),
            //       const SizedBox(
            //         height: 10,
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           // Left side - Title Section
            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               FadeTransition(
            //                 opacity: _animationController,
            //                 child: Text(
            //                   "Al-Quran",
            //                   style: GoogleFonts.poppins(
            //                     color: AppColors.white.withOpacity(0.65),
            //                     fontSize: 14,
            //                     letterSpacing: 4,
            //                     fontWeight: FontWeight.w500,
            //                   ),
            //                 ),
            //               ),
            //               const SizedBox(height: 8),
            //               SlideTransition(
            //                 position: Tween<Offset>(
            //                   begin: const Offset(-0.2, 0),
            //                   end: Offset.zero,
            //                 ).animate(CurvedAnimation(
            //                   parent: _animationController,
            //                   curve: Curves.easeOut,
            //                 )),
            //                 child: Text(
            //                   'The Holy Quran',
            //                   style: GoogleFonts.poppins(
            //                     fontSize: 32,
            //                     fontWeight: FontWeight.bold,
            //                     color: AppColors.white,
            //                     letterSpacing: 1,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //           // Right side - Menu Icon with glow effect
            //           Container(
            //             padding: const EdgeInsets.all(12),
            //             decoration: BoxDecoration(
            //               shape: BoxShape.circle,
            //               color: AppColors.white.withOpacity(0.1),
            //               boxShadow: [
            //                 BoxShadow(
            //                   color: AppColors.white.withOpacity(0.1),
            //                   blurRadius: 20,
            //                   spreadRadius: 2,
            //                 ),
            //               ],
            //             ),
            //             child: const Icon(
            //               Icons.menu_book_rounded,
            //               color: AppColors.white,
            //               size: 24,
            //             ),
            //           ),
            //         ],
            //       ),

            //     ],
            //   ),
            // ),
            // Enhanced Content Section
            Expanded(
              child: Column(
                children: [
                  // Resume Reading Button
                  Obx(() {
                    if (quranController.hasLastRead.value) {
                      final lastRead = quranController.lastReadInfo;
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () => quranController.resumeReading(),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: primary.withOpacity(0.1),
                                    blurRadius: 20,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 8),
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: primary.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header Section
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              primary,
                                              primary.withOpacity(0.8),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: primary.withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.auto_stories_rounded,
                                          color: AppColors.white,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Continue Reading",
                                              style: GoogleFonts.poppins(
                                                color: AppColors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                height: 1.2,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              quranController
                                                  .getTimeSinceLastRead(),
                                              style: GoogleFonts.poppins(
                                                color: AppColors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: primary.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.play_arrow_rounded,
                                          color: primary,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 15),

                                  // Divider
                                  Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          primary.withOpacity(0.2),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 15),

                                  // Surah Info Section
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              lastRead['surahNameEng'] ?? '',
                                              style: GoogleFonts.poppins(
                                                color: AppColors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                height: 1.3,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: primary.withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                "Ayat ${lastRead['ayatNumber']}",
                                                style: GoogleFonts.poppins(
                                                  color: primary,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                            color: primary.withOpacity(0.1),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          lastRead['surahNameAr'] ?? '',
                                          style: GoogleFonts.amiri(
                                            color: primary,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                            height: 1.2,
                                          ),
                                        ),
                                      ),
                                    ],
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
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Get.isDarkMode
                              ? Colors.black.withOpacity(0.3)
                              : primary.withOpacity(0.08),
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Get.isDarkMode
                              ? Colors.black.withOpacity(0.2)
                              : Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: Get.isDarkMode
                            ? AppColors.white.withOpacity(0.1)
                            : primary.withOpacity(0.08),
                        width: 1,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      child: Row(
                        children: [
                          // Total Surahs
                          Expanded(
                            child: _buildModernStatItem(
                              title: "Total",
                              value: "114",
                              icon: Icons.library_books_rounded,
                              color: primary,
                              isFirst: true,
                            ),
                          ),

                          // Divider
                          _buildVerticalDivider(),
                          // Makki Surahs
                          Expanded(
                            child: _buildModernStatItem(
                              title: "Makki",
                              value: "86",
                              icon: Icons.mosque_rounded,
                              color: const Color(0xFF10B981), // Emerald
                              isMiddle: true,
                            ),
                          ),

                          // Divider
                          _buildVerticalDivider(),

                          // Madani Surahs
                          Expanded(
                            child: _buildModernStatItem(
                              title: "Madani",
                              value: "28",
                              icon: Icons.location_city_rounded,
                              color: const Color(0xFFF59E0B), // Amber
                              isLast: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Enhanced Surah List
                  Expanded(
                    child: Obx(() {
                      if (quranController.quranSurahList.isEmpty) {
                        return CircularProgressIndicator(
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
                          return _buildEnhancedSurahCard(context, surah, index);
                        },
                      );
                    }),
                  ),
                ],
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
      color: primary.withOpacity(0.2),
    );
  }

  Widget _buildModernStatItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isFirst = false,
    bool isMiddle = false,
    bool isLast = false,
  }) {
    return Column(
      children: [
        // Icon with background
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: 24,
            color: color,
          ),
        ),

        const SizedBox(height: 12),

        // Value
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
            height: 1.0,
          ),
        ),

        const SizedBox(height: 4),

        // Title
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.black45,
            height: 1.2,
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
        color: AppColors.secondary,
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
            color: AppColors.transparent,
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
                        color: AppColors.white,
                        border: Border.all(color: primary),
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
                              color: AppColors.black87,
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
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.50,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
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
                color: AppColors.grey300,
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
                                color: AppColors.grey800,
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
                      Icon(
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
                      Icon(
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
                  color: AppColors.grey700,
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
                color: AppColors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: GoogleFonts.poppins(
                color: AppColors.white,
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
