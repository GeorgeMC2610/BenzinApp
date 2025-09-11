import 'dart:convert';

import 'package:flutter/material.dart';

import '../request_handler.dart';

abstract class AbstractManager<T> with ChangeNotifier {

  /// Backing list that widgets can listen to
  late List<T> _local;
  List<T> get local => _local;

  AbstractManager() {
    _local = [];
  }

  /// Each subclass defines its own URL
  String get baseUrl;
  String get responseKeyword;

  /// Subclasses know how to parse JSON
  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(T model);

  /// Subclasses must tell us how to extract the model's ID
  int getId(T model);

  /// Example: index (fetch all)
  Future<void> index() async {
    final response = await RequestHandler.sendGetRequest(baseUrl);
    final jsonResponse = json.decode(response.body);

    List<T> data = [];
    for (final jsonObject in jsonResponse) {
      T record = fromJson(jsonObject);
      data.add(record);
    }

    _local = data;
    notifyListeners();
  }

  Future<void> create(T model) async {
    final response = await RequestHandler.sendPostRequest(baseUrl, true, toJson(model));
    final jsonResponse = json.decode(response.body)[responseKeyword];
    final newModel = fromJson(jsonResponse);

    _local.add(newModel);
    notifyListeners();
  }

  Future<void> update(T model) async {
    final response = await RequestHandler.sendPatchRequest("$baseUrl/${getId(model)})", toJson(model));
    final jsonResponse = json.decode(response.body)[responseKeyword];
    final updated = fromJson(jsonResponse);

    final index = _local.indexWhere((e) => getId(e) == getId(model));
    if (index != -1) _local[index] = updated;

    notifyListeners();
  }

  Future<void> delete(T model) async {
    await RequestHandler.sendDeleteRequest("$baseUrl/${getId(model)}");
    _local.removeWhere((e) => getId(e) == getId(model));
    notifyListeners();
  }

  void destroyValues() {
    _local = [];
  }
}
