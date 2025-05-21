import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  static String get baseUrl => dotenv.env['API_BASE_URL']!;

  static Future<http.Response> post(String endpoint, dynamic body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    print('Making request to: $url'); // Debug logging

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    print('Response status: ${response.statusCode}'); // Debug logging
    print('Response body: ${response.body}');

    return response;
  }
}
