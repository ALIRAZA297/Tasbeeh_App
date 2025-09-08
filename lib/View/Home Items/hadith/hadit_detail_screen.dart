// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../../Api/hadith_api_service.dart';
// import '../../../Controller/fav_controller.dart';
// import '../../../Utils/app_colors.dart';

// class HadithDetailScreen extends StatefulWidget {
//   final HadithDetail hadithDetail;
//   final String displayName;
//   final String language;
//   final String sectionName;

//   const HadithDetailScreen({
//     super.key,
//     required this.hadithDetail,
//     required this.displayName,
//     required this.language,
//     required this.sectionName,
//   });

//   @override
//   State<HadithDetailScreen> createState() => _HadithDetailScreenState();
// }

// class _HadithDetailScreenState extends State<HadithDetailScreen> {
//   final FavoritesController favoritesController =
//       Get.put(FavoritesController());
//   bool isFavorite = false;
//   double textSize = 16.0;

//   @override
//   void initState() {
//     super.initState();
//     isFavorite = favoritesController.isHadithFavorite(
//       hadithNumber: widget.hadithDetail.hadithNumber,
//       displayName: widget.displayName,
//       language: widget.language,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         title: Text(
//           'Hadith ${widget.hadithDetail.hadithNumber}',
//           style: GoogleFonts.poppins(
//             fontSize: 20,
//             color: Get.isDarkMode ? AppColors.white : AppColors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           // Text size controls
//           PopupMenuButton<String>(
//             icon: Icon(
//               Icons.text_fields,
//               color: Get.isDarkMode ? AppColors.white : AppColors.black,
//             ),
//             color: primary,
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 value: 'small',
//                 child: Text('Small Text',
//                     style: GoogleFonts.poppins(
//                         color: AppColors.white, fontSize: 14)),
//               ),
//               PopupMenuItem(
//                 value: 'medium',
//                 child: Text('Medium Text',
//                     style: GoogleFonts.poppins(
//                         color: AppColors.white, fontSize: 16)),
//               ),
//               PopupMenuItem(
//                 value: 'large',
//                 child: Text('Large Text',
//                     style: GoogleFonts.poppins(
//                         color: AppColors.white, fontSize: 18)),
//               ),
//             ],
//             onSelected: (value) {
//               setState(() {
//                 switch (value) {
//                   case 'small':
//                     textSize = 14.0;
//                     break;
//                   case 'medium':
//                     textSize = 16.0;
//                     break;
//                   case 'large':
//                     textSize = 18.0;
//                     break;
//                 }
//               });
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Header info
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Get.isDarkMode ? secondary : primary,
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(20),
//                   bottomRight: Radius.circular(20),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Book and section info
//                   Row(
//                     children: [
//                       Container(
//                         width: 50,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           color: primary.withOpacity(0.1),
//                           border: Border.all(
//                             color: Get.isDarkMode ? primary : AppColors.grey100,
//                             width: 1.5,
//                           ),
//                         ),
//                         child: Icon(
//                           Icons.auto_stories_rounded,
//                           color: Get.isDarkMode ? primary : AppColors.grey100,
//                           size: 24,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               widget.displayName,
//                               style: GoogleFonts.poppins(
//                                 fontSize: 16,
//                                 color:
//                                     Get.isDarkMode ? primary : AppColors.white,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               widget.sectionName,
//                               style: GoogleFonts.poppins(
//                                 fontSize: 13,
//                                 color: Get.isDarkMode
//                                     ? primary
//                                     : AppColors.white70,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),

//                   // Hadith number and grades
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Get.isDarkMode
//                               ? primary.withOpacity(0.2)
//                               : AppColors.grey100.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             color: Get.isDarkMode ? primary : AppColors.grey100,
//                           ),
//                         ),
//                         child: Text(
//                           'Hadith ${widget.hadithDetail.hadithNumber}',
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 12,
//                             color: Get.isDarkMode ? primary : AppColors.grey100,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: Get.isDarkMode
//                               ? primary.withOpacity(0.2)
//                               : AppColors.grey100.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             color: Get.isDarkMode ? primary : AppColors.grey100,
//                           ),
//                         ),
//                         child: Text(
//                           widget.language,
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 12,
//                             color: Get.isDarkMode ? primary : AppColors.grey100,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),

