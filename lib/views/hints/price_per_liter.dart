import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class PricePerLiter extends StatelessWidget {
  const PricePerLiter({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(translate('gasPriceTitle'), style: Theme.of(context).textTheme.titleLarge),
        Text(translate('gasPriceBody'),
            style: Theme.of(context).textTheme.bodyMedium
        ),

        Image.asset('assets/images/gas_price.jpg'),

        const SizedBox(height: 25),

      ],
    ),
  );

}