import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/views/details/fuel_fill_record.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../services/language_provider.dart';

class FuelFillCard extends StatelessWidget {

  const FuelFillCard({
    super.key,
    required this.record
  });

  final FuelFillRecord record;

  @override
  Widget build(BuildContext context) {

    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewFuelFillRecord(record: record)
            )
        );
      },
      title: AutoSizeText(
          maxLines: 1,
          getLocalizedDate(context, record.dateTime),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
      ),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [

          // EDIT BUTTON
          FloatingActionButton.small(
            heroTag: null,
            onPressed: () {},
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            child: const Icon(Icons.edit),
          ),

          // DELETE BUTTON
          FloatingActionButton.small(
            heroTag: null,
            onPressed: () {},
            elevation: 0,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            child: const Icon(Icons.delete),
          ),
        ],
      ),

      // FUEL-FILL RECORD DATA
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("€${record.cost.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
          Text(_getFuelString(), style: const TextStyle(fontSize: 12)),
          Text("${record.getConsumption().toStringAsFixed(3)} lt./100km", style: const TextStyle(fontSize: 12)),
        ],
      ),
    );

  }

  String getLocalizedDate(BuildContext context, DateTime date) {
    final locale = Provider.of<LanguageProvider>(context).currentLocale.toLanguageTag();

    return "${DateFormat.EEEE(locale).format(date)} ${date.day}";
  }

  String _getFuelString() {

    if (record.fuelType == null) {

      if (record.gasStation == null) {
        return '-';
      }

      return record.gasStation!;
    }

    return record.gasStation == null? record.fuelType! : "${record.fuelType}, ${record.gasStation}";
  }

}