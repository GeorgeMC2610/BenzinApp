import 'package:benzinapp/services/classes/malfunction.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/managers/abstract_manager.dart';

class MalfunctionManager extends AbstractManager<Malfunction> {

  static final MalfunctionManager _instance = MalfunctionManager._internal();
  factory MalfunctionManager() => _instance;
  MalfunctionManager._internal();

  @override
  String get baseUrl => '${DataHolder.destination}/malfunction';

  @override
  Malfunction fromJson(Map<String, dynamic> json) => Malfunction.fromJson(json);

  @override
  int getId(Malfunction model) => model.id;

  @override
  String get responseKeyword => "malfunction";

  @override
  int compare(Malfunction a, Malfunction b) => b.dateStarted.compareTo(a.dateStarted);

  @override
  Map<String, dynamic> toJson(Malfunction model) => model.toJson();
}