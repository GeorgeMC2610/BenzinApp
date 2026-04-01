import 'package:flutter/material.dart';

class Odometer extends StatelessWidget {
  const Odometer({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Small Odometer", style: Theme.of(context).textTheme.titleLarge),
        Text("Small odometer refers to the travelled distance starting from the last time you fuelled your vehicle up until the next time. It's usually written right below your car's speedometer.",
            style: Theme.of(context).textTheme.bodyMedium
        ),

        Image.asset('assets/images/odometer.jpg'),

        const SizedBox(height: 25),

        Text("Big Odometer", style: Theme.of(context).textTheme.titleLarge),
        Text("Big odometer refers to the total travelled distance of your car. It starts from when the car was bought. If the car is old, this number is usually really big, if the car used. It's usually written right below your car's speedometer",
            style: Theme.of(context).textTheme.bodyMedium
        ),

        Image.asset('assets/images/odometer_big.jpg'),

      ],
    ),
  );

}