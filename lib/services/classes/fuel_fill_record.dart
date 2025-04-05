class FuelFillRecord {

  static FuelFillRecord fromJson(Map<String, dynamic> jsonObject) {
    return FuelFillRecord(
      id: jsonObject["id"],
      dateTime: DateTime.parse(jsonObject["filled_at"]),
      liters: jsonObject["lt"],
      cost: jsonObject["cost_eur"],
      kilometers: jsonObject["km"],
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
  });

  final int id;
  final DateTime dateTime;
  final double liters;
  final double cost;
  final double kilometers;

  final String? gasStation;
  final String? fuelType;
  final String? comments;

  double getConsumption() {
    return 100 * liters / kilometers;
  }

  double getEfficiency() {
    return kilometers / liters;
  }

  double getTravelCost() {
    return cost / kilometers;
  }
  
}