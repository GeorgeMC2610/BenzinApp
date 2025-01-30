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

    ];
  }

}