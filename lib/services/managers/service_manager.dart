import 'package:benzinapp/services/classes/service.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/managers/abstract_manager.dart';

class ServiceManager extends AbstractManager<Service> {

  static final ServiceManager _instance = ServiceManager._internal();
  factory ServiceManager() => _instance;
  ServiceManager._internal();

  @override
  String get baseUrl => '${DataHolder.destination}/service';

  @override
  Service fromJson(Map<String, dynamic> json) => Service.fromJson(json);

  @override
  int getId(Service model) => model.id;

  @override
  String get responseKeyword => "service";

  @override
  int compare(Service a, Service b) => b.dateHappened.compareTo(a.dateHappened);

  @override
  Map<String, dynamic> toJson(Service model) => model.toJson();
}