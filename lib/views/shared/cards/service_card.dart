import 'package:benzinapp/services/classes/service.dart';
import 'package:benzinapp/services/locale_string_converter.dart';
import 'package:benzinapp/services/managers/service_manager.dart';
import 'package:benzinapp/views/details/service.dart';
import 'package:benzinapp/views/forms/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../services/data_holder.dart';
import '../../../services/language_provider.dart';
import '../../../services/request_handler.dart';
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
                      builder: (context) => ServiceForm(service: widget.service)
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
                  AppLocalizations.of(context)!.confirmDeleteService,
                      (Function(bool) setLoadingState) async {

                      await ServiceManager().delete(widget.service);
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

      // SERVICE DATA
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.service.cost == null ? '-' : "€${LocaleStringConverter.formattedDouble(context, widget.service.cost!)}", style: const TextStyle(fontSize: 16)),
          Text(widget.service.dateHappened.toString().substring(0, 10), style: const TextStyle(fontSize: 15)),
          Text("${AppLocalizations.of(context)!.nextAtKm} ${getNextServiceInfo()}", style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  String getNextServiceInfo() {
    if (widget.service.nextServiceKilometers == null && widget.service.nextServiceDate == null) return '-';

    if (widget.service.nextServiceKilometers == null) {
      return '${AppLocalizations.of(context)!.before} ${widget.service.nextServiceDate!.toIso8601String().substring(0, 10)}';
    }

    if (widget.service.nextServiceDate == null) {
      return '${AppLocalizations.of(context)!.at} ${LocaleStringConverter.formattedBigInt(context, widget.service.nextServiceKilometers!)} km';
    }

    return '${AppLocalizations.of(context)!.at} '
        '${LocaleStringConverter.formattedBigInt(context, widget.service.nextServiceKilometers!)} km '
        '${AppLocalizations.of(context)!.orBefore} ${widget.service.nextServiceDate!.toIso8601String().substring(0, 10)}';

  }

}