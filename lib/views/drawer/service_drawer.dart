import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/filters/service_filter.dart';
import 'package:benzinapp/services/managers/service_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ServiceDrawerContent extends StatefulWidget {
  const ServiceDrawerContent({super.key});

  @override
  State<StatefulWidget> createState() => _ServiceDrawerContentState();
}

class _ServiceDrawerContentState extends State<ServiceDrawerContent> {
  TextEditingController searchController = TextEditingController();
  TextEditingController startKmController = TextEditingController();
  TextEditingController endKmController = TextEditingController();
  TextEditingController startCostController = TextEditingController();
  TextEditingController endCostController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    final filter = ServiceManager().filter;
    if (filter != null) {
      searchController.text = filter.searchString ?? '';
      startKmController.text = filter.km?.start?.toString() ?? '';
      endKmController.text = filter.km?.end?.toString() ?? '';
      startCostController.text = filter.cost?.start?.toString() ?? '';
      endCostController.text = filter.cost?.end?.toString() ?? '';
      startDate = filter.period?.start;
      endDate = filter.period?.end;
    }
  }

  _discardFilters() {
    ServiceManager().removeFilters();
    Navigator.of(context).pop();
  }

  _applyFilters() {
    var newFilter = ServiceFilter(
      searchString: searchController.text,
      km: (start: double.tryParse(startKmController.text), end: double.tryParse(endKmController.text)),
      cost: (start: double.tryParse(startCostController.text), end: double.tryParse(endCostController.text)),
      period: (startDate == null && endDate == null) ? null : (start: startDate, end: endDate),
    );

    ServiceManager().filter = newFilter;
    ServiceManager().applyFilters();
    Navigator.of(context).pop();
  }

  _selectDate(bool isEndDate) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.parse('1970-01-01'),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    setState(() {
      if (isEndDate) {
        endDate = date;
      } else {
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            translate('serviceFilters'),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildFilterField(
                  controller: searchController,
                  label: translate('searchInServices'),
                  type: TextInputType.text,
                  icon: Icons.search,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text("${translate('fromDate')} ${startDate?.toIso8601String().substring(0, 10) ?? translate('notSelected')}"),
                    ),
                    IconButton(
                      onPressed: () => _selectDate(false),
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text("${translate('toDate')} ${endDate?.toIso8601String().substring(0, 10) ?? translate('notSelected')}"),
                    ),
                    IconButton(
                      onPressed: () => _selectDate(true),
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildFilterField(controller: startKmController, label: translate('startKm'), icon: Icons.speed),
                _buildFilterField(controller: endKmController, label: translate('endKm'), icon: Icons.speed),
                const SizedBox(height: 20),
                _buildFilterField(controller: startCostController, label: translate('startCost'), icon: Icons.euro),
                _buildFilterField(controller: endCostController, label: translate('endCost'), icon: Icons.euro),
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
