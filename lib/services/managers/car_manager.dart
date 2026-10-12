import 'dart:convert';

import 'package:benzinapp/services/classes/car.dart';
import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/classes/malfunction.dart';
import 'package:benzinapp/services/classes/service.dart';
import 'package:benzinapp/services/classes/trip.dart';
import 'package:benzinapp/services/managers/abstract_manager.dart';
import 'package:benzinapp/services/managers/car_user_invitation_manager.dart';
import 'package:benzinapp/services/managers/fuel_fill_record_manager.dart';
import 'package:benzinapp/services/managers/malfunction_manager.dart';
import 'package:benzinapp/services/managers/service_manager.dart';
import 'package:benzinapp/services/managers/trip_manager.dart';

import '../data_holder.dart';
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

  @override
  Future<void> delete(Car model, { Map<String, dynamic> body = const {} }) async {
    if (!body.containsKey('username')) return;
    if (body["username"] != model.username) return;
    super.delete(model, body: { responseKeyword: body });
  }

  Future<void> getData(int id) async {
    final response = await RequestHandler.sendGetRequest("$baseUrl/$id");

    if (response.ok) {
      final jsonResponse = json.decode(response.body);

      final car = fromJson(jsonResponse[responseKeyword]);
      watchingCar = car;

      final ffrs = (jsonResponse['fuel_fill_records'] as List<dynamic>? ?? [])
          .map((e) => FuelFillRecord.fromJson(e as Map<String, dynamic>))
          .toList();

      final mlf = (jsonResponse['malfunctions'] as List<dynamic>? ?? [])
          .map((e) => Malfunction.fromJson(e as Map<String, dynamic>))
          .toList();

      final srv = (jsonResponse['services'] as List<dynamic>? ?? [])
          .map((e) => Service.fromJson(e as Map<String, dynamic>))
          .toList();

      final rpt = (jsonResponse['repeated_trips'] as List<dynamic>? ?? [])
          .map((e) => Trip.fromJson(e as Map<String, dynamic>))
          .toList();

      FuelFillRecordManager().setLocal(ffrs.toList());
      MalfunctionManager().setLocal(mlf.toList());
      ServiceManager().setLocal(srv.toList());
      TripManager().setLocal(rpt.toList());

      notifyListeners();
    }
    else {

    }
  }

  Future<void> transferOwnership(Car car, String username, String carUsername) async {
    final response = await RequestHandler.sendPatchRequest("$baseUrl/${car.id}/transfer_ownership", {
      "username": username,
      "car_username": carUsername
    });

    if (response.ok) {
      await index();
      await CarUserInvitationManager().index();
    }
    else {
      final jsonResponse = json.decode(response.body);
      setErrors(jsonResponse);
      notifyListeners();
    }
  }

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
  void destroyValues() {
    super.destroyValues();
    watchingCar = null;
  }

  @override
  int compare(Car a, Car b) => b.username.compareTo(a.username);

  @override
  Map<String, dynamic> toJson(Car model) => model.toJson();
}
