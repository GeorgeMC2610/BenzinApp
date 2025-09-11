import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/managers/abstract_manager.dart';

class FuelFillRecordManager extends AbstractManager<FuelFillRecord> {

  static final FuelFillRecordManager _instance = FuelFillRecordManager._internal();
  factory FuelFillRecordManager() => _instance;
  FuelFillRecordManager._internal();

  @override
  String get baseUrl => '${DataHolder.destination}/fuel_fill_record';

  @override
  FuelFillRecord fromJson(Map<String, dynamic> json) => FuelFillRecord.fromJson(json);

  @override
  int getId(FuelFillRecord model) => model.id;

  @override
  String get responseKeyword => "fuel_fill";

  @override
  Map<String, dynamic> toJson(FuelFillRecord model) => model.toJson();
}