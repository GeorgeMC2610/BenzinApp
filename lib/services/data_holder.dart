import 'managers/car_manager.dart';
import 'managers/fuel_fill_record_manager.dart';
import 'managers/malfunction_manager.dart';
import 'managers/service_manager.dart';
import 'managers/trip_manager.dart';

class DataHolder {

  static final DataHolder _instance = DataHolder._internal();
  factory DataHolder() => _instance;
  DataHolder._internal();

  static const String destination = 'https://benzin-app.fly.dev';

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

  String getPlacesApiKey() => const String.fromEnvironment("BENZINAPP_PLACES_KEY");
}