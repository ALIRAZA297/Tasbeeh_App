import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../Utils/app_colors.dart';
import '../../../Api/hadith_api_service.dart';
import '../../../Controller/fav_controller.dart';

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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Hadith ${widget.hadithDetail.hadithNumber}',
          style: const TextStyle(
            fontSize: 20,
            color: white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Text size controls
          PopupMenuButton<String>(
            icon: const Icon(Icons.text_fields, color: white),
            color: secondary,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'small',
                child: Text('Small Text',
                    style: TextStyle(color: white, fontSize: 14)),
              ),
              const PopupMenuItem(
                value: 'medium',
                child: Text('Medium Text',
                    style: TextStyle(color: white, fontSize: 16)),
              ),
              const PopupMenuItem(
                value: 'large',
                child: Text('Large Text',
                    style: TextStyle(color: white, fontSize: 18)),
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

          // Favorite button
          IconButton(
            onPressed: () {
              setState(() {
                favoritesController.toggleHadithFavorite(
                  hadithNumber: widget.hadithDetail.hadithNumber,
                  text: widget.hadithDetail.text,
                  displayName: widget.displayName,
                  language: widget.language,
                  sectionName: widget.sectionName,
                  grades: widget.hadithDetail.grades,
                  reference: widget.hadithDetail.reference,
                  chain: widget.hadithDetail.chain,
                  editionName: widget.hadithDetail.editionName,
                );
                isFavorite = !isFavorite;
              });
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
              color: isFavorite ? grey100 : white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: secondary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book and section info
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: grey100.withOpacity(0.2),
                          border: Border.all(
                            color: grey100,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.auto_stories_rounded,
                          color: grey100,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.displayName,
                              style: const TextStyle(
                                fontSize: 16,
                                color: white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.sectionName,
                              style: TextStyle(
                                fontSize: 13,
                                color: white70,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Hadith number and grades
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: grey100.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: grey100,
                          ),
                        ),
                        child: Text(
                          'Hadith ${widget.hadithDetail.hadithNumber}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: grey100,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: grey100.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: grey100.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          widget.language,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: grey100,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Grades
                  if (widget.hadithDetail.grades.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.hadithDetail.grades.map((grade) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getGradeColor(grade).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getGradeColor(grade),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            grade,
                            style: TextStyle(
                              fontSize: 11,
                              color: _getGradeColor(grade),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Hadith text
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: secondary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text header
                  Row(
                    children: [
                      Icon(
                        Icons.format_quote,
                        color: grey100,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Hadith Text',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: white,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () =>
                            _copyToClipboard(widget.hadithDetail.text),
                        icon: Icon(
                          Icons.copy,
                          color: white54,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Hadith text
                  SelectableText(
                    widget.hadithDetail.text,
                    style: TextStyle(
                      fontSize: textSize,
                      color: white,
                      height: 1.7,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Reference and chain info
            if (widget.hadithDetail.reference.isNotEmpty ||
                widget.hadithDetail.chain.isNotEmpty) ...[
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: secondary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: grey100,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Additional Information',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (widget.hadithDetail.reference.isNotEmpty) ...[
                      _buildInfoRow('Reference', widget.hadithDetail.reference),
                      const SizedBox(height: 8),
                    ],
                    if (widget.hadithDetail.chain.isNotEmpty) ...[
                      _buildInfoRow(
                          'Chain of Narration', widget.hadithDetail.chain),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ],
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
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: grey100,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: TextStyle(
            fontSize: 13,
            color: white70,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Color _getGradeColor(String grade) {
    final lowerGrade = grade.toLowerCase();
    if (lowerGrade.contains('sahih')) {
      return green;
    } else if (lowerGrade.contains('hasan')) {
      return orange;
    } else if (lowerGrade.contains('daif') || lowerGrade.contains('weak')) {
      return red;
    } else {
      return grey;
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Hadith copied to clipboard'),
        backgroundColor: grey100,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
