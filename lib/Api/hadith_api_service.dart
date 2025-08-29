import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class HadithApiService {
  static const String baseUrl = 'https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1';

  // Cache directories
  static Directory? _hadithCacheDirectory;
  static bool _isCacheInitialized = false;

  /// Initialize cache directory for hadith data
  static Future<void> _initializeCacheDirectory() async {
    if (_isCacheInitialized) return;

    try {
      final appDir = await getApplicationDocumentsDirectory();
      _hadithCacheDirectory = Directory('${appDir.path}/hadith_cache');

      if (!await _hadithCacheDirectory!.exists()) {
        await _hadithCacheDirectory!.create(recursive: true);
        debugPrint('Created hadith cache directory: ${_hadithCacheDirectory!.path}');
      }
      _isCacheInitialized = true;
      debugPrint('Hadith cache directory initialized successfully');
    } catch (e) {
      debugPrint('Error initializing hadith cache directory: $e');
      _isCacheInitialized = false;
    }
  }

  /// Generate cache file path for editions
  static String _getEditionsCacheFilePath() {
    return '${_hadithCacheDirectory?.path}/editions.json';
  }

  /// Generate cache file path for translations
  static String _getTranslationsCacheFilePath(String bookName) {
    return '${_hadithCacheDirectory?.path}/translations_$bookName.json';
  }

  /// Generate cache file path for sections
  static String _getSectionsCacheFilePath(String editionName) {
    return '${_hadithCacheDirectory?.path}/sections_$editionName.json';
  }

  /// Generate cache file path for section hadiths
  static String _getSectionHadithsCacheFilePath(String editionName, int sectionNumber) {
    return '${_hadithCacheDirectory?.path}/section_hadiths_${editionName}_$sectionNumber.json';
  }

  /// Generate cache file path for hadith details
  static String _getHadithDetailCacheFilePath(String editionName, int hadithNumber) {
    return '${_hadithCacheDirectory?.path}/hadith_detail_${editionName}_$hadithNumber.json';
  }

  /// Generate cache file path for hadith info
  static String _getHadithInfoCacheFilePath() {
    return '${_hadithCacheDirectory?.path}/hadith_info.json';
  }

  /// Check if data is cached
  static Future<bool> _isCached(String filePath) async {
    if (!_isCacheInitialized || _hadithCacheDirectory == null) return false;
    final file = File(filePath);
    return await file.exists();
  }

  /// Read data from cache
  static Future<Map<String, dynamic>?> _readFromCache(String filePath) async {
    if (!_isCacheInitialized || _hadithCacheDirectory == null) return null;

    try {
      final file = File(filePath);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        if (jsonString.isEmpty) {
          debugPrint('Cache file is empty: $filePath');
          await file.delete();
          return null;
        }
        final data = jsonDecode(jsonString) as Map<String, dynamic>;
        debugPrint('Cache hit: $filePath');
        return data;
      }
    } catch (e) {
      debugPrint('Error reading from cache ($filePath): $e');
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        debugPrint('Deleted corrupted cache file: $filePath');
      }
    }
    return null;
  }

  /// Write data to cache
  static Future<void> _writeToCache(String filePath, Map<String, dynamic> data) async {
    if (!_isCacheInitialized || _hadithCacheDirectory == null) return;

    try {
      final file = File(filePath);
      await file.writeAsString(jsonEncode(data));
      debugPrint('Cached data: $filePath');
    } catch (e) {
      debugPrint('Error writing to cache ($filePath): $e');
    }
  }

  /// Check if cache is expired (optional - you can set expiry time)
  static Future<bool> _isCacheExpired(String filePath, {Duration maxAge = const Duration(days: 7)}) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final stat = await file.stat();
        final age = DateTime.now().difference(stat.modified);
        return age > maxAge;
      }
    } catch (e) {
      debugPrint('Error checking cache expiry: $e');
    }
    return true;
  }

  // Get all available editions/collections
  static Future<List<Map<String, dynamic>>> getEditions() async {
    await _initializeCacheDirectory();

    const url = '$baseUrl/editions.json';
    final cacheFilePath = _getEditionsCacheFilePath();

    // Check cache first
    if (await _isCached(cacheFilePath) && !await _isCacheExpired(cacheFilePath)) {
      final cachedData = await _readFromCache(cacheFilePath);
      if (cachedData != null) {
        final editionsList = cachedData.entries.map((entry) {
          return {
            'book': entry.key,
            'name': entry.value['name'] as String,
            'editions': entry.value['collection'] as List<dynamic>,
          };
        }).toList();
        return editionsList;
      }
    }

    debugPrint('Fetching editions from: $url');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> editionsMap = json.decode(response.body);

      // Cache the data
      await _writeToCache(cacheFilePath, editionsMap);

      final editionsList = editionsMap.entries.map((entry) {
        return {
          'book': entry.key,
          'name': entry.value['name'] as String,
          'editions': entry.value['collection'] as List<dynamic>,
        };
      }).toList();

      return editionsList;
    } else {
      throw Exception('Failed to load editions: ${response.statusCode}');
    }
  }

  // Get all translations for a specific hadith book
  static Future<List<HadithTranslation>> getTranslations(String bookName) async {
    await _initializeCacheDirectory();

    final cacheFilePath = _getTranslationsCacheFilePath(bookName);

    // Check cache first
    if (await _isCached(cacheFilePath) && !await _isCacheExpired(cacheFilePath)) {
      final cachedData = await _readFromCache(cacheFilePath);
      if (cachedData != null) {
        final List<dynamic> translationsList = cachedData['translations'];
        return translationsList
            .map((json) => HadithTranslation(
                  editionName: json['editionName'] as String,
                  language: json['language'] as String,
                  author: json['author'] as String,
                  direction: json['direction'] as String,
                ))
            .toList();
      }
    }

    final editions = await getEditions();
    final translations = editions
        .expand((edition) => edition['editions'] as List<dynamic>)
        .where((edition) => (edition as Map<String, dynamic>)['name'].toString().contains(bookName))
        .map((edition) => HadithTranslation(
              editionName: edition['name'] as String,
              language: edition['language'] as String,
              author: edition['author'] as String,
              direction: edition['direction'] as String,
            ))
        .toList();

    // Cache the translations
    final cacheData = {
      'translations': translations
          .map((t) => {
                'editionName': t.editionName,
                'language': t.language,
                'author': t.author,
                'direction': t.direction,
              })
          .toList(),
    };
    await _writeToCache(cacheFilePath, cacheData);

    return translations;
  }

  // Get sections for a specific edition
  static Future<List<HadithSection>> getSections(String editionName) async {
    await _initializeCacheDirectory();

    final cacheFilePath = _getSectionsCacheFilePath(editionName);

    // Check cache first
    if (await _isCached(cacheFilePath) && !await _isCacheExpired(cacheFilePath)) {
      final cachedData = await _readFromCache(cacheFilePath);
      if (cachedData != null) {
        final List<dynamic> sectionsList = cachedData['sections'];
        return sectionsList
            .map((json) => HadithSection(
                  sectionNumber: json['sectionNumber'] as int,
                  name: json['name'] as String,
                  arabicName: json['arabicName'] as String,
                  range: List<int>.from(json['range']),
                ))
            .toList();
      }
    }

    final response = await http.get(Uri.parse('$baseUrl/editions/$editionName.json'));
    debugPrint('Fetching sections for edition: $editionName');
    debugPrint('Fetching URL: ${Uri.parse('$baseUrl/editions/$editionName.json')}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      List<HadithSection> sections = [];
      if (data.containsKey('metadata') && data['metadata'].containsKey('sections')) {
        final Map<String, dynamic> sectionNames = data['metadata']['sections'];
        final Map<String, dynamic> sectionDetails = data['metadata']['section_details'] ?? {};

        sections = sectionNames.entries.map((entry) {
          final details = sectionDetails[entry.key] ?? {};
          return HadithSection(
            sectionNumber: int.parse(entry.key),
            name: entry.value as String,
            arabicName: details['arabic_name'] ?? '',
            range: [
              (details['hadithnumber_first'] as num?)?.toInt() ?? 0,
              (details['hadithnumber_last'] as num?)?.toInt() ?? 0,
            ],
          );
        }).toList()
          ..removeWhere((section) => section.sectionNumber == 0 && section.name.isEmpty);
      }

      // Cache the sections
      final cacheData = {
        'sections': sections
            .map((s) => {
                  'sectionNumber': s.sectionNumber,
                  'name': s.name,
                  'arabicName': s.arabicName,
                  'range': s.range,
                })
            .toList(),
      };
      await _writeToCache(cacheFilePath, cacheData);

      return sections;
    } else {
      throw Exception('Failed to load sections: ${response.statusCode}');
    }
  }

  // Get hadiths from a specific section
  static Future<List<HadithItem>> getHadithsFromSection(String editionName, int sectionNumber) async {
    await _initializeCacheDirectory();

    final cacheFilePath = _getSectionHadithsCacheFilePath(editionName, sectionNumber);

    // Check cache first
    if (await _isCached(cacheFilePath) && !await _isCacheExpired(cacheFilePath)) {
      final cachedData = await _readFromCache(cacheFilePath);
      if (cachedData != null) {
        final List<dynamic> hadithsList = cachedData['hadiths'];
        return hadithsList
            .map((json) => HadithItem(
                  hadithNumber: json['hadithNumber'] as int,
                  text: json['text'] as String,
                  editionName: json['editionName'] as String,
                  sectionNumber: json['sectionNumber'] as int?,
                  grades: List<String>.from(json['grades']),
                ))
            .toList();
      }
    }

    final response = await http.get(Uri.parse('$baseUrl/editions/$editionName/sections/$sectionNumber.json'));
    debugPrint('Url: ${Uri.parse('$baseUrl/editions/$editionName/sections/$sectionNumber.json')}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      List<HadithItem> hadiths = [];
      if (data.containsKey('hadiths')) {
        final List<dynamic> hadithsList = data['hadiths'];
        hadiths = hadithsList.map((hadithJson) => HadithItem.fromJson(hadithJson as Map<String, dynamic>, editionName)).toList();
      }

      // Cache the hadiths
      final cacheData = {
        'hadiths': hadiths
            .map((h) => {
                  'hadithNumber': h.hadithNumber,
                  'text': h.text,
                  'editionName': h.editionName,
                  'sectionNumber': h.sectionNumber,
                  'grades': h.grades,
                })
            .toList(),
      };
      await _writeToCache(cacheFilePath, cacheData);

      return hadiths;
    } else {
      throw Exception('Failed to load hadiths from section: ${response.statusCode}');
    }
  }

  // Get specific hadith details
  static Future<HadithDetail> getHadithDetail(String editionName, int hadithNumber) async {
    await _initializeCacheDirectory();

    final cacheFilePath = _getHadithDetailCacheFilePath(editionName, hadithNumber);

    // Check cache first
    if (await _isCached(cacheFilePath) && !await _isCacheExpired(cacheFilePath)) {
      final cachedData = await _readFromCache(cacheFilePath);
      if (cachedData != null) {
        return HadithDetail(
          hadithNumber: cachedData['hadithNumber'] as int,
          text: cachedData['text'] as String,
          editionName: cachedData['editionName'] as String,
          grades: List<String>.from(cachedData['grades']),
          reference: cachedData['reference'] as String,
          chain: cachedData['chain'] as String,
        );
      }
    }

    final response = await http.get(Uri.parse('$baseUrl/editions/$editionName/$hadithNumber.json'));
    debugPrint('Url: ${Uri.parse('$baseUrl/editions/$editionName/$hadithNumber.json')}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('hadiths')) {
        final hadithJson = (data['hadiths'] as List).first as Map<String, dynamic>;
        final hadithDetail = HadithDetail.fromJson(hadithJson, editionName);

        // Cache the hadith detail
        final cacheData = {
          'hadithNumber': hadithDetail.hadithNumber,
          'text': hadithDetail.text,
          'editionName': hadithDetail.editionName,
          'grades': hadithDetail.grades,
          'reference': hadithDetail.reference,
          'chain': hadithDetail.chain,
        };
        await _writeToCache(cacheFilePath, cacheData);

        return hadithDetail;
      } else {
        throw Exception('Hadith data not found');
      }
    } else {
      throw Exception('Failed to load hadith detail: ${response.statusCode}');
    }
  }

  // Get hadith info/metadata
  static Future<Map<String, dynamic>> getHadithInfo() async {
    await _initializeCacheDirectory();

    final cacheFilePath = _getHadithInfoCacheFilePath();

    // Check cache first
    if (await _isCached(cacheFilePath) && !await _isCacheExpired(cacheFilePath)) {
      final cachedData = await _readFromCache(cacheFilePath);
      if (cachedData != null) {
        return cachedData;
      }
    }

    final response = await http.get(Uri.parse('$baseUrl/info.json'));
    debugPrint('Url: ${Uri.parse('$baseUrl/info.json')}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;

      // Cache the info
      await _writeToCache(cacheFilePath, data);

      return data;
    } else {
      throw Exception('Failed to load hadith info: ${response.statusCode}');
    }
  }

  // Cache management methods

  /// Clear all hadith cache
  static Future<void> clearAllCache() async {
    if (_hadithCacheDirectory == null) return;
    try {
      if (await _hadithCacheDirectory!.exists()) {
        await _hadithCacheDirectory!.delete(recursive: true);
        await _hadithCacheDirectory!.create(recursive: true);
        debugPrint('Cleared all hadith cache');
      }
    } catch (e) {
      debugPrint('Error clearing hadith cache: $e');
    }
  }

  /// Clear specific cache files
  static Future<void> clearEditionsCache() async {
    final filePath = _getEditionsCacheFilePath();
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        debugPrint('Cleared editions cache');
      }
    } catch (e) {
      debugPrint('Error clearing editions cache: $e');
    }
  }

  static Future<void> clearTranslationsCache(String bookName) async {
    final filePath = _getTranslationsCacheFilePath(bookName);
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        debugPrint('Cleared translations cache for $bookName');
      }
    } catch (e) {
      debugPrint('Error clearing translations cache: $e');
    }
  }

  static Future<void> clearSectionsCache(String editionName) async {
    final filePath = _getSectionsCacheFilePath(editionName);
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        debugPrint('Cleared sections cache for $editionName');
      }
    } catch (e) {
      debugPrint('Error clearing sections cache: $e');
    }
  }

  /// Get total cache size
  static Future<int> getCacheSize() async {
    if (_hadithCacheDirectory == null) return 0;

    int totalSize = 0;
    try {
      if (await _hadithCacheDirectory!.exists()) {
        await for (FileSystemEntity entity in _hadithCacheDirectory!.list()) {
          if (entity is File) {
            totalSize += await entity.length();
          }
        }
      }
      debugPrint('Total hadith cache size: $totalSize bytes');
    } catch (e) {
      debugPrint('Error calculating hadith cache size: $e');
    }
    return totalSize;
  }

  /// Get cache size in human readable format
  static String formatCacheSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Check if specific data is cached
  static Future<bool> isEditionsCached() async {
    await _initializeCacheDirectory();
    return await _isCached(_getEditionsCacheFilePath());
  }

  static Future<bool> isTranslationsCached(String bookName) async {
    await _initializeCacheDirectory();
    return await _isCached(_getTranslationsCacheFilePath(bookName));
  }

  static Future<bool> isSectionsCached(String editionName) async {
    await _initializeCacheDirectory();
    return await _isCached(_getSectionsCacheFilePath(editionName));
  }

  static Future<bool> isSectionHadithsCached(String editionName, int sectionNumber) async {
    await _initializeCacheDirectory();
    return await _isCached(_getSectionHadithsCacheFilePath(editionName, sectionNumber));
  }

  static Future<bool> isHadithDetailCached(String editionName, int hadithNumber) async {
    await _initializeCacheDirectory();
    return await _isCached(_getHadithDetailCacheFilePath(editionName, hadithNumber));
  }
}

