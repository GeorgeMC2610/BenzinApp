import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/car.dart';
import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/services/managers/fuel_fill_record_manager.dart';
import 'package:benzinapp/services/managers/service_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/classes/fuel_fill_record.dart';
import '../../services/classes/service.dart';
import '../../services/locale_string_converter.dart';
import '../shared/status_card.dart';

class CarInfoCard extends StatefulWidget {
  const CarInfoCard({super.key});


  @override createState() => _CarInfoCardState();
}

class _CarInfoCardState extends State<CarInfoCard> {

  Car? car;
  Service? lastService;
  FuelFillRecord? lastRecord;
  int? mostRecentTotalKilometers;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() {
    final car = CarManager().car;
    final lastService = ServiceManager().local.firstOrNull;
    final lastRecord = FuelFillRecordManager().local.firstOrNull;
    final mostRecentTotalKilometers = Car.getMostRecentTotalKilometers();

    setState(() {
      this.car = car;
      this.lastService = lastService;
      this.lastRecord = lastRecord;
      this.mostRecentTotalKilometers = mostRecentTotalKilometers;
    });
  }

  Widget normalBody() => SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)
          ),
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              Row(
              children: [
              Expanded(
              child: AutoSizeText(
                  '${car!.manufacturer} ${car!.model}',
          maxLines: 1,
          maxFontSize: 30,
          style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold
          )
      )
  ),

  const SizedBox(width: 15),

                Material(
                    color: Theme.of(context).colorScheme.secondaryContainer, // Set exact background color
                    borderRadius: BorderRadius.circular(20), // Keep shape consistent
                    elevation: 0, // No shadow
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text(car!.year.toString()),
                    )),

              ],
              ),

                    // fields that show if the car is ok
                    // will be added at a later date
                    // make them customizable pls
                    lastRecord != null ?
                    ListTile(
                      dense: false,
                      title: AutoSizeText(maxLines: 1, _getDaysString(context, lastRecord!)),
                      subtitle: Text(""
                          "${lastRecord!.liters} lt | "
                          "€${lastRecord!.cost.toStringAsFixed(2)}"
                      ),
                      leading: const Icon(FontAwesomeIcons.gasPump),
                    ) :
                    const SizedBox(),

                    _canServiceBeDisplayed(lastService) ? const Divider()
                        : const SizedBox(),

                    _canServiceBeDisplayed(lastService) ? getServiceCard(lastService!) : const SizedBox(),

                    lastService?.nextServiceDate != null ? getServiceCardWithDays(lastService!) : const SizedBox(),

                    // const StatusCard(
                    //     icon: Icon(FontAwesomeIcons.carBattery),
                    //     text: "Battery changed 2 and a half years ago",
                    //     status: StatusCardIndex.bad
                    // ),
                    //
                    // const StatusCard(
                    //     icon: Icon(FontAwesomeIcons.drumSteelpan),
                    //     text: "Tyres changed two months ago",
                    //     status: StatusCardIndex.good
                    // ),
                    //
                    // const StatusCard(
                    //     icon: Icon(FontAwesomeIcons.shower),
                    //     text: "Last car wash 1 month ago",
                    //     status: StatusCardIndex.good
                    // ),
                    //
                    // const StatusCard(
                    //     icon: Icon(FontAwesomeIcons.fileContract),
                    //     text: "Governmental check-up (KTEO) in 2 years",
                    //     status: StatusCardIndex.good
                    // ),
                    //
                    // const StatusCard(
                    //     icon: Icon(FontAwesomeIcons.idCard),
                    //     text: "Gas card in 1 years",
                    //     status: StatusCardIndex.good
                    // ),
                    //
                    // const StatusCard(
                    //   icon: Icon(FontAwesomeIcons.wifi),
                    //   text: "e-PASS is low on money",
                    //   status: StatusCardIndex.warning
                    // )


                  ],
              ),
          )
      ),
  );

  @override
  Widget build(BuildContext context) => normalBody();

  bool _canServiceBeDisplayed(Service? service) {
    if (service == null) return false;
    if (service.nextServiceKilometers == null) return false;

    return true;
  }

  String _getDaysString(BuildContext context, FuelFillRecord record) {

    var difference = record.dateTime.difference(DateTime.now());

    if (difference.inDays > 0) {
      return AppLocalizations.of(context)!.youPlannedYourFuelFill;
    }
    else if (difference.inDays == 0) {
      return AppLocalizations.of(context)!.lastFilledToday;
    }
    else if (difference.inDays == -1) {
      return AppLocalizations.of(context)!.lastFilledYesterday;
    }
    else if (difference.inDays >= -30) {
      return AppLocalizations.of(context)!.lastFilledDaysAgo(difference.inDays.abs());
    }
    else {
      return AppLocalizations.of(context)!.lastFilledAtDate(record.dateTime.toString().substring(0, 10));
    }

  }

  Widget getServiceCard(Service lastService) {
    if (mostRecentTotalKilometers == null) {
      return StatusCard(
          icon: const Icon(FontAwesomeIcons.wrench),
          text: '${AppLocalizations.of(context)!.nextServiceAt} ${LocaleStringConverter.formattedBigInt(context, lastService.nextServiceKilometers!)} km',
          status: StatusCardIndex.warning
      );
    }

    String message;
    StatusCardIndex status;
    var difference = lastService.nextServiceKilometers! - mostRecentTotalKilometers!;

    if (difference < 0) {
      message = AppLocalizations.of(context)!.serviceOverdueInKm(LocaleStringConverter.formattedBigInt(context, difference.abs()));
      status = StatusCardIndex.bad;
    }
    else if (difference < 200) {
      message = AppLocalizations.of(context)!.nextServiceInKm(LocaleStringConverter.formattedBigInt(context, difference));
      status = StatusCardIndex.bad;
    }
    else if (difference < 600) {
      message = AppLocalizations.of(context)!.nextServiceInKm(LocaleStringConverter.formattedBigInt(context, difference));
      status = StatusCardIndex.warning;
    }
    else {
      message = AppLocalizations.of(context)!.nextServiceInKm(LocaleStringConverter.formattedBigInt(context, difference));
      status = StatusCardIndex.good;
    }

    return StatusCard(
        icon: const Icon(FontAwesomeIcons.wrench),
        text: message,
        status: status
    );
  }

  Widget getServiceCardWithDays(Service lastService) {
    var difference = lastService.nextServiceDate!.difference(DateTime.now());
    String message;
    StatusCardIndex index;

    if (difference.inDays < 0) {
      message = AppLocalizations.of(context)!.serviceOverdueInDays(difference.inDays.abs());
      index = StatusCardIndex.bad;
    }
    else if (difference.inDays < 1) {
      message = AppLocalizations.of(context)!.serviceDueToday;
      index = StatusCardIndex.bad;
    }
    else if (difference.inDays < 2) {
      message = AppLocalizations.of(context)!.serviceDueTomorrow;
      index = StatusCardIndex.bad;
    }
    else if (difference.inDays < 30) {
      message = AppLocalizations.of(context)!.serviceDueInDays(difference.inDays);
      index = StatusCardIndex.warning;
    }
    else if (difference.inDays < 365) {
      message = AppLocalizations.of(context)!.serviceDueInMonths((difference.inDays/30).toInt());
      index = StatusCardIndex.good;
    }
    else {
      message = AppLocalizations.of(context)!.serviceDueInDateTime(LocaleStringConverter.dateShortDayMonthYearString(context, lastService.nextServiceDate!));
      index = StatusCardIndex.good;
    }

    return StatusCard(
      icon: const Icon(FontAwesomeIcons.calendar),
      text: message,
      status: index,
    );
  }

}