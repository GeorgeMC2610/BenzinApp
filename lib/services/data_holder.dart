import 'dart:convert';

import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/classes/malfunction.dart';
import 'package:benzinapp/services/classes/service.dart';
import 'package:benzinapp/services/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'classes/car.dart';

class DataHolder with ChangeNotifier {

  static final DataHolder _instance = DataHolder._internal();
  factory DataHolder() => _instance;
  DataHolder._internal();

  // TODO: Make these values not static, since this is a singleton.
  static List<FuelFillRecord>? _fuelFills;
  static List<Malfunction>? _malfunctions;
  static List<Service>? _services;
  static Car? _car;

  static const String destination = 'http://localhost:3000';

  Future<void> initializeValues() async {
    // assuming the token manager has been initialized and has a token value.
    var client = http.Client();

    var carUri = Uri.parse('$destination/car');
    var fuelFillsUri = Uri.parse('$destination/fuel_fill_record');
    var malfunctionsUri = Uri.parse('$destination/malfunction');
    var servicesUri = Uri.parse('$destination/service');
    // var tripsUri = Uri.parse('${destination}/repeated_trip');

    Map<String, String> authHeaders = {
      'Authorization': 'Bearer ${TokenManager().token}'
    };

    // send four separate requests to get all the possible data
    // once the requests are sent, the lists will no longer be null and can be
    // used inside the views.
    // if any of the lists are null for whatever reason, the views will turn
    // into loading screens.
    client.get(
      carUri, headers: authHeaders
    ).then((response) {
      var jsonResponse = jsonDecode(response.body);

      _car = Car(
        id: jsonResponse["id"],
        username: jsonResponse["username"],
        manufacturer: jsonResponse["manufacturer"],
        model: jsonResponse["model"],
        year: jsonResponse["year"]
      );
      notifyListeners();
    });

    client.get(
      fuelFillsUri, headers: authHeaders
    ).then((response) {
      var jsonResponse = jsonDecode(response.body);
      _fuelFills = [];

      for (var object in jsonResponse) {
        var fuelFill = FuelFillRecord.fromJson(object);
        _fuelFills!.add(fuelFill);
      }

      notifyListeners();
    });

    client.get(
        malfunctionsUri, headers: authHeaders
    ).then((response) {
      var jsonResponse = jsonDecode(response.body);
      _malfunctions = [];

      for (var object in jsonResponse) {
        var malfunction = Malfunction(
            id: object["id"],
            dateStarted: DateTime.parse(object["started"]),
            dateEnded: object["ended"] == null ? null : DateTime.parse(object["ended"]),
            title: object["title"],
            description: object["description"],
            cost: object["cost_eur"],
            kilometersDiscovered: object["at_km"],
            location: object["location"],
        );

        _malfunctions!.add(malfunction);
      }

      notifyListeners();
    });

    client.get(
        servicesUri, headers: authHeaders
    ).then((response) {
      var jsonResponse = jsonDecode(response.body);
      _services = [];

      for (var object in jsonResponse) {
        var service = Service(
          id: object["id"],
          dateHappened: DateTime.parse(object["date_happened"]),
          description: object["description"],
          cost: object["cost_eur"],
          kilometersDone: object["at_km"],
          nextServiceKilometers: object["next_km"],
          location: object["location"],
        );

        _services!.add(service);
      }
      notifyListeners();
    });

    // TODO: Complete the trip shenanigans.
    // client.get(
    //     tripsUri, headers: authHeaders
    // );

  }

  void destroyValues() async {
    _fuelFills = null;
    _malfunctions = null;
    _services = null;
    _car = null;
  }

  static Car? getCar() {
    return _car;
  }

  static Future<void> refreshFuelFills() async {
    var client = http.Client();
    var fuelFillsUri = Uri.parse('$destination/fuel_fill_record');
    client.get(
      fuelFillsUri,
      headers: {
        'Authorization': '${TokenManager().token}'
      }
    ).then((response) {
      var jsonResponse = jsonDecode(response.body);
      _fuelFills = [];

      for (var object in jsonResponse) {
        var fuelFill = FuelFillRecord.fromJson(object);
        _fuelFills!.add(fuelFill);
      }

      _instance.notifyListeners();
    });
  }

