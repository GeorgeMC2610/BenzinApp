import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/locale_string_converter.dart';
import 'package:benzinapp/services/managers/fuel_fill_record_manager.dart';
import 'package:benzinapp/services/managers/token_manager.dart';
import 'package:benzinapp/views/details/fuel_fill_record.dart';
import 'package:benzinapp/views/forms/fuel_fill_record.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../services/language_provider.dart';
import 'package:http/http.dart' as http;

import '../../../services/request_handler.dart';
import '../dialogs/delete_dialog.dart';

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
            onPressed: () {
              DeleteDialog.show(
                  context,
                  AppLocalizations.of(context)!.confirmDeleteFuelFill,
                      (Function(bool) setLoadingState) async {
                    setState(() => _isLoading = true);

                    await FuelFillRecordManager().delete(widget.record);
                    setState(() {
                      _isLoading = false;
                    });
                    setLoadingState(true);
                  }
              );
            },
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
          widget.record.totalKilometers == null ? const SizedBox() :
          Text('${LocaleStringConverter.formattedBigInt(context, widget.record.totalKilometers!)} km', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text(_getFuelString(), style: const TextStyle(fontSize: 12)),
          widget.record.getNext() == null ? const SizedBox() :
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

}