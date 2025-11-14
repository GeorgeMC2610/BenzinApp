import 'package:benzinapp/services/managers/car_user_invitation_manager.dart';
import 'package:benzinapp/services/managers/user_manager.dart';

import 'managers/car_manager.dart';
import 'managers/fuel_fill_record_manager.dart';
import 'managers/malfunction_manager.dart';
import 'managers/service_manager.dart';
import 'managers/trip_manager.dart';

class DataHolder {

  static final DataHolder _instance = DataHolder._internal();
  factory DataHolder() => _instance;
  DataHolder._internal();

  static const String destination = 'http://localhost:3000';

  Future<void> initializeValues() async {
    List<Future<void>> futures = [
      CarManager().index(),
      UserManager().getCurrentUser(),
      CarUserInvitationManager().index(),
    ];

    await Future.wait(futures);
  }

  /// Since all these data belong to separate cars, they will have to wait
  /// until the `watchingCar` value is initialized.
  Future<void> getCarData(int id) async {
    CarManager().watchingCar = CarManager().local.firstWhere((car) => car.id == id);

    List<Future<void>> futures = [
      FuelFillRecordManager().index(),
      ServiceManager().index(),
      MalfunctionManager().index(),
      TripManager().index(),
      CarUserInvitationManager().index(),
    ];

    await Future.wait(futures);
  }

  void destroyValues() async {
    FuelFillRecordManager().destroyValues();
    ServiceManager().destroyValues();
    MalfunctionManager().destroyValues();
    TripManager().destroyValues();
    CarManager().destroyValues();
    UserManager().destroyValues();
    CarUserInvitationManager().destroyValues();
  }

  // TODO: Stop using this logic here. This will be migrated to the API.
  String getPlacesApiKey() => const String.fromEnvironment("BENZINAPP_PLACES_KEY");
}
