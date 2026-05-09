import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class Odometer extends StatelessWidget {
  const Odometer({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(translate('odometerHintTitle1'), style: Theme.of(context).textTheme.titleLarge),
        Text(translate('odometerBody1'),
            style: Theme.of(context).textTheme.bodyMedium
        ),

        Image.asset('assets/images/odometer.jpg'),

        const SizedBox(height: 25),

        Text(translate('odometerHintTitle2'), style: Theme.of(context).textTheme.titleLarge),
        Text(translate('odometerBody2'),
            style: Theme.of(context).textTheme.bodyMedium
        ),

        Image.asset('assets/images/odometer_big.jpg'),

      ],
    ),
  );

}