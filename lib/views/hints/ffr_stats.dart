import 'package:flutter/material.dart';
import 'package:benzinapp/i18n/strings.g.dart';

class FfrStats extends StatelessWidget {
  const FfrStats({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(t.ffrStatsTitle1, style: Theme.of(context).textTheme.titleLarge),
        Text(t.ffrStatsBody1,
            style: Theme.of(context).textTheme.bodyMedium
        ),

        Image.asset('assets/images/filler_liters.jpg'),

        const SizedBox(height: 25),

        Text(t.ffrStatsTitle2, style: Theme.of(context).textTheme.titleLarge),
        Text(t.ffrStatsBody2,
            style: Theme.of(context).textTheme.bodyMedium
        ),

        Image.asset('assets/images/filler_cost.jpg'),

      ],
    ),
  );

}