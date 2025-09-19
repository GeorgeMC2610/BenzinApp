import 'package:benzinapp/services/classes/trip.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/managers/abstract_manager.dart';

class TripManager extends AbstractManager<Trip> {

  static final TripManager _instance = TripManager._internal();
  factory TripManager() => _instance;
  TripManager._internal();

  @override
  String get baseUrl => '${DataHolder.destination}/repeated_trip';

  @override
  Trip fromJson(Map<String, dynamic> json) => Trip.fromJson(json);

  @override
  int getId(Trip model) => model.id;

  @override
  String get responseKeyword => "repeated_trip";

  @override
  int compare(Trip a, Trip b) => b.created.compareTo(a.created);

  @override
  Map<String, dynamic> toJson(Trip model) => model.toJson();
}