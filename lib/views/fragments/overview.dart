import 'package:benzinapp/views/shared/status_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';


class OverviewFragment extends StatefulWidget {
  const OverviewFragment({super.key});

  @override
  State<OverviewFragment> createState() => _OverviewFragmentState();
}

class _OverviewFragmentState extends State<OverviewFragment> {

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

                        DropdownButton<int>(
                          value: 0, // No default selected
                          hint: const Text("Select an option"),

                          items: const [
                            DropdownMenuItem(value: 0, child: Text("Liters per 100km")),
                            DropdownMenuItem(value: 1, child: Text("Kilometers per Liter")),
                            DropdownMenuItem(value: 2, child: Text("Cost per Kilometre")),
                          ],
                          onChanged: (int? value) {
                            // Handle selection change
                          },
                          dropdownColor: const Color.fromARGB(
                              255, 255, 247, 240), // Background color of dropdown
                          style: const TextStyle(fontSize: 13, color: Colors.black), // Text style
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.black), // Custom dropdown icon
                          borderRadius: BorderRadius.circular(15), // Rounded corners
                          underline: Container(
                            color: Colors.transparent, // Custom underline
                          ),
                        ),

                        const SizedBox(height: 50),



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

  List<FlSpot> getChartData() {
    List<Map<String, dynamic>> data = [
      {"date": "2022-01-05", "value": 11.0},
      {"date": "2024-03-01", "value": 7.8},
      {"date": "2025-05-01", "value": 5.8},
    ];

    return data.map((entry) {
      double xValue = DateTime.parse(entry["date"]).millisecondsSinceEpoch.toDouble();
      double yValue = entry["value"];
      return FlSpot(xValue, yValue);
    }).toList();
  }

  /// Format x-axis labels (convert milliseconds back to 'YYYY-MM-DD')
  String formatDate(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat("yyyy-MM-dd").format(date);
  }

}