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
    try {
      await CarManager().get(forceBackend: true);
      isLoggedIn = true;
      return true;
    }
    on UnauthorizedException {
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    final Map<String, dynamic> body = {
      "username": username,
      "password": password,
    };

    final response = await RequestHandler.sendPostRequest(loginUri, false, body);

    if (response.statusCode == 200) {
      await TokenManager().removeToken();
      await TokenManager().setToken(json.decode(response.body)['auth_token']);

      isLoggedIn = true;
      return true;
    }
    else {
      return false;
    }
  }

  Future<bool> signup(
      String username, String password,
      String confirmPassword, String manufacturer,
      String model, int year) async {
    final Map<String, dynamic> body = {
      'username': username,
      'password': password,
      'password_confirmation': confirmPassword,
      'manufacturer': manufacturer,
      'model': model,
      'year': year,
    };

    final response = await RequestHandler.sendPostRequest(signupUri, false, body);

    if (response.statusCode == 201) {
      await TokenManager().removeToken();
      await TokenManager().setToken(jsonDecode(response.body)['auth_token']);

      isLoggedIn = true;
      return true;
    }
    else {
      return false;
    }
  }
}

class UnauthorizedException implements Exception {
  UnauthorizedException();
}