import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class FfrStats extends StatelessWidget {
  const FfrStats({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(translate('ffrStatsTitle1'), style: Theme.of(context).textTheme.titleLarge),
        Text(translate('ffrStatsBody1'),
            style: Theme.of(context).textTheme.bodyMedium
        ),

        Image.asset('assets/images/filler_liters.jpg'),

        const SizedBox(height: 25),

        Text(translate('ffrStatsTitle2'), style: Theme.of(context).textTheme.titleLarge),
        Text(translate('ffrStatsBody2'),
            style: Theme.of(context).textTheme.bodyMedium
        ),

        Image.asset('assets/images/filler_cost.jpg'),

      ],
    ),
  );

}