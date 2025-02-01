import 'package:benzinapp/services/classes/fuel_fill_record.dart';

class DataHolder {

  static List<FuelFillRecord> getFuelFillRecords() {
    return [
      FuelFillRecord(
        id: 0,
        dateTime: DateTime(2024, DateTime.april, 20),
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
          dateTime: DateTime(2024, DateTime.may, 27),
          cost: 56.5,
          liters: 29.37,
          kilometers: 419
      ),

      FuelFillRecord(
          id: 3,
          dateTime: DateTime(2024, DateTime.may, 29),
          cost: 33.1,
          liters: 17.27,
          kilometers: 210
      ),

    ];
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