import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Components/animation.dart';

import '../../../Api/hadith_api_service.dart';
import '../../../Utils/app_colors.dart';
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

class _HadithSectionsScreenState extends State<HadithSectionsScreen>
    with TickerProviderStateMixin {
  List<HadithSection> sections = [];
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController _searchController = TextEditingController();
  List<HadithSection> filteredSections = [];
  bool isSearching = false;
  late AnimationController _animationController;
  late AnimationController _searchAnimationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadSections();
    _searchController.addListener(_filterSections);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchAnimationController.dispose();
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

      _animationController.forward();
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
      if (isSearching) {
        _searchAnimationController.forward();
      } else {
        _searchAnimationController.reverse();
        _searchController.clear();
        filteredSections = sections;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16,
        right: 16,
        bottom: 8,
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          // App Bar
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  // size: 18,
                  color: Get.isDarkMode ? AppColors.white : AppColors.black87,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isSearching ? _buildSearchField() : _buildTitle(),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: AnimatedRotation(
                  turns: isSearching ? 0.13 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    isSearching ? Icons.add : Icons.search_rounded,
                    color: Get.isDarkMode ? AppColors.white : AppColors.black87,
                  ),
                ),
                onPressed: _toggleSearch,
              ),
            ],
          ),

          // Book info header
          if (!isSearching) ...[
            const SizedBox(height: 16),
            _buildBookInfoHeader(),
          ],
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Sections',
      style: GoogleFonts.poppins(
        fontSize: 22,
        color: Get.isDarkMode ? AppColors.white : AppColors.black87,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? AppColors.white.withOpacity(0.1)
            : AppColors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Get.isDarkMode
              ? AppColors.white.withOpacity(0.2)
              : AppColors.black.withOpacity(0.1),
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.poppins(
          color: Get.isDarkMode ? AppColors.white : AppColors.black87,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Search sections...',
          hintStyle: GoogleFonts.poppins(
            color: Get.isDarkMode
                ? AppColors.white.withOpacity(0.5)
                : AppColors.black.withOpacity(0.5),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Get.isDarkMode
                ? AppColors.white.withOpacity(0.5)
                : AppColors.black.withOpacity(0.5),
            size: 20,
          ),
        ),
        autofocus: true,
      ),
    );
  }

  Widget _buildBookInfoHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppColors.white.withOpacity(0.05) : secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Get.isDarkMode
              ? AppColors.white.withOpacity(0.1)
              : AppColors.black.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: Get.isDarkMode ? secondary : primary, width: 2),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primary.withOpacity(0.8),
                  secondary.withOpacity(0.6),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: AppColors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.displayName,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Get.isDarkMode ? AppColors.white : AppColors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoChip(widget.language, Icons.language_rounded),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                        '${sections.length} Sections', Icons.list_rounded),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: primary,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: primary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (errorMessage != null) {
      return _buildErrorState();
    }

    if (filteredSections.isEmpty) {
      return _buildEmptyState();
    }

    return _buildSectionsList();
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primary.withOpacity(0.1),
                  secondary.withOpacity(0.1),
                ],
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: primary,
                backgroundColor: primary.withOpacity(0.2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading Sections...',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Get.isDarkMode
                  ? AppColors.white.withOpacity(0.8)
                  : AppColors.black87.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.red.withOpacity(0.1),
              AppColors.red.withOpacity(0.05),
            ],
          ),
          border: Border.all(
            color: AppColors.red.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.red.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColors.red,
                size: 35,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to Load Sections',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Get.isDarkMode
                    ? AppColors.white.withOpacity(0.7)
                    : AppColors.black87.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadSections,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: AppColors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Get.isDarkMode
                  ? AppColors.white.withOpacity(0.1)
                  : primary.withOpacity(0.1),
            ),
            child: Icon(
              isSearching ? Icons.search_off_rounded : Icons.list_alt_rounded,
              size: 50,
              color: Get.isDarkMode
                  ? AppColors.white.withOpacity(0.5)
                  : primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            isSearching ? 'No Sections Found' : 'No Sections Available',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Get.isDarkMode
                  ? AppColors.white.withOpacity(0.7)
                  : AppColors.black87.withOpacity(0.7),
            ),
          ),
          if (isSearching) ...[
            const SizedBox(height: 8),
            Text(
              'Try different search terms',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Get.isDarkMode
                    ? AppColors.white.withOpacity(0.5)
                    : AppColors.black87.withOpacity(0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionsList() {
    return RefreshIndicator(
      onRefresh: _loadSections,
      color: primary,
      backgroundColor: Get.isDarkMode ? AppColors.grey800 : AppColors.white,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredSections.length,
            itemBuilder: (context, index) {
              final section = filteredSections[index];

              final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    (index / filteredSections.length) * 0.5,
                    ((index + 1) / filteredSections.length) * 0.5 + 0.5,
                    curve: Curves.easeOutCubic,
                  ),
                ),
              );

              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(
                  opacity: animation,
                  child: AppButtonAnimation(
                    child: ModernSectionTile(
                      section: section,
                      index: index,
                      onTap: () {
                        Get.to(() => HadithListScreen(
                              editionName: widget.editionName,
                              section: section,
                              displayName: widget.displayName,
                              language: widget.language,
                            ));
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ModernSectionTile extends StatelessWidget {
  final HadithSection section;
  final int index;
  final VoidCallback onTap;

  const ModernSectionTile({
    super.key,
    required this.section,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getGradientColors(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Get.isDarkMode
                ? AppColors.white.withOpacity(0.1)
                : AppColors.black.withOpacity(0.05),
          ),
        ),
        child: Material(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row with section number and arrow
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: primary.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          'Section ${section.sectionNumber}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: primary,
                          ),
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primary.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: primary,
                          size: 16,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Arabic title (if available)
                  if (section.arabicName.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? AppColors.amber.withOpacity(0.1)
                            : AppColors.amber.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.amber.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        section.arabicName,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColors.amber700,
                          fontWeight: FontWeight.w600,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // English title
                  Text(
                    section.name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: primary,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Statistics row
                  Row(
                    children: [
                      _buildStatItem(
                        Icons.format_list_numbered_rounded,
                        '${section.hadithCount} Hadiths',
                        primary,
                      ),
                      if (section.rangeText.isNotEmpty) ...[
                        const SizedBox(width: 16),
                        _buildStatItem(
                          Icons.numbers_rounded,
                          'Range: ${section.rangeText}',
                          AppColors.black87.withOpacity(0.6),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getGradientColors(int index) {
    final gradients = [
      [primary.withOpacity(0.1), secondary.withOpacity(0.05)],
      [secondary.withOpacity(0.1), primary.withOpacity(0.05)],
      [AppColors.grey100.withOpacity(0.1), primary.withOpacity(0.05)],
      [primary.withOpacity(0.05), secondary.withOpacity(0.1)],
    ];

    return gradients[index % gradients.length];
  }
}
