import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/locale_string_converter.dart';
import 'package:benzinapp/views/charts/costs_pie_chart.dart';
import 'package:benzinapp/views/charts/fuel_trend_line_chart.dart';
import 'package:benzinapp/views/charts/insufficient_data_card.dart';
import 'package:benzinapp/views/shared/status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class OverviewFragment extends StatefulWidget {
  const OverviewFragment({super.key});

  @override
  State<OverviewFragment> createState() => _OverviewFragmentState();
}

class _OverviewFragmentState extends State<OverviewFragment> {

  ChartDisplayFocus _focus = ChartDisplayFocus.consumption;
  int? _selectedFocusValue = 0;

  @override
  Widget build(BuildContext context) {

    return Consumer<DataHolder>(
      builder: (context, dataHolder, child) {

        if (
        DataHolder.getFuelFillRecords() == null ||
        DataHolder.getServices() == null ||
        DataHolder.getCar() == null
        ) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Center(
                child: CircularProgressIndicator(
                  value: null,
                )
            ),
          );
        }

        final FuelFillRecord? lastRecord = DataHolder.getFuelFillRecords()!.isEmpty ? null : DataHolder.getFuelFillRecords()!.first;

        // TODO: Improve the scroll view cards when it's loading.
        // Maybe add cards with a small animation of a progress bar, instead
        // of just a plain circular progress bar.
        return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(AppLocalizations.of(context)!.loggedInAs(DataHolder.getCar()!.username)),

                  const SizedBox(height: 10),

                  // car info container
                  SizedBox(
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
                                          '${DataHolder.getCar()!.manufacturer} ${DataHolder.getCar()!.model}',
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
                                      color: Colors.amber, // Set exact background color
                                      borderRadius: BorderRadius.circular(20), // Keep shape consistent
                                      elevation: 0, // No shadow
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                        child: Text(DataHolder.getCar()!.year.toString()),
                                      )),

                                ],
                              ),

                              // fields that show if the car is ok
                              // will be added at a later date
                              // make them customizable pls
                              lastRecord != null ?
                              ListTile(
                                dense: false,
                                title: AutoSizeText(maxLines: 1, _getDaysString(context, lastRecord)),
                                subtitle: Text(""
                                    "${lastRecord.liters} lt | "
                                    "€${lastRecord.cost.toStringAsFixed(2)}"
                                ),
                                leading: const Icon(FontAwesomeIcons.gasPump),
                              ) :
                              const SizedBox(),

                              const Divider(),

                              const StatusCard(
                                  icon: Icon(FontAwesomeIcons.wrench),
                                  text: "Service overdue by 5 months",
                                  status: StatusCardIndex.bad
                              ),

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
                  ),

                  // graph with consumption container
                  DataHolder.getFuelFillRecords()!.length < 2 ?
                  const InsufficientDataCard()
                      :
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: AutoSizeText(
                                      AppLocalizations.of(context)!.fuelUsageTrend,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold
                                      )
                                  )
                              ),

                              const SizedBox(height: 15),

                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 255, 247, 240), // Background color
                                  borderRadius: BorderRadius.circular(15), // Rounded corners
                                  border: Border.all(color: Colors.black26, width: 1), // Optional border
                                ),
                                child: DropdownButton<int>(
                                  value: _selectedFocusValue, // No default selected
                                  hint: const Text("Select an option"), // TODO: Localize string
                                  items: [
                                    DropdownMenuItem(value: 0, child: Text(AppLocalizations.of(context)!.litersPer100km)),
                                    DropdownMenuItem(value: 1, child: Text(AppLocalizations.of(context)!.kilometersPerLiter)),
                                    DropdownMenuItem(value: 2, child: Text(AppLocalizations.of(context)!.costPerKilometer)),
                                  ],
                                  onChanged: (int? value) {
                                    setState(() {
                                      switch (value!) {
                                        case 0:
                                          _focus = ChartDisplayFocus.consumption;
                                          break;
                                        case 1:
                                          _focus = ChartDisplayFocus.efficiency;
                                          break;
                                        case 2:
                                          _focus = ChartDisplayFocus.travelCost;
                                          break;
                                      }

                                      _selectedFocusValue = value;
                                    });
                                  },
                                  dropdownColor: const Color.fromARGB(255, 255, 247, 240),
                                  style: const TextStyle(fontSize: 13, color: Colors.black),
                                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),

                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  borderRadius: BorderRadius.circular(15), // Rounded corners
                                  underline: Container(
                                    color: Colors.transparent, // Custom underline
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // graph with consumption container
                              FuelTrendLineChart(
                                data: DataHolder.getFuelFillRecords()!,
                                size: 300,
                                focusType: _focus,
                                context: context,
                              ),

                            ],
                          ),
                        )
                    ),
                  ),

                  // cost pie chart
                  // might not be available to show if there are no data
                  _areCostsEmpty() ? const SizedBox() :
                  SizedBox(
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
                              Center(
                                child: AutoSizeText(
                                    AppLocalizations.of(context)!.combinedCosts,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                              ),

                              const SizedBox(height: 20),

                              CostsPieChart(buildContext: context),

                              const SizedBox(height: 20),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "◉ ",
                                    style: TextStyle(
                                        color: Colors.lightGreen.shade500,
                                        fontSize: 25
                                    ),
                                  ),
                                  Text('${AppLocalizations.of(context)!.fuelFills} - €${DataHolder.getTotalFuelFillCosts()}')
                                ],
                              ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "◉ ",
                                    style: TextStyle(
                                        color: Colors.green.shade700,
                                        fontSize: 25
                                    ),
                                  ),
                                  Text('${AppLocalizations.of(context)!.malfunctions} - €${DataHolder.getTotalMalfunctionCosts()}')
                                ],
                              ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "◉ ",
                                    style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 25
                                    ),
                                  ),
                                  Text('${AppLocalizations.of(context)!.services} - €${DataHolder.getTotalServiceCosts()}')
                                ],
                              ),
                            ],
                          ),
                        )
                    ),
                  ),

                  // car average stats container
                  DataHolder.getFuelFillRecords()!.isEmpty ? const SizedBox() :
                  SizedBox(
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
                              Center(
                                  child: AutoSizeText(
                                      AppLocalizations.of(context)!.averageConsumption,
                                      maxLines: 1,
                                      maxFontSize: 25,
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold
                                      )
                                  )
                              ),

                              const SizedBox(height: 15),

                              Text(AppLocalizations.of(context)!.consumption,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text('${LocaleStringConverter.formattedDouble(context, DataHolder.getTotalConsumption())} lt./100 km',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(AppLocalizations.of(context)!.efficiency,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text('${LocaleStringConverter.formattedDouble(context, DataHolder.getTotalEfficiency())} km/lt.',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(AppLocalizations.of(context)!.travel_cost,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text('€${LocaleStringConverter.formattedDouble(context, DataHolder.getTotalTravelCost())}/km',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),

                  // timely manner consumption
                  DataHolder.getFuelFillRecords()!.isEmpty ? const SizedBox() :
                  SizedBox(
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
                              Center(
                                child: AutoSizeText(
                                    AppLocalizations.of(context)!.totalStatistics,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                              ),

                              const SizedBox(height: 15),

                              Text(AppLocalizations.of(context)!.totalLitersFilled,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text('${LocaleStringConverter.formattedDouble(context, DataHolder.getTotalLitersFilled())} lt.',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(AppLocalizations.of(context)!.totalKilometersTravelled,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text('${LocaleStringConverter.formattedDouble(context, DataHolder.getTotalKilometersTraveled())} km',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(AppLocalizations.of(context)!.totalCosts,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text('€${LocaleStringConverter.formattedDouble(context, DataHolder.getTotalCost())}',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),

                            ],
                          ),
                        )
                    ),
                  ),
                ],
              ),
            )
        );
      },
    );
  }

  bool _areCostsEmpty() {
    return
    DataHolder.getTotalFuelFillCosts() +
    DataHolder.getTotalServiceCosts() +
    DataHolder.getTotalMalfunctionCosts()
    == 0;
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

}