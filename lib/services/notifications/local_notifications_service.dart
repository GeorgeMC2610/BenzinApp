import 'package:benzinapp/services/notifications/notification_handler.dart';
import 'package:benzinapp/views/shared/notification.dart';

class LocalNotificationsService {
  // Private constructor for singleton pattern
  LocalNotificationsService._internal();

  // Singleton instance
  static final LocalNotificationsService _instance = LocalNotificationsService._internal();

  // Factory constructor to return singleton instance
  factory LocalNotificationsService.instance() => _instance;

  /// Initializes the local notifications service.
  Future<void> init() async {
    // Initialization setup
  }

  /// Shows an overlay notification using the SnackbarNotification wrapper with only the title,
  /// and creates/inserts the record locally from the payload.
  Future<void> showNotification(
    String? title,
    String? body,
    String? payload,
  ) async {
    if (payload != null) {
      await NotificationHandler.processRecord(payload);
    }

    if (title != null && title.isNotEmpty) {
      SnackbarNotification.show(MessageType.info, title);
    }
  }
}
