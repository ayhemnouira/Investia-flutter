class AuthResponse {
  final String message;
  final String? username;

  AuthResponse({required this.message, this.username});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'] ?? json.toString(),
      username: json['username'],
    );
  }
}
