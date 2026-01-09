import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/car.dart';
import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/services/managers/fuel_fill_record_manager.dart';
import 'package:benzinapp/services/managers/service_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../services/classes/fuel_fill_record.dart';
import '../../services/classes/service.dart';
import '../../services/locale_string_converter.dart';
import '../shared/cards/loading_data_card.dart';
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
  Widget build(BuildContext context) => Consumer2<FuelFillRecordManager, ServiceManager>(
    builder: (context, fuelManager, serviceManager, _) {
      if (fuelManager.local == null || serviceManager.local == null) {
        return const LoadingDataCard();
      }

      car = CarManager().watchingCar;
      lastService = ServiceManager().local?.firstOrNull;
      lastRecord = FuelFillRecordManager().local?.firstOrNull;
      mostRecentTotalKilometers = Car.getMostRecentTotalKilometers();

      return normalBody();
    },
  );

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

                    // info with the user owner
                    if (!car!.isOwned())
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person, size: 25),
                          const SizedBox(width: 10),
                          Text(car!.ownerUsername.toString())
                        ],
                      ),

                    Row(
                      children: [
                        const Icon(Icons.directions_car, size: 25),
                        const SizedBox(width: 10),
                        Text(car!.username),
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

  bool _canServiceBeDisplayed(Service? service) {
    if (service == null) return false;
    if (service.nextServiceKilometers == null) return false;

    return true;
  }

  String _getDaysString(BuildContext context, FuelFillRecord record) {

    var difference = record.dateTime.difference(DateTime.now());

    if (difference.inDays > 0) {
      return translate('youPlannedYourFuelFill');
    }
    else if (difference.inDays == 0) {
      return translate('lastFilledToday');
    }
    else if (difference.inDays == -1) {
      return translate('lastFilledYesterday');
    }
    else if (difference.inDays >= -30) {
      return translate('lastFilledDaysAgo', args: {'amountOfDays': difference.inDays.abs()});
    }
    else {
      return translate('lastFilledAtDate', args: {'date': record.dateTime.toString().substring(0, 10)});
    }

  }

  Widget getServiceCard(Service lastService) {
    if (mostRecentTotalKilometers == null) {
      return StatusCard(
          icon: const Icon(FontAwesomeIcons.wrench),
          text: '${translate('nextServiceAt')} ${LocaleStringConverter.formattedBigInt(context, lastService.nextServiceKilometers!)} km',
          status: StatusCardIndex.warning
      );
    }

    String message;
    StatusCardIndex status;
    var difference = lastService.nextServiceKilometers! - mostRecentTotalKilometers!;

    if (difference < 0) {
      message = translate('serviceOverdueInKm', args: {'amount': LocaleStringConverter.formattedBigInt(context, difference.abs())} );
      status = StatusCardIndex.bad;
    }
    else if (difference < 200) {
      message = translate('nextServiceInKm', args: {'amount': LocaleStringConverter.formattedBigInt(context, difference)});
      status = StatusCardIndex.bad;
    }
    else if (difference < 600) {
      message = translate('nextServiceInKm', args: {'amount': LocaleStringConverter.formattedBigInt(context, difference)});
      status = StatusCardIndex.warning;
    }
    else {
      message = translate('nextServiceInKm', args: {'amount': LocaleStringConverter.formattedBigInt(context, difference)});
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
      message = translate('serviceOverdueInDays', args: {'amount': difference.inDays.abs()});
      index = StatusCardIndex.bad;
    }
    else if (difference.inDays < 1) {
      message = translate('serviceDueToday');
      index = StatusCardIndex.bad;
    }
    else if (difference.inDays < 2) {
      message = translate('serviceDueTomorrow');
      index = StatusCardIndex.bad;
    }
    else if (difference.inDays < 30) {
      message = translate('serviceDueInDays', args: {'amount': difference.inDays});
      index = StatusCardIndex.warning;
    }
    else if (difference.inDays < 365) {
      message = translate('serviceDueInMonths', args: {'amount': difference.inDays~/30});
      index = StatusCardIndex.good;
    }
    else {
      message = translate('serviceDueInDateTime', args: {'date': LocaleStringConverter.dateShortDayMonthYearString(context, lastService.nextServiceDate!)});
      index = StatusCardIndex.good;
    }

    return StatusCard(
      icon: const Icon(FontAwesomeIcons.calendar),
      text: message,
      status: index,
    );
  }

}