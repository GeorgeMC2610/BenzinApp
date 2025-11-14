import 'package:benzinapp/services/managers/user_manager.dart';

class CarUserInvitation {
  CarUserInvitation({
    required this.id,
    required this.recipientUsername,
    required this.senderUsername,
    required this.carId,
    required this.access,
    required this.isAccepted,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String recipientUsername;
  final String senderUsername;
  final int carId;
  int access;
  final bool isAccepted;
  final DateTime createdAt;
  final DateTime updatedAt;

  static CarUserInvitation fromJson(Map<String, dynamic> json) => CarUserInvitation(
    id: json[CarUserInvitationFields.id],
    recipientUsername: json[CarUserInvitationFields.recipientUsername],
    senderUsername: json[CarUserInvitationFields.senderUsername],
    carId: json[CarUserInvitationFields.carId],
    access: json[CarUserInvitationFields.access],
    isAccepted: json[CarUserInvitationFields.isAccepted],
    createdAt: DateTime.parse(json[CarUserInvitationFields.createdAt]),
    updatedAt: DateTime.parse(json[CarUserInvitationFields.updatedAt]),
  );

  Map<String, dynamic> toJson() => {
    "car_user_invitation": {
      CarUserInvitationFields.access: access,
      CarUserInvitationFields.recipientUsername: recipientUsername,
      CarUserInvitationFields.carId: carId,
    }
  };

  bool incoming() => recipientUsername == (UserManager().currentUser?.username ?? '');
  bool outgoing() => senderUsername == (UserManager().currentUser?.username ?? '');
}

class CarUserInvitationFields {
  static const String id = "id";
  static const String recipientUsername = "recipient_username";
  static const String senderUsername = "sender_username";
  static const String carId = "car_id";
  static const String access = "access";
  static const String isAccepted = "is_accepted";
  static const String createdAt = "created_at";
  static const String updatedAt = "updated_at";
}