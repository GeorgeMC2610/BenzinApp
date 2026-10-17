import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/request_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../notifications/firebase_messaging_service.dart';

class FCMManager with ChangeNotifier {
  static final FCMManager _instance = FCMManager._internal();
  factory FCMManager() => _instance;
  FCMManager._internal() {
    loadSettings();
  }

  static String baseUrl = DataHolder.destination;

  bool _receiveEmailNotifications = true;
  bool _receivePushNotifications = false;

  bool get receiveEmailNotifications => _receiveEmailNotifications;
  bool get receivePushNotifications => _receivePushNotifications;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _receiveEmailNotifications = prefs.getBool('receiveEmailNotifications') ?? true;
    _receivePushNotifications = prefs.getBool('receivePushNotifications') ?? false;
    notifyListeners();
  }

  /// Pulls the real subscription state from the server and overwrites the
  /// locally cached switches, so the settings screen reflects the truth even
  /// after a reinstall, a login on another device, or a failed toggle request.
  Future<void> syncWithServer() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      final results = await Future.wait([
        isSubscribedEmail(),
        token != null ? isSubscribed(fcmToken: token) : Future.value(false),
      ]);

      _receiveEmailNotifications = results[0];
      _receivePushNotifications = results[1];
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('receiveEmailNotifications', _receiveEmailNotifications);
      await prefs.setBool('receivePushNotifications', _receivePushNotifications);
    } catch (e) {
      // keep the cached values if the server can't be reached.
      print('Could not sync notification settings: $e');
    }
  }

  Future<bool> isSubscribedEmail() async {
    final String url = "$baseUrl/is_subscribed_email";
    final response = await RequestHandler.sendGetRequest(url);
    return _parseSubscription(response);
  }

  Future<void> subscribeEmail() async {
    final String url = "$baseUrl/subscribe_email";
    await RequestHandler.sendPostRequest(url, true, {});
  }

  Future<void> unsubscribeEmail() async {
    final String url = "$baseUrl/unsubscribe_email";
    await RequestHandler.sendDeleteRequest(url);
  }

  Future<bool> isSubscribed({String? fcmToken}) async {
    final String url = "$baseUrl/is_subscribed_notifications?token=$fcmToken";
    final response = await RequestHandler.sendGetRequest(url);
    return _parseSubscription(response);
  }

  // 200 means subscribed, 404 means not subscribed. anything else means the
  // answer is unknown, so throw instead of guessing.
  bool _parseSubscription(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return true;
      case 404:
        return false;
      default:
        throw Exception('Unexpected subscription status: ${response.statusCode}');
    }
  }

  /// Detaches this device from the current account before logging out, so the
  /// account stops receiving push notifications here, and resets the cached
  /// switches so they don't carry over to the next account.
  Future<void> unsubscribeDevice() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await unsubscribe(token);
      }
    } catch (e) {
      print('Could not unsubscribe device: $e');
    }

    _receiveEmailNotifications = true;
    _receivePushNotifications = false;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('receiveEmailNotifications');
    await prefs.remove('receivePushNotifications');
  }

  Future<void> subscribe(String fcmToken, {String? locale}) async {
    final prefs = await SharedPreferences.getInstance();
    final String localeCode = locale ?? prefs.getString('language_code') ?? 'en';
    final String url = "$baseUrl/subscribe_notifications";
    await RequestHandler.sendPostRequest(url, true, {
      'token': fcmToken,
      'locale': localeCode,
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

    if (value) {
      await subscribeEmail();
    } else {
      await unsubscribeEmail();
    }
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
