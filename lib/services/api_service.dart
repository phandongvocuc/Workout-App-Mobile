import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../data/models/user_model.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class LoginResult {
  final String token;
  final String role;
  final UserModel user;

  const LoginResult({
    required this.token,
    required this.role,
    required this.user,
  });
}

class ApiService {
  String _baseUrl;
  static const Duration _timeout = Duration(seconds: 10);

  ApiService(String baseUrl) : _baseUrl = _normalizeUrl(baseUrl);

  String get baseUrl => _baseUrl;

  void updateBaseUrl(String newUrl) {
    _baseUrl = _normalizeUrl(newUrl);
  }

  static String _normalizeUrl(String url) {
    var trimmed = url.trim();
    if (trimmed.endsWith('/')) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }
    return trimmed;
  }

  Map<String, String> _headers({String? token}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    final response = await _send(
      () => http.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        headers: _headers(),
        body: jsonEncode({'email': email.trim(), 'password': password}),
      ),
    );

    final data = _decodeMap(response);
    return LoginResult(
      token: data['token'] as String,
      role: data['role'] as String,
      user: UserModel.fromJson(Map<String, dynamic>.from(data['user'] as Map)),
    );
  }

  Future<void> logout(String token) async {
    try {
      await _send(
        () => http.post(
          Uri.parse('$_baseUrl/api/auth/logout'),
          headers: _headers(token: token),
        ),
      );
    } catch (_) {
      // Ignore network errors on logout so local session still clears
    }
  }

  Future<UserModel> fetchMe(String token) async {
    final response = await _send(
      () => http.get(
        Uri.parse('$_baseUrl/api/auth/me'),
        headers: _headers(token: token),
      ),
    );
    return UserModel.fromJson(_decodeMap(response));
  }

  Future<UserModel> updateMyProfile({
    required String token,
    required String fullName,
    String? phone,
    String? fitnessGoal,
    double? heightCm,
    double? weightKg,
    int? age,
    String? gender,
    String? password,
  }) async {
    final body = <String, dynamic>{
      'fullName': fullName.trim(),
      'phone': phone?.trim(),
      'fitnessGoal': fitnessGoal,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'age': age,
      'gender': gender,
      if (password != null && password.isNotEmpty) 'password': password,
    };

    final response = await _send(
      () => http.put(
        Uri.parse('$_baseUrl/api/users/me'),
        headers: _headers(token: token),
        body: jsonEncode(body),
      ),
    );
    return UserModel.fromJson(_decodeMap(response));
  }

  // Admin User CRUD
  Future<List<UserModel>> adminListUsers(String token) async {
    final response = await _send(
      () => http.get(
        Uri.parse('$_baseUrl/api/admin/users'),
        headers: _headers(token: token),
      ),
    );
    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((e) => UserModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<UserModel> adminCreateUser({
    required String token,
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String? fitnessGoal,
    String? membershipTier,
    double? heightCm,
    double? weightKg,
    bool active = true,
  }) async {
    final response = await _send(
      () => http.post(
        Uri.parse('$_baseUrl/api/admin/users'),
        headers: _headers(token: token),
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
          'fullName': fullName.trim(),
          'phone': phone?.trim(),
          'fitnessGoal': fitnessGoal,
          'membershipTier': membershipTier,
          'heightCm': heightCm,
          'weightKg': weightKg,
          'active': active,
        }),
      ),
    );
    return UserModel.fromJson(_decodeMap(response));
  }

  Future<UserModel> adminUpdateUser({
    required String token,
    required int id,
    required String email,
    String? password,
    required String fullName,
    String? phone,
    String? fitnessGoal,
    String? membershipTier,
    double? heightCm,
    double? weightKg,
    required bool active,
  }) async {
    final response = await _send(
      () => http.put(
        Uri.parse('$_baseUrl/api/admin/users/$id'),
        headers: _headers(token: token),
        body: jsonEncode({
          'email': email.trim(),
          if (password != null && password.isNotEmpty) 'password': password,
          'fullName': fullName.trim(),
          'phone': phone?.trim(),
          'fitnessGoal': fitnessGoal,
          'membershipTier': membershipTier,
          'heightCm': heightCm,
          'weightKg': weightKg,
          'active': active,
        }),
      ),
    );
    return UserModel.fromJson(_decodeMap(response));
  }

  Future<void> adminDeleteUser({
    required String token,
    required int id,
  }) async {
    await _send(
      () => http.delete(
        Uri.parse('$_baseUrl/api/admin/users/$id'),
        headers: _headers(token: token),
      ),
    );
  }

  Future<http.Response> _send(Future<http.Response> Function() requestFn) async {
    try {
      final response = await requestFn().timeout(_timeout);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      }
      throw ApiException(
        _extractErrorMessage(response),
        statusCode: response.statusCode,
      );
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw ApiException(
        'Connection timed out. Make sure the HydroFit Spring Boot server is running at $_baseUrl.',
      );
    } on SocketException {
      throw ApiException(
        'Cannot reach server at $_baseUrl. Check your server URL and ensure Spring Boot is running.',
      );
    } on http.ClientException {
      throw ApiException(
        'Network error connecting to $_baseUrl. Check your server URL and Wi-Fi.',
      );
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  Map<String, dynamic> _decodeMap(http.Response response) {
    if (response.body.isEmpty) return {};
    return Map<String, dynamic>.from(jsonDecode(response.body) as Map);
  }

  String _extractErrorMessage(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['message'] is String) {
        return decoded['message'] as String;
      }
    } catch (_) {}
    return 'Request failed (HTTP ${response.statusCode})';
  }
}

