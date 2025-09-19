import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class SnackbarNotification {
  static void show(MessageType type, String message) {
    showOverlayNotification(
    (context) => SafeArea(
    child: Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: getColor[type],
      child: ListTile(
        leading: getIcon[type],
        title: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ),
  ),
        duration: const Duration(seconds: 3),
    );
  }

  static Map<MessageType, Icon> getIcon = {
    MessageType.success: const Icon(Icons.check, color: Colors.white),
    MessageType.info: const Icon(Icons.info_outline, color: Colors.white),
    MessageType.alert: const Icon(Icons.warning_amber_outlined, color: Colors.white),
    MessageType.danger: const Icon(Icons.cancel_outlined, color: Colors.white),
  };

  static Map<MessageType, Color> getColor = {
    MessageType.success: Colors.green.shade900,
    MessageType.info: Colors.blueAccent,
    MessageType.alert: Colors.amber.shade800,
    MessageType.danger: Colors.red,
  };
}

enum MessageType {
  success,
  info,
  alert,
  danger,
}