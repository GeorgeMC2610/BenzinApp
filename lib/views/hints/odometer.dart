import 'package:flutter/material.dart';
import 'package:benzinapp/i18n/strings.g.dart';

class Odometer extends StatelessWidget {
  const Odometer({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(t.odometerHintTitle1, style: Theme.of(context).textTheme.titleLarge),
        Text(t.odometerBody1,
            style: Theme.of(context).textTheme.bodyMedium
        ),

        Image.asset('assets/images/odometer.jpg'),

        const SizedBox(height: 25),

        Text(t.odometerHintTitle2, style: Theme.of(context).textTheme.titleLarge),
        Text(t.odometerBody2,
            style: Theme.of(context).textTheme.bodyMedium
        ),

        Image.asset('assets/images/odometer_big.jpg'),

      ],
    ),
  );

}