import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/service.dart';
import 'package:benzinapp/services/locale_string_converter.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        title: Text(AppLocalizations.of(context)!.serviceData),
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
              // CARD WITH BASE DATA
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
                        Text('Name:', style: SharedFontStyles.legendTextStyle),
                        Text(
                            trip.title,
                            style: SharedFontStyles.mainTextStyle
                        ),

                        const SizedBox(height: 20),

                        Text('Weekly Occurance:', style: SharedFontStyles.legendTextStyle),
                        Text(
                            trip.timesRepeating == 1 ? "Doesn't repeat" :
                            'Repeating ${widget.trip.timesRepeating} times per week',
                            style: SharedFontStyles.descriptiveTextStyle
                        ),

                        const SizedBox(height: 20),

                        Text('Trip Distance:', style: SharedFontStyles.legendTextStyle),
                        Text(
                          '${LocaleStringConverter.formattedDouble(context, trip.totalKm)} km',
                          style: SharedFontStyles.descriptiveTextStyle
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              DividerWithText(
                  text: 'Analytics Per Time',
                  lineColor: Colors.grey ,
                  textColor: Colors.black,
                  textSize: 17,
                  barThickness: 3,
              ),

              // TITLE AND DESCRIPTION
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
                        Text(trip.title, style: mainDescription(Colors.green)),
                        Text(trip.title, style: legendDescription(Colors.green)),

                        const SizedBox(height: 10),

                        Text(trip.title, style: mainDescription(Colors.grey)),
                        Text(trip.title, style: legendDescription(Colors.grey)),

                        const SizedBox(height: 10),

                        Text(trip.title, style: mainDescription(Colors.redAccent)),
                        Text(trip.title, style: legendDescription(Colors.redAccent)),
                      ],
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
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
                            Text(AppLocalizations.of(context)!.cost, style: SharedFontStyles.legendTextStyle),
                            Text(
                                trip.totalKm == null ?
                                '-' :
                                '€${LocaleStringConverter.formattedDouble(context, trip.totalKm)}',
                                style: SharedFontStyles.descriptiveTextStyle
                            ),

                            const SizedBox(height: 20),

                            Text(AppLocalizations.of(context)!.nextAtKm, style: SharedFontStyles.legendTextStyle),
                            Text(
                                trip.totalKm == null ?
                                '-' :
                                '${LocaleStringConverter.formattedBigInt(context, trip.timesRepeating)} km',
                                style: SharedFontStyles.descriptiveTextStyle
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Expanded(
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
                            Text(AppLocalizations.of(context)!.location, style: SharedFontStyles.legendTextStyle),
                            Text(trip.originAddress ?? '-', style: SharedFontStyles.descriptiveTextStyle),
                            Center(
                              child: trip.originAddress == null ? const SizedBox() : ElevatedButton.icon(
                                onPressed: () {},
                                label: AutoSizeText(AppLocalizations.of(context)!.seeOnMap, maxLines: 1, minFontSize: 8),
                                icon: const Icon(Icons.pin_drop, size: 20.3,),
                                style: const ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(Colors.orange),
                                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                                ),
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );


  }
}