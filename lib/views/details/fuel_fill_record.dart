import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ViewFuelFillRecord extends StatelessWidget {
  const ViewFuelFillRecord({super.key, required this.record});

  final FuelFillRecord record;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.fuelFillRecordData),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      persistentFooterAlignment: AlignmentDirectional.centerStart,
      // EDIT AND DELETE BUTTONS
      persistentFooterButtons: [
        ElevatedButton.icon(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Theme.of(context).buttonTheme.colorScheme?.primary),
              foregroundColor: WidgetStatePropertyAll(Theme.of(context).buttonTheme.colorScheme?.onPrimary),
            ),
            icon: const Icon(Icons.edit),
            label: Text(AppLocalizations.of(context)!.edit)
        ),
        ElevatedButton.icon(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Theme.of(context).buttonTheme.colorScheme?.error),
              foregroundColor: WidgetStateProperty.all(Theme.of(context).buttonTheme.colorScheme?.onPrimary),
            ),
            icon: const Icon(Icons.delete),
            label: Text(AppLocalizations.of(context)!.delete)
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
                                _getFuelString(context),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: _getFuelString(context) == AppLocalizations.of(context)!.unspecified ? Colors.grey : Colors.black,
                                    fontStyle: _getFuelString(context) == AppLocalizations.of(context)!.unspecified ? FontStyle.italic : FontStyle.normal,
                                ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // TWO CARDS WITH THE DATA AND THE STATS
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
                            Text(AppLocalizations.of(context)!.liters, style: legendTextStyle),
                            Text("${record.liters} lt", style: descriptiveTextStyle),

                            const SizedBox(height: 20),

                            Text(AppLocalizations.of(context)!.kilometers, style: legendTextStyle),
                            Text("${record.kilometers} km", style: descriptiveTextStyle),

                            const SizedBox(height: 20),

                            Text(AppLocalizations.of(context)!.cost, style: legendTextStyle),
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
                            Text(AppLocalizations.of(context)!.consumption, style: legendTextStyle),
                            Text("${record.getConsumption().toStringAsFixed(3)} lt/100km", style: mainTextStyle),

                            const SizedBox(height: 20),

                            Text(AppLocalizations.of(context)!.efficiency, style: legendTextStyle),
                            Text("${record.getEfficiency().toStringAsFixed(3)} km/lt", style: mainTextStyle),

                            const SizedBox(height: 20),

                            Text(AppLocalizations.of(context)!.travel_cost, style: legendTextStyle),
                            Text("${record.getTravelCost().toStringAsFixed(2)} €/km", style: mainTextStyle),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

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
                            const Icon(Icons.comment_outlined, size: 15, color: CupertinoColors.systemGrey,),
                            const SizedBox(width: 5),
                            Text(AppLocalizations.of(context)!.comments, style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Text(
                          record.comments == null ? AppLocalizations.of(context)!.nothingToShowHere : record.comments!,
                          style: TextStyle(
                            color: record.comments == null ? Colors.grey : Colors.black,
                            fontStyle: record.comments == null ? FontStyle.italic : FontStyle.normal
                          ),
                        )

                      ],
                    ),
                  ),
                ),
              ),
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

  String _getFullDateTimeString() {
    return DateFormat.yMMMMEEEEd().format(record.dateTime);
  }

  String _getFuelString(BuildContext context) {

    if (record.fuelType == null) {

      if (record.gasStation == null) {
        return AppLocalizations.of(context)!.unspecified;
      }

      return record.gasStation!;
    }

    return record.gasStation == null? record.fuelType! : "${record.fuelType}, ${record.gasStation}";
  }

}