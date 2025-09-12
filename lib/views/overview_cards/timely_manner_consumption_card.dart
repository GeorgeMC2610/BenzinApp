import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/car.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../services/locale_string_converter.dart';

class TimelyMannerConsumptionCard extends StatefulWidget {
  const TimelyMannerConsumptionCard({super.key});

  @override
  State<StatefulWidget> createState() => _TimelyMannerConsumptionCardState();
}

class _TimelyMannerConsumptionCardState extends State<TimelyMannerConsumptionCard> {

  double? totalLitersFilled, totalCost, totalKilometersTravelled;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() {
    setState(() {
      totalLitersFilled = Car.getTotalLitersFilled();
      totalCost = Car.getTotalCost();
      totalKilometersTravelled = Car.getTotalKilometersTraveled();
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
                    translate('totalStatistics'),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                    )
                ),
              ),

              const SizedBox(height: 15),

              Text(translate('totalLitersFilled'),
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text('${LocaleStringConverter.formattedDouble(context, totalLitersFilled!)} lt.',
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 10),

              Text(translate('totalKilometersTravelled'),
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text('${LocaleStringConverter.formattedDouble(
                  context,
                  totalKilometersTravelled!
              )} km',
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 10),

              Text(translate('totalCosts'),
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text('€${LocaleStringConverter.formattedDouble(context, totalCost!)}',
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