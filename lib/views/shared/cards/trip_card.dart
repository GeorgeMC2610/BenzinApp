import 'package:benzinapp/services/classes/trip.dart';
import 'package:benzinapp/services/locale_string_converter.dart';
import 'package:benzinapp/views/forms/trip.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../services/data_holder.dart';
import '../../../services/language_provider.dart';
import '../../../services/request_handler.dart';
import '../dialogs/delete_dialog.dart';

class TripCard extends StatefulWidget {
  const TripCard({super.key, required this.trip});

  final Trip trip;

  @override
  State<StatefulWidget> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {

  @override
  Widget build(BuildContext context) {
    final NumberFormat format = NumberFormat('#,###', Provider
        .of<LanguageProvider>(context)
        .currentLocale
        .toLanguageTag());

    return ListTile(
      onTap: () {

      },

      title: Text(
        widget.trip.title,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
        ),
      ),

      subtitle: getSubtitle(),

      style: ListTileTheme
          .of(context)
          .style,

      // --- === EDIT AND DELETE BUTTONS === ---
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
                      builder: (context) => TripForm(trip: widget.trip)
                  )
              );
            },
            elevation: 0,
            backgroundColor: Theme
                .of(context)
                .primaryColor,
            foregroundColor: Colors.white,
            child: const Icon(Icons.edit),
          ),

          // DELETE BUTTON
          FloatingActionButton.small(
            heroTag: null,
            onPressed: () {
              DeleteDialog.show(
                  context,
                  'Delete Trip',
                      (Function(bool) setLoadingState) {
                    RequestHandler.sendDeleteRequest(
                      '${DataHolder.destination}/repeated_trip/${widget.trip
                          .id}',
                          () {
                        setLoadingState(true); // Close the dialog
                      },
                          (response) {
                        DataHolder.deleteTrip(widget.trip);
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

    );
  }

  Widget getSubtitle() {
    if (widget.trip.timesRepeating == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(FontAwesomeIcons.arrowRight, size: 15,),
              const SizedBox(width: 5),
              const Text(" One-time trip", )
            ],
          ),

          const SizedBox(height: 5),

          Row(
            children: [
              const Icon(FontAwesomeIcons.coins, size: 18,),
              const SizedBox(width: 5),
              Text(" €19.99", style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              )),
            ],
          ),

          const SizedBox(height: 5),

          Row(
            children: [
              const Icon(FontAwesomeIcons.car, size: 15,),
              const SizedBox(width: 5),
              Text(" ${LocaleStringConverter.formattedDouble(context, widget.trip.totalKm)} km")
            ],
          ),

          Text("Created at: ${LocaleStringConverter.dateShortDayMonthYearString(context, widget.trip.created)}")
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(FontAwesomeIcons.arrowRotateRight, size: 15,),
            const SizedBox(width: 5),
            Text(" ${widget.trip.timesRepeating} times per week", )
          ],
        ),

        const SizedBox(height: 5),

        Row(
          children: [
            const Icon(FontAwesomeIcons.coins, size: 18,),
            const SizedBox(width: 5),
            Text(" €19.99 per week", style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            )),
          ],
        ),

        Row(
          children: [
            const Icon(FontAwesomeIcons.gasPump, size: 18,),
            const SizedBox(width: 5),
            Text(" 5.20 lt. per week", style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            )),
          ],
        ),

        const SizedBox(height: 5),

        Row(
          children: [
            const Icon(FontAwesomeIcons.car, size: 15,),
            const SizedBox(width: 5),
            Text(" ${LocaleStringConverter.formattedDouble(context, widget.trip.totalKm)} km")
          ],
        ),

        Text("Created at: ${LocaleStringConverter.dateShortDayMonthYearString(context, widget.trip.created)}")
      ],
    );
  }

}