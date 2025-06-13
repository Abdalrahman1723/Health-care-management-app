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
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      return _handleResponse(response);
    } catch (e) {
      log('Error in GET request: $e');
      if (e is http.Response) {
        log('Response status code: ${e.statusCode}');
        log('Response body: ${e.body}');
        throw Exception(
            'Failed to make GET request: Status ${e.statusCode} - ${e.body}');
      }
      throw Exception('Failed to make GET request: $e');
    }
  }

  //========the post method=========//
  Future<dynamic> post(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    String myUri = '$baseUrl$endpoint';
    if (endpoint.contains("predict")) {
      myUri = "https://web-production-d6781.up.railway.app/predict";
    }
    log("the client uri : $myUri");
    final response = await client.post(
      Uri.parse(myUri),
      headers: headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  //========the put method=========//
  Future<dynamic> put(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    String myUri = '$baseUrl$endpoint';
    log("------------------my uri is : $myUri");
    try {
      final response = await client.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      log('Error in PUT request: $e');
      throw Exception('Failed to make PUT request: $e');
    }
  }

  //========the delete method=========//
  Future<dynamic> delete(String endpoint,
      {Map<String, String>? headers}) async {
    try {
      final response = await client.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      return _handleResponse(response);
    } catch (e) {
      log('Error in DELETE request: $e');
      throw Exception('Failed to make DELETE request: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        log('Response body: ${response.body}');
        if (response.body.isEmpty) {
          return null;
        }
        return jsonDecode(response.body);
      } catch (e) {
        log('Error parsing response: $e');
        log('Raw response body: ${response.body}');
        throw FormatException('Failed to parse response: ${response.body}');
      }
    } else {
      log("Response error - Status: ${response.statusCode}, Body: ${response.body}");
      throw Exception(
          'Failed to load data: ${response.statusCode} - ${response.body}');
    }
  }
}
