import 'package:benzinapp/services/managers/token_manager.dart';
import 'package:benzinapp/services/managers/user_manager.dart';
import 'package:benzinapp/services/request_handler.dart';
import '../data_holder.dart';

class SessionManager {

  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  final loginUri = '${DataHolder.destination}/login';
  final logoutUri = '${DataHolder.destination}/logout';
  final signupUri = '${DataHolder.destination}/signup';

  bool isLoggedIn = false;

  Future<bool> testConnection() async {
    try {
      await UserManager().getCurrentUser();
      return true;
    }
    catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await RequestHandler.sendDeleteRequest(logoutUri);
    await TokenManager().removeToken();
    isLoggedIn = false;
    DataHolder().destroyValues();
  }

  Future<SessionStatus> login(String email, String password) async {
    final Map<String, dynamic> body = {
      "user": {
        "email": email,
        "password": password,
      }
    };

    final response = await RequestHandler.sendPostRequest(loginUri, false, body);

    if (response.statusCode == 200) {

    }

    switch (response.statusCode) {
      case 200:
        await TokenManager().removeToken();
        await TokenManager().setToken(response.headers['authorization']!);
        isLoggedIn = true;
        return SessionStatus.success;
      case 401:
        return SessionStatus.wrongCredentials;
      default:
        return SessionStatus.blank;
    }
  }

  Future<SessionStatus> signup(
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

    switch (response.statusCode) {
      case 201:
        await TokenManager().removeToken();
        await TokenManager().setToken(response.headers['authorization']!);
        isLoggedIn = true;
        return SessionStatus.success;
      case 422:
        return response.body.contains("Email") ? SessionStatus.emailTaken : SessionStatus.usernameTaken;
      case 500:
        return SessionStatus.serverError;
      default:
        return SessionStatus.blank;
    }
  }
}

enum SessionStatus {
  success,
  wrongCredentials,
  usernameTaken,
  emailTaken,
  serverError,
  blank
}

class UnauthorizedException implements Exception {
  UnauthorizedException();
}