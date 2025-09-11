import 'package:google_maps_flutter/google_maps_flutter.dart';

class Malfunction {

  Malfunction({
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
  DateTime dateStarted;
  String description;
  String title;
  int kilometersDiscovered;
  int severity;

  DateTime? dateEnded;
  double? cost;
  String? location;

  static Malfunction fromJson(Map<String, dynamic> object) => Malfunction(
    id: object[MalfunctionFields.id],
    dateStarted: DateTime.parse(object[MalfunctionFields.started]),
    dateEnded: DateTime.tryParse(object[MalfunctionFields.ended] ?? ''),
    title: object[MalfunctionFields.title],
    description: object[MalfunctionFields.description],
    severity: object[MalfunctionFields.severity],
    cost: object[MalfunctionFields.costEur],
    kilometersDiscovered: object[MalfunctionFields.atKm],
    location: ['null', ''].any((test) => test == object[MalfunctionFields.location]) ? null : object[MalfunctionFields.location],
  );

  Map<String, dynamic> toJson() => {
    MalfunctionFields.started: dateStarted.toIso8601String().substring(0, 10),
    MalfunctionFields.ended: dateEnded?.toIso8601String().substring(0, 10),
    MalfunctionFields.title: title,
    MalfunctionFields.description: description,
    MalfunctionFields.severity: severity,
    MalfunctionFields.costEur: cost,
    MalfunctionFields.atKm: kilometersDiscovered,
    MalfunctionFields.location: location,
  };

  static Malfunction empty() => Malfunction(
    id: -1,
    dateStarted: DateTime.now(),
    description: '',
    title: '', severity: 0,
    kilometersDiscovered: -1
  );

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

class MalfunctionFields {
  static const String id = 'id';
  static const String started = 'started';
  static const String ended = 'ended';
  static const String title = 'title';
  static const String description = 'description';
  static const String severity = 'severity';
  static const String costEur = 'cost_eur';
  static const String atKm = 'at_km';
  static const String location = 'location';
}