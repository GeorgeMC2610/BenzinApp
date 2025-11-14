import 'dart:convert';

import 'package:benzinapp/services/classes/car.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/managers/abstract_manager.dart';

import '../request_handler.dart';


class CarManager extends AbstractManager<Car> {

  static final CarManager _instance = CarManager._internal();
  factory CarManager() => _instance;
  CarManager._internal();

  Car? watchingCar;

  @override
  String get baseUrl => '${DataHolder.destination}/car';

  @override
  Car fromJson(Map<String, dynamic> json) => Car.fromJson(json);

  @override
  int getId(Car model) => model.id;

  @override
  String get responseKeyword => "car";

  Future<String?> claimCar(String username, String password) async {
    final response = await RequestHandler.sendPostRequest("$baseUrl/claim", true, {
      "username": username,
      "password": password,
    });
    final jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      final newModel = fromJson(jsonResponse[responseKeyword]);

      super.manualInsert(newModel);
      notifyListeners();
      return null;
    }
    else {
      return jsonResponse["message"];
    }
  }

  @override
  int compare(Car a, Car b) => b.username.compareTo(a.username);

  @override
  Map<String, dynamic> toJson(Car model) => model.toJson();
}