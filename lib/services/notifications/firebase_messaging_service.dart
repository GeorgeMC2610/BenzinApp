import 'dart:convert';
import 'package:benzinapp/services/managers/fcm_manager.dart';
import 'package:benzinapp/services/notifications/notification_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      print('FCM token refreshed: $fcmToken');
      if (FCMManager().receivePushNotifications) {
        await FCMManager().subscribe(fcmToken);
      }
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

    // Create/insert record locally immediately when notification is received
    NotificationHandler.processRecord(message.data);

    final (title, body) = NotificationHandler.resolveTitleAndBody(
      data: message.data,
      fallbackTitle: message.notification?.title,
      fallbackBody: message.notification?.body,
    );

    if (title != null || body != null) {
      // Show notification. We pass the whole data map as a payload for navigation on tap.
      _localNotificationsService?.showNotification(
        title,
        body,
        jsonEncode(message.data),
      );
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
    await NotificationHandler.handlePayload(data);
  }
}

/// Background message handler (must be top-level function or static)
/// Handles messages when the app is fully terminated
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message received: ${message.data.toString()}');
}
