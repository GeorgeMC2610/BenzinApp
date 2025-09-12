import 'managers/car_manager.dart';
import 'managers/fuel_fill_record_manager.dart';
import 'managers/malfunction_manager.dart';
import 'managers/service_manager.dart';
import 'managers/trip_manager.dart';

class DataHolder {

  static final DataHolder _instance = DataHolder._internal();
  factory DataHolder() => _instance;
  DataHolder._internal();

  static const String destination = 'http://192.168.68.71:3000';

  Future<void> initializeValues() async {
    await FuelFillRecordManager().index();
    await ServiceManager().index();
    await MalfunctionManager().index();
    await TripManager().index();
    await CarManager().get(forceBackend: true);
  }

  void destroyValues() async {
    FuelFillRecordManager().destroyValues();
    ServiceManager().destroyValues();
    MalfunctionManager().destroyValues();
    TripManager().destroyValues();
    CarManager().car = null;
  }
}