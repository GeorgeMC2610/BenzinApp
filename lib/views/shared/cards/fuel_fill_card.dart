import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/token_manager.dart';
import 'package:benzinapp/views/details/fuel_fill_record.dart';
import 'package:benzinapp/views/forms/fuel_fill_record.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../services/language_provider.dart';
import 'package:http/http.dart' as http;

class FuelFillCard extends StatefulWidget {

  const FuelFillCard({
    super.key,
    required this.record
  });

  final FuelFillRecord record;

  @override
  State<StatefulWidget> createState() => _FuelFillCardState();
}

class _FuelFillCardState extends State<FuelFillCard> {

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewFuelFillRecord(record: widget.record)
            )
        );
      },
      title: AutoSizeText(
          maxLines: 1,
          getLocalizedDate(context, widget.record.dateTime),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
      ),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [

          // EDIT BUTTON
          FloatingActionButton.small(
            heroTag: null,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FuelFillRecordForm(fuelFillRecord: widget.record)
                  )
              );
            },
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            child: const Icon(Icons.edit),
          ),

          // DELETE BUTTON
          FloatingActionButton.small(
            heroTag: null,
            onPressed: () => deleteDialog(context),
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
          Text("€${widget.record.cost.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
          Text(_getFuelString(), style: const TextStyle(fontSize: 12)),
          Text("${widget.record.getConsumption().toStringAsFixed(3)} lt./100km", style: const TextStyle(fontSize: 12)),
        ],
      ),
    );

  }

  String getLocalizedDate(BuildContext context, DateTime date) {
    final locale = Provider.of<LanguageProvider>(context).currentLocale.toLanguageTag();

    return "${DateFormat.EEEE(locale).format(date)} ${date.day}";
  }

  String _getFuelString() {

    if (widget.record.fuelType == null || widget.record.fuelType!.isEmpty) {

      if (widget.record.gasStation == null || widget.record.gasStation!.isEmpty) {
        return '-';
      }

      return widget.record.gasStation!;
    }

    return widget.record.gasStation == null? widget.record.fuelType! : "${widget.record.fuelType}, ${widget.record.gasStation}";
  }

  Future<void> deleteDialog(BuildContext context) {
    return showDialog<void>(
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
  }
}