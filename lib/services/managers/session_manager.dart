import 'dart:convert';

import 'package:benzinapp/services/managers/token_manager.dart';
import 'package:benzinapp/services/request_handler.dart';

import '../data_holder.dart';
import 'car_manager.dart';

class SessionManager {

  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  final loginUri = '${DataHolder.destination}/auth/login';
  final signupUri = '${DataHolder.destination}/signup';

  bool isLoggedIn = false;

  Future<bool> testConnection() async {
    return false;
  }

  Future<int> login(String email, String password) async {
    final Map<String, dynamic> body = {
      "user": {
        "email": email,
        "password": password,
      }
    };

    final response = await RequestHandler.sendPostRequest(loginUri, false, body);

    if (response.statusCode == 200) {
      await TokenManager().removeToken();
      await TokenManager().setToken(response.headers['Authorization']!);

      isLoggedIn = true;
    }

    return response.statusCode;
  }

  Future<int> signup(
      String email, String username, String password,
      String confirmPassword) async {
    final Map<String, dynamic> body = {
      "user": {
        "email": email,
        "username": username,
        "password_confirmation": confirmPassword,
        "password": password,
      }
    };

    final response = await RequestHandler.sendPostRequest(signupUri, false, body);

    if (response.statusCode == 201) {
      await TokenManager().removeToken();
      await TokenManager().setToken(jsonDecode(response.body)['auth_token']);

      isLoggedIn = true;
    }

    return response.statusCode;
  }
}

class UnauthorizedException implements Exception {
  UnauthorizedException();
}