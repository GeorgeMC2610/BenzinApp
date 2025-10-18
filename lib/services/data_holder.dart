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
    await CarManager().index();
  }

  /// Since all these data belong to separate cars, they will have to wait
  /// until the `watchingCar` value is initialized.
  Future<void> getCarData() async {
    List<Future<void>> futures = [
      FuelFillRecordManager().index(),
      ServiceManager().index(),
      MalfunctionManager().index(),
      TripManager().index()
    ];

    await Future.wait(futures);
  }

  void destroyValues() async {
    FuelFillRecordManager().destroyValues();
    ServiceManager().destroyValues();
    MalfunctionManager().destroyValues();
    TripManager().destroyValues();
    CarManager().destroyValues();
  }

  // TODO: Stop using this logic here. This will be migrated to the API.
  String getPlacesApiKey() => const String.fromEnvironment("BENZINAPP_PLACES_KEY");
}