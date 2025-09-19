import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/service.dart';
import 'package:benzinapp/services/locale_string_converter.dart';
import 'package:benzinapp/services/managers/service_manager.dart';
import 'package:benzinapp/views/maps/view_trip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
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
        title: Text(translate('serviceData')),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      persistentFooterAlignment: AlignmentDirectional.centerStart,
      // EDIT AND DELETE BUTTONS
      persistentFooterButtons: [
        Row(
          children: [
            Expanded(
              child: FilledButton.tonalIcon(
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
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  ),
                  icon: const Icon(Icons.edit),
                  label: Text(translate('edit'))
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: FilledButton.tonalIcon(
                  onPressed: () {
                    DeleteDialog.show(
                        context,
                        translate('confirmDeleteService'),
                            (Function(bool) setLoadingState) async {

                          await ServiceManager().delete(widget.service);
                          setLoadingState(true);
                          Navigator.pop(context);
                        }
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                  ),
                  icon: const Icon(Icons.delete),
                  label: Text(translate('delete'))
              ),
            )
          ],
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
                        Text(translate('dateDone'), style: SharedFontStyles.legendTextStyle),
                        Text(
                            LocaleStringConverter.dateDayMonthYearString(context, service.dateHappened),
                            style: SharedFontStyles.descriptiveTextStyle
                        ),

                        const SizedBox(height: 20),

                        Text(translate('serviceMileage'), style: SharedFontStyles.legendTextStyle),
                        Text(
                          '${LocaleStringConverter.formattedBigInt(context, service.kilometersDone)} km',
                          style: SharedFontStyles.descriptiveTextStyle
                        ),

                        const SizedBox(height: 20),

                        Text(translate('cost'), style: SharedFontStyles.legendTextStyle),
                        Text(
                            '€${LocaleStringConverter.formattedDouble(context, service.cost!)}',
                            style: SharedFontStyles.descriptiveTextStyle
                        ),
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
                        Text(translate('description'), style: SharedFontStyles.legendTextStyle),
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
                            Text(translate('nextAtKm'), style: SharedFontStyles.legendTextStyle),
                            Text(
                                getNextServiceInfo(),
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
                            Text(translate('location'), style: SharedFontStyles.legendTextStyle),
                            Text(service.getAddress() ?? '-', style: SharedFontStyles.descriptiveTextStyle),
                            Center(
                              child: service.getAddress() == null ? const SizedBox() : ElevatedButton.icon(
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
                                label: AutoSizeText(translate('seeOnMap'), maxLines: 1, minFontSize: 8),
                                icon: const Icon(Icons.pin_drop, size: 20.3,),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
                                  foregroundColor: Theme.of(context).colorScheme.onPrimaryFixedVariant
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

  String getNextServiceInfo() {
    if (service.nextServiceKilometers == null && service.nextServiceDate == null) return '-';

    if (service.nextServiceKilometers == null) {
      return '${translate('before')} ${service.nextServiceDate!.toIso8601String().substring(0, 10)}';
    }

    if (service.nextServiceDate == null) {
      return '${translate('at')} ${LocaleStringConverter.formattedBigInt(context, service.nextServiceKilometers!)} km';
    }

    return '${translate('at')} '
        '${LocaleStringConverter.formattedBigInt(context, service.nextServiceKilometers!)} km '
        '${translate('orBefore')} ${service.nextServiceDate!.toIso8601String().substring(0, 10)}';

  }
}