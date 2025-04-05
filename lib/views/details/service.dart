import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/service.dart';
import 'package:benzinapp/services/locale_string_converter.dart';
import 'package:benzinapp/views/maps/view_trip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../services/data_holder.dart';
import '../../services/request_handler.dart';
import '../forms/service.dart';
import '../shared/dialogs/delete_dialog.dart';
import '../shared/shared_font_styles.dart';

class ViewService extends StatefulWidget {
  const ViewService({super.key, required this.service});

  final Service service;

  @override
  State<StatefulWidget> createState() => _ViewServiceState();
}

class _ViewServiceState extends State<ViewService> {

  late Service service;

  @override
  void initState() {
    super.initState();
    service = widget.service;
  }

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
              var service = await Navigator.push<Service>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ServiceForm(service: this.service, isViewing: true)
                  )
              );

              if (service != null) {
                setState(() {
                  this.service = service;
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
                      '${DataHolder.destination}/service/${service.id}',
                          () {
                        setLoadingState(true); // Close the dialog
                      },
                          (response) {
                        DataHolder.deleteService(service);
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
                        Text(AppLocalizations.of(context)!.dateDone, style: SharedFontStyles.legendTextStyle),
                        Text(
                            LocaleStringConverter.dateDayMonthYearString(context, service.dateHappened),
                            style: SharedFontStyles.descriptiveTextStyle
                        ),

                        const SizedBox(height: 20),

                        Text(AppLocalizations.of(context)!.serviceMileage, style: SharedFontStyles.legendTextStyle),
                        Text('${LocaleStringConverter.formattedBigInt(context, service.kilometersDone)} km', style: SharedFontStyles.descriptiveTextStyle),
                      ],
                    ),
                  ),
                ),
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
                        Text(AppLocalizations.of(context)!.description, style: SharedFontStyles.legendTextStyle),
                        Text(service.description, style: SharedFontStyles.descriptiveTextStyle),
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
                                service.cost == null ?
                                '-' :
                                '€${LocaleStringConverter.formattedDouble(context, service.cost!)}',
                                style: SharedFontStyles.descriptiveTextStyle
                            ),

                            const SizedBox(height: 20),

                            Text(AppLocalizations.of(context)!.nextAtKm, style: SharedFontStyles.legendTextStyle),
                            Text(
                                service.nextServiceKilometers == null ?
                                '-' :
                                '${LocaleStringConverter.formattedBigInt(context, service.nextServiceKilometers!)} km',
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
                            Text(service.getAddress() ?? '-', style: SharedFontStyles.descriptiveTextStyle),
                            Center(
                              child: service.location == null ? const SizedBox() : ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => ViewTripOnMaps(
                                          positions: [service.getCoordinates()!],
                                          addresses: [service.getAddress()!]
                                      )
                                    )
                                  );
                                },
                                label: AutoSizeText(AppLocalizations.of(context)!.seeOnMap, maxLines: 1, minFontSize: 8),
                                icon: const Icon(Icons.pin_drop, size: 20.3,),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
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