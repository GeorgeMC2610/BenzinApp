import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FuelFillCard extends StatelessWidget {

  const FuelFillCard({
    super.key,
    required this.record
  });

  static const days = {
    0  : "Sunday",
    1  : "Monday",
    2  : "Tuesday",
    3  : "Wednesday",
    4  : "Thursday",
    5  : "Friday",
    6  : "Saturday",
  };

  final FuelFillRecord record;

  @override
  Widget build(BuildContext context) {

    return ListTile(
      title: Text(
          "${days[record.dateTime.weekday]} ${record.dateTime.day}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
      ),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [

          // EDIT BUTTON
          FloatingActionButton.small(
            onPressed: () {},
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            child: const Icon(Icons.edit),
          ),

          // DELETE BUTTON
          FloatingActionButton.small(
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