import 'package:flutter/material.dart';
import 'package:benzinapp/i18n/strings.g.dart';

class PricePerLiter extends StatelessWidget {
  const PricePerLiter({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(t.gasPriceTitle, style: Theme.of(context).textTheme.titleLarge),
        Text(t.gasPriceBody,
            style: Theme.of(context).textTheme.bodyMedium
        ),

        Image.asset('assets/images/gas_price.jpg'),

        const SizedBox(height: 25),

      ],
    ),
  );

}