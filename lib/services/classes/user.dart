class User {

  User({
    required this.email,
    required this.username,
    required this.createdAt,
    required this.updatedAt,
    this.confirmedAt
  });

  final String email;
  String username;
  final DateTime createdAt;
  DateTime updatedAt;
  DateTime? confirmedAt;

  bool isConfirmed() => confirmedAt != null;

  static User fromJson(Map<String, dynamic> object) => User(
    email: object[UserFields.email],
    username: object[UserFields.username],
    createdAt: DateTime.parse(object[UserFields.createdAt]),
    updatedAt: DateTime.parse(object[UserFields.updatedAt]),
    confirmedAt: DateTime.tryParse(object[UserFields.confirmedAt] ?? ''),
  );

  Map<String, dynamic> toJson() => {
    UserFields.email: email,
    UserFields.username: username,
    UserFields.createdAt: createdAt,
    UserFields.updatedAt: updatedAt,
    UserFields.confirmedAt: confirmedAt,
  };
}

class UserFields {
  static const String username = "username";
  static const String email = "email";
  static const String createdAt = "created_at";
  static const String updatedAt = "updated_at";
  static const String confirmedAt = "confirmed_at";
}