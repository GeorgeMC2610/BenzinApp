import 'package:benzinapp/services/distance_metric_provider.dart';
import 'package:benzinapp/services/volume_metric_provider.dart';
import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:flutter_translate/flutter_translate.dart';

class FuelMetricService {
  static String getConsumptionOrEfficiency(
      FuelFillRecord record,
      DistanceMetric distanceMetric,
      VolumeMetric volumeMetric) {
    
    // Base values (Metric)
    double consumption = record.getConsumption(); // L/100km
    double efficiency = record.getEfficiency();    // km/L

    if (distanceMetric == DistanceMetric.kilometers) {
      if (volumeMetric == VolumeMetric.liters) {
        return "${consumption.toStringAsFixed(3)} lt./100km";
      } else {
        // km and gallons (Rare but possible)
        double galPer100km = consumption * 0.264172; 
        return "${galPer100km.toStringAsFixed(3)} gal./100km";
      }
    } else {
      if (volumeMetric == VolumeMetric.liters) {
        // miles and liters
        double miPerLiter = efficiency * 0.621371;
        return "${miPerLiter.toStringAsFixed(3)} mi/lt.";
      } else {
        // miles and gallons (MPG)
        // 1 L/100km = 235.215 MPG (US)
        // MPG = 235.215 / (L/100km)
        double mpg = 235.215 / consumption;
        return "${mpg.toStringAsFixed(3)} mpg";
      }
    }
  }

  static double getChartValue(
      FuelFillRecord record,
      String focusType, // consumption, efficiency, travelCost
      DistanceMetric distanceMetric,
      VolumeMetric volumeMetric) {
    
    switch (focusType) {
      case 'consumption':
        double base = record.getConsumption(); // L/100km
        if (distanceMetric == DistanceMetric.kilometers) {
          return volumeMetric == VolumeMetric.liters ? base : base * 0.264172;
        } else {
          // Miles. Typically US users want MPG even for "consumption" focus, 
          // but if we stick to "volume per distance":
          return volumeMetric == VolumeMetric.liters 
            ? base * 1.60934  // L/100mi
            : base * 0.425144; // Gal/100mi (roughly)
        }
      
      case 'efficiency':
        double base = record.getEfficiency(); // km/L
        if (distanceMetric == DistanceMetric.kilometers) {
          return volumeMetric == VolumeMetric.liters ? base : base / 3.78541;
        } else {
          return volumeMetric == VolumeMetric.liters 
            ? base * 0.621371 // mi/L
            : base * 2.35215; // mi/gal (MPG)
        }

      case 'travelCost':
        double base = record.getTravelCost(); // Cost/km
        return distanceMetric == DistanceMetric.kilometers ? base : base * 1.60934; // Cost/mi
        
      default:
        return 0.0;
    }
  }
}
