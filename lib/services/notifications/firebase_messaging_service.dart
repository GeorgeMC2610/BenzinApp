import 'dart:convert';
import 'package:benzinapp/main.dart';
import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/classes/malfunction.dart';
import 'package:benzinapp/services/classes/service.dart';
import 'package:benzinapp/services/classes/trip.dart';
import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/views/details/fuel_fill_record.dart';
import 'package:benzinapp/views/details/malfunction.dart';
import 'package:benzinapp/views/details/service.dart';
import 'package:benzinapp/views/details/trip.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'local_notifications_service.dart';

class FirebaseMessagingService {
  // Private constructor for singleton pattern
  FirebaseMessagingService._internal();

  // Singleton instance
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();

  // Factory constructor to provide singleton instance
  factory FirebaseMessagingService.instance() => _instance;

  Map<String, dynamic>? pendingNotificationPayload;

  // Reference to local notifications service for displaying notifications
  LocalNotificationsService? _localNotificationsService;

  /// Initialize Firebase Messaging and sets up all message listeners
  Future<void> init({required LocalNotificationsService localNotificationsService}) async {
    // Init local notifications service
    _localNotificationsService = localNotificationsService;

    // Handle FCM token
    _handlePushNotificationsToken();

    // Request user permission for notifications
    requestPermission();

    // Register handler for background messages (app terminated)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listen for messages when the app is in foreground
    FirebaseMessaging.onMessage.listen(_onMessageReceived);

    // Listen for notification taps when the app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Check for initial message that opened the app from terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      pendingNotificationPayload = initialMessage.data;
    }
  }

  /// Retrieves and manages the FCM token for push notifications
  Future<void> _handlePushNotificationsToken() async {
    // Get the FCM token for the device
    final token = await FirebaseMessaging.instance.getToken();
    print('Push notifications token: $token');

    // Listen for token refresh events
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      print('FCM token refreshed: $fcmToken');
      // TODO: optionally send token to your server for targeting this device
    }).onError((error) {
      // Handle errors during token refresh
      print('Error refreshing FCM token: $error');
    });
  }

  /// Requests notification permission from the user
  Future<void> requestPermission() async {
    // Request permission for alerts, badges, and sounds
    final result = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Log the user's permission decision
    print('User granted permission: ${result.authorizationStatus}');
  }

  /// Centralized message handler
  void _onMessageReceived(RemoteMessage message) {
    print('Message received data: ${message.data}');
    
    String? title;
    String? body;

    // 1. Check if the message is using your translatable structure in the data payload
    if (message.data.containsKey('title_key')) {
      title = translate(message.data['title_key'], args: _parseArgs(message.data['title_args']));
    } 
    
    if (message.data.containsKey('body_key')) {
      body = translate(message.data['body_key'], args: _parseArgs(message.data['body_args']));
    }

    // 2. Fallback to standard notification if keys weren't found
    title ??= message.notification?.title;
    body ??= message.notification?.body;

    if (title != null || body != null) {
      // Show notification. We pass the whole data map as a payload for navigation on tap.
      _localNotificationsService?.showNotification(
          title, body, jsonEncode(message.data));
    }
  }

  /// Handles notification taps
  void _onMessageOpenedApp(RemoteMessage message) {
    print('Notification caused the app to open: ${message.data.toString()}');
    handleNavigation(message.data);
  }

  /// Logic to navigate based on message data
  Future<void> handleNavigation(Map<String, dynamic> data) async {
    print('Navigating with data: $data');
    try {
      if (data.containsKey('screen_args')) {
        dynamic rawArgs = data['screen_args'];
        if (rawArgs is String) {
          rawArgs = jsonDecode(rawArgs);
        }
        final Map<String, dynamic> screenArgs = Map<String, dynamic>.from(rawArgs as Map);
        final carId = screenArgs['car_id'];
        if (CarManager().local == null) {
          await CarManager().index();
        }
        final car = CarManager().local?.firstWhere((c) => c.id == carId);
        CarManager().watchingCar = car;

        // Navigating to a different screen when the "screen" arg is present.
        if (data.containsKey("screen")) {
          switch (data["screen"]) {
            case "fuel_fill_record_screen":
              final FuelFillRecord newRecord = FuelFillRecord.fromJson(screenArgs);
              navigateNowOrLater(ViewFuelFillRecord(record: newRecord));
              break;
            case "malfunction_screen":
              final Malfunction newRecord = Malfunction.fromJson(screenArgs);
              navigateNowOrLater(ViewMalfunction(malfunction: newRecord));
              break;
            case "service_screen":
              final Service newRecord = Service.fromJson(screenArgs);
              navigateNowOrLater(ViewService(service: newRecord));
              break;
            case "repeated_trip_screen":
              final Trip newRecord = Trip.fromJson(screenArgs);
              navigateNowOrLater(ViewTrip(trip: newRecord));
              break;
            default:
              break;
          }
        }
      }
    } catch (e, stackTrace) {
      print("Error handling notification tap in FirebaseMessagingService: $e");
      print(stackTrace);
    }
  }

  void navigateNowOrLater(Widget nextScreen) {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (BuildContext context) => nextScreen,
        ),
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (BuildContext context) => nextScreen,
        ),
      ));
    }
  }

  Map<String, dynamic>? _parseArgs(dynamic args) {
    if (args == null) return null;
    if (args is Map<String, dynamic>) return args;
    try {
      return jsonDecode(args as String) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
}

/// Background message handler (must be top-level function or static)
/// Handles messages when the app is fully terminated
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message received: ${message.data.toString()}');
}
