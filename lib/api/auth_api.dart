import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/auth_response.dart';
import 'api_client.dart';

class AuthApi {
  static final String? _baseUrl = dotenv.env['API_BASE_URL'];

  static Future<AuthResponse> login(String username, String password) async {
    final response = await ApiClient.post('auth/login', {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Invalid credentials');
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  static Future<AuthResponse> register(
    String username,
    String email,
    String password,
  ) async {
    final response = await ApiClient.post(
      'auth/register',
      jsonEncode({'username': username, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Registration failed');
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  static Future<AuthResponse> getCurrentUser(String sessionId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/auth/me'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'JSESSIONID=$sessionId',
      },
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get user: ${response.body}');
    }
  }
}
