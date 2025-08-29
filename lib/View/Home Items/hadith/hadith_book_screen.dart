import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Hadith Books',
          style: TextStyle(
            fontSize: 20,
            color: white,
            fontWeight: FontWeight.bold,
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
              padding: EdgeInsets.symmetric(horizontal: 32.w),
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
      backgroundColor: secondary,
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
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
    return Card(
      color: primary100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: white.withOpacity(0.2), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 16.w),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: grey100.withOpacity(0.2),
            border: Border.all(
              color: grey100,
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.menu_book_rounded,
            color: grey100,
            size: 28,
          ),
        ),
        title: Text(
          // editions.isNotEmpty ? editions.first.name : collectionName, // Use the first edition's book name or collection name
          displayName, // Use the display name here
          style: const TextStyle(
            color: white,
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
                style: TextStyle(
                  color: white.withOpacity(0.7),
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: grey100.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: grey100.withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      '${editions.length} Translation${editions.length > 1 ? 's' : ''}',
                      style: TextStyle(
                        color: grey100,
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
        // trailing: Container(
        //   padding: EdgeInsets.all(8.w),
        //   decoration: BoxDecoration(
        //     color:  white.withOpacity(0.1),
        //     borderRadius: BorderRadius.circular(8),
        //   ),
        //   child: Icon(
        //     Icons.arrow_forward_ios_rounded,
        //     color:  white.withOpacity(0.7),
        //     size: 16,
        //   ),
        // ),
        onTap: () {
          showHadithTranslationsBottomSheet(
              context, collectionName, displayName, editions);
          // Get.to(
          //   () => HadithTranslationsScreen(
          //     collectionName: collectionName,
          //     displayName: displayName, // Pass the display name
          //     editions: editions,
          // )
          // );
        },
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
