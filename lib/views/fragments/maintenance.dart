import 'package:flutter/material.dart';

class MaintenanceFragment extends StatefulWidget {
  const MaintenanceFragment({super.key});

  @override
  State<MaintenanceFragment> createState() => _MaintenanceFragmentState();
}

class _MaintenanceFragmentState extends State<MaintenanceFragment> {

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
            'Maintenance Fragment',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }

}