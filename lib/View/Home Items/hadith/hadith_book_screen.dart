// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:tasbeeh_app/Components/animation.dart';

// import '../../../Api/hadith_api_service.dart';
// import '../../../Utils/app_AppColors.dart';
// import 'hadith_translations_screen.dart';

// class HadithBooksScreen extends StatefulWidget {
//   const HadithBooksScreen({super.key});

//   @override
//   State<HadithBooksScreen> createState() => _HadithBooksScreenState();
// }

// class _HadithBooksScreenState extends State<HadithBooksScreen> {
//   Map<String, List<HadithEdition>> collections = {};
//   Map<String, String> collectionDisplayNames = {}; // Add this line
//   bool isLoading = true;
//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _loadCollections();
//   }

//   Future<void> _loadCollections() async {
//     try {
//       setState(() {
//         isLoading = true;
//         errorMessage = null;
//       });

//       final editionsData = await HadithApiService.getEditions();

//       // Group editions by collection
//       Map<String, List<HadithEdition>> groupedCollections = {};
//       Map<String, String> displayNames = {};

//       for (var data in editionsData) {
//         final collectionName = data['book'] as String? ?? '';
//         final collectionDisplayName = data['name'] as String? ?? collectionName;
//         final editionsList = (data['editions'] as List<dynamic>?)?.map((e) {
//               return HadithEdition.fromJson(
//                   e as Map<String, dynamic>, collectionName);
//             }).toList() ??
//             [];

//         if (collectionName.isNotEmpty) {
//           groupedCollections[collectionName] = editionsList;
//           displayNames[collectionName] = collectionDisplayName;
//         }
//       }

//       setState(() {
//         collections = groupedCollections;
//         collectionDisplayNames = displayNames;
//         isLoading = false;
//       });

