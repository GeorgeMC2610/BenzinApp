import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewFuelFillRecord extends StatelessWidget {
  const ViewFuelFillRecord({super.key, required this.record});

  final FuelFillRecord record;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fuel Fill Record Data"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      persistentFooterAlignment: AlignmentDirectional.centerStart,
      persistentFooterButtons: [
        ElevatedButton.icon(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Theme.of(context).buttonTheme.colorScheme?.primary),
              foregroundColor: WidgetStatePropertyAll(Theme.of(context).buttonTheme.colorScheme?.onPrimary),
            ),
            icon: const Icon(Icons.edit),
            label: const Text("Edit")
        ),
        ElevatedButton.icon(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Theme.of(context).buttonTheme.colorScheme?.error),
              foregroundColor: WidgetStateProperty.all(Theme.of(context).buttonTheme.colorScheme?.onPrimary),
            ),
            icon: const Icon(Icons.delete),
            label: const Text("Delete")
        )
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // singular card with initial data
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                            const Icon(Icons.access_time_outlined, size: 30,),
                            const SizedBox(width: 15),
                            Text(_getFullDateTimeString(), style: const TextStyle(fontSize: 18)),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            const Icon(Icons.local_gas_station_outlined, size: 30,),
                            const SizedBox(width: 15),
                            Text(
                                _getFuelString(),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: _getFuelString() == 'Unspecified' ? Colors.grey : Colors.black,
                                    fontStyle: _getFuelString() == 'Unspecified' ? FontStyle.italic : FontStyle.normal,
                                ),
                            ),
                          ],
                        ),


                      ],
                    ),
                  ),
                ),
              ),

              Row(
                children: [

                  Expanded(
                    flex: 2,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Liters:", style: legendTextStyle),
                            Text("${record.liters} lt", style: descriptiveTextStyle),

                            const SizedBox(height: 20),

                            const Text("Kilometers:", style: legendTextStyle),
                            Text("${record.kilometers} km", style: descriptiveTextStyle),

                            const SizedBox(height: 20),

                            const Text("Cost:", style: legendTextStyle),
                            Text("€${record.cost}", style: descriptiveTextStyle),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 3,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Consumption:", style: legendTextStyle),
                            Text("${record.getConsumption().toStringAsFixed(3)} lt/100km", style: mainTextStyle),

                            const SizedBox(height: 20),

                            const Text("Efficiency:", style: legendTextStyle),
                            Text("${record.getEfficiency().toStringAsFixed(3)} km/lt", style: mainTextStyle),

                            const SizedBox(height: 20),

                            const Text("Travel Cost:", style: legendTextStyle),
                            Text("${record.getTravelCost().toStringAsFixed(2)} €/km", style: mainTextStyle),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )

            ],
          )
        )
      ),
    );
  }

  static const TextStyle legendTextStyle = TextStyle(
    color: CupertinoColors.systemGrey,
    fontSize: 12
  );

  static const TextStyle descriptiveTextStyle = TextStyle(
    fontSize: 20.5,
  );

  static const TextStyle mainTextStyle = TextStyle(
      fontSize: 20.5,
      fontWeight: FontWeight.bold
  );

  static const days = {
    1  : "Monday",
    2  : "Tuesday",
    3  : "Wednesday",
    4  : "Thursday",
    5  : "Friday",
    6  : "Saturday",
    7  : "Sunday",
  };

  static const months = {
    1  : "January",
    2  : "February",
    3  : "March",
    4  : "April",
    5  : "May",
    6  : "June",
    7  : "July",
    8  : "August",
    9  : "September",
    10 : "October",
    11 : "November",
    12 : "December"
  };

  String _getFullDateTimeString() {
    return "${days[record.dateTime.weekday]}, ${record.dateTime.day} ${months[record.dateTime.month]} ${record.dateTime.year}";
  }

  String _getFuelString() {

    if (record.fuelType == null) {

      if (record.gasStation == null) {
        return 'Unspecified';
      }

      return record.gasStation!;
    }

    return record.gasStation == null? record.fuelType! : "${record.fuelType}, ${record.gasStation}";
  }

}