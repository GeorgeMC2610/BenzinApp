import 'package:benzinapp/services/classes/car.dart';

class Trip {
  Trip({
    required this.id,
    required this.title,
    required this.timesRepeating,
    required this.totalKm,
    required this.created,
    required this.updated,
    required this.originLatitude,
    required this.originLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.originAddress,
    required this.destinationAddress,
    required this.polyline,

    this.createdByUsername
  });

  final int id;
  String title;
  int timesRepeating;
  double totalKm;
  final DateTime created;
  final DateTime updated;
  double originLatitude;
  double originLongitude;
  double destinationLatitude;
  double destinationLongitude;
  String originAddress;
  String destinationAddress;
  String polyline;

  String? createdByUsername;

  static Trip fromJson(Map<String, dynamic> object) => Trip(
    id: object[TripFields.id],
    title: object[TripFields.title],
    timesRepeating: object[TripFields.timesRepeating],
    totalKm: (object[TripFields.totalKm] as num).toDouble(),
    created: DateTime.parse(object[TripFields.createdAt]),
    updated: DateTime.parse(object[TripFields.updatedAt]),
    originLatitude: (object[TripFields.originLatitude] as num).toDouble(),
    originLongitude: (object[TripFields.originLongitude] as num).toDouble(),
    destinationLatitude:
    (object[TripFields.destinationLatitude] as num).toDouble(),
    destinationLongitude:
    (object[TripFields.destinationLongitude] as num).toDouble(),
    originAddress: object[TripFields.originAddress],
    destinationAddress: object[TripFields.destinationAddress],
    polyline: object[TripFields.polyline],
    createdByUsername: object[TripFields.createdByUsername]
  );

  /// Convert to JSON using keys from TripManager
  Map<String, dynamic> toJson() => {
    TripFields.title: title,
    TripFields.timesRepeating: timesRepeating,
    TripFields.totalKm: totalKm,
    TripFields.originLatitude: originLatitude,
    TripFields.originLongitude: originLongitude,
    TripFields.destinationLatitude: destinationLatitude,
    TripFields.destinationLongitude: destinationLongitude,
    TripFields.originAddress: originAddress,
    TripFields.destinationAddress: destinationAddress,
    TripFields.polyline: polyline,
  };

  static Trip empty() => Trip(
      id: -1, title: '', timesRepeating: -1,
      totalKm: -1, created: DateTime.now(), updated: DateTime.now(),
      originLatitude: -1, originLongitude: -1,
      destinationLatitude: -1, destinationLongitude: -1,
      originAddress: '', destinationAddress: '',
      polyline: ''
  );

  double getBestTripCost(bool perTime) {
    final bestTravelCost = Car.getBestTravelCost();

    return perTime
        ? totalKm * bestTravelCost
        : totalKm * bestTravelCost * timesRepeating;
  }

  double getAverageTripCost(bool perTime) {
    final averageTravelCost = Car.getTotalTravelCost();

    return perTime
        ? totalKm * averageTravelCost
        : totalKm * averageTravelCost * timesRepeating;
  }

  double getWorstTripCost(bool perTime) {
    final worstTravelCost = Car.getWorstTravelCost();

    return perTime
        ? totalKm * worstTravelCost
        : totalKm * worstTravelCost * timesRepeating;
  }

  double getBestTripConsumption(bool perTime) {
    final bestEfficiency = Car.getBestEfficiency();

    return perTime
        ? totalKm / bestEfficiency
        : (totalKm / bestEfficiency) * timesRepeating;
  }

  double getAverageTripConsumption(bool perTime) {
    final avgEfficiency = Car.getTotalEfficiency();

    return perTime
        ? totalKm / avgEfficiency
        : (totalKm / avgEfficiency) * timesRepeating;
  }

  double getWorstTripConsumption(bool perTime) {
    final worstEfficiency = Car.getWorstEfficiency();

    return perTime
        ? totalKm / worstEfficiency
        : (totalKm / worstEfficiency) * timesRepeating;
  }

}

class TripFields {
  static const String id = 'id';
  static const String title = 'title';
  static const String timesRepeating = 'times_repeating';
  static const String totalKm = 'total_km';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
  static const String originLatitude = 'origin_latitude';
  static const String originLongitude = 'origin_longitude';
  static const String destinationLatitude = 'destination_latitude';
  static const String destinationLongitude = 'destination_longitude';
  static const String originAddress = 'origin_address';
  static const String destinationAddress = 'destination_address';
  static const String polyline = 'polyline';
  static const String createdByUsername = 'created_by_username';
}