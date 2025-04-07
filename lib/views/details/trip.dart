import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/service.dart';
import 'package:benzinapp/services/locale_string_converter.dart';
import 'package:benzinapp/views/maps/view_trip.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/classes/trip.dart';
import '../../services/data_holder.dart';
import '../../services/request_handler.dart';
import '../forms/service.dart';
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

  @override
  void initState() {
    super.initState();
    trip = widget.trip;
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
        title: Text(AppLocalizations.of(context)!.tripData),
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
            label: Text(AppLocalizations.of(context)!.edit)
        ),
        ElevatedButton.icon(
            onPressed: () {
              DeleteDialog.show(
                  context,
                  AppLocalizations.of(context)!.confirmDeleteService,
                      (Function(bool) setLoadingState) {

                    RequestHandler.sendDeleteRequest(
                      '${DataHolder.destination}/repeated_trip/${trip.id}',
                          () {
                        setLoadingState(true); // Close the dialog
                      },
                          (response) {
                        DataHolder.deleteTrip(trip);
                        Navigator.pop(context);
                      },
                    );
                  }
              );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Theme.of(context).buttonTheme.colorScheme?.error),
              foregroundColor: WidgetStateProperty.all(Theme.of(context).buttonTheme.colorScheme?.onPrimary),
            ),
            icon: const Icon(Icons.delete),
            label: Text(AppLocalizations.of(context)!.delete)
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
                        Text(AppLocalizations.of(context)!.tripName, style: SharedFontStyles.legendTextStyle),
                        Text(
                            trip.title,
                            style: SharedFontStyles.mainTextStyle
                        ),

                        const SizedBox(height: 20),

                        Text(AppLocalizations.of(context)!.weeklyOccurrence, style: SharedFontStyles.legendTextStyle),
                        AutoSizeText(
                            maxLines: 1,
                            trip.timesRepeating == 1 ? AppLocalizations.of(context)!.noRepeat :
                            AppLocalizations.of(context)!.repeatingTimesPerWeek(trip.timesRepeating),
                            style: SharedFontStyles.descriptiveTextStyle
                        ),

                        const SizedBox(height: 20),

                        Text(AppLocalizations.of(context)!.tripDistance, style: SharedFontStyles.legendTextStyle),
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
                  text: AppLocalizations.of(context)!.analyticsPerTime,
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
                        Text(
                          '€${LocaleStringConverter.formattedDouble(context, trip.getBestTripCost(true))} '
                          '${AppLocalizations.of(context)!.perTime}',
                          style: mainDescription(Colors.green)
                        ),
                        Text(
                          '${LocaleStringConverter.formattedDouble(context, trip.getBestTripConsumption(true))} lt. '
                          '${AppLocalizations.of(context)!.perTime}',
                          style: legendDescription(Colors.green)
                        ),

                        const SizedBox(height: 10),

                        Text(
                            '€${LocaleStringConverter.formattedDouble(context, trip.getAverageTripCost(true))} '
                            '${AppLocalizations.of(context)!.perTime}',
                            style: mainDescription(Colors.grey)
                        ),
                        Text(
                            '${LocaleStringConverter.formattedDouble(context, trip.getAverageTripConsumption(true))} lt. '
                            '${AppLocalizations.of(context)!.perTime}',
                            style: legendDescription(Colors.grey)
                        ),

                        const SizedBox(height: 10),

                        Text(
                            '€${LocaleStringConverter.formattedDouble(context, trip.getWorstTripCost(true))} '
                            '${AppLocalizations.of(context)!.perTime}',
                            style: mainDescription(Colors.redAccent)
                        ),
                        Text(
                            '${LocaleStringConverter.formattedDouble(context, trip.getWorstTripConsumption(true))} lt. '
                            '${AppLocalizations.of(context)!.perTime}',
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
                    text: AppLocalizations.of(context)!.weeklyAnalytics,
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
                            Text(
                                '€${LocaleStringConverter.formattedDouble(context, trip.getBestTripCost(false))} '
                                '${AppLocalizations.of(context)!.perWeek}',
                                style: mainDescription(Colors.green)
                            ),
                            Text(
                                '${LocaleStringConverter.formattedDouble(context, trip.getBestTripConsumption(false))} lt. '
                                '${AppLocalizations.of(context)!.perWeek}',
                                style: legendDescription(Colors.green)
                            ),

                            const SizedBox(height: 10),

                            Text(
                                '€${LocaleStringConverter.formattedDouble(context, trip.getAverageTripCost(false))} '
                                '${AppLocalizations.of(context)!.perWeek}',
                                style: mainDescription(Colors.grey)
                            ),
                            Text(
                                '${LocaleStringConverter.formattedDouble(context, trip.getAverageTripConsumption(false))} lt. '
                                '${AppLocalizations.of(context)!.perWeek}',
                                style: legendDescription(Colors.grey)
                            ),

                            const SizedBox(height: 10),

                            Text(
                                '€${LocaleStringConverter.formattedDouble(context, trip.getWorstTripCost(false))} '
                                '${AppLocalizations.of(context)!.perWeek}',
                                style: mainDescription(Colors.redAccent)
                            ),
                            Text(
                                '${LocaleStringConverter.formattedDouble(context, trip.getWorstTripConsumption(false))} lt. '
                                '${AppLocalizations.of(context)!.perWeek}',
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
                text: AppLocalizations.of(context)!.mapDetails,
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
                            label: Text(AppLocalizations.of(context)!.showOnMaps),
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