import 'package:benzinapp/services/classes/fuel_fill_record.dart';

class DataHolder {

  static List<FuelFillRecord> getFuelFillRecords() {
    var fuelFills = [
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
      ),

    ];

    fuelFills.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    fuelFills.forEach((element) => print(element.id));

    return fuelFills;
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

}