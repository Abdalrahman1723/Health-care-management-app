// core/network/api_client.dart

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode

http.Client createHttpClient() {
  if (kDebugMode) {
    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    return IOClient(ioClient);
  } else {
    return http.Client(); // Default secure client for production
  }
}

class ApiClient {
  final String baseUrl;
  final http.Client client;

  ApiClient({required this.baseUrl}) : client = createHttpClient();

  //========the get method=========//
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
      );
      return _handleResponse(response);
    } catch (e) {
      log('Error in GET request: $e');
      throw Exception('Failed to make GET request: $e');
    }
  }

  //========the post method=========//
  Future<dynamic> post(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    final response = await client.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  //? Add put, delete, etc. as needed

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      log(response.body);
      return jsonDecode(response.body);
    } else {
      log("response error :${response.body}");
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
