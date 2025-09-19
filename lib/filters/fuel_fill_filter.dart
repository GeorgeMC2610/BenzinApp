import 'package:benzinapp/filters/abstract_filter.dart';
import '../services/classes/fuel_fill_record.dart';

class FuelFillFilter extends AbstractFilter<FuelFillRecord> {

  String? searchString;
  ({double? start, double? end})? km;
  ({double? start, double? end})? totalKm;
  ({double? start, double? end})? lt;
  ({double? start, double? end})? cost;
  ({DateTime? start, DateTime? end})? period;

  FuelFillFilter({
    this.searchString,
    this.km,
    this.lt,
    this.cost,
    this.period,
  });

  @override
  bool matches(FuelFillRecord model) {
    if (searchString != null && searchString!.isNotEmpty) {
      final query = searchString!.toLowerCase();
      final inStation = model.gasStation?.toLowerCase().contains(query) ?? false;
      final inFuelType = model.fuelType?.toLowerCase().contains(query) ?? false;
      final inId = model.id.toString() == searchString;

      if (!(inStation || inFuelType || inId)) {
        return false;
      }
    }

    if (!withinRange(model.kilometers, start: km?.start, end: km?.end)) return false;
    if (!withinRange(model.liters, start: lt?.start, end: lt?.end)) return false;
    if (!withinRange(model.cost, start: cost?.start, end: cost?.end)) return false;

    if (model.totalKilometers != null) {
      if (!withinRange(model.totalKilometers!, start: totalKm?.start, end: totalKm?.end)) return false;
    }

    if (period != null) {
      final start = period!.start;
      final end = period!.end;

      if (start != null && model.dateTime.isBefore(start)) {
        return false;
      }
      if (end != null && model.dateTime.isAfter(end)) {
        return false;
      }
    }

    return true;
  }
}