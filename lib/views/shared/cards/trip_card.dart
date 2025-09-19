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
import '../buttons/card_edit_delete_buttons.dart';
import '../dialogs/delete_dialog.dart';

class TripCard extends StatefulWidget {
  const TripCard({super.key, required this.trip});

  final Trip trip;

  @override
  State<StatefulWidget> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {

  double? totalTravelCost, averageTripCost, averageTripConsumption;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() {
    setState(() {
      totalTravelCost = Car.getTotalTravelCost();
      averageTripConsumption = widget.trip.getAverageTripConsumption(false);
      averageTripCost = widget.trip.getAverageTripConsumption(false);
    });
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
              Text( totalTravelCost == null ? '-' : " €${
                  LocaleStringConverter.formattedDouble(context,
                      widget.trip.totalKm * totalTravelCost!
                  )
              }", style: const TextStyle(
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

          AutoSizeText(maxLines: 1, translate('createdAt', args: {'date': LocaleStringConverter.dateShortDayMonthYearString(context, widget.trip.created)}))
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
            AutoSizeText(averageTripCost == null ? '-' : " €${LocaleStringConverter.formattedDouble(context, averageTripCost!)
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
            AutoSizeText( averageTripConsumption == null ? '-' : " ${
                LocaleStringConverter.formattedDouble(context, averageTripConsumption!)
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

        AutoSizeText(maxLines: 1, translate('createdAt', args: {'date': LocaleStringConverter.dateShortDayMonthYearString(context, widget.trip.created)}))
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
        'Delete Trip',
            (Function(bool) setLoadingState) async {

          await TripManager().delete(widget.trip);
          setLoadingState(true);
        }
    );
  }

}