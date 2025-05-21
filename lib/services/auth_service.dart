import 'dart:convert';

import 'package:http/http.dart' as http;

import '../api/api_client.dart';
import 'storage_service.dart';

class AuthService {
  final StorageService _storageService = StorageService();

  Future<bool> login(String username, String password) async {
    try {
      await _storageService.saveUsername(username);
      return true;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      return true;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<String?> getCurrentUser() async {
    return await _storageService.getUsername();
  }

  Future<void> logout() async {
    await _storageService.deleteUsername();
    await _storageService.deleteSessionId();
  }

  Future<void> resetPassword(String email) async {
    final response = await http.post(
      Uri.parse('${ApiClient.baseUrl}/auth/reset-password'),
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception('Password reset failed');
    }
  }
}
