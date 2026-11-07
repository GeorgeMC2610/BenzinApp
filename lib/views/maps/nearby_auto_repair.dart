import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

/// Placeholder screen. Will show nearby auto-repair shops on a map (Maps SDK).
class NearbyAutoRepair extends StatelessWidget {
  const NearbyAutoRepair({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(translate('nearbyAutoRepair')),
      ),
      body: Center(child: Text(translate('comingSoon'))),
    );
  }
}
