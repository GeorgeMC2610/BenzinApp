import 'package:benzinapp/services/classes/service.dart';
import 'package:benzinapp/services/locale_string_converter.dart';
import 'package:benzinapp/services/managers/service_manager.dart';
import 'package:benzinapp/views/details/service.dart';
import 'package:benzinapp/views/forms/service.dart';
import 'package:benzinapp/views/shared/buttons/card_edit_delete_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../services/language_provider.dart';
import '../dialogs/delete_dialog.dart';

class ServiceCard extends StatefulWidget {
  const ServiceCard({super.key, required this.service});

  final Service service;

  @override
  State<StatefulWidget> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {

  @override
  Widget build(BuildContext context) {

    final NumberFormat format = NumberFormat('#,###', Provider.of<LanguageProvider>(context).currentLocale.toLanguageTag());

    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewService(service: widget.service)
            )
        );
      },
      title: Text(
          "${format.format(widget.service.kilometersDone)} km",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
      ),
      trailing: CardEditDeleteButtons(
        onEditButtonPressed: edit,
        onDeleteButtonPressed: edit,
      ),

      // SERVICE DATA
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.service.cost == null ? '-' : "€${LocaleStringConverter.formattedDouble(context, widget.service.cost!)}", style: const TextStyle(fontSize: 16)),
          Text(widget.service.dateHappened.toString().substring(0, 10), style: const TextStyle(fontSize: 15)),
          Text("${translate('nextAtKm')} ${getNextServiceInfo()}", style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  edit() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ServiceForm(service: widget.service)
        )
    );
  }

  delete() {
    DeleteDialog.show(
        context,
        translate('confirmDeleteService'),
            (Function(bool) setLoadingState) async {

          await ServiceManager().delete(widget.service);
          setLoadingState(true);
        }
    );
  }

  String getNextServiceInfo() {
    if (widget.service.nextServiceKilometers == null && widget.service.nextServiceDate == null) return '-';

    if (widget.service.nextServiceKilometers == null) {
      return '${translate('before')} ${widget.service.nextServiceDate!.toIso8601String().substring(0, 10)}';
    }

    if (widget.service.nextServiceDate == null) {
      return '${translate('at')} ${LocaleStringConverter.formattedBigInt(context, widget.service.nextServiceKilometers!)} km';
    }

    return '${translate('at')} '
        '${LocaleStringConverter.formattedBigInt(context, widget.service.nextServiceKilometers!)} km '
        '${translate('orBefore')} ${widget.service.nextServiceDate!.toIso8601String().substring(0, 10)}';

  }

}