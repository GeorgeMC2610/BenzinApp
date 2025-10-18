import 'package:benzinapp/services/classes/car.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/managers/abstract_manager.dart';


class CarManager extends AbstractManager<Car> {

  static final CarManager _instance = CarManager._internal();
  factory CarManager() => _instance;
  CarManager._internal();

  Car? watchingCar;

  @override
  String get baseUrl => '${DataHolder.destination}/car';

  @override
  Car fromJson(Map<String, dynamic> json) => Car.fromJson(json);

  @override
  int getId(Car model) => model.id;

  @override
  String get responseKeyword => "car";

  @override
  int compare(Car a, Car b) => b.username.compareTo(a.username);

  @override
  Map<String, dynamic> toJson(Car model) => model.toJson();
}