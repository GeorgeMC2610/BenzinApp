import 'package:flutter/material.dart';

class FuelFillsFragment extends StatefulWidget {
  const FuelFillsFragment({super.key});

  @override
  State<FuelFillsFragment> createState() => _FuelFillsFragmentState();
}

class _FuelFillsFragmentState extends State<FuelFillsFragment> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You have pushed the button this many times:',
          ),
          Text(
            'Fuel Fills Fragment',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }

}