// Data Models (keeping your existing models unchanged)
class HadithEdition {
  final String name;
  final String book;
  final String author;
  final String language;
  final bool hasSections;
  final String direction;
  final String source;
  final String comments;
  final String link;
  final String linkMin;

  HadithEdition({
    required this.name,
    required this.book,
    required this.author,
    required this.language,
    required this.hasSections,
    required this.direction,
    required this.source,
    required this.comments,
    required this.link,
    required this.linkMin,
  });

  factory HadithEdition.fromJson(Map<String, dynamic> json, String book) {
    return HadithEdition(
      name: json['name'] ?? '',
      book: book,
      author: json['author'] ?? '',
      language: json['language'] ?? '',
      hasSections: json['has_sections'] ?? false,
      direction: json['direction'] ?? 'ltr',
      source: json['source'] ?? '',
      comments: json['comments'] ?? '',
      link: json['link'] ?? '',
      linkMin: json['linkmin'] ?? '',
    );
  }

  String get collectionDisplayName {
    switch (book.toLowerCase()) {
      case 'bukhari':
        return 'Sahih al-Bukhari';
      case 'muslim':
        return 'Sahih Muslim';
      case 'abudawud':
        return 'Sunan Abi Dawud';
      case 'tirmidhi':
        return 'Jami\' at-Tirmidhi';
      case 'nasai':
        return 'Sunan an-Nasa\'i';
      case 'ibnmajah':
        return 'Sunan Ibn Majah';
      case 'qudsi':
        return 'Forty Hadith Qudsi';
      case 'nawawi':
        return 'Forty Hadith Nawawi';
      case 'dehlawi':
        return 'Forty Hadith Dehlawi';
      case 'malik':
        return 'Muwatta Malik';
      default:
        return book.toUpperCase();
    }
  }
}

