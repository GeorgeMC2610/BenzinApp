import 'dart:convert';

import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/views/details/fuel_fill_record.dart';
import 'package:benzinapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsService {
  // Private constructor for singleton pattern
  LocalNotificationsService._internal();

  //Singleton instance
  static final LocalNotificationsService _instance = LocalNotificationsService._internal();

  //Factory constructor to return singleton instance
  factory LocalNotificationsService.instance() => _instance;

  //Main plugin instance for handling notifications
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  //Android-specific initialization settings using app launcher icon
  final _androidInitializationSettings = const AndroidInitializationSettings('@mipmap/benzinapp_logo_round');

  //iOS-specific initialization settings with permission requests
  final _iosInitializationSettings = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  //Android notification channel configuration
  final _androidChannel = const AndroidNotificationChannel(
    'channel_id',
    'Channel name',
    description: 'Android push notification channel',
    importance: Importance.max,
  );

  //Flag to track initialization status
  bool _isFlutterLocalNotificationInitialized = false;

  //Counter for generating unique notification IDs
  int _notificationIdCounter = 0;

  /// Initializes the local notifications plugin for Android and iOS.
  Future<void> init() async {
    // Check if already initialized to prevent redundant setup
    if (_isFlutterLocalNotificationInitialized) {
      return;
    }

    // Create plugin instance
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Combine platform-specific settings
    final initializationSettings = InitializationSettings(
      android: _androidInitializationSettings,
      iOS: _iosInitializationSettings,
    );

    // Initialize plugin with settings and callback for notification taps
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
          // Handle notification tap in foreground / background
          print('Foreground notification has been tapped: ${response.payload}');
          if (response.payload == null) return;

          try {
            final Map<String, dynamic> payload = jsonDecode(response.payload!);

            // Navigating to a different screen when the "screen" arg is present.
            if (payload.containsKey("screen")) {
              switch (payload["screen"]) {
                case "fuel_fill_record_screen":
                  dynamic rawArgs = payload['screen_args'];
                  if (rawArgs is String) {
                    rawArgs = jsonDecode(rawArgs);
                  }
                  final Map<String, dynamic> screenArgs = Map<String, dynamic>.from(rawArgs as Map);
                  final FuelFillRecord newRecord = FuelFillRecord.fromJson(screenArgs);

                  // TODO: Find a better way to do this. Ideally pass the Car or CarID into the FFR model.
                  final carId = screenArgs['car_id'];
                  if (CarManager().local == null) {
                    await CarManager().index();
                  }
                  final car = CarManager().local?.firstWhere((c) => c.id == carId);
                  CarManager().watchingCar = car;

                  navigateNowOrLater(ViewFuelFillRecord(record: newRecord));
                  break;
                default:
                  break;
              }
            }
          } catch (e, stackTrace) {
            print("Error handling notification tap: $e");
            print(stackTrace);
          }
        });

    // Create Android notification channel
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    // Mark initialization as complete
    _isFlutterLocalNotificationInitialized = true;
  }

  void navigateNowOrLater(Widget nextScreen) {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (BuildContext context) => nextScreen,
        ),
      );
    }
    else {
      WidgetsBinding.instance.addPostFrameCallback((_) => navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (BuildContext context) => nextScreen,
        ),
      ));
    }
  }

  /// Show a local notification with the given title, body, and payload.
  Future<void> showNotification(
      String? title,
      String? body,
      String? payload,
      ) async {
    // Android-specific notification details
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.max,
      priority: Priority.high,
    );

    // iOS-specific notification details
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // Combine platform-specific details
    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Display the notification
    await _flutterLocalNotificationsPlugin.show(
      _notificationIdCounter++,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}