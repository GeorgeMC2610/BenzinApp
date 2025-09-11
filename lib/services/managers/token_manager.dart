import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  String? _token;

  TokenManager._internal();

  factory TokenManager() => _instance;

  // Initialize token from SharedPreferences
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _instance._token = prefs.getString('bearer_token');
  }

  String? get token => _token;

  // Save token to memory and SharedPreferences
  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bearer_token', token);
  }

  // Remove token from memory and SharedPreferences
  Future<void> removeToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('bearer_token');
  }

  // Check if token is present
  bool get isTokenPresent => _token != null;
}