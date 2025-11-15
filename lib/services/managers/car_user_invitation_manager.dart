import 'package:benzinapp/services/classes/car_user_invitation.dart';
import 'package:benzinapp/services/managers/abstract_manager.dart';
import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/services/request_handler.dart';
import '../data_holder.dart';

class CarUserInvitationManager extends AbstractManager<CarUserInvitation> {

  static final CarUserInvitationManager _instance = CarUserInvitationManager._internal();
  factory CarUserInvitationManager() => _instance;
  CarUserInvitationManager._internal();

  @override
  String get baseUrl => '${DataHolder.destination}/car_user_invitation';

  @override
  CarUserInvitation fromJson(Map<String, dynamic> json) => CarUserInvitation.fromJson(json);

  @override
  int compare(CarUserInvitation a, CarUserInvitation b) => b.id.compareTo(a.id);

  @override
  Map<String, dynamic> toJson(CarUserInvitation model) => model.toJson();

  @override
  int getId(CarUserInvitation model) => model.id;

  @override
  String get responseKeyword => "car_user_invitation";

  @override
  Future<void> update(CarUserInvitation model) => throw UnimplementedError();

  @override
  Future<void> delete(CarUserInvitation model) async {
    super.delete(model);
    await CarManager().index();
    notifyListeners();
  }

  Future<bool> accept(int id) async {
    final response = await RequestHandler.sendPatchRequest("$baseUrl/$id/accept", {});
    if (response.statusCode == 204) {
      local.where((element) => element.id == id).firstOrNull?.isAccepted = true;
      await CarManager().index();
      notifyListeners();
    }

    return response.statusCode == 204;
  }


}