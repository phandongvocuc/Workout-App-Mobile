import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../data/models/user_model.dart';
import '../data/repositories/prefs_repository.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final PrefsRepository _prefs;
  final ApiService _apiService;

  String? _token;
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider(this._prefs)
      : _apiService = ApiService(_prefs.getApiBaseUrl()) {
    _restoreSession();
  }

  String get apiBaseUrl => _apiService.baseUrl;
  String? get token => _token;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _token != null && _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _restoreSession() {
    final savedToken = _prefs.getAuthToken();
    final savedUserJson = _prefs.getUserJson();
    if (savedToken != null && savedUserJson != null) {
      try {
        _token = savedToken;
        _currentUser = UserModel.fromJson(
          Map<String, dynamic>.from(jsonDecode(savedUserJson) as Map),
        );
      } catch (_) {
        _token = null;
        _currentUser = null;
      }
    }
  }

  Future<void> setApiBaseUrl(String newUrl) async {
    final trimmed = newUrl.trim();
    if (trimmed.isEmpty) return;
    _apiService.updateBaseUrl(trimmed);
    await _prefs.setApiBaseUrl(trimmed);
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.login(email: email, password: password);
      _token = result.token;
      _currentUser = result.user;
      await _prefs.setAuthToken(result.token);
      await _prefs.setUserJson(jsonEncode(result.user.toJson()));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshProfile() async {
    if (_token == null) return;
    try {
      final updated = await _apiService.fetchMe(_token!);
      _currentUser = updated;
      await _prefs.setUserJson(jsonEncode(updated.toJson()));
      notifyListeners();
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        await logout();
      }
    }
  }

  Future<void> updateProfile({
    required String fullName,
    String? phone,
    String? fitnessGoal,
    double? heightCm,
    double? weightKg,
    String? password,
  }) async {
    if (_token == null) {
      throw ApiException('You are not logged in.');
    }
    final updated = await _apiService.updateMyProfile(
      token: _token!,
      fullName: fullName,
      phone: phone,
      fitnessGoal: fitnessGoal,
      heightCm: heightCm,
      weightKg: weightKg,
      password: password,
    );
    _currentUser = updated;
    await _prefs.setUserJson(jsonEncode(updated.toJson()));
    notifyListeners();
  }

  // Admin methods
  Future<List<UserModel>> adminFetchUsers() async {
    if (_token == null) throw ApiException('Authentication required.');
    return _apiService.adminListUsers(_token!);
  }

  Future<UserModel> adminCreateUser({
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
    if (_token == null) throw ApiException('Authentication required.');
    return _apiService.adminCreateUser(
      token: _token!,
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
      fitnessGoal: fitnessGoal,
      membershipTier: membershipTier,
      heightCm: heightCm,
      weightKg: weightKg,
      active: active,
    );
  }

  Future<UserModel> adminUpdateUser({
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
    if (_token == null) throw ApiException('Authentication required.');
    return _apiService.adminUpdateUser(
      token: _token!,
      id: id,
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
      fitnessGoal: fitnessGoal,
      membershipTier: membershipTier,
      heightCm: heightCm,
      weightKg: weightKg,
      active: active,
    );
  }

  Future<void> adminDeleteUser(int id) async {
    if (_token == null) throw ApiException('Authentication required.');
    await _apiService.adminDeleteUser(token: _token!, id: id);
  }

  Future<void> logout() async {
    final currentToken = _token;
    _token = null;
    _currentUser = null;
    _errorMessage = null;
    await _prefs.setAuthToken(null);
    await _prefs.setUserJson(null);
    notifyListeners();

    if (currentToken != null) {
      await _apiService.logout(currentToken);
    }
  }
}

