import 'dart:convert';

import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/classes/malfunction.dart';
import 'package:benzinapp/services/classes/service.dart';
import 'package:benzinapp/services/request_handler.dart';
import 'package:flutter/material.dart';

import 'classes/car.dart';
import 'classes/trip.dart';

class DataHolder with ChangeNotifier {

  static final DataHolder _instance = DataHolder._internal();
  factory DataHolder() => _instance;
  DataHolder._internal();

  // TODO: Make these values not static, since this is a singleton.
  static List<FuelFillRecord>? _fuelFills;
  static List<Malfunction>? _malfunctions;
  static List<Service>? _services;
  static List<Trip>? _trips;
  static Car? _car;

  static const String destination = 'http://localhost:3000';

  Future<void> initializeValues() async {
    // assuming the token manager has been initialized and has a token value.

    var carUri = '$destination/car';
    var fuelFillsUri = '$destination/fuel_fill_record';
    var malfunctionsUri = '$destination/malfunction';
    var servicesUri = '$destination/service';
    var tripsUri = '$destination/repeated_trip';

    // send four separate requests to get all the possible data
    // once the requests are sent, the lists will no longer be null and can be
    // used inside the views.
    // if any of the lists are null for whatever reason, the views will turn
    // into loading screens.
    RequestHandler.sendGetRequest(
      carUri, () {},
      (response) {
        var jsonResponse = jsonDecode(response.body);

        _car = Car.fromJson(jsonResponse);
        notifyListeners();
      }
    );

    RequestHandler.sendGetRequest(fuelFillsUri, () {},
      (response) {
        var jsonResponse = jsonDecode(response.body);
        _fuelFills = [];

        for (var object in jsonResponse) {
          var fuelFill = FuelFillRecord.fromJson(object);
          _fuelFills!.add(fuelFill);
        }

        notifyListeners();
      }
    );

    RequestHandler.sendGetRequest(malfunctionsUri, () {},
      (response) {
        var jsonResponse = jsonDecode(response.body);
        _malfunctions = [];

        for (var object in jsonResponse) {
          var malfunction = Malfunction.fromJson(object);
          _malfunctions!.add(malfunction);
        }

        notifyListeners();
      }
    );

    RequestHandler.sendGetRequest(servicesUri, () {},
      (response) {
        var jsonResponse = jsonDecode(response.body);
        _services = [];

        for (var object in jsonResponse) {
          var service = Service.fromJson(object);
          _services!.add(service);
        }
        notifyListeners();
      }
    );

    RequestHandler.sendGetRequest(tripsUri, () {},
      (response) {
        var jsonResponse = jsonDecode(response.body);
        _trips = [];

        for (var object in jsonResponse) {
        var trip = Trip.fromJson(object);
        _trips!.add(trip);
        }
        notifyListeners();
      }
    );

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

  // FUEL FILLS
  static Future<void> refreshFuelFills() async {
    RequestHandler.sendGetRequest(
      '$destination/fuel_fill_record',
      () {},
      (response) {
        var jsonResponse = jsonDecode(response.body);
        _fuelFills = [];

        for (var object in jsonResponse) {
          var fuelFill = FuelFillRecord.fromJson(object);
          _fuelFills!.add(fuelFill);
        }

        _instance.notifyListeners();
      }
    );
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

  static void setFuelFill(FuelFillRecord modified) {
    var initial = _fuelFills!.firstWhere((element) => element.id == modified.id);
    var indexOfInitial = _fuelFills!.indexOf(initial);
    _fuelFills![indexOfInitial] = modified;
    _instance.notifyListeners();
  }

  static void deleteFuelFill(FuelFillRecord record) {
    _fuelFills!.remove(record);
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

  // MALFUNCTIONS
  static List<Malfunction>? getMalfunctions() {
    if (_malfunctions == null) {
      return null;
    }

    _malfunctions!.sort((a, b) => b.dateStarted.compareTo(a.dateStarted));
    return _malfunctions!;
  }

  static Future<void> refreshMalfunctions() async {
    RequestHandler.sendGetRequest(
        '$destination/malfunction',
            () {},
            (response) {
          var jsonResponse = jsonDecode(response.body);
          _malfunctions = [];

          for (var object in jsonResponse) {
            var malfunction = Malfunction.fromJson(object);
            _malfunctions!.add(malfunction);
          }

          _instance.notifyListeners();
        }
    );
  }

  static void addMalfunction(Malfunction malfunction) {
    _malfunctions!.add(malfunction);
    _instance.notifyListeners();
  }

  static void setMalfunction(Malfunction modified) {
    var initial = _malfunctions!.firstWhere((element) => element.id == modified.id);
    var indexOfInitial = _malfunctions!.indexOf(initial);
    _malfunctions![indexOfInitial] = modified;
    _instance.notifyListeners();
  }

  static void deleteMalfunction(Malfunction malfunction) {
    _malfunctions!.remove(malfunction);
    _instance.notifyListeners();
  }

  // SERVICES
  static List<Service>? getServices() {
    if (_services == null) {
      return null;
    }

    _services!.sort((a, b) => b.kilometersDone.compareTo(a.kilometersDone));
    return _services!;
  }

  static Future<void> refreshServices() async {
    RequestHandler.sendGetRequest(
        '$destination/service',
            () {},
            (response) {
          var jsonResponse = jsonDecode(response.body);
          _services = [];

          for (var object in jsonResponse) {
            var service = Service.fromJson(object);
            _services!.add(service);
          }

          _instance.notifyListeners();
        }
    );
  }

  static void addService(Service service) {
    _services!.add(service);
    _instance.notifyListeners();
  }

  static void setService(Service modified) {
    var initial = _services!.firstWhere((element) => element.id == modified.id);
    var indexOfInitial = _services!.indexOf(initial);
    _services![indexOfInitial] = modified;
    _instance.notifyListeners();
  }

  static void deleteService(Service service) {
    _services!.remove(service);
    _instance.notifyListeners();
  }

  // TRIPS
  static List<Trip>? getTrips() {
    if (_trips == null) {
      return null;
    }

    _services!.sort((a, b) => b.kilometersDone.compareTo(a.kilometersDone));
    return _trips!;
  }

  static Future<void> refreshTrips() async {
    RequestHandler.sendGetRequest(
        '$destination/repeated_trip',
            () {},
            (response) {
          var jsonResponse = jsonDecode(response.body);
          _trips = [];

          for (var object in jsonResponse) {
            var trip = Trip.fromJson(object);
            _trips!.add(trip);
          }

          _instance.notifyListeners();
        }
    );
  }

  static void addTrip(Trip trip) {
    _trips!.add(trip);
    _instance.notifyListeners();
  }

  static void setTrip(Trip trip) {
    var initial = _trips!.firstWhere((element) => element.id == trip.id);
    var indexOfInitial = _trips!.indexOf(initial);
    _trips![indexOfInitial] = trip;
    _instance.notifyListeners();
  }

  static void deleteTrip(Trip trip) {
    _trips!.remove(trip);
    _instance.notifyListeners();
  }

  // GENERAL STATS
  // TODO: Add calendar filters to them
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