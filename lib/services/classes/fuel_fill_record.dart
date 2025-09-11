import 'package:benzinapp/services/data_holder.dart';
import 'package:flutter/cupertino.dart';

import '../managers/fuel_fill_record_manager.dart';

class FuelFillRecord {

  static FuelFillRecord fromJson(Map<String, dynamic> object) => FuelFillRecord(
      id: object[FuelFillRecordFields.id],
      dateTime: DateTime.parse(object[FuelFillRecordFields.filledAt]),
      liters: object[FuelFillRecordFields.lt],
      cost: object[FuelFillRecordFields.costEur],
      kilometers: object[FuelFillRecordFields.km],
      totalKilometers: object[FuelFillRecordFields.totalKm].toString().isEmpty ? null : object[FuelFillRecordFields.totalKm],
      fuelType: object[FuelFillRecordFields.fuelType].toString().isEmpty ? null : object[FuelFillRecordFields.fuelType],
      gasStation: object[FuelFillRecordFields.station].toString().isEmpty ? null : object[FuelFillRecordFields.station],
      comments: object[FuelFillRecordFields.notes].toString().isEmpty ? null : object[FuelFillRecordFields.notes]
  );

  Map<String, dynamic> toJson() => {
    FuelFillRecordFields.filledAt: dateTime.toIso8601String().substring(0, 10),
    FuelFillRecordFields.lt: liters,
    FuelFillRecordFields.costEur: cost,
    FuelFillRecordFields.km: kilometers,
    FuelFillRecordFields.totalKm: totalKilometers,
    FuelFillRecordFields.fuelType: fuelType,
    FuelFillRecordFields.station: gasStation,
    FuelFillRecordFields.notes: comments
  };

  static FuelFillRecord empty() => FuelFillRecord(
      id: -1,
      dateTime: DateTime.now(),
      liters: -1,
      cost: -1,
      kilometers: -1
  );

  FuelFillRecord({
    required this.id,
    required this.dateTime,
    required this.liters,
    required this.cost,
    required this.kilometers,

    this.gasStation,
    this.fuelType,
    this.comments,
    this.totalKilometers,
  });

  final int id;
  DateTime dateTime;
  double liters;
  double cost;
  double kilometers;

  int? totalKilometers;
  String? gasStation;
  String? fuelType;
  String? comments;

  FuelFillRecord? getNext() {
    var indexOfNext = FuelFillRecordManager().local!.indexOf(this) - 1;
    if (indexOfNext < 0) return null;
    return FuelFillRecordManager().local![indexOfNext];
  }

  double getConsumption() {
    if (getNext() == null) {
      return double.nan;
    }

    return 100 * liters / getNext()!.kilometers;
  }

  double getEfficiency() {
    if (getNext() == null) {
      return double.nan;
    }

    return getNext()!.kilometers / liters;
  }

  double getTravelCost() {
    if (getNext() == null) {
      return double.nan;
    }

    return cost / getNext()!.kilometers;
  }
  
}

class FuelFillRecordFields {
  static const String id = "id";
  static const String filledAt = "filled_at";
  static const String lt = "lt";
  static const String costEur = "cost_eur";
  static const String km = "km";
  static const String totalKm = "total_km";
  static const String station = "station";
  static const String fuelType = "fuel_type";
  static const String notes = "notes";
}