//                   // Grades
//                   if (widget.hadithDetail.grades.isNotEmpty) ...[
//                     Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: widget.hadithDetail.grades.map((grade) {
//                         return Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: AppColors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                               color: _getGradeColor(grade),
//                               width: 1,
//                             ),
//                           ),
//                           child: Text(
//                             grade,
//                             style: GoogleFonts.poppins(
//                               fontSize: 11,
//                               color: _getGradeColor(grade),
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Hadith text
//             Container(
//               width: double.infinity,
//               margin: const EdgeInsets.symmetric(horizontal: 16),
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: secondary,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: AppColors.white12),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Text header
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.format_quote,
//                         color: primary,
//                         size: 24,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Hadith Text',
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: primary,
//                         ),
//                       ),
//                       const Spacer(),
//                       IconButton(
//                         onPressed: () =>
//                             _copyToClipboard(widget.hadithDetail.text),
//                         icon: Icon(
//                           Icons.copy,
//                           color: primary,
//                           size: 20,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),

//                   // Hadith text
//                   SelectableText(
//                     widget.hadithDetail.text,
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.poppins(
//                       fontSize: textSize,
//                       color: primary,
//                       height: 2,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Reference and chain info
//             if (widget.hadithDetail.reference.isNotEmpty ||
//                 widget.hadithDetail.chain.isNotEmpty) ...[
//               Container(
//                 width: double.infinity,
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: primary,
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: AppColors.white12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.info_outline,
//                           color: AppColors.grey100,
//                           size: 20,
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           'Additional Information',
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: AppColors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     if (widget.hadithDetail.reference.isNotEmpty) ...[
//                       _buildInfoRow('Reference', widget.hadithDetail.reference),
//                       const SizedBox(height: 8),
//                     ],
//                     if (widget.hadithDetail.chain.isNotEmpty) ...[
//                       _buildInfoRow(
//                           'Chain of Narration', widget.hadithDetail.chain),
//                     ],
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String title, String content) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: GoogleFonts.poppins(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: AppColors.grey100,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           content,
//           style: GoogleFonts.poppins(
//             fontSize: 13,
//             color: AppColors.white70,
//             height: 1.4,
//           ),
//         ),
//       ],
//     );
//   }

//   Color _getGradeColor(String grade) {
//     final lowerGrade = grade.toLowerCase();
//     if (lowerGrade.contains('sahih')) {
//       return AppColors.green;
//     } else if (lowerGrade.contains('hasan')) {
//       return AppColors.orange;
//     } else if (lowerGrade.contains('daif') || lowerGrade.contains('weak')) {
//       return AppColors.red;
//     } else {
//       return AppColors.grey;
//     }
//   }

//   void _copyToClipboard(String text) {
//     Clipboard.setData(ClipboardData(text: text));
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text('Hadith copied to clipboard'),
//         backgroundColor: AppColors.grey100,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Api/hadith_api_service.dart';
import '../../../Controller/fav_controller.dart';
import '../../../Utils/app_colors.dart';

class HadithDetailScreen extends StatefulWidget {
  final HadithDetail hadithDetail;
  final String displayName;
  final String language;
  final String sectionName;

  const HadithDetailScreen({
    super.key,
    required this.hadithDetail,
    required this.displayName,
    required this.language,
    required this.sectionName,
  });

  @override
  State<HadithDetailScreen> createState() => _HadithDetailScreenState();
}

class _HadithDetailScreenState extends State<HadithDetailScreen> {
  final FavoritesController favoritesController =
      Get.put(FavoritesController());
  bool isFavorite = false;
  double textSize = 16.0;

  @override
  void initState() {
    super.initState();
    isFavorite = favoritesController.isHadithFavorite(
      hadithNumber: widget.hadithDetail.hadithNumber,
      displayName: widget.displayName,
      language: widget.language,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Hadith ${widget.hadithDetail.hadithNumber}',
          style: GoogleFonts.poppins(
            fontSize: 22,
            color: Get.isDarkMode ? AppColors.white : AppColors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.text_fields,
              color: Get.isDarkMode ? AppColors.white : AppColors.black,
            ),
            color: primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'small',
                child: Text('Small',
                    style: GoogleFonts.poppins(
                        color: AppColors.white, fontSize: 14)),
              ),
              PopupMenuItem(
                value: 'medium',
                child: Text('Medium',
                    style: GoogleFonts.poppins(
                        color: AppColors.white, fontSize: 16)),
              ),
              PopupMenuItem(
                value: 'large',
                child: Text('Large',
                    style: GoogleFonts.poppins(
                        color: AppColors.white, fontSize: 18)),
              ),
            ],
            onSelected: (value) {
              setState(() {
                switch (value) {
                  case 'small':
                    textSize = 14.0;
                    break;
                  case 'medium':
                    textSize = 16.0;
                    break;
                  case 'large':
                    textSize = 18.0;
                    break;
                }
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Get.isDarkMode ? secondary : primary,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.white,
                            child: Icon(
                              Icons.auto_stories_rounded,
                              color: primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.displayName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: Get.isDarkMode
                                        ? primary
                                        : AppColors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.sectionName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Get.isDarkMode
                                        ? primary
                                        : AppColors.white70,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        children: [
                          Chip(
                            color:
                                const WidgetStatePropertyAll(AppColors.white),
                            label: Text(
                              'Hadith ${widget.hadithDetail.hadithNumber}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            backgroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Get.isDarkMode
                                    ? primary
                                    : AppColors.grey100,
                              ),
                            ),
                          ),
                          Chip(
                            label: Text(
                              widget.language,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            backgroundColor: AppColors.white,
                            color:
                                const WidgetStatePropertyAll(AppColors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Get.isDarkMode
                                    ? primary
                                    : AppColors.grey100,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (widget.hadithDetail.grades.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.hadithDetail.grades.map((grade) {
                            return Chip(
                              label: Text(
                                grade,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: _getGradeColor(grade),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              backgroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: _getGradeColor(grade)),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Hadith Text Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: secondary,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.format_quote,
                            color: primary,
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Hadith Text',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: primary,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () =>
                                _copyToClipboard(widget.hadithDetail.text),
                            icon: Icon(
                              Icons.copy,
                              color: primary,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SelectableText(
                        widget.hadithDetail.text,
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.poppins(
                          fontSize: textSize,
                          color: primary,
                          height: 1.8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (widget.hadithDetail.reference.isNotEmpty ||
                  widget.hadithDetail.chain.isNotEmpty) ...[
                const SizedBox(height: 16),
                // Additional Info Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: primary,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.grey100,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Additional Information',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (widget.hadithDetail.reference.isNotEmpty)
                          _buildInfoRow(
                              'Reference', widget.hadithDetail.reference),
                        if (widget.hadithDetail.reference.isNotEmpty &&
                            widget.hadithDetail.chain.isNotEmpty)
                          const SizedBox(height: 12),
                        if (widget.hadithDetail.chain.isNotEmpty)
                          _buildInfoRow(
                              'Chain of Narration', widget.hadithDetail.chain),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.grey100,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.white70,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Color _getGradeColor(String grade) {
    final lowerGrade = grade.toLowerCase();
    if (lowerGrade.contains('sahih')) {
      return AppColors.green;
    } else if (lowerGrade.contains('hasan')) {
      return AppColors.orange;
    } else if (lowerGrade.contains('daif') || lowerGrade.contains('weak')) {
      return AppColors.red;
    } else {
      return AppColors.grey;
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Hadith copied to clipboard',
          style: GoogleFonts.poppins(color: AppColors.white),
        ),
        backgroundColor: AppColors.grey100,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
