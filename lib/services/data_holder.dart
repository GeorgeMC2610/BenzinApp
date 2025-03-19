import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/classes/malfunction.dart';
import 'package:benzinapp/services/classes/service.dart';
import 'package:benzinapp/services/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DataHolder with ChangeNotifier {

  static final DataHolder _instance = DataHolder._internal();
  factory DataHolder() => _instance;
  DataHolder._internal();

  static List<FuelFillRecord> _fuelFills = [];
  static List<Malfunction> _malfunctions = [];
  static List<Service> _services = [];
  static const String destination = 'http://0.0.0.0:3000';

  Future<void> initializeValues() async {
    // assuming the token manager has been initialized and has a token value.
    var client = http.Client();

    var carUri = Uri.parse('${destination}/car');
    var fuelFillsUri = Uri.parse('${destination}/fuel_fill_record');
    var malfunctionsUri = Uri.parse('${destination}/malfunction');
    var servicesUri = Uri.parse('${destination}/service');
    var tripsUri = Uri.parse('${destination}/repeated_trip');

    Map<String, String> authHeaders = {
      'Authorization': 'Bearer ${TokenManager().token}'
    };

    client.get(
      carUri, headers: authHeaders
    );

    client.get(
        fuelFillsUri, headers: authHeaders
    );

    client.get(
        malfunctionsUri, headers: authHeaders
    );

    client.get(
        servicesUri, headers: authHeaders
    );

    client.get(
        tripsUri, headers: authHeaders
    );

  }

  static List<FuelFillRecord> getFuelFillRecords() {
    _fuelFills.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return _fuelFills;
  }

  static void addFuelFill(FuelFillRecord record) {
    _fuelFills.add(record);
    _instance.notifyListeners();
  }

  static Map<String, List<FuelFillRecord>> getYearMonthFuelFills() {
    Map<String, List<FuelFillRecord>> groupedRecords = {};

    for (var record in getFuelFillRecords()) {
      String key = "${record.dateTime.year}-${record.dateTime.month.toString()
          .padLeft(2, '0')}";

      if (!groupedRecords.containsKey(key)) {
        groupedRecords[key] = [];
      }

      groupedRecords[key]!.add(record);
    }

    return groupedRecords;
  }

  static List<Malfunction> getMalfunctions() {
    _malfunctions.sort((a, b) => b.id.compareTo(a.id));
    return _malfunctions;
  }

  static List<Service> getServices() {
    _services.sort((a, b) => b.kilometersDone.compareTo(a.kilometersDone));
    return _services;
  }

  static double getTotalConsumption() {
    double totalKilometers = _fuelFills.fold(0, (sum, fuelFill) => sum + fuelFill.kilometers);
    double totalLiters = _fuelFills.fold(0, (sum, fuelFill) => sum + fuelFill.liters);

    return 100 * totalLiters / totalKilometers;
  }

  static double getTotalEfficiency() {
    double totalKilometers = _fuelFills.fold(0, (sum, fuelFill) => sum + fuelFill.kilometers);
    double totalLiters = _fuelFills.fold(0, (sum, fuelFill) => sum + fuelFill.liters);

    return totalKilometers / totalLiters;
  }

  static double getTotalTravelCost() {
    double totalCost = _fuelFills.fold(0, (sum, fuelFill) => sum + fuelFill.cost);
    double totalKilometers = _fuelFills.fold(0, (sum, fuelFill) => sum + fuelFill.kilometers);

    return totalCost / totalKilometers;
  }


  static void addMalfunction(Malfunction malfunction) {
    _malfunctions.add(malfunction);
    _instance.notifyListeners();
  }

  static void addService(Service service) {
    _services.add(service);
    _instance.notifyListeners();
  }

  static void deleteFuelFill(FuelFillRecord record) {
    _fuelFills.remove(record);
    _instance.notifyListeners();
  }

  static void deleteMalfunction(Malfunction malfunction) {
    _malfunctions.remove(malfunction);
    _instance.notifyListeners();
  }

  static void deleteService(Service service) {
    _services.remove(service);
    _instance.notifyListeners();
  }

  static void setFuelFill(FuelFillRecord initial, FuelFillRecord modified) {
    int index = _fuelFills.indexOf(initial);
    _fuelFills[index] = modified;
    _instance.notifyListeners();
  }

  static double getTotalLitersFilled() {
    return _fuelFills.fold(0, (sum, fuelFill) => sum + fuelFill.liters);
  }

  static double getTotalKilometersTraveled() {
    return _fuelFills.fold(0, (sum, fuelFill) => sum + fuelFill.kilometers);
  }

  static double getTotalFuelFillCosts() {
    return DataHolder.getFuelFillRecords().fold<double>(0, (sum, record) => sum + record.cost);
  }

  static double getTotalMalfunctionCosts() {
    return DataHolder.getMalfunctions().fold<double>(0, (sum, malfunction) => sum + (malfunction.cost ?? 0));
  }

  static double getTotalServiceCosts() {
    return DataHolder.getServices().fold<double>(0, (sum, service) => sum + (service.cost ?? 0));
  }

  static double getTotalCost() {
    double totalCosts = 0;

    totalCosts += _fuelFills.fold<double>(0, (sum, fuelFill) => sum + fuelFill.cost);
    totalCosts += _services.fold<double>(0, (sum, service) => sum + (service.cost ?? 0));
    totalCosts += _malfunctions.fold<double>(0, (sum, malfunction) => sum + (malfunction.cost ?? 0));

    return totalCosts;
  }

}