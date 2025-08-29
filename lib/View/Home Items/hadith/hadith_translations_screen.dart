import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../Utils/app_colors.dart';
import '../../../Api/hadith_api_service.dart';
import 'hadith_sections_screen.dart';

void showHadithTranslationsBottomSheet(
  BuildContext context,
  String collectionName,
  String displayName,
  List<HadithEdition> editions,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(16.r),
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20.r),
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
                            displayName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.sp,
                              color: primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            _getCollectionDescription(collectionName),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.translate_rounded,
                      size: 16.sp,
                      color: primary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${editions.length} Translations',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Icon(
                      Icons.language_rounded,
                      size: 16.sp,
                      color: primary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Multiple Languages',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              "Choose Translation",
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 16.h),
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
      width: 100.w,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      margin: EdgeInsets.only(right: 8.h, left: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primary,
            primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15.r),
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
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
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
