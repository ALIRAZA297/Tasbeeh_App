import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

Map<String, String> basicHeaderInfo() {
  return {
    HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers":
        "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
  };
}

class ApiMethod {
  ApiMethod(this.isBasic);
  final bool isBasic;

  Future<Map<String, dynamic>?> get(String url) async {
    debugPrint('|📍 GET Request: $url');

    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: basicHeaderInfo(),
          )
          .timeout(const Duration(seconds: 15));

      debugPrint('|📒 Response Code: ${response.statusCode}');
      debugPrint('|📒 Response Body: ${response.body.substring(0, response.body.length > 300 ? 300 : response.body.length)}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        debugPrint('❌ Error: ${response.statusCode} ${response.body}');
        return null;
      }
    } on SocketException {
      debugPrint('❌ Network Error: Check your Internet connection.');
      return null;
    } on TimeoutException {
      debugPrint('❌ Timeout Error: $url');
      return null;
    } catch (e) {
      debugPrint('❌ Unknown Error: $e');
      return null;
    }
  }
}
