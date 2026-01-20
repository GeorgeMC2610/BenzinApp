import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/car.dart';
import 'package:benzinapp/services/classes/trip.dart';
import 'package:benzinapp/services/locale_string_converter.dart';
import 'package:benzinapp/views/details/trip.dart';
import 'package:benzinapp/views/forms/trip.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../../services/managers/trip_manager.dart';
import '../../../services/managers/user_manager.dart';
import '../buttons/card_edit_delete_buttons.dart';
import '../dialogs/delete_dialog.dart';

class TripCard extends StatefulWidget {
  const TripCard({super.key, required this.trip});

  final Trip trip;

  @override
  State<StatefulWidget> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {

  double totalTravelCost = Car.getTotalTravelCost();

  late double averageTripCost;
  late double averageTripConsumption;

  late double repeatingAverageTripCost;
  late double repeatingAverageTripConsumption;

  @override
  void initState() {
    super.initState();
    averageTripCost = widget.trip.getAverageTripCost(true);
    averageTripConsumption = widget.trip.getAverageTripConsumption(true);

    repeatingAverageTripCost = widget.trip.getAverageTripCost(false);
    repeatingAverageTripConsumption = widget.trip.getAverageTripConsumption(false);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => ViewTrip(trip: widget.trip)
          )
        );
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
      trailing: CardEditDeleteButtons(
        onEditButtonPressed: edit,
        onDeleteButtonPressed: delete,
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
              Text(" ${translate('oneTimeTrip')}", )
            ],
          ),

          const SizedBox(height: 5),

          Row(
            children: [
              const Icon(FontAwesomeIcons.coins, size: 18,),
              const SizedBox(width: 5),
              Text(" €${LocaleStringConverter.formattedDouble(context, widget.trip.totalKm * totalTravelCost)}",
                style: const TextStyle(
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

          AutoSizeText(maxLines: 1, translate('createdAt', args: {'date': LocaleStringConverter.dateShortDayMonthYearString(context, widget.trip.created)})),
          if (widget.trip.createdByUsername != null && widget.trip.createdByUsername != UserManager().currentUser!.username)
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
                  widget.trip.createdByUsername!,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
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
            Text(" ${translate('repeatingTimesPerWeekShort', args: {'n': widget.trip.timesRepeating})}", )
          ],
        ),

        const SizedBox(height: 5),

        Row(
          children: [
            const Icon(FontAwesomeIcons.coins, size: 18,),
            const SizedBox(width: 5),
            AutoSizeText("€${LocaleStringConverter.formattedDouble(context, repeatingAverageTripCost)
                } ${translate('perWeek')}",
                maxFontSize: 18,
                style: const TextStyle(
                  fontWeight: FontWeight.bold
            )),
          ],
        ),

        Row(
          children: [
            const Icon(FontAwesomeIcons.gasPump, size: 18,),
            const SizedBox(width: 5),
            AutoSizeText(" ${
                LocaleStringConverter.formattedDouble(context, repeatingAverageTripConsumption)
            } lt. ${translate('perWeek')}",
                maxFontSize: 18,
                style: const TextStyle(
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

        AutoSizeText(maxLines: 1, translate('createdAt', args: {'date': LocaleStringConverter.dateShortDayMonthYearString(context, widget.trip.created)})),
        if (widget.trip.createdByUsername != null && widget.trip.createdByUsername != UserManager().currentUser!.username)
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
                widget.trip.createdByUsername!,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
      ],
    );
  }

  edit() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TripForm(trip: widget.trip)
        )
    );
  }

  delete() {
    DeleteDialog.show(
        context,
        translate('deleteTrip'),
            (Function(bool) setLoadingState) async {

          await TripManager().delete(widget.trip);
          setLoadingState(true);
        }
    );
  }

}