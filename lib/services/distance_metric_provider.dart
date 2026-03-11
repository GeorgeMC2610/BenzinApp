import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DistanceMetric { kilometers, miles }

class DistanceMetricProvider extends ChangeNotifier {
  DistanceMetric _metric = DistanceMetric.kilometers;
  static const String _metricKey = 'distanceMetric';

  DistanceMetric get metric => _metric;

  DistanceMetricProvider() {
    _loadDistanceMetric();
  }

  void _loadDistanceMetric() async {
    final prefs = await SharedPreferences.getInstance();
    final metricString = prefs.getString(_metricKey);
    if (metricString == 'miles') {
      _metric = DistanceMetric.miles;
    } else {
      _metric = DistanceMetric.kilometers;
    }
    notifyListeners();
  }

  void setMetric(DistanceMetric newMetric) async {
    if (_metric == newMetric) return;

    _metric = newMetric;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_metricKey, newMetric == DistanceMetric.miles ? 'miles' : 'kilometers');
    notifyListeners();
  }

  double convert(double kilometers) {
    if (_metric == DistanceMetric.miles) {
      return kilometers * 0.621371;
    }
    return kilometers;
  }

  String get label => _metric == DistanceMetric.miles ? 'mi' : 'km';
  String get longLabel => _metric == DistanceMetric.miles ? 'miles' : 'kilometers';
  String get translatableCode => _metric == DistanceMetric.miles ? 'milesSetting' : 'kilometersSetting';
}
