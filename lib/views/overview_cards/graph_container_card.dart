import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/managers/fuel_fill_record_manager.dart';
import 'package:benzinapp/views/charts/insufficient_data_card.dart';
import 'package:benzinapp/views/shared/cards/loading_data_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../charts/fuel_trend_line_chart.dart';

class GraphContainerCard extends StatefulWidget {
  const GraphContainerCard({super.key});

  @override
  State<StatefulWidget> createState() => _GraphContainerCardState();
}

class _GraphContainerCardState extends State<GraphContainerCard> {

  ChartDisplayFocus _focus = ChartDisplayFocus.consumption;
  int? _selectedFocusValue = 0;

  Widget normalBody(FuelFillRecordManager manager) => SizedBox(
    width: MediaQuery.sizeOf(context).width,
    child: manager.local!.length < 2 ? const InsufficientDataCard() : Card(
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
                      translate('fuelUsageTrend'),
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
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Theme.of(context).colorScheme.onSurface.withAlpha(77), width: 1),
                ),
                child: DropdownButton<int>(
                  value: _selectedFocusValue, // No default selected
                  hint: const Text("Select an option"), // TODO: Localize string
                  items: [
                    DropdownMenuItem(value: 0, child: Text(translate('litersPer100km'))),
                    DropdownMenuItem(value: 1, child: Text(translate('kilometersPerLiter'))),
                    DropdownMenuItem(value: 2, child: Text(translate('costPerKilometer'))),
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
                  dropdownColor: Theme.of(context).colorScheme.surfaceContainerLow,
                  style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                  icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.onSurface),

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
                data: manager.local!,
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
  Widget build(BuildContext context) => Consumer<FuelFillRecordManager>(
    builder: (context, fuelFillManager, _) {
      if (fuelFillManager.local == null) return const LoadingDataCard();
      return normalBody(fuelFillManager);
    }
  );

}