import 'dart:convert';

import 'package:benzinapp/filters/abstract_filter.dart';
import 'package:flutter/material.dart';

import '../request_handler.dart';

abstract class AbstractManager<T> with ChangeNotifier {

  /// Backing list that widgets can listen to
  late List<T> _local;
  List<T>? _filtered;
  List<T> get local => _local;
  List<T> get localOrFiltered => _filtered ?? _local;

  AbstractManager() {
    _local = [];
  }

  AbstractFilter? filter;

  /// Each subclass defines its own URL
  String get baseUrl;
  String get responseKeyword;

  /// Subclasses know how to parse JSON
  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(T model);

  /// Subclasses must tell us how to extract the model's ID
  int getId(T model);
  int compare(T a, T b);

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

  void applyFilters() {
    if (this.filter == null) return;

    this._filtered = _local.where((element) => this.filter!.matches(element)).toList();
    notifyListeners();
  }

  void removeFilters() {
    this.filter = null;
    this._filtered = null;
    notifyListeners();
  }

  Future<void> create(T model) async {
    final response = await RequestHandler.sendPostRequest(baseUrl, true, toJson(model));
    final jsonResponse = json.decode(response.body)[responseKeyword];
    final newModel = fromJson(jsonResponse);

    int index = _findIndex(newModel);
    _local.insert(index, newModel);

    notifyListeners();
  }

  Future<void> update(T model) async {
    final response = await RequestHandler.sendPatchRequest("$baseUrl/${getId(model)})", toJson(model));
    final jsonResponse = json.decode(response.body)[responseKeyword];
    final updated = fromJson(jsonResponse);

    _local.removeWhere((e) => getId(e) == getId(model));
    int index = _findIndex(updated);
    _local.insert(index, updated);

    notifyListeners();
  }

  Future<void> delete(T model) async {
    await RequestHandler.sendDeleteRequest("$baseUrl/${getId(model)}");
    _local.removeWhere((e) => getId(e) == getId(model));
    notifyListeners();
  }

  int _findIndex(T item) {
    for (int i = 0; i < _local.length; i++) {
      if (compare(item, _local[i]) < 0) {
        return i;
      }
    }
    return _local.length;
  }

  void destroyValues() {
    _local = [];
  }
}
