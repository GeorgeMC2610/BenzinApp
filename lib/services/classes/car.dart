import 'package:benzinapp/services/managers/fuel_fill_record_manager.dart';
import 'package:benzinapp/services/managers/malfunction_manager.dart';
import 'dart:math';

import 'package:benzinapp/services/managers/service_manager.dart';
import 'package:benzinapp/services/managers/user_manager.dart';

class Car {

  Car({
    required this.id,
    required this.username,
    required this.ownerUsername,
    required this.manufacturer,
    required this.model,
    required this.year,
    required this.isShared,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  String username;
  String ownerUsername;
  String manufacturer;
  String model;
  bool isShared;
  int year;
  final DateTime createdAt;
  DateTime updatedAt;

  static Car fromJson(Map<String, dynamic> object) => Car(
    id: object[CarFields.id],
    username: object[CarFields.username],
    ownerUsername: object[CarFields.ownerUsername],
    manufacturer: object[CarFields.manufacturer],
    model: object[CarFields.model],
    year: object[CarFields.year],
    isShared: object[CarFields.isShared] ?? false,
    createdAt: DateTime.parse(object[CarFields.createdAt]),
    updatedAt: DateTime.parse(object[CarFields.createdAt]),
  );

  Map<String, dynamic> toJson() => {
    CarFields.manufacturer: manufacturer,
    CarFields.username: username,
    CarFields.model: model,
    CarFields.year: year
  };

  bool isOwned() {
    return UserManager().currentUser!.username == ownerUsername;
  }

  /// Total Consumption (Liters / 100 km)
  static double getTotalConsumption() {
    final fuelFills = FuelFillRecordManager().local;

    if (fuelFills.length <= 1) return 0;

    final totalKilometers = fuelFills
        .skip(1) // skip the first record
        .fold<double>(0, (sum, f) => sum + f.kilometers);

    final totalLiters =
    fuelFills.fold<double>(0, (sum, f) => sum + f.liters);

    return totalKilometers == 0 ? 0 : 100 * totalLiters / totalKilometers;
  }

  /// Efficiency (km / L)
  static double getTotalEfficiency() {
    final fuelFills = FuelFillRecordManager().local;

    if (fuelFills.length <= 1) return 0;

    final totalKilometers =
    fuelFills.skip(1).fold<double>(0, (sum, f) => sum + f.kilometers);

    final totalLiters =
    fuelFills.fold<double>(0, (sum, f) => sum + f.liters);

    return totalLiters == 0 ? 0 : totalKilometers / totalLiters;
  }

  /// Travel cost per km (EUR / km)
  static double getTotalTravelCost() {
    final fuelFills = FuelFillRecordManager().local;

    if (fuelFills.length <= 1) return 0;

    final totalCost =
    fuelFills.fold<double>(0, (sum, f) => sum + f.cost);

    final totalKilometers =
    fuelFills.skip(1).fold<double>(0, (sum, f) => sum + f.kilometers);

    return totalKilometers == 0 ? 0 : totalCost / totalKilometers;
  }

  /// Total liters filled
  static double getTotalLitersFilled() {
    final fuelFills = FuelFillRecordManager().local;
    return fuelFills.fold<double>(0, (sum, f) => sum + f.liters);
  }

  /// Total kilometers traveled
  static double getTotalKilometersTraveled() {
    final fuelFills = FuelFillRecordManager().local;
    return fuelFills.fold<double>(0, (sum, f) => sum + f.kilometers);
  }

  /// Total costs: Fuel only
  static double getTotalFuelFillCosts() {
    final fuelFills = FuelFillRecordManager().local;
    return fuelFills.fold<double>(0, (sum, f) => sum + f.cost);
  }

  /// Total costs: Malfunctions only
  static double getTotalMalfunctionCosts() {
    final malfunctions = MalfunctionManager().local;
    return malfunctions.fold<double>(
        0, (sum, m) => sum + (m.cost ?? 0));
  }

  /// Total costs: Services only
  static double getTotalServiceCosts() {
    final services = ServiceManager().local;
    return services.fold<double>(
        0, (sum, s) => sum + (s.cost ?? 0));
  }

  /// Total costs: Fuel + Services + Malfunctions
  static double getTotalCost() {
    final fuelFills = FuelFillRecordManager().local;
    final services = ServiceManager().local;
    final malfunctions = MalfunctionManager().local;

    return fuelFills.fold<double>(0, (sum, f) => sum + f.cost) +
        services.fold<double>(0, (sum, s) => sum + (s.cost ?? 0)) +
        malfunctions.fold<double>(0, (sum, m) => sum + (m.cost ?? 0));
  }

  /// Best efficiency (max km/L)
  static double getBestEfficiency() {
    final fuelFills = FuelFillRecordManager().local;
    final efficiencies = fuelFills
        .where((f) => f.getNext() != null)
        .map((f) => f.getEfficiency());

    return efficiencies.isEmpty ? 0 : efficiencies.reduce(max);
  }

  /// Worst efficiency (min km/L)
  static double getWorstEfficiency() {
    final fuelFills = FuelFillRecordManager().local;
    final efficiencies = fuelFills
        .where((f) => f.getNext() != null)
        .map((f) => f.getEfficiency());

    return efficiencies.isEmpty ? 0 : efficiencies.reduce(min);
  }

  /// Best travel cost (min EUR/km)
  static double getBestTravelCost() {
    final fuelFills = FuelFillRecordManager().local;
    final travelCosts = fuelFills
        .where((f) => f.getNext() != null)
        .map((f) => f.getTravelCost());

    return travelCosts.isEmpty ? 0 : travelCosts.reduce(min);
  }

  /// Worst travel cost (max EUR/km)
  static double getWorstTravelCost() {
    final fuelFills = FuelFillRecordManager().local;
    final travelCosts = fuelFills
        .where((f) => f.getNext() != null)
        .map((f) => f.getTravelCost());

    return travelCosts.isEmpty ? 0 : travelCosts.reduce(max);
  }

  /// Most recent odometer reading
  static int? getMostRecentTotalKilometers() {
    final fuelFills = FuelFillRecordManager().local;
    if (fuelFills.isEmpty) return null;
    return fuelFills.first.totalKilometers;
  }
}

class CarFields {
  static const String id = "id";
  static const String username = "username";
  static const String manufacturer = "manufacturer";
  static const String model = "model";
  static const String year = "year";
  static const String ownerUsername = "owner_username";
  static const String createdAt = "created_at";
  static const String updatedAt = "updated_at";
  static const String isShared = "shared";
}