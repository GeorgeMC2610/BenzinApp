class FuelFillRecord {

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