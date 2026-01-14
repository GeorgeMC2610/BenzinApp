import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/locale_string_converter.dart';
import 'package:benzinapp/services/managers/fuel_fill_record_manager.dart';
import 'package:benzinapp/services/managers/user_manager.dart';
import 'package:benzinapp/views/details/fuel_fill_record.dart';
import 'package:benzinapp/views/forms/fuel_fill_record.dart';
import 'package:benzinapp/views/shared/buttons/card_edit_delete_buttons.dart';
import 'package:benzinapp/views/shared/notification.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../services/language_provider.dart';
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
          getLocalizedDate(context, widget.record.dateTime),
          maxLines: 1,
          maxFontSize: 18,
          minFontSize: 12,
          style: const TextStyle(fontWeight: FontWeight.bold)
      ),
      trailing: CardEditDeleteButtons(
        onEditButtonPressed: edit,
        onDeleteButtonPressed: delete,
      ),

      // FUEL-FILL RECORD DATA
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("€${widget.record.cost.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
          if (widget.record.totalKilometers != null)
            Text('${LocaleStringConverter.formattedBigInt(context, widget.record.totalKilometers!)} km', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text(_getFuelString(), style: const TextStyle(fontSize: 12)),
          Text("${widget.record.getConsumption().toStringAsFixed(3)} lt./100km", style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          if (widget.record.createdByUsername != null && widget.record.createdByUsername != UserManager().currentUser!.username)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.person,
                size: 14,
                color: Colors.blueGrey,
              ),
              const SizedBox(width: 4),
              Text(
                widget.record.createdByUsername!,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );

  }

  edit() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FuelFillRecordForm(fuelFillRecord: widget.record)
        )
    );
  }

  delete() {
    DeleteDialog.show(
        context,
        translate('confirmDeleteFuelFill'),
            (Function(bool) setLoadingState) async {
          setState(() => _isLoading = true);

          await FuelFillRecordManager().delete(widget.record);
          SnackbarNotification.show(MessageType.info, translate('successfullyDeletedFuelFill'));
          setState(() {
            _isLoading = false;
          });
          setLoadingState(true);
        }
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