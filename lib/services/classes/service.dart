import 'package:google_maps_flutter/google_maps_flutter.dart';

class Service {

  static Service fromJson(Map<String, dynamic> object) {
    return Service(
      id: object["id"],
      dateHappened: DateTime.parse(object["date_happened"]),
      description: object["description"],
      cost: object["cost_eur"],
      kilometersDone: object["at_km"],
      nextServiceDate: DateTime.tryParse(object["next_at_date"].toString()),
      nextServiceKilometers: object["next_km"],
      location: ['null', ''].any((test) => test == object['location']) ? null : object["location"],
    );
  }

  const Service({
    required this.id,
    required this.kilometersDone,
    required this.description,
    required this.dateHappened,
    required this.cost,

    this.nextServiceDate,
    this.nextServiceKilometers,
    this.location
  });

  final int id;
  final int kilometersDone;
  final String description;
  final DateTime dateHappened;
  final double cost;

  final DateTime? nextServiceDate;
  final int? nextServiceKilometers;
  final String? location;

  String? getAddress() {
    if (location == null) return null;
    if (!location!.contains('|')) return null;

    return location!.split('|').first;
  }

  LatLng? getCoordinates() {
    if (location == null) return null;
    if (!location!.contains('|')) return null;

    var latitude = double.parse(location!.split('|').last.split(',').first.trim());
    var longitude = double.parse(location!.split('|').last.split(',').last.trim());
    return LatLng(latitude, longitude);
  }

}