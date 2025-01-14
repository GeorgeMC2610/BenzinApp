import 'package:flutter/material.dart';

class TripsFragment extends StatefulWidget {
  const TripsFragment({super.key});

  @override
  State<TripsFragment> createState() => _TripsFragmentState();
}

class _TripsFragmentState extends State<TripsFragment> {

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
            'Trips Fragment',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }

}