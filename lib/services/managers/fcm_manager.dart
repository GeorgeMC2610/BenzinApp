import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/request_handler.dart';

class FCMManager {
  static String baseUrl = DataHolder.destination;

  Future<bool> isSubscribed({String? fcmToken}) async {
    final String url = "$baseUrl/is_subscribed?token=$fcmToken";
    final response = await RequestHandler.sendGetRequest(url);
    return response.ok;
  }

  Future<void> subscribe(String fcmToken) async {
    final String url = "$baseUrl/subscribe_notifications";
    await RequestHandler.sendPostRequest(url, true, {
      'token': fcmToken
    });
  }

  Future<void> unsubscribe(String fcmToken) async {
    final String url = "$baseUrl/unsubscribe_notifications";
    await RequestHandler.sendDeleteRequest(url, body: {
      'token': fcmToken
    });
  }
}