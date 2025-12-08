import 'dart:convert';

import 'package:benzinapp/services/classes/user.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/managers/token_manager.dart';
import 'package:benzinapp/services/request_handler.dart';
import 'package:flutter/material.dart';

class UserManager with ChangeNotifier {

  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;
  UserManager._internal();

  User? currentUser;

  void setCurrentUser(User user) {
    currentUser = user;
  }

  Future<void> destroyValues() async {
    currentUser = null;
    notifyListeners();
  }

  Future<void> getCurrentUser() async {
    // prepare the send data
    const url = '${DataHolder.destination}/users';

    final response = await RequestHandler.sendGetRequest(url);
    final jsonResponse = jsonDecode(response.body)['user'];

    currentUser = User.fromJson(jsonResponse);
    notifyListeners();
  }

  Future<UserPayloadStatus> sendResetPasswordToken(String email) async {
    // prepare the sending data
    const url = '${DataHolder.destination}/password';
    final body = { 'email': email };

    // send the data
    final response = await RequestHandler.sendPostRequest(url, false, body);

    switch (response.statusCode) {
      case 204:
        return UserPayloadStatus.resetTokenSent;
      default:
        return UserPayloadStatus.undefined;
    }
  }

  Future<UserPayloadStatus> resetPassword(String email, String otp, String password, String passwordConfirm) async {
    // prepare the sending data
    const url = '${DataHolder.destination}/password';
    final body = {
      'email': email,
      'code': otp,
      'password': password,
      'password_confirmation': password,
    };

    // send the data
    final response = await RequestHandler.sendPatchRequest(url, body, authorize: false);

    switch (response.statusCode) {
      case 200:
        return UserPayloadStatus.passwordResetOk;
      case 422:
        return UserPayloadStatus.resetTokenWrong;
      default:
        return UserPayloadStatus.undefined;
    }
  }

  Future<UserPayloadStatus> resendConfirmationToken() async {
    // initialize the url
    const url = '${DataHolder.destination}/confirmation';

    // send the data
    final response = await RequestHandler.sendPostRequest(url, true, {});

    switch (response.statusCode) {
      case 200:
        return UserPayloadStatus.confirmTokenSent;
      case 422:
        // make a call to user data, so it's updated.
        return UserPayloadStatus.confirmedAlready;
      case 403:
        return UserPayloadStatus.confirmTokenEarly;
      default:
        return UserPayloadStatus.undefined;
    }
  }

  Future<UserPayloadStatus> confirmUser(String otp) async {
    // initialize the url
    const url = '${DataHolder.destination}/users/confirmation';
    final body = {
      'code': otp,
    };

    // send the data
    final response = await RequestHandler.sendPatchRequest(url, body);

    switch (response.statusCode) {
      case 200:
      case 422:
      // store when the user was confirmed.
        return UserPayloadStatus.confirmedOk;
      case 403:
        return UserPayloadStatus.confirmTokenWrong;
      default:
        return UserPayloadStatus.undefined;
    }
  }

  Future<DateTime?> getConfirmationDateSent() async {
    // initialize the url
    const url = '${DataHolder.destination}/users/confirmation';

    // send the data
    final response = await RequestHandler.sendGetRequest(url);
    final jsonResponse = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
        return DateTime.tryParse(jsonResponse['date'] ?? '');
      case 404:
        return null;
    }

    return null;
  }

  Future<bool> deleteAccount(String username, String password) async {
    const url = '${DataHolder.destination}/users';
    final body = {
      'username': username,
      'password': password,
    };

    final response = await RequestHandler.sendDeleteRequest(url, body: body);

    if (response.ok) {
      TokenManager().removeToken();
      DataHolder().destroyValues();
      return true;
    }

    return false;
  }

}

enum UserPayloadStatus {
  passwordResetOk,
  resetTokenSent,
  resetTokenEarly,
  resetTokenEmailNotFound,
  resetTokenWrong,
  resetTokenCurrentPassword,

  confirmTokenSent,
  confirmTokenEarly,
  confirmTokenWrong,
  confirmedAlready,
  confirmedOk,

  undefined
}