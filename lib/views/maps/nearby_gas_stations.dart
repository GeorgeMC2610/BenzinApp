import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

/// Placeholder screen. Will show nearby gas stations on a map (Maps SDK).
class NearbyGasStations extends StatelessWidget {
  const NearbyGasStations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(translate('nearbyGasStations')),
      ),
      body: Center(child: Text(translate('comingSoon'))),
    );
  }
}
