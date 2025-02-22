import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/service.dart';
import 'package:benzinapp/services/locale_string_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../shared/shared_font_styles.dart';

class ViewService extends StatelessWidget {
  const ViewService({super.key, required this.service});

  final Service service;

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
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Theme.of(context).buttonTheme.colorScheme?.primary),
              foregroundColor: WidgetStatePropertyAll(Theme.of(context).buttonTheme.colorScheme?.onPrimary),
            ),
            icon: const Icon(Icons.edit),
            label: Text(AppLocalizations.of(context)!.edit)
        ),
        ElevatedButton.icon(
            onPressed: () {},
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
                            Text(service.location ?? '-', style: SharedFontStyles.descriptiveTextStyle),
                            Center(
                              child: service.location == null ? const SizedBox() : ElevatedButton.icon(
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