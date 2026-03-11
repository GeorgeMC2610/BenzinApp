import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum VolumeMetric { liters, gallons }

class VolumeMetricProvider extends ChangeNotifier {
  VolumeMetric _metric = VolumeMetric.liters;
  static const String _metricKey = 'volumeMetric';

  VolumeMetric get metric => _metric;

  VolumeMetricProvider() {
    _loadVolumeMetric();
  }

  void _loadVolumeMetric() async {
    final prefs = await SharedPreferences.getInstance();
    final metricString = prefs.getString(_metricKey);
    if (metricString == 'gallons') {
      _metric = VolumeMetric.gallons;
    } else {
      _metric = VolumeMetric.liters;
    }
    notifyListeners();
  }

  void setMetric(VolumeMetric newMetric) async {
    if (_metric == newMetric) return;

    _metric = newMetric;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_metricKey, newMetric == VolumeMetric.gallons ? 'gallons' : 'liters');
    notifyListeners();
  }

  double convert(double liters) {
    if (_metric == VolumeMetric.gallons) {
      return liters * 0.264172; // 1 Liter = 0.264172 US Gallons
    }
    return liters;
  }

  String get label => _metric == VolumeMetric.gallons ? 'gal' : 'lt';
  String get longLabel => _metric == VolumeMetric.gallons ? 'gallons' : 'liters';
  String get translatableCode => _metric == VolumeMetric.gallons ? 'gallonsSetting' : 'litersSetting';
}
