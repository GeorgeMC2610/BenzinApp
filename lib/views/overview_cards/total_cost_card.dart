import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/car.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/locale_string_converter.dart';

class TotalCostCardContainer extends StatefulWidget {
  const TotalCostCardContainer({super.key});

  @override
  State<StatefulWidget> createState() => _TotalCostCardContainerState();
}

class _TotalCostCardContainerState extends State<TotalCostCardContainer> {

  double? totalEfficiency, totalConsumption, totalTravelCost;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() {
    setState(() {
      totalEfficiency = Car.getTotalEfficiency();
      totalConsumption = Car.getTotalConsumption();
      totalTravelCost = Car.getTotalTravelCost();
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
              Text('${LocaleStringConverter.formattedDouble(context, totalConsumption!)} lt./100 km',
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
              Text('${LocaleStringConverter.formattedDouble(context, totalEfficiency!)} km/lt.',
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
              Text('€${LocaleStringConverter.formattedDouble(context, totalTravelCost!)}/km',
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        )
    ),
  );

  @override
  Widget build(BuildContext context) => normalBody();
}