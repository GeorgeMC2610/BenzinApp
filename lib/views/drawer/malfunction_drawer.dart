import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/filters/malfunction_filter.dart';
import 'package:benzinapp/services/managers/malfunction_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class MalfunctionDrawerContent extends StatefulWidget {
  const MalfunctionDrawerContent({super.key});

  @override
  State<StatefulWidget> createState() => _MalfunctionDrawerContentState();
}

class _MalfunctionDrawerContentState extends State<MalfunctionDrawerContent> {
  TextEditingController searchController = TextEditingController();
  MalfunctionStatusFilter statusFilter = MalfunctionStatusFilter.both;
  Set<int> selectedSeverities = {1, 2, 3, 4, 5};
  MalfunctionGroupBy groupBy = MalfunctionGroupBy.none;

  @override
  void initState() {
    super.initState();
    final filter = MalfunctionManager().filter;
    if (filter != null) {
      searchController.text = filter.searchString ?? '';
      statusFilter = filter.statusFilter;
      selectedSeverities = Set.from(filter.severities);
      groupBy = filter.groupBy;
    }
  }

  _discardFilters() {
    MalfunctionManager().removeFilters();
    Navigator.of(context).pop();
  }

  _applyFilters() {
    var newFilter = MalfunctionFilter(
      searchString: searchController.text,
      statusFilter: statusFilter,
      severities: selectedSeverities,
      groupBy: groupBy,
    );

    MalfunctionManager().filter = newFilter;
    MalfunctionManager().applyFilters();
    Navigator.of(context).pop();
  }

  Widget _buildFilterField({
    required TextEditingController controller,
    required String label,
    TextInputType type = TextInputType.text,
    IconData icon = Icons.tune,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
    child: TextField(
      controller: controller,
      keyboardType: type,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            translate('malfunctionFilters'),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFilterField(
                  controller: searchController,
                  label: translate('searchInMalfunctions'),
                  icon: Icons.search,
                ),
                const SizedBox(height: 20),
                Text(translate('statusFilter'), style: const TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<MalfunctionStatusFilter>(
                  isExpanded: true,
                  value: statusFilter,
                  onChanged: (MalfunctionStatusFilter? newValue) {
                    setState(() {
                      statusFilter = newValue!;
                    });
                  },
                  items: [
                    DropdownMenuItem(value: MalfunctionStatusFilter.both, child: Text(translate('allStatuses'))),
                    DropdownMenuItem(value: MalfunctionStatusFilter.fixed, child: Text(translate('onlyFixed'))),
                    DropdownMenuItem(value: MalfunctionStatusFilter.unfixed, child: Text(translate('onlyUnfixed'))),
                  ],
                ),
                const SizedBox(height: 20),
                Text(translate('severityFilter'), style: const TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8.0,
                  children: List<Widget>.generate(5, (int index) {
                    int severity = index + 1;
                    return FilterChip(
                      label: Text(severity.toString()),
                      selected: selectedSeverities.contains(severity),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedSeverities.add(severity);
                          } else {
                            selectedSeverities.remove(severity);
                          }
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 20),
                Text(translate('groupBy'), style: const TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<MalfunctionGroupBy>(
                  isExpanded: true,
                  value: groupBy,
                  onChanged: (MalfunctionGroupBy? newValue) {
                    setState(() {
                      groupBy = newValue!;
                    });
                  },
                  items: [
                    DropdownMenuItem(value: MalfunctionGroupBy.none, child: Text(translate('groupNone'))),
                    DropdownMenuItem(value: MalfunctionGroupBy.status, child: Text(translate('groupStatus'))),
                    DropdownMenuItem(value: MalfunctionGroupBy.severity, child: Text(translate('groupSeverity'))),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.tonal(
                  onPressed: _discardFilters,
                  child: Text(translate('discard')),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: _applyFilters,
                  child: Text(translate('apply')),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
