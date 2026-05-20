import 'package:benzinapp/filters/abstract_filter.dart';
import '../services/classes/malfunction.dart';

enum MalfunctionStatusFilter { fixed, unfixed, both }
enum MalfunctionGroupBy { status, severity, none }

class MalfunctionFilter extends AbstractFilter<Malfunction> {
  String? searchString;
  MalfunctionStatusFilter statusFilter;
  Set<int> severities;
  MalfunctionGroupBy groupBy;

  MalfunctionFilter({
    this.searchString,
    this.statusFilter = MalfunctionStatusFilter.both,
    this.severities = const {},
    this.groupBy = MalfunctionGroupBy.none,
  }) {
    if (severities.isEmpty) {
      severities = {1, 2, 3, 4, 5};
    }
  }

  @override
  bool matches(Malfunction model) {
    if (searchString != null && searchString!.isNotEmpty) {
      final query = searchString!.toLowerCase();
      final inTitle = model.title.toLowerCase().contains(query);
      final inLocation = model.location?.toLowerCase().contains(query) ?? false;
      final inDescription = model.description.toLowerCase().contains(query);

      if (!(inTitle || inLocation || inDescription)) {
        return false;
      }
    }

    if (statusFilter == MalfunctionStatusFilter.fixed && !model.isFixed()) return false;
    if (statusFilter == MalfunctionStatusFilter.unfixed && model.isFixed()) return false;

    if (severities.isNotEmpty && !severities.contains(model.severity)) return false;

    return true;
  }
}
