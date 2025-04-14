import 'package:benzinapp/services/data_holder.dart';
import 'package:flutter/cupertino.dart';

class FuelFillRecord {

  static FuelFillRecord fromJson(Map<String, dynamic> jsonObject) {
    return FuelFillRecord(
      id: jsonObject["id"],
      dateTime: DateTime.parse(jsonObject["filled_at"]),
      liters: jsonObject["lt"],
      cost: jsonObject["cost_eur"],
      kilometers: jsonObject["km"],
      totalKilometers: jsonObject["total_km"].toString().isEmpty ? null : jsonObject["total_km"],
      fuelType: jsonObject["fuel_type"].toString().isEmpty ? null : jsonObject["fuel_type"],
      gasStation: jsonObject["station"].toString().isEmpty ? null : jsonObject["station"],
      comments: jsonObject["notes"].toString().isEmpty ? null : jsonObject["notes"]
    );
  }

  const FuelFillRecord({
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
  final DateTime dateTime;
  final double liters;
  final double cost;
  final double kilometers;

  final int? totalKilometers;
  final String? gasStation;
  final String? fuelType;
  final String? comments;

  FuelFillRecord? getNext() {
    var indexOfNext = DataHolder.getFuelFillRecords()!.indexOf(this) - 1;
    if (indexOfNext < 0) return null;
    return DataHolder.getFuelFillRecords()![indexOfNext];
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