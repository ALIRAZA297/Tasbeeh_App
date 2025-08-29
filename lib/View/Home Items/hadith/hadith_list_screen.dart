import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Utils/app_colors.dart';
import '../../../Controller/fav_controller.dart';
import 'hadit_detail_screen.dart';
import '../../../Api/hadith_api_service.dart';

class HadithListScreen extends StatefulWidget {
  final String editionName;
  final HadithSection section;
  final String displayName;
  final String language;

  const HadithListScreen({
    super.key,
    required this.editionName,
    required this.section,
    required this.displayName,
    required this.language,
  });

  @override
  State<HadithListScreen> createState() => _HadithListScreenState();
}

class _HadithListScreenState extends State<HadithListScreen> {
  List<HadithItem> hadiths = [];
  List<HadithItem> filteredHadiths = [];
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadHadiths();
    _searchController.addListener(_filterHadiths);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHadiths() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final fetchedHadiths = await HadithApiService.getHadithsFromSection(
        widget.editionName,
        widget.section.sectionNumber,
      );

      setState(() {
        hadiths = fetchedHadiths;
        filteredHadiths = fetchedHadiths;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _filterHadiths() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredHadiths = hadiths;
      } else {
        filteredHadiths = hadiths
            .where((hadith) =>
                hadith.text.toLowerCase().contains(query) ||
                hadith.hadithNumber.toString().contains(query))
            .toList();
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        _searchController.clear();
        filteredHadiths = hadiths;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: _searchController,
                style: const TextStyle(color: white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Search hadiths...',
                  hintStyle: TextStyle(color: white60),
                  border: InputBorder.none,
                ),
                autofocus: true,
              )
            : Text(
                widget.section.name.length > 25
                    ? '${widget.section.name.substring(0, 25)}...'
                    : widget.section.name,
                style: const TextStyle(
                  fontSize: 18,
                  color: white,
                  fontWeight: FontWeight.bold,
                ),
              ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            onPressed: _toggleSearch,
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: white,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Section header info
          if (!isSearching) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: secondary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section number and book info
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
                          'Section ${widget.section.sectionNumber}',
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
                  const SizedBox(height: 12),

                  // Arabic title
                  if (widget.section.arabicName.isNotEmpty) ...[
                    Text(
                      widget.section.arabicName,
                      style: TextStyle(
                        fontSize: 18,
                        color: grey100,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 8),
                  ],

                  // English title
                  Text(
                    widget.section.name,
                    style: const TextStyle(
                      fontSize: 16,
                      color: white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Section info
                  Row(
                    children: [
                      Icon(
                        Icons.format_list_numbered_rounded,
                        color: grey100,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.section.hadithCount} Hadiths',
                        style: TextStyle(
                          fontSize: 12,
                          color: grey100,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (widget.section.rangeText.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        Icon(
                          Icons.numbers_rounded,
                          color: white70,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Range: ${widget.section.rangeText}',
                          style: TextStyle(
                            fontSize: 12,
                            color: white70,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Hadiths list
          Expanded(
            child: _buildHadithsContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHadithsContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: white,
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: white54,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Error loading hadiths',
              style: TextStyle(
                color: white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: white70,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadHadiths,
              style: ElevatedButton.styleFrom(
                backgroundColor: grey100,
              ),
              child: const Text(
                'Retry',
                style: TextStyle(color: white),
              ),
            ),
          ],
        ),
      );
    }

    if (filteredHadiths.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.book_outlined,
              color: white54,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              isSearching ? 'No hadiths found' : 'No hadiths available',
              style: TextStyle(
                color: white70,
                fontSize: 16,
              ),
            ),
            if (isSearching) ...[
              const SizedBox(height: 8),
              Text(
                'Try different search terms',
                style: TextStyle(
                  color: white54,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadHadiths,
      color: grey100,
      backgroundColor: secondary,
      child: ListView.builder(
        itemCount: filteredHadiths.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final hadith = filteredHadiths[index];
          return HadithTile(
            hadithItem: hadith,
            onTap: () async {
              // Show loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => Center(
                  child: CircularProgressIndicator(
                    color: grey100,
                  ),
                ),
              );

              try {
                // Fetch detailed hadith
                final hadithDetail = await HadithApiService.getHadithDetail(
                  widget.editionName,
                  hadith.hadithNumber,
                );

                // Close loading dialog
                Navigator.pop(context);

                // Navigate to reading screen
                Get.to(() => HadithDetailScreen(
                      hadithDetail: hadithDetail,
                      displayName: widget.displayName,
                      language: widget.language,
                      sectionName: widget.section.name,
                    ));
              } catch (e) {
                // Close loading dialog
                Navigator.pop(context);

                // Show error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to load hadith details: $e'),
                    backgroundColor: red,
                  ),
                );
              }
            },
            editionName: widget.editionName,
            displayName: widget.displayName,
            language: widget.language,
            sectionName: widget.section.name,
          );
        },
      ),
    );
  }
}

class HadithTile extends StatefulWidget {
  final HadithItem hadithItem;
  final VoidCallback onTap;
  final String editionName;
  final String displayName;
  final String language;
  final String sectionName;

  const HadithTile({
    super.key,
    required this.hadithItem,
    required this.onTap,
    required this.editionName,
    required this.displayName,
    required this.language,
    required this.sectionName,
  });

  @override
  State<HadithTile> createState() => _HadithTileState();
}

class _HadithTileState extends State<HadithTile> {
  bool isFavorite = false;
  final FavoritesController favoritesController =
      Get.put(FavoritesController());

  @override
  void initState() {
    super.initState();
    // Check if the hadith is already in favorites
    isFavorite = favoritesController.isHadithFavorite(
      hadithNumber: widget.hadithItem.hadithNumber,
      displayName: widget.displayName,
      language: widget.language,
    );
  }

  Future<void> _toggleFavorite() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: grey100,
        ),
      ),
    );

    try {
      // Fetch HadithDetail to get reference and chain
      final hadithDetail = await HadithApiService.getHadithDetail(
        widget.editionName,
        widget.hadithItem.hadithNumber,
      );

      // Close loading dialog
      Navigator.pop(context);

      // Toggle favorite status
      setState(() {
        isFavorite = !isFavorite;
        favoritesController.toggleHadithFavorite(
          hadithNumber: widget.hadithItem.hadithNumber,
          text: widget.hadithItem.text,
          displayName: widget.displayName,
          language: widget.language,
          sectionName: widget.sectionName,
          grades: widget.hadithItem.grades,
          reference: hadithDetail.reference,
          chain: hadithDetail.chain,
          editionName: widget.editionName,
        );
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              isFavorite ? 'Added to favorites' : 'Removed from favorites'),
          backgroundColor: isFavorite ? secondary : red,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);

      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to toggle favorite: $e'),
          backgroundColor: red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: transparent,
      highlightColor: transparent,
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: secondary,
          border: Border.all(color: white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with hadith number and favorite button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: grey100.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: grey100.withOpacity(0.5),
                    ),
                  ),
                  child: Text(
                    'Hadith ${widget.hadithItem.hadithNumber}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: grey100,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Grade badge
                    if (widget.hadithItem.primaryGrade.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getGradeColor(widget.hadithItem.primaryGrade)
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                _getGradeColor(widget.hadithItem.primaryGrade),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          widget.hadithItem.primaryGrade,
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                _getGradeColor(widget.hadithItem.primaryGrade),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    // Favorite button
                    InkWell(
                      onTap: _toggleFavorite,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: isFavorite ? grey100 : white54,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Text preview
            Text(
              widget.hadithItem.text.length > 150
                  ? '"${widget.hadithItem.text.substring(0, 150)}..."'
                  : '"${widget.hadithItem.text}"',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: white70,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 12),

            // Footer with read more indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tap to read full hadith',
                  style: TextStyle(
                    fontSize: 12,
                    color: white54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: white54,
                  size: 14,
                ),
              ],
            ),
          ],
        ),
      ),
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
}
