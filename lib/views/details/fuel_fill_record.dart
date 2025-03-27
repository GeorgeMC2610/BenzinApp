import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/language_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:benzinapp/views/shared/shared_font_styles.dart';
import 'package:http/http.dart' as http;

import '../../services/token_manager.dart';
import '../forms/fuel_fill_record.dart';

class ViewFuelFillRecord extends StatefulWidget {
  const ViewFuelFillRecord({super.key, required this.record});

  final FuelFillRecord record;

  @override
  State<StatefulWidget> createState() => _ViewFuelFillRecordState();
}

class _ViewFuelFillRecordState extends State<ViewFuelFillRecord> {
  bool _isLoading = false;

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
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FuelFillRecordForm(fuelFillRecord: widget.record, viewingRecord: true)
                    )
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Theme.of(context).buttonTheme.colorScheme?.primary),
                foregroundColor: WidgetStatePropertyAll(Theme.of(context).buttonTheme.colorScheme?.onPrimary),
              ),
              icon: const Icon(Icons.edit),
              label: Text(AppLocalizations.of(context)!.edit)
          ),
          ElevatedButton.icon(
              onPressed: () {
                showDialog<void>(
                    context: context,
                    builder: (BuildContext buildContext) {
                      return AlertDialog(
                        title: Text(AppLocalizations.of(context)!.confirmDeleteFuelFill),
                        content: Text(
                            AppLocalizations.of(context)!.confirmDeleteGenericBody),
                        actions: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(width: 1.0, color: Colors.red),
                            ),
                            child: Text(AppLocalizations.of(context)!.cancel),
                          ),

                          ElevatedButton.icon(
                            icon: _isLoading ? const CircularProgressIndicator(value: null) : null,
                            onPressed: () {

                              setState(() {
                                _isLoading = true;
                              });

                              var client = http.Client();
                              var url = Uri.parse(
                                  '${DataHolder.destination}/fuel_fill_record/${widget.record.id}');

                              client.delete(
                                  url,
                                  headers: {
                                    'Authorization': '${TokenManager().token}'
                                  }
                              ).whenComplete(() {
                                setState(() {
                                  _isLoading = false;
                                });

                                DataHolder.deleteFuelFill(widget.record);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });


                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white
                            ),
                            label: Text(AppLocalizations.of(context)!.delete),
                          ),
                        ],
                      );
                    }
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Theme.of(context).buttonTheme.colorScheme?.error),
                foregroundColor: WidgetStateProperty.all(Theme.of(context).buttonTheme.colorScheme?.onPrimary),
              ),
              icon: const Icon(Icons.delete),
              label: Text(AppLocalizations.of(context)!.delete)
          )
        ],
        body: Consumer<DataHolder>(
            builder: (context, dataHolder, child) {

              return SingleChildScrollView(
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
                                        Text(_getFullDateTimeString(context), style: const TextStyle(fontSize: 18)),
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
                                        Text(AppLocalizations.of(context)!.liters, style: SharedFontStyles.legendTextStyle),
                                        Text("${widget.record.liters} lt", style: SharedFontStyles.descriptiveTextStyle),

                                        const SizedBox(height: 20),

                                        Text(AppLocalizations.of(context)!.kilometers, style: SharedFontStyles.legendTextStyle),
                                        Text("${widget.record.kilometers} km", style: SharedFontStyles.descriptiveTextStyle),

                                        const SizedBox(height: 20),

                                        Text(AppLocalizations.of(context)!.cost, style: SharedFontStyles.legendTextStyle),
                                        Text("€${widget.record.cost}", style: SharedFontStyles.descriptiveTextStyle),
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
                                        Text(AppLocalizations.of(context)!.consumption, style: SharedFontStyles.legendTextStyle),
                                        Text("${widget.record.getConsumption().toStringAsFixed(3)} lt/100km", style: SharedFontStyles.mainTextStyle),

                                        const SizedBox(height: 20),

                                        Text(AppLocalizations.of(context)!.efficiency, style: SharedFontStyles.legendTextStyle),
                                        Text("${widget.record.getEfficiency().toStringAsFixed(3)} km/lt", style: SharedFontStyles.mainTextStyle),

                                        const SizedBox(height: 20),

                                        Text(AppLocalizations.of(context)!.travel_cost, style: SharedFontStyles.legendTextStyle),
                                        Text("${widget.record.getTravelCost().toStringAsFixed(2)} €/km", style: SharedFontStyles.mainTextStyle),
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
                                      widget.record.comments == null ? AppLocalizations.of(context)!.nothingToShowHere : widget.record.comments!,
                                      style: TextStyle(
                                          color: widget.record.comments == null ? Colors.grey : Colors.black,
                                          fontStyle: widget.record.comments == null ? FontStyle.italic : FontStyle.normal
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
              );
            }
        )
    );
  }

  String _getFullDateTimeString(BuildContext context) {
    return DateFormat.yMMMMEEEEd(Provider.of<LanguageProvider>(context).currentLocale.toLanguageTag()).format(widget.record.dateTime);
  }

  String _getFuelString(BuildContext context) {

    if (widget.record.fuelType == null) {

      if (widget.record.gasStation == null) {
        return AppLocalizations.of(context)!.unspecified;
      }

      return widget.record.gasStation!;
    }

    return widget.record.gasStation == null? widget.record.fuelType! : "${widget.record.fuelType}, ${widget.record.gasStation}";
  }
}