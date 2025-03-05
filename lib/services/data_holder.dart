import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/classes/malfunction.dart';
import 'package:benzinapp/services/classes/service.dart';
import 'package:flutter/material.dart';

class DataHolder with ChangeNotifier {

  static final DataHolder _instance = DataHolder._internal();
  factory DataHolder() => _instance;
  DataHolder._internal();

  static List<FuelFillRecord> _fuelFills = [];
  static List<Malfunction> _malfunctions = [];
  static List<Service> _services = [];

  static List<FuelFillRecord> getFuelFillRecords() {
    if (_fuelFills.isEmpty) {
      _fuelFills.addAll([
          FuelFillRecord(
              id: 0,
              dateTime: DateTime(2024, DateTime.march, 19),
              cost: 67.9,
              liters: 39.2,
              kilometers: 409
          ),

        FuelFillRecord(
          id: 1,
          dateTime: DateTime(2024, DateTime.april, 29),
          cost: 42.1,
          liters: 24.5,
          kilometers: 249
      ),

        FuelFillRecord(
            id: 2,
            dateTime: DateTime(2024, DateTime.may, 18),
            cost: 110,
            liters: 60,
            kilometers: 728
        ),

        FuelFillRecord(
            id: 3,
            dateTime: DateTime(2024, DateTime.june, 27),
            cost: 56.5,
            liters: 29.37,
            kilometers: 419
        ),

        FuelFillRecord(
            id: 4,
            dateTime: DateTime(2024, DateTime.july, 29),
            cost: 33.1,
            liters: 17.27,
            kilometers: 210
        ),

        FuelFillRecord(
            id: 5,
            dateTime: DateTime(2024, DateTime.august, 19),
            cost: 67.9,
            liters: 39.2,
            kilometers: 409
        ),

        FuelFillRecord(
            id: 6,
            dateTime: DateTime(2024, DateTime.september, 29),
            cost: 42.1,
            liters: 24.5,
            kilometers: 249
        ),

        FuelFillRecord(
            id: 7,
            dateTime: DateTime(2024, DateTime.october, 18),
            cost: 110,
            liters: 60,
            kilometers: 528
        ),

        FuelFillRecord(
            id: 8,
            dateTime: DateTime(2024, DateTime.november, 27),
            cost: 56.5,
            liters: 29.37,
            kilometers: 419
        ),

        FuelFillRecord(
            id: 9,
            dateTime: DateTime(2024, DateTime.december, 29),
            cost: 66.1,
            liters: 33.27,
            kilometers: 440
        )]
      );
    }

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
    if (_malfunctions.isEmpty) {
      _malfunctions.addAll([
        Malfunction(
            id: 5,
            dateStarted: DateTime(2025, DateTime.january, 16),
            description: 'Dashcam Broken',
            title: "it won't record",
            kilometersDiscovered: 200094,
            dateEnded: DateTime(2025, DateTime.january, 19),
            cost: null,
            location: null,
        ),

        Malfunction(
          id: 5,
          dateStarted: DateTime(2024, DateTime.december, 6),
          description: 'Window Shield',
          title: 'brokennn',
          kilometersDiscovered: 192847,
          dateEnded: DateTime(2024, DateTime.december, 19),
          cost: 229.93,
          location: "Synchro Center"
        ),

        Malfunction(
            id: 0,
            dateStarted: DateTime(2024, DateTime.november, 29),
            description: 'Ta takakia trizoun',
            title: 'Braking pads',
            kilometersDiscovered: 99278
        ),

        Malfunction(
            id: 0,
            dateStarted: DateTime(2024, DateTime.may, 18),
            description: 'Reverse light is borken',
            title: 'Reversing light',
            kilometersDiscovered: 77182
        ),

        Malfunction(
            id: 0,
            dateStarted: DateTime(2024, DateTime.october, 2),
            description: 'takakeiros trizeiros',
            title: 'Bad tyres',
            kilometersDiscovered: 109372
        ),
      ]);
    }

    _malfunctions.sort((a, b) => b.id.compareTo(a.id));
    return _malfunctions;
  }

  static List<Service> getServices() {
    if (_services.isEmpty) {
      _services.addAll([
        Service(
            id: 0,
            dateHappened: DateTime(2024, DateTime.november, 29),
            description: 'Ta takakia trizoun',
            kilometersDone: 129402
        ),

        Service(
            id: 0,
            dateHappened: DateTime(2024, DateTime.may, 18),
            description: 'Reverse light is borken',
            kilometersDone: 118372
        ),

        Service(
            id: 0,
            dateHappened: DateTime(2024, DateTime.january, 2),
            description: 'takakeiros trizeiros',
            kilometersDone: 102852
        ),

        Service(
          id: 3,
          dateHappened: DateTime(2025, DateTime.january, 29),
          description: '- bouzi\n- takakia\n- kai kati allo pou den thymamai',
          kilometersDone: 106538,
          location: 'Synchronerios Senterios',
          nextServiceKilometers: 110938,
          cost: 520.82
        )
      ]);
    }

    _services.sort((a, b) => b.kilometersDone.compareTo(a.kilometersDone));
    return _services;
  }

  static void addMalfunction(Malfunction malfunction) {
    _malfunctions.add(malfunction);
    _instance.notifyListeners();
  }

  static void addService(Service service) {
    _services.add(service);
    _instance.notifyListeners();
  }

}