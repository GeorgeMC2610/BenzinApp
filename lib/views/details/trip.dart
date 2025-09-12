import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/locale_string_converter.dart';
import 'package:benzinapp/services/managers/trip_manager.dart';
import 'package:benzinapp/views/maps/view_trip.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/classes/trip.dart';
import '../forms/trip.dart';
import '../shared/dialogs/delete_dialog.dart';
import '../shared/shared_font_styles.dart';

class ViewTrip extends StatefulWidget {
  const ViewTrip({super.key, required this.trip});

  final Trip trip;

  @override
  State<StatefulWidget> createState() => _ViewTripState();
}

class _ViewTripState extends State<ViewTrip> {

  late Trip trip;

  double? bestTripCost, averageTripCost, worstTripCost;
  double? bestConsumption, averageConsumption, worstConsumption;

  double? bestRepeatingTripCost, averageRepeatingTripCost, worstRepeatingTripCost;
  double? bestRepeatingConsumption, averageRepeatingConsumption, worstRepeatingConsumption;

  @override
  void initState() {
    super.initState();
    trip = widget.trip;
    initialize();
  }

  initialize() async {
    final bestTripCost = await trip.getBestTripCost(true);
    final bestRepeatingTripCost = await trip.getBestTripCost(false);

    final averageTripCost = await trip.getAverageTripCost(true);
    final averageRepeatingTripCost = await trip.getAverageTripCost(false);

    final worstTripCost = await trip.getWorstTripCost(true);
    final worstRepeatingTripCost = await trip.getWorstTripCost(false);

    final bestConsumption = await trip.getBestTripConsumption(true);
    final bestRepeatingConsumption = await trip.getBestTripConsumption(false);

    final averageConsumption = await trip.getAverageTripConsumption(true);
    final averageRepeatingConsumption = await trip.getAverageTripConsumption(false);

    final worstConsumption = await trip.getWorstTripConsumption(true);
    final worstRepeatingConsumption = await trip.getWorstTripConsumption(false);

    setState(() {
      this.bestTripCost = bestTripCost;
      this.bestRepeatingTripCost = bestRepeatingTripCost;

      this.averageTripCost = averageTripCost;
      this.averageRepeatingTripCost = averageRepeatingTripCost;

      this.worstTripCost = worstTripCost;
      this.worstRepeatingTripCost = worstRepeatingTripCost;

      this.bestConsumption = bestConsumption;
      this.bestRepeatingConsumption = bestRepeatingConsumption;

      this.averageConsumption = averageConsumption;
      this.averageRepeatingConsumption = averageRepeatingConsumption;

      this.worstConsumption = worstConsumption;
      this.worstRepeatingConsumption = worstRepeatingConsumption;
    });

  }


  TextStyle mainDescription(Color color) => TextStyle(
      fontSize: 20.5,
      fontWeight: FontWeight.bold,
      color: color
  );

