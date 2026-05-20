import 'package:benzinapp/filters/abstract_filter.dart';
import '../services/classes/service.dart';

class ServiceFilter extends AbstractFilter<Service> {
  String? searchString;
  ({double? start, double? end})? km;
  ({double? start, double? end})? cost;
  ({DateTime? start, DateTime? end})? period;

  ServiceFilter({
    this.searchString,
    this.km,
    this.cost,
    this.period,
  });

  @override
  bool matches(Service model) {
    if (searchString != null && searchString!.isNotEmpty) {
      final query = searchString!.toLowerCase();
      final inDescription = model.description.toLowerCase().contains(query);
      final inLocation = model.location?.toLowerCase().contains(query) ?? false;

      if (!(inDescription || inLocation)) {
        return false;
      }
    }

    if (!withinRange(model.kilometersDone.toDouble(), start: km?.start, end: km?.end)) return false;
    if (model.cost != null) {
      if (!withinRange(model.cost!, start: cost?.start, end: cost?.end)) return false;
    } else if (cost?.start != null || cost?.end != null) {
      return false;
    }

    if (period != null) {
      final start = period!.start;
      final end = period!.end;

      if (start != null && model.dateHappened.isBefore(start)) {
        return false;
      }
      if (end != null && model.dateHappened.isAfter(end)) {
        return false;
      }
    }

    return true;
  }
}
