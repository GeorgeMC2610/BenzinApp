import 'package:google_maps_flutter/google_maps_flutter.dart';

class Malfunction {

  static Malfunction fromJson(Map<String, dynamic> object) {
    return Malfunction(
      id: object["id"],
      dateStarted: DateTime.parse(object["started"]),
      dateEnded: object["ended"] == null ? null : DateTime.parse(object["ended"]),
      title: object["title"],
      description: object["description"],
      severity: object["severity"],
      cost: object["cost_eur"],
      kilometersDiscovered: object["at_km"],
      location: object["location"],
    );
  }

  const Malfunction({
    required this.id,
    required this.dateStarted,
    required this.description,
    required this.title,
    required this.severity,
    required this.kilometersDiscovered,

    this.dateEnded,
    this.cost,
    this.location,
  });

  final int id;
  final DateTime dateStarted;
  final String description;
  final String title;
  final int kilometersDiscovered;
  final int severity;

  final DateTime? dateEnded;
  final double? cost;
  final String? location;

  bool isFixed () {
    return dateEnded != null;
  }

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