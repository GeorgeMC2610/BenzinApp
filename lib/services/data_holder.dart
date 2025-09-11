import 'dart:convert';

import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/classes/malfunction.dart';
import 'package:benzinapp/services/classes/service.dart';
import 'package:flutter/material.dart';

import 'classes/car.dart';
import 'classes/trip.dart';
import 'managers/car_manager.dart';
import 'managers/fuel_fill_record_manager.dart';
import 'managers/malfunction_manager.dart';
import 'managers/service_manager.dart';
import 'managers/trip_manager.dart';

class DataHolder with ChangeNotifier {

  static final DataHolder _instance = DataHolder._internal();
  factory DataHolder() => _instance;
  DataHolder._internal();

  // TODO: Make these values not static, since this is a singleton.
  List<FuelFillRecord>? fuelFills;
  List<Malfunction>? malfunctions;
  List<Service>? services;
  List<Trip>? trips;
  Car? car;

  static const String destination = 'http://192.168.68.58:3000';

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

  // GENERAL STATS
  // TODO: Add calendar filters to them


}