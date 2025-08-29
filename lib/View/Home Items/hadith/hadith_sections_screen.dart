import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Utils/app_colors.dart';
import '../../../Api/hadith_api_service.dart';
import 'hadith_list_screen.dart';

class HadithSectionsScreen extends StatefulWidget {
  final String editionName;
  final String displayName;
  final String language;

  const HadithSectionsScreen({
    super.key,
    required this.editionName,
    required this.displayName,
    required this.language,
  });

  @override
  State<HadithSectionsScreen> createState() => _HadithSectionsScreenState();
}

class _HadithSectionsScreenState extends State<HadithSectionsScreen> {
  List<HadithSection> sections = [];
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController _searchController = TextEditingController();
  List<HadithSection> filteredSections = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadSections();
    _searchController.addListener(_filterSections);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSections() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final fetchedSections =
          await HadithApiService.getSections(widget.editionName);

      setState(() {
        sections = fetchedSections;
        filteredSections = fetchedSections;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading sections: $e');
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _filterSections() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredSections = sections;
      } else {
        filteredSections = sections
            .where((section) =>
                section.name.toLowerCase().contains(query) ||
                section.arabicName.toLowerCase().contains(query) ||
                section.sectionNumber.toString().contains(query))
            .toList();
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        _searchController.clear();
        filteredSections = sections;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: isSearching
            ? TextField(
                controller: _searchController,
                style: TextStyle(color: white, fontSize: 18.sp),
                decoration: InputDecoration(
                  hintText: 'Search sections...',
                  hintStyle: TextStyle(color: white60),
                  border: InputBorder.none,
                ),
                autofocus: true,
              )
            : Text(
                'Sections',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: white,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
          // Book header info
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
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: grey100.withOpacity(0.2),
                          border: Border.all(
                            color: grey100,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.menu_book_rounded,
                          color: grey100,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.displayName,
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: grey100.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: grey100.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Text(
                                    widget.language,
                                    style: TextStyle(
                                      color: grey100,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: grey100.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: grey100.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Text(
                                    '${sections.length} Sections',
                                    style: TextStyle(
                                      color: grey100,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
          ],

          // Sections list
          Expanded(
            child: _buildSectionsContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionsContent() {
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
            SizedBox(height: 16.h),
            Text(
              'Error loading sections',
              style: TextStyle(
                color: white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: white70,
                  fontSize: 12.sp,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _loadSections,
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

    if (filteredSections.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.book_outlined,
              color: white54,
              size: 48,
            ),
            SizedBox(height: 16.h),
            Text(
              isSearching ? 'No sections found' : 'No sections available',
              style: TextStyle(
                color: white70,
                fontSize: 16.sp,
              ),
            ),
            if (isSearching) ...[
              SizedBox(height: 8.h),
              Text(
                'Try different search terms',
                style: TextStyle(
                  color: white54,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadSections,
      color: grey100,
      backgroundColor: secondary,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filteredSections.length,
        itemBuilder: (context, index) {
          final section = filteredSections[index];
          return SectionTile(
            section: section,
            onTap: () {
              Get.to(() => HadithListScreen(
                    editionName: widget.editionName,
                    section: section,
                    displayName: widget.displayName,
                    language: widget.language,
                  ));
            },
          );
        },
      ),
    );
  }
}

class SectionTile extends StatelessWidget {
  final HadithSection section;
  final VoidCallback onTap;

  const SectionTile({
    super.key,
    required this.section,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: secondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section number badge
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    color: grey100.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: grey100.withOpacity(0.5),
                    ),
                  ),
                  child: Text(
                    'Section ${section.sectionNumber}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      color: grey100,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: white54,
                  size: 16,
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Arabic title
            if (section.arabicName.isNotEmpty) ...[
              Text(
                section.arabicName,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: const Color(0xFFFFC107),
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 8.h),
            ],

            // English title
            Text(
              section.name,
              style: TextStyle(
                fontSize: 16.sp,
                color: white,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
            SizedBox(height: 12.h),

            // Statistics
            Row(
              children: [
                _buildStatItem(
                  Icons.format_list_numbered_rounded,
                  '${section.hadithCount} Hadiths',
                  grey100,
                ),
                SizedBox(width: 16.w),
                if (section.rangeText.isNotEmpty)
                  _buildStatItem(
                    Icons.numbers_rounded,
                    'Range: ${section.rangeText}',
                    white54,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 16,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
