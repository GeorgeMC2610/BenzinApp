import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/views/charts/fuel_trend_line_chart.dart';
import 'package:benzinapp/views/shared/status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(AppLocalizations.of(context)!.loggedInAs('polo_despoina')),

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
                            const Text('Volkswagen Polo',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold
                                )
                            ),

                            const SizedBox(width: 15),

                            Material(
                              color: Colors.amber, // Set exact background color
                              borderRadius: BorderRadius.circular(20), // Keep shape consistent
                              elevation: 0, // No shadow
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                child: Text("2001"),
                              )),

                          ],
                        ),

                        // fields that show if the car is ok
                        // will be added at a later date
                        // make them customizable pls
                        const ListTile(
                          dense: false,
                          title: const Text("Last filled 2 weeks ago"),
                          subtitle: const Text('39 lt. | USD26'),
                          leading: const Icon(FontAwesomeIcons.gasPump),
                        ),

                        const Divider(),

                        const StatusCard(
                            icon: Icon(FontAwesomeIcons.wrench),
                            text: "Service overdue by 5 months",
                            status: StatusCardIndex.bad
                        ),

                        const StatusCard(
                            icon: Icon(FontAwesomeIcons.carBattery),
                            text: "Battery changed 2 and a half years ago",
                            status: StatusCardIndex.bad
                        ),

                        const StatusCard(
                            icon: Icon(FontAwesomeIcons.drumSteelpan),
                            text: "Tyres changed two months ago",
                            status: StatusCardIndex.good
                        ),

                        const StatusCard(
                            icon: Icon(FontAwesomeIcons.shower),
                            text: "Last car wash 1 month ago",
                            status: StatusCardIndex.good
                        ),

                        const StatusCard(
                            icon: Icon(FontAwesomeIcons.fileContract),
                            text: "Governmental check-up (KTEO) in 2 years",
                            status: StatusCardIndex.good
                        ),

                        const StatusCard(
                            icon: Icon(FontAwesomeIcons.idCard),
                            text: "Gas card in 1 years",
                            status: StatusCardIndex.good
                        )


                      ],
                    ),
                  )
              ),
            ),

            // graph with consumption container
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
                          child: Text(AppLocalizations.of(context)!.fuelUsageTrend,
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
                          data: DataHolder.getFuelFillRecords(),
                          size: 350,
                          focusType: _focus,
                          context: context,
                        ),

                      ],
                    ),
                  )
              ),
            ),

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
                          child: Text(AppLocalizations.of(context)!.combinedCosts,
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                        ),

                      ],
                    ),
                  )
              ),
            ),

            // car consumption container
            Container(
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
                          child: Text(AppLocalizations.of(context)!.averageConsumption,
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold
                              )
                          )
                        ),

                        const SizedBox(height: 15),

                        Text(AppLocalizations.of(context)!.litersPer100km,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        const Text('Something something better than the green limo',
                          style: TextStyle(
                              fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(AppLocalizations.of(context)!.kilometersPerLiter,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text('Something something better than the green limo',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(AppLocalizations.of(context)!.costPerKilometer,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text('Something something better than the green limo',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
              ),
            ),

            // timely manner consumption
            Container(
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
                        child: Text(AppLocalizations.of(context)!.totalStatistics,
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
                      const Text('Something something better than the green limo',
                        style: TextStyle(
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
                      const Text('Something something better than the green limo',
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
                      const Text('Something something better than the green limo',
                        style: TextStyle(
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
  }

}