import 'package:benzinapp/services/distance_metric_provider.dart';
import 'package:benzinapp/services/volume_metric_provider.dart';
import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/views/overview_cards/car_info_card.dart';
import 'package:benzinapp/views/overview_cards/cost_pie_chart_card.dart';
import 'package:benzinapp/views/overview_cards/timely_manner_consumption_card.dart';
import 'package:benzinapp/views/overview_cards/total_cost_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../overview_cards/graph_container_card.dart';

class OverviewFragment extends StatefulWidget {
  const OverviewFragment({super.key});

  @override
  State<OverviewFragment> createState() => _OverviewFragmentState();
}

class _OverviewFragmentState extends State<OverviewFragment> {

  String? username = CarManager().watchingCar?.username;

  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // logged in as <username> text.
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
      )
    )
  );

  String getCurrentMetrics(BuildContext context) {
    final distanceLabel = Provider.of<DistanceMetricProvider>(context).label;
    final volumeLabel = Provider.of<VolumeMetricProvider>(context).label;
    return "$distanceLabel, $volumeLabel";
  }
}
