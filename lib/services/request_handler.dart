import 'dart:convert';
import 'package:benzinapp/services/managers/session_manager.dart';
import 'package:benzinapp/services/managers/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RequestHandler {

  static Future<Map<String, String>> basisHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';
    return {
      'Content-Type': 'application/json',
      'Accept-Language': languageCode,
    };
  }

  static Future<Map<String, String>> authorizationHeaders() async {
    final base = await basisHeaders();
    return {
      ...base,
      'Authorization': TokenManager().token!,
    };
  }

  static Future<http.Response> sendGetRequest(String uri) async {
    var client = http.Client();
    var url = Uri.parse(uri);
    var headers = await authorizationHeaders();

    final response = await client.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 401) {
      throw UnauthorizedException();
    }

    return response;
  }

  static Future<http.Response> sendPostRequest(String uri, bool authorize, Map<String, dynamic> body) async {
    print(await basisHeaders());
    var client = http.Client();
    var url = Uri.parse(uri);
    var headers = authorize ? await authorizationHeaders() : await basisHeaders();

    final response = await client.post(
      url,
      headers: headers,
      body: json.encode(body)
    );

    if (response.statusCode == 401 && authorize) {
      throw UnauthorizedException();
    }

    return response;
  }

  static Future<http.Response> sendPatchRequest(String uri, Map<String, dynamic> body, { bool authorize = true }) async {
    var client = http.Client();
    var url = Uri.parse(uri);
    var headers = authorize ? await authorizationHeaders() : await basisHeaders();

    final response = await client.patch(
        url,
        headers: headers,
        body: json.encode(body)
    );

    if (response.statusCode == 401) {
      throw UnauthorizedException();
    }

    return response;
  }

  static Future<http.Response> sendDeleteRequest(String uri) async {
    var client = http.Client();
    var url = Uri.parse(uri);
    var headers = await authorizationHeaders();

    final response = await client.delete(
        url,
        headers: headers,
    );

    if (response.statusCode == 401) {
      throw UnauthorizedException();
    }

    return response;
  }
}

extension Ok on http.Response {
  bool get ok => (statusCode ~/100) == 2;
}
