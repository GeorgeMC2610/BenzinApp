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

  static Future<http.Response> _sendRequest(
    String method,
    String uri, {
    Map<String, dynamic>? body,
    bool authorize = true,
  }) async {
    var client = http.Client();
    var url = Uri.parse(uri);
    var headers = authorize ? await authorizationHeaders() : await basisHeaders();

    http.Response response;
    var encodedBody = body != null ? json.encode(body) : null;

    switch (method.toUpperCase()) {
      case 'GET':
        response = await client.get(url, headers: headers);
        break;
      case 'POST':
        response = await client.post(url, headers: headers, body: encodedBody);
        break;
      case 'PATCH':
        response = await client.patch(url, headers: headers, body: encodedBody);
        break;
      case 'DELETE':
        response = await client.delete(url, headers: headers, body: body?.isEmpty ?? true ? null : encodedBody);
        break;
      default:
        throw Exception('Unsupported HTTP method: $method');
    }

    if (response.statusCode == 401 && authorize) {
      throw UnauthorizedException();
    }

    print(response.body);

    return response;
  }

  static Future<http.Response> sendGetRequest(String uri, { bool authorize = true }) async {
    return _sendRequest('GET', uri, authorize: authorize);
  }

  static Future<http.Response> sendPostRequest(String uri, bool authorize, Map<String, dynamic> body) async {
    return _sendRequest('POST', uri, body: body, authorize: authorize);
  }

  static Future<http.Response> sendPatchRequest(String uri, Map<String, dynamic> body, { bool authorize = true }) async {
    return _sendRequest('PATCH', uri, body: body, authorize: authorize);
  }

  static Future<http.Response> sendDeleteRequest(String uri, { Map<String, dynamic> body = const {}, bool authorize = true }) async {
    return _sendRequest('DELETE', uri, body: body, authorize: authorize);
  }
}

extension Ok on http.Response {
  bool get ok => (statusCode ~/100) == 2;
}