  static List<FuelFillRecord>? getFuelFillRecords() {
    if (_fuelFills == null) {
      return null;
    }

    _fuelFills!.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return _fuelFills;
  }

  static void addFuelFill(FuelFillRecord record) {
    _fuelFills!.add(record);
    _instance.notifyListeners();
  }

  static Map<String, List<FuelFillRecord>> getYearMonthFuelFills() {
    Map<String, List<FuelFillRecord>> groupedRecords = {};

    for (var record in getFuelFillRecords()!) {
      String key = "${record.dateTime.year}-${record.dateTime.month.toString()
          .padLeft(2, '0')}";

      if (!groupedRecords.containsKey(key)) {
        groupedRecords[key] = [];
      }

      groupedRecords[key]!.add(record);
    }

    return groupedRecords;
  }

  static List<Malfunction>? getMalfunctions() {
    if (_malfunctions == null) {
      return null;
    }

    _malfunctions!.sort((a, b) => b.id.compareTo(a.id));
    return _malfunctions!;
  }

  static List<Service>? getServices() {
    if (_services == null) {
      return null;
    }

    _services!.sort((a, b) => b.kilometersDone.compareTo(a.kilometersDone));
    return _services!;
  }

  static double getTotalConsumption() {
    double totalKilometers = _fuelFills!.fold(0, (sum, fuelFill) => sum + fuelFill.kilometers);
    double totalLiters = _fuelFills!.fold(0, (sum, fuelFill) => sum + fuelFill.liters);

    return 100 * totalLiters / totalKilometers;
  }

  static double getTotalEfficiency() {
    double totalKilometers = _fuelFills!.fold(0, (sum, fuelFill) => sum + fuelFill.kilometers);
    double totalLiters = _fuelFills!.fold(0, (sum, fuelFill) => sum + fuelFill.liters);

    return totalKilometers / totalLiters;
  }

  static double getTotalTravelCost() {
    double totalCost = _fuelFills!.fold(0, (sum, fuelFill) => sum + fuelFill.cost);
    double totalKilometers = _fuelFills!.fold(0, (sum, fuelFill) => sum + fuelFill.kilometers);

    return totalCost / totalKilometers;
  }


  static void addMalfunction(Malfunction malfunction) {
    _malfunctions!.add(malfunction);
    _instance.notifyListeners();
  }

  static void addService(Service service) {
    _services!.add(service);
    _instance.notifyListeners();
  }

  static void deleteFuelFill(FuelFillRecord record) {
    _fuelFills!.remove(record);
    _instance.notifyListeners();
  }

  static void deleteMalfunction(Malfunction malfunction) {
    _malfunctions!.remove(malfunction);
    _instance.notifyListeners();
  }

  static void deleteService(Service service) {
    _services!.remove(service);
    _instance.notifyListeners();
  }

  static void setFuelFill(FuelFillRecord modified) {
    var initial = _fuelFills!.firstWhere((element) => element.id == modified.id);
    var indexOfInitial = _fuelFills!.indexOf(initial);
    _fuelFills![indexOfInitial] = modified;
    _instance.notifyListeners();
  }

  static double getTotalLitersFilled() {
    return _fuelFills!.fold(0, (sum, fuelFill) => sum + fuelFill.liters);
  }

  static double getTotalKilometersTraveled() {
    return _fuelFills!.fold(0, (sum, fuelFill) => sum + fuelFill.kilometers);
  }

  static double getTotalFuelFillCosts() {
    return DataHolder.getFuelFillRecords()!.fold<double>(0, (sum, record) => sum + record.cost);
  }

  static double getTotalMalfunctionCosts() {
    return DataHolder.getMalfunctions()!.fold<double>(0, (sum, malfunction) => sum + (malfunction.cost ?? 0));
  }

  static double getTotalServiceCosts() {
    return DataHolder.getServices()!.fold<double>(0, (sum, service) => sum + (service.cost ?? 0));
  }

  static double getTotalCost() {
    double totalCosts = 0;

    totalCosts += _fuelFills!.fold<double>(0, (sum, fuelFill) => sum + fuelFill.cost);
    totalCosts += _services!.fold<double>(0, (sum, service) => sum + (service.cost ?? 0));
    totalCosts += _malfunctions!.fold<double>(0, (sum, malfunction) => sum + (malfunction.cost ?? 0));

    return totalCosts;
  }

}