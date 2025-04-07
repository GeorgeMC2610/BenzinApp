import 'package:BenzinApp/services/token_manager.dart';
import 'package:http/http.dart' as http;

class RequestHandler {

  static Future<void> sendGetRequest(String uri, Function() whenComplete, Function(http.Response response) onResponse) async {
    var client = http.Client();
    var url = Uri.parse(uri);
    var headers = {
      'Authorization': TokenManager().token!
    };

    client.get(
      url,
      headers: headers,
    ).whenComplete(whenComplete).then(onResponse);
  }

  static Future<void> sendPostRequest(String uri, bool authorize, Map<String, dynamic> body, Function() whenComplete, Function(http.Response response) onResponse) async {
    var client = http.Client();
    var url = Uri.parse(uri);
    var headers = authorize ? {
      'Authorization': TokenManager().token!
    } : null;

    client.post(
      url,
      headers: headers,
      body: body
    ).whenComplete(whenComplete).then(onResponse);
  }

  static Future<void> sendPatchRequest(String uri, Map<String, dynamic> body, Function() whenComplete, Function(http.Response response) onResponse) async {
    var client = http.Client();
    var url = Uri.parse(uri);
    var headers = {
      'Authorization': TokenManager().token!
    };

    client.patch(
        url,
        headers: headers,
        body: body
    ).whenComplete(whenComplete).then(onResponse);
  }

  static Future<void> sendDeleteRequest(String uri, Function() whenComplete, Function(http.Response response) onResponse) async {
    var client = http.Client();
    var url = Uri.parse(uri);
    var headers = {
      'Authorization': TokenManager().token!
    };

    client.delete(
        url,
        headers: headers,
    ).whenComplete(whenComplete).then(onResponse);
  }
}