  TextStyle legendDescription(Color color) => TextStyle(
      fontSize: 14.5,
      color: color
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('tripData')),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      persistentFooterAlignment: AlignmentDirectional.centerStart,
      // EDIT AND DELETE BUTTONS
      persistentFooterButtons: [
        ElevatedButton.icon(
            onPressed: () async {
              var trip = await Navigator.push<Trip>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TripForm(trip: this.trip, isViewing: true)
                  )
              );

              if (trip != null) {
                setState(() {
                  this.trip = trip;
                });
              }
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Theme.of(context).buttonTheme.colorScheme?.primary),
              foregroundColor: WidgetStatePropertyAll(Theme.of(context).buttonTheme.colorScheme?.onPrimary),
            ),
            icon: const Icon(Icons.edit),
            label: Text(translate('edit'))
        ),
        ElevatedButton.icon(
            onPressed: () {
              DeleteDialog.show(
                  context,
                  translate('confirmDeleteService'),
                      (Function(bool) setLoadingState) async {

                    await TripManager().delete(widget.trip);
                    setLoadingState(true);
                    Navigator.pop(context);
                  }
              );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Theme.of(context).buttonTheme.colorScheme?.error),
              foregroundColor: WidgetStateProperty.all(Theme.of(context).buttonTheme.colorScheme?.onPrimary),
            ),
            icon: const Icon(Icons.delete),
            label: Text(translate('delete'))
        )
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              // === CARD WITH BASE DATA ===
                SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(translate('tripName'), style: SharedFontStyles.legendTextStyle),
                        Text(
                            trip.title,
                            style: SharedFontStyles.mainTextStyle
                        ),

                        const SizedBox(height: 20),

                        Text(translate('weeklyOccurrence'), style: SharedFontStyles.legendTextStyle),
                        AutoSizeText(
                            maxLines: 1,
                            trip.timesRepeating == 1 ? translate('noRepeat') :
                            translate('repeatingTimesPerWeek', args: {'n': trip.timesRepeating}),
                            style: SharedFontStyles.descriptiveTextStyle
                        ),

                        const SizedBox(height: 20),

                        Text(translate('tripDistance'), style: SharedFontStyles.legendTextStyle),
                        Text(
                          '${LocaleStringConverter.formattedDouble(context, trip.totalKm)} km',
                          style: SharedFontStyles.descriptiveTextStyle
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // === ANALYTICS PER ONE TIME === //
              DividerWithText(
                  text: translate('analyticsPerTime'),
                  lineColor: Colors.grey ,
                  textColor: Theme.of(context).colorScheme.primary,
                  textSize: 17,
                  barThickness: 3,
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        bestTripCost == null ? const Text('') : Text(
                          '€${LocaleStringConverter.formattedDouble(context, bestTripCost!)} '
                          '${translate('perTime')}',
                          style: mainDescription(Colors.green)
                        ),
                        bestConsumption == null ? const Text('') : Text(
                          '${LocaleStringConverter.formattedDouble(context, bestConsumption!)} lt. '
                          '${translate('perTime')}',
                          style: legendDescription(Colors.green)
                        ),

                        const SizedBox(height: 10),

                        averageTripCost == null ? const Text('') : Text(
                            '€${LocaleStringConverter.formattedDouble(context, averageTripCost!)} '
                            '${translate('perTime')}',
                            style: mainDescription(Colors.grey)
                        ),
                        averageConsumption == null ? const Text('') : Text(
                            '${LocaleStringConverter.formattedDouble(context, averageConsumption!)} lt. '
                            '${translate('perTime')}',
                            style: legendDescription(Colors.grey)
                        ),

                        const SizedBox(height: 10),

                        worstTripCost == null ? const Text('') : Text(
                            '€${LocaleStringConverter.formattedDouble(context, worstTripCost!)} '
                            '${translate('perTime')}',
                            style: mainDescription(Colors.redAccent)
                        ),
                        worstConsumption == null ? const Text('') : Text(
                            '${LocaleStringConverter.formattedDouble(context, worstConsumption!)} lt. '
                            '${translate('perTime')}',
                            style: legendDescription(Colors.redAccent)
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // === ANALYTICS PER WEEK === //
              trip.timesRepeating == 1 ? const SizedBox() :
              Column(
                children: [
                  DividerWithText(
                    text: translate('weeklyAnalytics'),
                    lineColor: Colors.grey ,
                    textColor: Theme.of(context).colorScheme.primary,
                    textSize: 17,
                    barThickness: 3,
                  ),

                  // TITLE AND DESCRIPTION
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: Card(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            bestRepeatingTripCost == null ? const Text('') : Text(
                                '€${LocaleStringConverter.formattedDouble(context, bestRepeatingTripCost!)} '
                                '${translate('perWeek')}',
                                style: mainDescription(Colors.green)
                            ),
                            bestRepeatingConsumption == null ? const Text('') : Text(
                                '${LocaleStringConverter.formattedDouble(context, bestRepeatingConsumption!)} lt. '
                                '${translate('perWeek')}',
                                style: legendDescription(Colors.green)
                            ),

                            const SizedBox(height: 10),

                            averageRepeatingTripCost == null ? const Text('') : Text(
                                '${LocaleStringConverter.formattedDouble(context, averageRepeatingTripCost!)} lt. '
                                    '${translate('perWeek')}',
                                style: mainDescription(Colors.grey)
                            ),
                            averageRepeatingConsumption == null ? const Text('') : Text(
                                '${LocaleStringConverter.formattedDouble(context, averageRepeatingConsumption!)} lt. '
                                    '${translate('perWeek')}',
                                style: legendDescription(Colors.grey)
                            ),

                            const SizedBox(height: 10),

                            worstRepeatingTripCost == null ? const Text('') : Text(
                                '${LocaleStringConverter.formattedDouble(context, worstRepeatingTripCost!)} lt. '
                                    '${translate('perWeek')}',
                                style: mainDescription(Colors.redAccent)
                            ),
                            worstRepeatingConsumption == null ? const Text('') : Text(
                                '${LocaleStringConverter.formattedDouble(context, worstRepeatingConsumption!)} lt. '
                                    '${translate('perWeek')}',
                                style: legendDescription(Colors.redAccent)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              DividerWithText(
                text: translate('mapDetails'),
                lineColor: Colors.grey ,
                textColor: Theme.of(context).colorScheme.primary,
                textSize: 17,
                barThickness: 3,
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          trip.originAddress,
                          textAlign: TextAlign.center,
                          style: SharedFontStyles.mainTextStyle
                        ),
                        const Icon(Icons.pin_drop_sharp, size: 40, color: Colors.green,),
                        const SizedBox(height: 15),
                        const Icon(FontAwesomeIcons.arrowDownLong, size: 40),
                        const SizedBox(height: 20),
                        const Icon(Icons.pin_drop_sharp, size: 40, color: Colors.red,),
                        Text(
                            trip.destinationAddress,
                            textAlign: TextAlign.center,
                            style: SharedFontStyles.mainTextStyle
                        ),

                        const SizedBox(height: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewTripOnMaps(
                                        polyline: trip.polyline,
                                        positions: [
                                          LatLng(trip.originLatitude, trip.originLongitude),
                                          LatLng(trip.destinationLatitude, trip.destinationLongitude)
                                        ],
                                        addresses: [
                                          trip.originAddress,
                                          trip.destinationAddress
                                        ],
                                      )
                                  )
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondaryContainer
                            ),
                            label: Text(translate('showOnMaps')),
                            icon: const Icon(Icons.map),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );


  }
}