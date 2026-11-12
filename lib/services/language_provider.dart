import 'package:benzinapp/i18n/strings.g.dart';
import 'package:benzinapp/services/managers/fcm_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en', 'US');

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadLocale();
  }

  /// Applies the saved language to the translations. Called before the app
  /// starts, so the first frame is already in the right language.
  static Future<void> restoreSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await LocaleSettings.setLocaleRaw(prefs.getString('language_code') ?? 'en');
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }

  void changeLocale(Locale newLocale) async {
    _currentLocale = newLocale;
    await LocaleSettings.setLocaleRaw(newLocale.languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', newLocale.languageCode);
    notifyListeners();

    if (FCMManager().receivePushNotifications) {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await FCMManager().subscribe(token, locale: newLocale.languageCode);
      }
    }
  }
}
