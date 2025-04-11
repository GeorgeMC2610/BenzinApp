import 'package:benzinapp/services/classes/malfunction.dart';
import 'package:benzinapp/views/details/malfunction.dart';
import 'package:benzinapp/views/forms/malfunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          _getStatus(),
          _getSeverity(),
          Text("${AppLocalizations.of(context)!.discoveredAt} ${format.format(widget.malfunction.kilometersDiscovered)} km", style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _getStatus() {
    final isFixed = widget.malfunction.dateEnded != null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isFixed
              ? AppLocalizations.of(context)!.fixedMalfunction
              : AppLocalizations.of(context)!.ongoingMalfunction,
          style: TextStyle(
            fontSize: 14,
            color: isFixed ? Colors.green : Colors.red,
          ),
        ),
        if (isFixed) ...[
          const SizedBox(width: 4),
          const Icon(Icons.check_circle, color: Colors.green, size: 18),
        ],
      ],
    );
  }

  Widget _getSeverity() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        severityIconIndex[widget.malfunction.severity]!,
        const SizedBox(width: 5),
        Text(
          severityStringIndex[widget.malfunction.severity]!,
          style: TextStyle(
            fontSize: 14,
            color: severityColorIndex[widget.malfunction.severity]!,
          ),
        ),
      ],
    );
  }

  static const Map<int, String> severityStringIndex = {
    1: 'Lowest',
    2: 'Low',
    3: 'Normal',
    4: 'High',
    5: 'Highest'
  };

  static const Map<int, Color> severityColorIndex = {
    1: Colors.blue,
    2: Colors.lightBlue,
    3: Colors.orange,
    4: Colors.red,
    5: Color.fromARGB(255, 128, 0, 0)
  };

  static const Map<int, Icon> severityIconIndex = {
    1: Icon(Icons.arrow_downward, color: Colors.blue, size: 20),
    2: Icon(Icons.keyboard_arrow_down, color: Colors.lightBlue, size: 20),
    3: Icon(Icons.horizontal_rule_sharp, color: Colors.orange, size: 20),
    4: Icon(Icons.keyboard_arrow_up, color: Colors.red, size: 20),
    5: Icon(Icons.arrow_upward, color:Color.fromARGB(255, 128, 0, 0), size: 20),
  };

}