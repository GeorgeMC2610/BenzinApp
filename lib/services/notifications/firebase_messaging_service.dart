import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'local_notifications_service.dart';

class FirebaseMessagingService {
  // Private constructor for singleton pattern
  FirebaseMessagingService._internal();

  // Singleton instance
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();

  // Factory constructor to provide singleton instance
  factory FirebaseMessagingService.instance() => _instance;

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
      _onMessageOpenedApp(initialMessage);
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
    _handleNavigation(message.data);
  }

  /// Logic to navigate based on message data
  void _handleNavigation(Map<String, dynamic> data) {
    print('Navigating with data: $data');
    final screen = data['screen'];
    
    if (screen == 'invitation_screen') {
      // final invitationId = data['invitation_id'];
      // TODO: Navigate using your Navigator or global key
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
