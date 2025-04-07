import 'package:benzinapp/services/classes/malfunction.dart';
import 'package:benzinapp/views/details/malfunction.dart';
import 'package:benzinapp/views/forms/malfunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../services/data_holder.dart';
import '../../../services/language_provider.dart';
import '../../../services/request_handler.dart';
import '../dialogs/delete_dialog.dart';

class MalfunctionCard extends StatefulWidget {
  const MalfunctionCard({super.key, required this.malfunction});

  final Malfunction malfunction;

  @override
  State<StatefulWidget> createState() => _MalfunctionCardState();
}

class _MalfunctionCardState extends State<MalfunctionCard> {

  @override
  Widget build(BuildContext context) {

    final NumberFormat format = NumberFormat('#,###', Provider.of<LanguageProvider>(context).currentLocale.toLanguageTag());

    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewMalfunction(malfunction: widget.malfunction)
            )
        );
      },
      title: Text(
          widget.malfunction.title,
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
                      builder: (context) => MalfunctionForm(malfunction: widget.malfunction)
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
                  AppLocalizations.of(context)!.confirmDeleteMalfunction,
                      (Function(bool) setLoadingState) {

                    RequestHandler.sendDeleteRequest(
                      '${DataHolder.destination}/malfunction/${widget.malfunction.id}',
                          () {
                        setLoadingState(true); // Close the dialog
                      },
                          (response) {
                        DataHolder.deleteMalfunction(widget.malfunction);
                      },
                    );
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

      // MALFUNCTION DATA
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.malfunction.dateStarted.toString().substring(0, 10), style: const TextStyle(fontSize: 16)),
          Text(widget.malfunction.dateEnded == null ?
          AppLocalizations.of(context)!.ongoingMalfunction :
          AppLocalizations.of(context)!.fixedMalfunction,
            style: TextStyle(
              fontSize: 12,
              color: widget.malfunction.dateEnded == null ? Colors.red : Colors.green,
            )
          ),
          Text("${AppLocalizations.of(context)!.discoveredAt} ${format.format(widget.malfunction.kilometersDiscovered)} km", style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

}