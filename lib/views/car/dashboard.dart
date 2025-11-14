import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/views/fragments/settings.dart';
import 'package:benzinapp/views/shared/car_list.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:flutter/material.dart';

import 'package:flutter_translate/flutter_translate.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
              icon: const Icon(Icons.settings))
        ],
        title: Text(translate('dashboardAppBar')),
      ),
      body: RefreshIndicator(
        onRefresh: refreshCars,
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DividerWithText(
                          text: translate('dashboardMyCars'),
                          lineColor: Colors.grey,
                          textColor: Theme.of(context).colorScheme.primary,
                          textSize: 16),

                      const SizedBox(height: 15),

                      const CarList(owned: true),

                      const SizedBox(height: 15),

                      DividerWithText(
                          text: translate('dashboardSharedWithMe'),
                          lineColor: Colors.grey,
                          textColor: Theme.of(context).colorScheme.primary,
                          textSize: 16
                      ),

                      const SizedBox(height: 15),

                      const CarList(owned: false),

                    ]
                )
            )
        ),
      )
  );

  Future<void> refreshCars() async {
    await CarManager().index();
  }

  bool isLoading = false;
}