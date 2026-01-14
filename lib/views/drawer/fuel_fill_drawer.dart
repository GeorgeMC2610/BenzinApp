import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/filters/fuel_fill_filter.dart';
import 'package:benzinapp/services/managers/fuel_fill_record_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class FuelFillDrawer extends StatefulWidget {
  const FuelFillDrawer({super.key});

  @override
  State<StatefulWidget> createState() => _FuelFillDrawerState();
}

class _FuelFillDrawerState extends State<FuelFillDrawer> {

  TextEditingController startKmController = TextEditingController();
  TextEditingController endKmController = TextEditingController();
  TextEditingController startTotalKmController = TextEditingController();
  TextEditingController endTotalKmController = TextEditingController();
  TextEditingController startLtController = TextEditingController();
  TextEditingController endLtController = TextEditingController();
  TextEditingController startCostController = TextEditingController();
  TextEditingController endCostController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    final filter = FuelFillRecordManager().filter;
    if (filter != null) {
      startDate = filter.period?.start;
      endDate = filter.period?.end;
      searchController.text = filter.searchString?.toString() ?? '';
      startKmController.text = filter.km?.start?.toString() ?? '';
      endKmController.text = filter.km?.end?.toString() ?? '';
      startTotalKmController.text = filter.totalKm?.start?.toString() ?? '';
      endTotalKmController.text = filter.totalKm?.end?.toString() ?? '';
      startLtController.text = filter.lt?.start?.toString() ?? '';
      endLtController.text = filter.lt?.end?.toString() ?? '';
      startCostController.text = filter.cost?.start?.toString() ?? '';
      endCostController.text = filter.cost?.end?.toString() ?? '';
    }
  }

  _discardFilters() {
    FuelFillRecordManager().removeFilters();
    Navigator.of(context).pop();
  }

  _applyFilters() {
    var newFilter = FuelFillRecordManager().filter ?? FuelFillFilter();
    newFilter.searchString = searchController.text;
    newFilter.period = (startDate == null && endDate == null) ? null : (start: startDate, end: endDate);
    newFilter.km = (start: double.tryParse(startKmController.text), end: double.tryParse(endKmController.text));
    newFilter.totalKm = (start: double.tryParse(startTotalKmController.text), end: double.tryParse(endTotalKmController.text));
    newFilter.lt = (start: double.tryParse(startLtController.text), end: double.tryParse(endLtController.text));
    newFilter.cost = (start: double.tryParse(startCostController.text), end: double.tryParse(endCostController.text));

    FuelFillRecordManager().filter = newFilter;
    FuelFillRecordManager().applyFilters();
  }

  _selectDate(bool endDate) async {
    final leastDate = FuelFillRecordManager().local
        ?.map((record) => record.dateTime)
        .reduce((a, b) => a.isBefore(b) ? a : b);

    final mostDate = FuelFillRecordManager().local
        ?.map((record) => record.dateTime)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    final date = await showDatePicker(
        context: context,
        firstDate: leastDate ?? DateTime.parse('1970-01-01'),
        lastDate: mostDate ?? DateTime.now()
    );

    setState(() {
      if (endDate) {
        this.endDate = date;
      }
      else {
        startDate = date;
      }
    });
  }

  Widget _buildFilterField({
    required TextEditingController controller,
    required String label,
    TextInputType type = TextInputType.number,
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
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                translate('fuelFilters'),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // search
                    _buildFilterField(
                      controller: searchController,
                      label: translate('searchHint'),
                      type: TextInputType.text,
                      icon: Icons.search,
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: AutoSizeText(
                             "${translate('fromDate')} ${startDate?.toIso8601String().substring(0, 10) ?? translate('notSelected')}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                            maxLines: 1,
                          ),
                        ),

                        IconButton.filledTonal(
                          onPressed: () => _selectDate(false),
                          icon: const Icon(Icons.calendar_month_sharp),
                        )
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            "${translate('toDate')}  ${endDate?.toIso8601String().substring(0, 10) ?? translate('notSelected')}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                            maxLines: 1,
                          ),
                        ),

                        IconButton.filledTonal(
                          onPressed: () => _selectDate(true),
                          icon: const Icon(Icons.calendar_month_sharp),
                        )
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Km fields
                    _buildFilterField(
                      controller: startKmController,
                      label: translate('startKm'),
                      icon: Icons.speed,
                    ),
                    _buildFilterField(
                      controller: endKmController,
                      label: translate('endKm'),
                      icon: Icons.speed,
                    ),

                    const SizedBox(height: 20),

                    // Total Km fields
                    _buildFilterField(
                      controller: startTotalKmController,
                      label: translate('startTotalKm'),
                      icon: Icons.alt_route,
                    ),
                    _buildFilterField(
                      controller: endTotalKmController,
                      label: translate('endTotalKm'),
                      icon: Icons.alt_route,
                    ),

                    const SizedBox(height: 20),

                    // Liters fields
                    _buildFilterField(
                      controller: startLtController,
                      label: translate('startLt'),
                      icon: Icons.local_gas_station,
                    ),
                    _buildFilterField(
                      controller: endLtController,
                      label: translate('endLt'),
                      icon: Icons.local_gas_station,
                    ),

                    const SizedBox(height: 20),

                    // Cost fields
                    _buildFilterField(
                      controller: startCostController,
                      label: translate('startCost'),
                      icon: Icons.euro,
                    ),
                    _buildFilterField(
                      controller: endCostController,
                      label: translate('endCost'),
                      icon: Icons.euro,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Theme.of(context).colorScheme.errorContainer,
                      ),
                      onPressed: _discardFilters,
                      icon: const Icon(Icons.clear),
                      label: AutoSizeText(translate('discard'), maxLines: 1),
                    ),
                  ),

                  const SizedBox(width: 5),

                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _applyFilters,
                      icon: const Icon(Icons.check),
                      label: AutoSizeText(translate('apply'), maxLines: 1),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}