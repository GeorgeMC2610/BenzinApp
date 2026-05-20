import 'package:benzinapp/services/volume_metric_provider.dart';
import 'package:benzinapp/services/distance_metric_provider.dart';
import 'package:provider/provider.dart';
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
    final distanceProvider = Provider.of<DistanceMetricProvider>(context, listen: false);
    final volumeProvider = Provider.of<VolumeMetricProvider>(context, listen: false);

    if (filter != null) {
      startDate = filter.period?.start;
      endDate = filter.period?.end;
      searchController.text = filter.searchString?.toString() ?? '';

      startKmController.text = filter.km?.start == null ? '' : distanceProvider.convert(filter.km!.start!).toStringAsFixed(1);
      endKmController.text = filter.km?.end == null ? '' : distanceProvider.convert(filter.km!.end!).toStringAsFixed(1);

      startTotalKmController.text = filter.totalKm?.start == null ? '' : distanceProvider.convert(filter.totalKm!.start!).toStringAsFixed(1);
      endTotalKmController.text = filter.totalKm?.end == null ? '' : distanceProvider.convert(filter.totalKm!.end!).toStringAsFixed(1);

      startLtController.text = filter.lt?.start == null ? '' : volumeProvider.convert(filter.lt!.start!).toStringAsFixed(1);
      endLtController.text = filter.lt?.end == null ? '' : volumeProvider.convert(filter.lt!.end!).toStringAsFixed(1);

      startCostController.text = filter.cost?.start?.toString() ?? '';
      endCostController.text = filter.cost?.end?.toString() ?? '';
    }
  }

  _discardFilters() {
    FuelFillRecordManager().removeFilters();
    Navigator.of(context).pop();
  }

  _applyFilters() {
    final distanceProvider = Provider.of<DistanceMetricProvider>(context, listen: false);
    final volumeProvider = Provider.of<VolumeMetricProvider>(context, listen: false);

    var newFilter = FuelFillRecordManager().filter ?? FuelFillFilter();
    newFilter.searchString = searchController.text;
    newFilter.period = (startDate == null && endDate == null) ? null : (start: startDate, end: endDate);

    double? sKm = double.tryParse(startKmController.text);
    double? eKm = double.tryParse(endKmController.text);
    newFilter.km = (
      start: sKm == null ? null : distanceProvider.deconvert(sKm),
      end: eKm == null ? null : distanceProvider.deconvert(eKm)
    );

    double? sTKm = double.tryParse(startTotalKmController.text);
    double? eTKm = double.tryParse(endTotalKmController.text);
    newFilter.totalKm = (
      start: sTKm == null ? null : distanceProvider.deconvert(sTKm),
      end: eTKm == null ? null : distanceProvider.deconvert(eTKm)
    );

    double? sLt = double.tryParse(startLtController.text);
    double? eLt = double.tryParse(endLtController.text);
    newFilter.lt = (
      start: sLt == null ? null : volumeProvider.deconvert(sLt),
      end: eLt == null ? null : volumeProvider.deconvert(eLt)
    );

    newFilter.cost = (start: double.tryParse(startCostController.text), end: double.tryParse(endCostController.text));

    FuelFillRecordManager().filter = newFilter;
    FuelFillRecordManager().applyFilters();
    Navigator.of(context).pop();
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
    final distanceProvider = Provider.of<DistanceMetricProvider>(context);
    final volumeProvider = Provider.of<VolumeMetricProvider>(context);
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
                      label: translate('startKm', args: {'unit': distanceProvider.label}),
                      icon: Icons.speed,
                    ),
                    _buildFilterField(
                      controller: endKmController,
                      label: translate('endKm', args: {'unit': distanceProvider.label}),
                      icon: Icons.speed,
                    ),

                    const SizedBox(height: 20),

                    // Total Km fields
                    _buildFilterField(
                      controller: startTotalKmController,
                      label: translate('startTotalKm', args: {'unit': distanceProvider.label}),
                      icon: Icons.alt_route,
                    ),
                    _buildFilterField(
                      controller: endTotalKmController,
                      label: translate('endTotalKm', args: {'unit': distanceProvider.label}),
                      icon: Icons.alt_route,
                    ),

                    const SizedBox(height: 20),

                    // Liters fields
                    _buildFilterField(
                      controller: startLtController,
                      label: translate('startLt', args: {'unit': volumeProvider.label}),
                      icon: Icons.local_gas_station,
                    ),
                    _buildFilterField(
                      controller: endLtController,
                      label: translate('endLt', args: {'unit': volumeProvider.label}),
                      icon: Icons.local_gas_station,
                    ),

                    const SizedBox(height: 20),

                    // Cost fields
                    _buildFilterField(
                      controller: startCostController,
                      label: translate('startCost'),
                      icon: Icons.payments,
                    ),
                    _buildFilterField(
                      controller: endCostController,
                      label: translate('endCost'),
                      icon: Icons.payments,
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
