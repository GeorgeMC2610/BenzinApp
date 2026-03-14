import 'package:benzinapp/services/distance_metric_provider.dart';
import 'package:benzinapp/services/volume_metric_provider.dart';
import 'package:benzinapp/services/classes/fuel_fill_record.dart';

class FuelMetricService {
  static String getConsumptionOrEfficiency(
      FuelFillRecord record,
      DistanceMetric distanceMetric,
      VolumeMetric volumeMetric) {
    
    // Base values (Metric)
    double consumption = record.getConsumption(); // L/100km
    double efficiency = record.getEfficiency();    // km/L

    String cLabel = getConsumptionLabel(distanceMetric, volumeMetric);
    String eLabel = getEfficiencyLabel(distanceMetric, volumeMetric);

    if (distanceMetric == DistanceMetric.kilometers) {
      if (volumeMetric == VolumeMetric.liters) {
        return "${consumption.toStringAsFixed(3)} $cLabel";
      } else {
        double galPer100km = consumption * 0.264172; 
        return "${galPer100km.toStringAsFixed(3)} $cLabel";
      }
    } else {
      if (volumeMetric == VolumeMetric.liters) {
        double miPerLiter = efficiency * 0.621371;
        return "${miPerLiter.toStringAsFixed(3)} $eLabel";
      } else {
        double mpg = 235.215 / consumption;
        return "${mpg.toStringAsFixed(3)} mpg";
      }
    }
  }

  static double getConvertedConsumption(double baseLitersPer100km, DistanceMetric distanceMetric, VolumeMetric volumeMetric) {
    if (distanceMetric == DistanceMetric.kilometers) {
      return volumeMetric == VolumeMetric.liters ? baseLitersPer100km : baseLitersPer100km * 0.264172;
    } else {
      return volumeMetric == VolumeMetric.liters 
          ? baseLitersPer100km * 1.60934  // L/100mi
          : baseLitersPer100km * 0.425144; // Gal/100mi
    }
  }

  static double getConvertedEfficiency(double baseKmPerLiter, DistanceMetric distanceMetric, VolumeMetric volumeMetric) {
    if (distanceMetric == DistanceMetric.kilometers) {
      return volumeMetric == VolumeMetric.liters ? baseKmPerLiter : baseKmPerLiter / 3.78541; // km/gal
    } else {
      return volumeMetric == VolumeMetric.liters 
          ? baseKmPerLiter * 0.621371 // mi/L
          : baseKmPerLiter * 2.35215; // mi/gal (MPG)
    }
  }

  static double getConvertedTravelCost(double baseCostPerKm, DistanceMetric distanceMetric) {
    return distanceMetric == DistanceMetric.kilometers ? baseCostPerKm : baseCostPerKm * 1.60934;
  }

  static String getConsumptionLabel(DistanceMetric distanceMetric, VolumeMetric volumeMetric) {
    final dist = distanceMetric == DistanceMetric.miles ? 'mi' : 'km';
    final vol = volumeMetric == VolumeMetric.gallons ? 'gal' : 'lt';
    return "$vol./100 $dist";
  }

  static String getEfficiencyLabel(DistanceMetric distanceMetric, VolumeMetric volumeMetric) {
    final dist = distanceMetric == DistanceMetric.miles ? 'mi' : 'km';
    final vol = volumeMetric == VolumeMetric.gallons ? 'gal' : 'lt';
    if (distanceMetric == DistanceMetric.miles && volumeMetric == VolumeMetric.gallons) return "mpg";
    return "$dist/$vol";
  }

  static double getChartValue(
      FuelFillRecord record,
      String focusType, // consumption, efficiency, travelCost
      DistanceMetric distanceMetric,
      VolumeMetric volumeMetric) {
    
    switch (focusType) {
      case 'consumption':
        return getConvertedConsumption(record.getConsumption(), distanceMetric, volumeMetric);
      case 'efficiency':
        return getConvertedEfficiency(record.getEfficiency(), distanceMetric, volumeMetric);
      case 'travelCost':
        return getConvertedTravelCost(record.getTravelCost(), distanceMetric);
      default:
        return 0.0;
    }
  }
}
