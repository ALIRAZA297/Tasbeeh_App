import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../View/Home Items/Quran/Model/surah_e_quran_model.dart';
import 'api_method.dart';

class ApiService {
  static const String baseUrl = "https://hadithapi.com/api";
  static const String apiKey =
      "\$2y\$10\$G2AnPf652uzFdaDfAzjsMOIOaXsFxRYBLYDAbzf4bwoFnCcmBpIu";

  static const quranApi = 'http://api.alquran.cloud/v1/quran/ar';

  /// Generic GET request
  static Future<Map<String, dynamic>?> get(String endpoint) async {
    final response =
        await http.get(Uri.parse("$baseUrl/$endpoint?apiKey=$apiKey"));

    if (response.statusCode == 200) {
      return json.decode(response.body); // Return JSON response
    } else {
      return null;
    }
  }

  /// GET Hadiths with pagination
  static Future<Map<String, dynamic>?> getHadiths(int page) async {
    final url = "$baseUrl/hadiths/?apiKey=$apiKey&page=$page";
    debugPrint("Calling API: $url");

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        debugPrint(
            "API Response: ${response.body.substring(0, 300)}..."); // Print part of response
        return json.decode(response.body);
      } else {
        debugPrint("API Error: ${response.statusCode}, ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Network Error: $e");
      return null;
    }
  }

  static Future<List<Surah>> getSurah(int id, String lang) async {
    List<Surah> surah = [];
    final url = 'https://quranenc.com/api/v1/translation/sura/$lang/$id';
    debugPrint("Fetching Surah from: $url");

    try {
      final response = await ApiMethod(true).get(url);

      debugPrint("Raw API Response: $response");

      if (response != null && response["result"] != null) {
        response["result"].forEach((e) {
          surah.add(Surah.fromJson(e));
        });
        debugPrint("Fetched Ayats: ${surah.length}");
      } else {
        debugPrint("No result found in API response");
      }
    } catch (e) {
      debugPrint('Error fetching Surah: $e');
    }

    return surah;
  }
}
