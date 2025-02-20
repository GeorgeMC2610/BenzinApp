import 'package:benzinapp/services/classes/malfunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../services/language_provider.dart';

class MalfunctionCard extends StatelessWidget {
  const MalfunctionCard({super.key, required this.malfunction});

  final Malfunction malfunction;

  @override
  Widget build(BuildContext context) {

    final NumberFormat format = NumberFormat('#,###', Provider.of<LanguageProvider>(context).currentLocale.toLanguageTag());

    return ListTile(
      title: Text(
          malfunction.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
      ),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [

          // EDIT BUTTON
          FloatingActionButton.small(
            onPressed: () {},
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            child: const Icon(Icons.edit),
          ),

          // DELETE BUTTON
          FloatingActionButton.small(
            onPressed: () {},
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
          Text(malfunction.dateStarted.toString().substring(0, 10), style: const TextStyle(fontSize: 16)),
          Text(malfunction.dateEnded == null ?
          AppLocalizations.of(context)!.ongoingMalfunction :
          AppLocalizations.of(context)!.fixedMalfunction,
            style: TextStyle(
              fontSize: 12,
              color: malfunction.dateEnded == null ? Colors.red : Colors.green,
            )
          ),
          Text("${AppLocalizations.of(context)!.discoveredAt} ${format.format(malfunction.kilometersDiscovered)} km", style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

}