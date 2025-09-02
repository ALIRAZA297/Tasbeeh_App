import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Api/hadith_api_service.dart';
import '../../../Utils/app_colors.dart';
import 'hadith_sections_screen.dart';

void showHadithTranslationsBottomSheet(
  BuildContext context,
  String collectionName,
  String displayName,
  List<HadithEdition> editions,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Get.isDarkMode ? AppColors.black : AppColors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.50,
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppColors.black87 : AppColors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
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
              color: Get.isDarkMode
                  ? secondary.withOpacity(0.1)
                  : primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    Get.isDarkMode ? AppColors.white : primary.withOpacity(0.1),
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
                            displayName,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              color: primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getCollectionDescription(collectionName),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Get.isDarkMode
                                  ? AppColors.grey600
                                  : AppColors.grey800,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
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
                      Icons.translate_rounded,
                      size: 16,
                      color: primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${editions.length} Translations',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.language_rounded,
                      size: 16,
                      color: primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Multiple Languages',
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
                color: AppColors.grey600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: editions.asMap().entries.map((entry) {
                final edition = entry.value;
                return _buildEnhancedTranslationButton(
                  edition.language,
                  _getLanguageIcon(edition.language),
                  () {
                    log('Edition details: '
                        'name: ${edition.name}, '
                        'language: ${edition.language}, '
                        'author: ${edition.author}, '
                        'direction: ${edition.direction}');
                    debugPrint(
                        'Selected edition: ${edition.name} (${edition.language})');
                    Get.back();
                    Get.to(() => HadithSectionsScreen(
                          editionName: edition.name,
                          displayName: displayName,
                          language: edition.language,
                        ));
                  },
                );
              }).toList(),
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

String _getCollectionDescription(String collectionName) {
  switch (collectionName.toLowerCase()) {
    case 'bukhari':
      return 'The most authentic and widely accepted collection of Hadith in the Islamic world';
    case 'muslim':
      return 'Second most authentic collection, known for systematic arrangement';
    case 'abudawud':
      return 'Focuses on legal rulings and Islamic jurisprudence';
    case 'tirmidhi':
      return 'Includes commentary and grading, comprehensive Islamic teachings';
    case 'nasai':
      return 'Known for detailed hadith chain analysis and authentication';
    case 'ibnmajah':
      return 'Comprehensive collection covering various aspects of Islamic life';
    default:
      return 'Authentic collection of prophetic traditions';
  }
}

IconData _getLanguageIcon(String language) {
  switch (language.toLowerCase()) {
    case 'english':
      return Icons.language;
    case 'arabic':
      return Icons.menu_book_rounded;
    case 'urdu':
      return Icons.translate;
    case 'hindi':
      return Icons.translate;
    default:
      return Icons.translate;
  }
}
