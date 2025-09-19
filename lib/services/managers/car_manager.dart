import 'dart:convert';

import 'package:benzinapp/services/classes/car.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/managers/session_manager.dart';
import 'package:benzinapp/services/request_handler.dart';
import 'package:flutter/material.dart';

class CarManager with ChangeNotifier {

  static final CarManager _instance = CarManager._internal();
  factory CarManager() => _instance;
  CarManager._internal();

  Car? car;

  final uri = '${DataHolder.destination}/car';

  Future<void> get({bool forceBackend = false}) async {
    if (car != null && !forceBackend) {
      return;
    }

    final response = await RequestHandler.sendGetRequest(uri);
    if (response.statusCode != 200) {
      throw UnauthorizedException();
    }

    var jsonResponse = jsonDecode(response.body);

    car = Car.fromJson(jsonResponse);
  }

  Future<void> update(Car modified) async {
    final response = await RequestHandler.sendPatchRequest(uri, car!.toJson());
    final jsonResponse = json.decode(response.body);
    final updated = Car.fromJson(jsonResponse);

    car = updated;
    notifyListeners();
  }
}