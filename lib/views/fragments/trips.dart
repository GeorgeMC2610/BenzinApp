import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/views/shared/cards/fuel_fill_card.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:flutter/material.dart';

class TripsFragment extends StatefulWidget {
  const TripsFragment({super.key});

  @override
  State<TripsFragment> createState() => _TripsFragmentState();
}

class _TripsFragmentState extends State<TripsFragment> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DividerWithText(
                text: 'Repeating Trips',
                lineColor: Colors.blueGrey,
                textColor: Colors.blueGrey,
                textSize: 12.8
            ),

            Text('Nothing to show here.'),

            DividerWithText(
                text: 'One-Time Trips',
                lineColor: Colors.blueGrey,
                textColor: Colors.blueGrey,
                textSize: 12.8
            ),
            

          ]
        )
      )
    );
  }

}