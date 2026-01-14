import 'package:benzinapp/filters/fuel_fill_filter.dart';
import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/managers/abstract_manager.dart';
import 'package:benzinapp/services/managers/car_manager.dart';


class FuelFillRecordManager extends AbstractManager<FuelFillRecord> {

  static final FuelFillRecordManager _instance = FuelFillRecordManager._internal();
  factory FuelFillRecordManager() => _instance;
  FuelFillRecordManager._internal();

  @override
  String get baseUrl => '${DataHolder.destination}/car/${CarManager().watchingCar!.id}/fuel_fill_record';

  @override
  FuelFillFilter? get filter => super.filter as FuelFillFilter?;

  @override
  set filter(setted) => super.filter = setted;

  @override
  FuelFillRecord fromJson(Map<String, dynamic> json) => FuelFillRecord.fromJson(json);

  @override
  int getId(FuelFillRecord model) => model.id;

  @override
  int compare(FuelFillRecord a, FuelFillRecord b) => b.dateTime.compareTo(a.dateTime);

  @override
  String get responseKeyword => "fuel_fill_record";

  @override
  Map<String, dynamic> toJson(FuelFillRecord model) => model.toJson();
}