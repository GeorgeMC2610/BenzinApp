import 'package:benzinapp/services/classes/malfunction.dart';
import 'package:benzinapp/views/details/malfunction.dart';
import 'package:benzinapp/views/forms/malfunction.dart';
import 'package:benzinapp/views/shared/buttons/card_edit_delete_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../services/language_provider.dart';
import '../../../services/managers/malfunction_manager.dart';
import '../../../services/managers/user_manager.dart';
import '../dialogs/delete_dialog.dart';
import '../notification.dart';

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
      trailing: CardEditDeleteButtons(
        onEditButtonPressed: edit,
        onDeleteButtonPressed: delete,
      ),

      // MALFUNCTION DATA
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.malfunction.dateStarted.toString().substring(0, 10), style: const TextStyle(fontSize: 16)),
          _getStatus(),
          _getSeverity(),
          Text("${translate('discoveredAt')} ${format.format(widget.malfunction.kilometersDiscovered)} km", style: const TextStyle(fontSize: 12)),
          if (widget.malfunction.createdByUsername != null && widget.malfunction.createdByUsername != UserManager().currentUser!.username)
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
                  widget.malfunction.createdByUsername!,
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
            builder: (context) => MalfunctionForm(malfunction: widget.malfunction)
        )
    );
  }

  delete() {
    DeleteDialog.show(
        context,
        translate('confirmDeleteMalfunction'),
            (Function(bool) setLoadingState) async {

          await MalfunctionManager().delete(widget.malfunction);
          SnackbarNotification.show(
            MessageType.info,
            translate('successfullyDeletedMalfunction'),
          );
          setLoadingState(true);
        }
    );
  }

  Widget _getStatus() {
    final isFixed = widget.malfunction.dateEnded != null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isFixed
              ? translate('fixedMalfunction')
              : translate('ongoingMalfunction'),
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
          severityStringIndex(context)[widget.malfunction.severity]!,
          style: TextStyle(
            fontSize: 14,
            color: severityColorIndex[widget.malfunction.severity]!,
          ),
        ),
      ],
    );
  }

  Map<int, String> severityStringIndex(context) {
    return {
      1: translate('severityLowest'),
      2: translate('severityLow'),
      3: translate('severityNormal'),
      4: translate('severityHigh'),
      5: translate('severityHighest')
    };
  }

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