class HadithTranslation {
  final String editionName;
  final String language;
  final String author;
  final String direction;

  HadithTranslation({
    required this.editionName,
    required this.language,
    required this.author,
    required this.direction,
  });
}

class HadithSection {
  final int sectionNumber;
  final String name;
  final String arabicName;
  final List<int> range;

  HadithSection({
    required this.sectionNumber,
    required this.name,
    required this.arabicName,
    required this.range,
  });

  int get hadithCount {
    if (range.length >= 2 && range[0] != 0 && range[1] != 0) {
      return range[1] - range[0] + 1;
    }
    return 0;
  }

  String get rangeText {
    if (range.length >= 2 && range[0] != 0 && range[1] != 0) {
      return range[0] == range[1] ? '${range[0]}' : '${range[0]}-${range[1]}';
    }
    return '';
  }
}

class HadithItem {
  final int hadithNumber;
  final String text;
  final String editionName;
  final int? sectionNumber;
  final List<String> grades;

  HadithItem({
    required this.hadithNumber,
    required this.text,
    required this.editionName,
    this.sectionNumber,
    required this.grades,
  });

  factory HadithItem.fromJson(Map<String, dynamic> json, String editionName) {
    final gradesList = (json['grades'] as List<dynamic>?)?.map((g) => (g as Map<String, dynamic>)['grade'] as String).toList() ?? [];
    return HadithItem(
      hadithNumber: (json['hadithnumber'] as num).toInt(),
      text: json['text'] ?? '',
      editionName: editionName,
      grades: gradesList,
    );
  }

  String get primaryGrade {
    return grades.isNotEmpty ? grades.first : 'Unknown';
  }
}

class HadithDetail {
  final int hadithNumber;
  final String text;
  final String editionName;
  final List<String> grades;
  final String reference;
  final String chain;

  HadithDetail({
    required this.hadithNumber,
    required this.text,
    required this.editionName,
    required this.grades,
    required this.reference,
    required this.chain,
  });

  factory HadithDetail.fromJson(Map<String, dynamic> json, String editionName) {
    final gradesList = (json['grades'] as List<dynamic>?)?.map((g) => (g as Map<String, dynamic>)['grade'] as String).toList() ?? [];
    final ref = json['reference'] as Map<String, dynamic>? ?? {};
    return HadithDetail(
      hadithNumber: (json['hadithnumber'] as num).toInt(),
      text: json['text'] ?? '',
      editionName: editionName,
      grades: gradesList,
      reference: 'Book ${ref['book'] ?? ''}, Hadith ${ref['hadith'] ?? ''}',
      chain: json['chain'] ?? '',
    );
  }

  String get primaryGrade {
    return grades.isNotEmpty ? grades.first : 'Unknown';
  }
}
