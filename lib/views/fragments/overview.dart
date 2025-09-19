import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/services/managers/fuel_fill_record_manager.dart';
import 'package:benzinapp/services/managers/malfunction_manager.dart';
import 'package:benzinapp/services/managers/service_manager.dart';
import 'package:benzinapp/views/overview_cards/car_info_card.dart';
import 'package:benzinapp/views/overview_cards/cost_pie_chart_card.dart';
import 'package:benzinapp/views/overview_cards/timely_manner_consumption_card.dart';
import 'package:benzinapp/views/overview_cards/total_cost_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';


import '../overview_cards/graph_container_card.dart';
import '../shared/notification.dart';

class OverviewFragment extends StatefulWidget {
  const OverviewFragment({super.key});

  @override
  State<OverviewFragment> createState() => _OverviewFragmentState();
}

class _OverviewFragmentState extends State<OverviewFragment> {

  String? username;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    final car = CarManager().car;

    setState(() {
      username = car?.username;
    });
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Consumer3<FuelFillRecordManager, MalfunctionManager, ServiceManager>(
        builder: (_, __, ___, ____, _____) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // logged in as <username> text.
            Text(translate('loggedInAs', args: {'username': username ?? '-'})),

            const SizedBox(height: 10),

            // car info container
            CarInfoCard(),

            // graph with consumption container
            GraphContainerCard(),

            // cost pie chart
            // might not be available to show if there are no data
            CostPieChartCard(),

            // car average stats container
            TotalCostCardContainer(),

            // timely manner consumption
            TimelyMannerConsumptionCard(),
          ],
        ),

      )
    )
  );
}