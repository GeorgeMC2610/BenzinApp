import 'package:google_maps_flutter/google_maps_flutter.dart';

class Service {

  Service({
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
  int kilometersDone;
  String description;
  DateTime dateHappened;

  double? cost;
  DateTime? nextServiceDate;
  int? nextServiceKilometers;
  String? location;

  static Service fromJson(Map<String, dynamic> object) => Service(
    id: object[ServiceFields.id],
    dateHappened: DateTime.parse(object[ServiceFields.dateHappened]),
    description: object[ServiceFields.description],
    cost: object[ServiceFields.costEur],
    kilometersDone: object[ServiceFields.atKm],
    nextServiceDate: DateTime.tryParse(object[ServiceFields.nextAtDate] ?? ''),
    nextServiceKilometers: object[ServiceFields.nextKm],
    location: ['null', ''].any((test) => test == object[ServiceFields.location]) ? null : object[ServiceFields.location],
  );

  Map<String, dynamic> toJson() => {
    ServiceFields.dateHappened: dateHappened.toIso8601String().substring(0, 10),
    ServiceFields.description: description,
    ServiceFields.costEur: cost,
    ServiceFields.atKm: kilometersDone,
    ServiceFields.nextAtDate: nextServiceDate?.toIso8601String().substring(0, 10),
    ServiceFields.nextKm: nextServiceKilometers,
    ServiceFields.location: location,
  };

  static Service empty() => Service(
      id: -1,
      kilometersDone: -1,
      description: '',
      dateHappened: DateTime.now(), cost: -1
  );


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

class ServiceFields {
  static const String id = "id";
  static const String dateHappened = "date_happened";
  static const String description = "description";
  static const String costEur = "cost_eur";
  static const String atKm = "at_km";
  static const String nextAtDate = "next_at_date";
  static const String nextKm = "next_km";
  static const String location = "location";
}