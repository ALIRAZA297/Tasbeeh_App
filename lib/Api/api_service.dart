import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

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
    log("Calling API: $url");

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        log(
            "API Response: ${response.body.substring(0, 300)}..."); // Print part of response
        return json.decode(response.body);
      } else {
        log("API Error: ${response.statusCode}, ${response.body}");
        return null;
      }
    } catch (e) {
      log("Network Error: $e");
      return null;
    }
  }
}
