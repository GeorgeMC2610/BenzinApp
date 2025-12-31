import 'dart:convert';

import 'package:benzinapp/filters/abstract_filter.dart';
import 'package:flutter/material.dart';

import '../request_handler.dart';

abstract class AbstractManager<T> with ChangeNotifier {

  /// Backing list that widgets can listen to
  late List<T>? _local;
  List<T>? _filtered;
  List<T>? get local => _local;
  List<T>? get localOrFiltered => _filtered ?? _local;
  late Map<String, dynamic> _errors;
  Map<String, dynamic> get errors => _errors;

  AbstractManager() {
    _errors = {};
    _local = null;
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
    if (this.filter == null || _local == null) return;

    this._filtered = _local!.where((element) => this.filter!.matches(element)).toList();
    notifyListeners();
  }

  void removeFilters() {
    this.filter = null;
    this._filtered = null;
    notifyListeners();
  }

  Future<void> create(T model) async {
    _errors = {};
    final response = await RequestHandler.sendPostRequest(baseUrl, true, { responseKeyword: toJson(model) } );
    final jsonResponse = json.decode(response.body);

    if (response.ok) {
      if (_local != null) {
        final newModel = fromJson(jsonResponse[responseKeyword]);
        int index = _findIndex(newModel);
        _local!.insert(index, newModel);
      }
    }
    else {
      _errors = jsonResponse["errors"];
    }

    notifyListeners();
  }

  Future<void> update(T model) async {
    _errors = {};
    final response = await RequestHandler.sendPatchRequest("$baseUrl/${getId(model)})", { responseKeyword: toJson(model) });
    final jsonResponse = json.decode(response.body);

    if (response.ok) {
      if (_local != null) {
        final updated = fromJson(jsonResponse[responseKeyword]);
        _local!.removeWhere((e) => getId(e) == getId(model));
        int index = _findIndex(updated);
        _local!.insert(index, updated);
      }
    }
    else {
      _errors = jsonResponse["errors"];
    }

    notifyListeners();
  }

  Future<void> delete(T model, { Map<String, dynamic> body = const {} }) async {
    await RequestHandler.sendDeleteRequest("$baseUrl/${getId(model)}", body: body);
    _local?.removeWhere((e) => getId(e) == getId(model));
    notifyListeners();
  }

  @protected
  void manualInsert(T model) {
    if (_local != null) {
      int index = _findIndex(model);
      _local!.insert(index, model);
    }
  }

  @protected
  void setErrors(Map<String, dynamic> json) {
    _errors = json;
  }

  int _findIndex(T item) {
    if (_local != null) {
      for (int i = 0; i < _local!.length; i++) {
        if (compare(item, _local![i]) < 0) {
          return i;
        }
      }
      return _local!.length;
    }
    else {
      return -1;
    }
  }

  void destroyValues() {
    _local = null;
    _filtered = null;
    _errors = {};
  }
}
