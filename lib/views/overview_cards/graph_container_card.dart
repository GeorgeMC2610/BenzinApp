import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/managers/fuel_fill_record_manager.dart';
import 'package:benzinapp/views/charts/insufficient_data_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../charts/fuel_trend_line_chart.dart';

class GraphContainerCard extends StatefulWidget {
  const GraphContainerCard({super.key});

  @override
  State<StatefulWidget> createState() => _GraphContainerCardState();
}

class _GraphContainerCardState extends State<GraphContainerCard> {

  ChartDisplayFocus _focus = ChartDisplayFocus.consumption;
  int? _selectedFocusValue = 0;

  @override
  void initState() {
    super.initState();
  }

  Widget normalBody() => SizedBox(
    width: MediaQuery.sizeOf(context).width,
    child: FuelFillRecordManager().local.length < 2 ? const InsufficientDataCard() : Card(
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
                data: FuelFillRecordManager().local.skip(1).toList(),
                size: 300,
                focusType: _focus,
                context: context,
              ),

            ],
          ),
        )
    ),
  );

  @override
  Widget build(BuildContext context) => normalBody();

}