import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

enum DateRangePreset {
  lastMonth,
  lastTwoMonths,
  lastThreeMonths,
  lastFourMonths,
  lastSixMonths,
  lastTenMonths,
  lastTwelveMonths,
  lifetime,
  custom
}

class DateRangePicker extends StatefulWidget {
  final Function(DateTime start, DateTime end) onRangeSelected;

  const DateRangePicker({super.key, required this.onRangeSelected});

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  DateRangePreset _selectedPreset = DateRangePreset.lastThreeMonths;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 90));
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Default to lifetime which is already set
  }

  void _updateRange(DateRangePreset preset) async {
    DateTime now = DateTime.now();
    DateTime start;
    DateTime end = now;

    switch (preset) {
      case DateRangePreset.lastMonth:
        start = DateTime(now.year, now.month - 1, now.day);
        break;
      case DateRangePreset.lastTwoMonths:
        start = DateTime(now.year, now.month - 2, now.day);
        break;
      case DateRangePreset.lastThreeMonths:
        start = DateTime(now.year, now.month - 3, now.day);
        break;
      case DateRangePreset.lastFourMonths:
        start = DateTime(now.year, now.month - 4, now.day);
        break;
      case DateRangePreset.lastSixMonths:
        start = DateTime(now.year, now.month - 6, now.day);
        break;
      case DateRangePreset.lastTenMonths:
        start = DateTime(now.year, now.month - 10, now.day);
        break;
      case DateRangePreset.lastTwelveMonths:
        start = DateTime(now.year, now.month - 12, now.day);
        break;
      case DateRangePreset.lifetime:
        start = DateTime(2000);
        break;
      case DateRangePreset.custom:
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime.now().add(const Duration(days: 1)),
          initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
        );
        if (picked != null) {
          setState(() {
            _selectedPreset = DateRangePreset.custom;
            _startDate = picked.start;
            _endDate = picked.end;
          });
          widget.onRangeSelected(_startDate, _endDate);
        }
        return;
    }

    setState(() {
      _selectedPreset = preset;
      _startDate = start;
      _endDate = end;
    });
    widget.onRangeSelected(_startDate, _endDate);
  }

  String _getPresetLabel(DateRangePreset preset) {
    switch (preset) {
      case DateRangePreset.lastMonth:
        return translate('lastMonth');
      case DateRangePreset.lastTwoMonths:
        return translate('lastTwoMonths');
      case DateRangePreset.lastThreeMonths:
        return translate('lastThreeMonths');
      case DateRangePreset.lastFourMonths:
        return translate('lastFourMonths');
      case DateRangePreset.lastSixMonths:
        return translate('lastSixMonths');
      case DateRangePreset.lastTenMonths:
        return translate('lastTenMonths');
      case DateRangePreset.lastTwelveMonths:
        return translate('lastTwelveMonths');
      case DateRangePreset.lifetime:
        return translate('lifetime');
      case DateRangePreset.custom:
        return translate('customRange');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(77),
                width: 1),
          ),
          child: DropdownButton<DateRangePreset>(
            value: _selectedPreset,
            items: DateRangePreset.values.map((preset) {
              return DropdownMenuItem(
                value: preset,
                child: Text(_getPresetLabel(preset)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                _updateRange(value);
              }
            },
            dropdownColor: Theme.of(context).colorScheme.surfaceContainerLow,
            style: TextStyle(
                fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
            icon: Icon(Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.onSurface),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            borderRadius: BorderRadius.circular(15),
            underline: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        if (_selectedPreset == DateRangePreset.custom)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: Text(
              "${DateFormat('dd-MM-yy', Localizations.localeOf(context).toString()).format(_startDate)} - ${DateFormat('dd-MM-yy', Localizations.localeOf(context).toString()).format(_endDate)}",
              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ),
      ],
    );
  }
}
