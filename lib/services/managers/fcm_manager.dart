import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/request_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../notifications/firebase_messaging_service.dart';

class FCMManager with ChangeNotifier {
  static final FCMManager _instance = FCMManager._internal();
  factory FCMManager() => _instance;
  FCMManager._internal() {
    loadSettings();
  }

  static String baseUrl = DataHolder.destination;

  bool _receiveEmailNotifications = false;
  bool _receivePushNotifications = false;

  bool get receiveEmailNotifications => _receiveEmailNotifications;
  bool get receivePushNotifications => _receivePushNotifications;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _receiveEmailNotifications = prefs.getBool('receiveEmailNotifications') ?? false;
    _receivePushNotifications = prefs.getBool('receivePushNotifications') ?? false;
    notifyListeners();
  }

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

  Future<void> toggleEmailNotifications(bool value) async {
    _receiveEmailNotifications = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('receiveEmailNotifications', value);

    // TODO: Implement remote email notification subscription if endpoint exists
  }

  Future<void> togglePushNotifications(bool value) async {
    _receivePushNotifications = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('receivePushNotifications', value);

    if (value) {
      await FirebaseMessagingService.instance().requestPermission();
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await subscribe(token);
      }
    } else {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await unsubscribe(token);
      }
    }
  }
}
