import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveSessionId(String sessionId) async {
    await _storage.write(key: 'session_id', value: sessionId);
  }

  Future<String?> getSessionId() async {
    return await _storage.read(key: 'session_id');
  }

  Future<void> deleteSessionId() async {
    await _storage.delete(key: 'session_id');
  }

  Future<void> saveUsername(String username) async {
    await _storage.write(key: 'username', value: username);
  }

  Future<String?> getUsername() async {
    return await _storage.read(key: 'username');
  }

  Future<void> deleteUsername() async {
    await _storage.delete(key: 'username');
  }
}