//       // Log for debugging
//       debugPrint(
//           'Loaded ${groupedCollections.length} collections: ${groupedCollections.keys.join(", ")}');
//     } catch (e) {
//       debugPrint('Error loading collections: $e');
//       setState(() {
//         errorMessage =
//             'Failed to load Hadith books. Please check your internet connection and try again.';
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       appBar: AppBar(
//         centerTitle: true,
//         scrolledUnderElevation: 0,
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         title: Text(
//           'Hadith Books',
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.bold,
//             color: Get.isDarkMode ? AppColors.white : AppColors.black,
//           ),
//         ),
//       ),
//       body: _buildBody(),
//     );
//   }

//   Widget _buildBody() {
//     if (isLoading) {
//       return Center(
//         child: CircularProgressIndicator(
//           strokeWidth: 4,
//           color: primary,
//         ),
//       );
//     }

//     if (errorMessage != null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.error_outline,
//               color: AppColors.white.withOpacity(0.54),
//               size: 64,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Error Loading Books',
//               style: TextStyle(
//                 color: AppColors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 32),
//               child: Text(
//                 errorMessage!,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: AppColors.white.withOpacity(0.7),
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: _loadCollections,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.grey100,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text(
//                 'Retry',
//                 style: TextStyle(
//                   color: AppColors.white,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     if (collections.isEmpty) {
//       return Center(
//         child: Text(
//           'No books available',
//           style: TextStyle(
//             color: AppColors.white.withOpacity(0.7),
//             fontSize: 16,
//           ),
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _loadCollections,
//       color: AppColors.grey100,
//       backgroundColor: primary,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: collections.keys.length,
//         itemBuilder: (context, index) {
//           final collectionName = collections.keys.elementAt(index);
//           final editions = collections[collectionName]!;

//           final displayName = collectionDisplayNames[collectionName] ??
//               collectionName; // Get display name
//           log('Loading collection: $collectionName with ${editions.length} editions');
//           return _buildCollectionCard(collectionName, editions, displayName);
//         },
//       ),
//     );
//   }

//   Widget _buildCollectionCard(
//       String collectionName, List<HadithEdition> editions, String displayName) {
//     return AppButtonAnimation(
//       child: Card(
//         elevation: 1,
//         color: secondary,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         margin: const EdgeInsets.only(bottom: 12),
//         child: ListTile(
//           shape: RoundedRectangleBorder(
//             side: BorderSide(color: AppColors.white.withOpacity(0.2), width: 1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           contentPadding:
//               const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
//           leading: Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               color: AppColors.grey100.withOpacity(0.2),
//               border: Border.all(
//                 color: primary,
//                 width: 1.5,
//               ),
//             ),
//             child: Icon(
//               Icons.menu_book_rounded,
//               color: primary,
//               size: 28,
//             ),
//           ),
//           title: Text(
//             // editions.isNotEmpty ? editions.first.name : collectionName, // Use the first edition's book name or collection name
//             displayName, // Use the display name here
//             style: GoogleFonts.poppins(
//               color: primary,
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           subtitle: Padding(
//             padding: const EdgeInsets.only(top: 6),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _getCollectionDescription(collectionName),
//                   style: GoogleFonts.poppins(
//                     color: AppColors.black54,
//                     fontSize: 14,
//                     height: 1.3,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 3),
//                       decoration: BoxDecoration(
//                         color: AppColors.black.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: AppColors.grey100.withOpacity(0.5),
//                         ),
//                       ),
//                       child: Text(
//                         '${editions.length} Translation${editions.length > 1 ? 's' : ''}',
//                         style: GoogleFonts.poppins(
//                           color: AppColors.black54,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           onTap: () {
//             showHadithTranslationsBottomSheet(
//                 context, collectionName, displayName, editions);
//           },
//         ),
//       ),
//     );
//   }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Components/animation.dart';

import '../../../Api/hadith_api_service.dart';
import '../../../Utils/app_colors.dart';
import 'hadith_translations_screen.dart';

class HadithBooksScreen extends StatefulWidget {
  const HadithBooksScreen({super.key});

  @override
  State<HadithBooksScreen> createState() => _HadithBooksScreenState();
}

class _HadithBooksScreenState extends State<HadithBooksScreen>
    with SingleTickerProviderStateMixin {
  Map<String, List<HadithEdition>> collections = {};
  Map<String, String> collectionDisplayNames = {};
  bool isLoading = true;
  String? errorMessage;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _loadCollections();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadCollections() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final editionsData = await HadithApiService.getEditions();

      // Group editions by collection
      Map<String, List<HadithEdition>> groupedCollections = {};
      Map<String, String> displayNames = {};

      for (var data in editionsData) {
        final collectionName = data['book'] as String? ?? '';
        final collectionDisplayName = data['name'] as String? ?? collectionName;
        final editionsList = (data['editions'] as List<dynamic>?)?.map((e) {
              return HadithEdition.fromJson(
                  e as Map<String, dynamic>, collectionName);
            }).toList() ??
            [];

        if (collectionName.isNotEmpty) {
          groupedCollections[collectionName] = editionsList;
          displayNames[collectionName] = collectionDisplayName;
        }
      }

      setState(() {
        collections = groupedCollections;
        collectionDisplayNames = displayNames;
        isLoading = false;
      });

      _animationController.forward();

      // Log for debugging
      debugPrint(
          'Loaded ${groupedCollections.length} collections: ${groupedCollections.keys.join(", ")}');
    } catch (e) {
      debugPrint('Error loading collections: $e');
      setState(() {
        errorMessage =
            'Failed to load Hadith books. Please check your internet connection and try again.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAppBar(),
            _buildBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: Text(
        'Hadith Books',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Get.isDarkMode ? AppColors.white : AppColors.black,
        ),
      ),
      //
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
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
                'Loading Books...',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Get.isDarkMode
                      ? AppColors.white.withOpacity(0.8)
                      : AppColors.black.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        margin: const EdgeInsets.all(20),
        child: Center(
          child: Container(
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
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.red.withOpacity(0.1),
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.red,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Oops! Something went wrong',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.red,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Get.isDarkMode
                        ? AppColors.white.withOpacity(0.7)
                        : AppColors.black.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: _loadCollections,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (collections.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary.withOpacity(0.1),
                ),
                child: Icon(
                  Icons.library_books_rounded,
                  size: 50,
                  color: primary.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'No Books Available',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Get.isDarkMode
                      ? AppColors.white.withOpacity(0.7)
                      : AppColors.black.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCollections,
      color: primary,
      backgroundColor: Get.isDarkMode ? secondary : AppColors.white,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: collections.keys.length,
            itemBuilder: (context, index) {
              final collectionName = collections.keys.elementAt(index);
              final editions = collections[collectionName]!;
              final displayName =
                  collectionDisplayNames[collectionName] ?? collectionName;

              final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    (index / collections.keys.length) * 0.5,
                    ((index + 1) / collections.keys.length) * 0.5 + 0.5,
                    curve: Curves.easeOutCubic,
                  ),
                ),
              );

              log('Loading collection: $collectionName with ${editions.length} editions');
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(
                  opacity: animation,
                  child: _buildCollectionCard(
                      collectionName, editions, displayName, index),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCollectionCard(String collectionName,
      List<HadithEdition> editions, String displayName, int index) {
    final gradientColors = _getGradientColors(index);

    return AppButtonAnimation(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              gradientColors[0],
              gradientColors[1],
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Get.isDarkMode
                  ? AppColors.white.withOpacity(0.1)
                  : AppColors.black.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Material(
              color: AppColors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  showHadithTranslationsBottomSheet(
                      context, collectionName, displayName, editions);
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Icon Container
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.white.withOpacity(0.2),
                          border: Border.all(
                            color: primary.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.menu_book_rounded,
                          color: primary,
                          size: 30,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: GoogleFonts.poppins(
                                color: Get.isDarkMode
                                    ? AppColors.white
                                    : AppColors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 8),

                            Text(
                              _getCollectionDescription(collectionName),
                              style: GoogleFonts.poppins(
                                color: Get.isDarkMode
                                    ? AppColors.white.withOpacity(0.7)
                                    : AppColors.black.withOpacity(0.7),
                                fontSize: 13,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 12),

                            // Bottom Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: primary.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: primary.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    '${editions.length} Translation${editions.length > 1 ? 's' : ''}',
                                    style: GoogleFonts.poppins(
                                      color: primary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primary.withOpacity(0.2),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
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

  String _getCollectionDescription(String collectionName) {
    switch (collectionName.toLowerCase()) {
      case 'bukhari':
        return 'The most authentic collection of Hadith compiled by Imam Bukhari. Contains the sayings, actions, and approvals of Prophet Muhammad (ﷺ).';
      case 'muslim':
        return 'The second most authentic collection after Bukhari, compiled by Imam Muslim. Known for its systematic arrangement and rigorous authentication.';
      case 'abudawud':
        return 'Focuses primarily on legal rulings and jurisprudence. Compiled by Imam Abu Dawud, contains hadiths related to Islamic law.';
      case 'tirmidhi':
        return 'Compiled by Imam Tirmidhi, includes commentary and grading of hadiths. Known for its comprehensive coverage of Islamic teachings.';
      case 'nasai':
        return 'Compiled by Imam An-Nasa\'i, known for detailed analysis of hadith chains and authentication methods.';
      case 'ibnmajah':
        return 'Compiled by Imam Ibn Majah, provides a comprehensive collection covering various aspects of Islamic life and practice.';
      case 'qudsi':
        return 'Sacred sayings where the meaning comes from Allah but the words are from Prophet Muhammad (ﷺ). Known as Hadith Qudsi.';
      case 'nawawi':
        return 'A collection of 40 important hadiths compiled by Imam Nawawi, covering fundamental principles of Islam.';
      case 'dehlawi':
        return 'A collection of 40 hadiths selected by Shah Waliullah Dehlawi, focusing on spiritual and moral guidance.';
      case 'malik':
        return 'One of the earliest collections of hadith and Islamic jurisprudence, compiled by Imam Malik ibn Anas.';
      default:
        return 'Authentic collection of prophetic traditions and teachings from Islamic literature.';
    }
  }
}
