import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/classes/malfunction.dart';

class DataHolder {

  static List<FuelFillRecord> _fuelFills = [];
  static List<Malfunction> _malfunctions = [];

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

}