import 'package:benzinapp/services/classes/user.dart';
import 'package:flutter/material.dart';

class UserManager with ChangeNotifier {

  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;
  UserManager._internal();

  User? currentUser;

}