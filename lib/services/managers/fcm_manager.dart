import 'package:benzinapp/views/shared/notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class FCMManager {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    // 1. Request Permission (Crucial for iOS)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // 2. Get Token
      String? token = await _fcm.getToken();
      if (token != null) {
        await _sendTokenToBackend(token);
      }

      // 3. Listen for Token Refresh
      _fcm.onTokenRefresh.listen(_sendTokenToBackend);
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    // TODO: Replace with your actual backend call logic
    // Usually, you'd send this along with the User ID/Auth header
    SnackbarNotification.show(MessageType.info, token);
    print("FCM Token: $token");
    // Example:
    // await http.post(Uri.parse('https://your-api.com/user/fcm-token'),
    //    body: {'token': token});
  }
}