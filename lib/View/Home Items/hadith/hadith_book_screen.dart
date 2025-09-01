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

class _HadithBooksScreenState extends State<HadithBooksScreen> {
  Map<String, List<HadithEdition>> collections = {};
  Map<String, String> collectionDisplayNames = {}; // Add this line
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCollections();
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
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Hadith Books',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Get.isDarkMode ? white : black,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 4,
          color: primary,
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
              color: white.withOpacity(0.54),
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Error Loading Books',
              style: TextStyle(
                color: white,
                fontSize: 18,
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
                  color: white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadCollections,
              style: ElevatedButton.styleFrom(
                backgroundColor: grey100,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(
                  color: white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (collections.isEmpty) {
      return Center(
        child: Text(
          'No books available',
          style: TextStyle(
            color: white.withOpacity(0.7),
            fontSize: 16,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCollections,
      color: grey100,
      backgroundColor: primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: collections.keys.length,
        itemBuilder: (context, index) {
          final collectionName = collections.keys.elementAt(index);
          final editions = collections[collectionName]!;

          final displayName = collectionDisplayNames[collectionName] ??
              collectionName; // Get display name
          log('Loading collection: $collectionName with ${editions.length} editions');
          return _buildCollectionCard(collectionName, editions, displayName);
        },
      ),
    );
  }

  Widget _buildCollectionCard(
      String collectionName, List<HadithEdition> editions, String displayName) {
    return AppButtonAnimation(
      child: Card(
        elevation: 1,
        color: secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: white.withOpacity(0.2), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: grey100.withOpacity(0.2),
              border: Border.all(
                color: primary,
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: primary,
              size: 28,
            ),
          ),
          title: Text(
            // editions.isNotEmpty ? editions.first.name : collectionName, // Use the first edition's book name or collection name
            displayName, // Use the display name here
            style: GoogleFonts.poppins(
              color: primary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getCollectionDescription(collectionName),
                  style: GoogleFonts.poppins(
                    color: black54,
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: grey100.withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        '${editions.length} Translation${editions.length > 1 ? 's' : ''}',
                        style: GoogleFonts.poppins(
                          color: black54,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            showHadithTranslationsBottomSheet(
                context, collectionName, displayName, editions);
          },
        ),
      ),
    );
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
