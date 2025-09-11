import 'package:benzinapp/services/classes/car.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CostsPieChart extends StatefulWidget {

  const CostsPieChart({super.key, required this.theme});
  final String theme;

  static const Map<String, Map<String, Color>> pieChartColors = {
    "dark": {
      "fuel": Colors.green,
      "malfunction": Colors.lightGreen,
      "service": Colors.deepOrange,
    },
    "light": {
      "fuel": Colors.orange,
      "malfunction": Colors.redAccent,
      "service": Colors.deepOrangeAccent,
    }
  };

  @override
  State<StatefulWidget> createState() => _CostPieChartState();
}

class _CostPieChartState extends State<CostsPieChart> {

  bool isLoading = true;
  double? fuelFillCost, malfunctionsCost, servicesCost, totalCost;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    var fuelFillCost = await Car.getTotalFuelFillCosts();
    var malfunctionsCost = await Car.getTotalMalfunctionCosts();
    var servicesCost = await Car.getTotalServiceCosts();

    setState(() {
      this.fuelFillCost = fuelFillCost;
      this.malfunctionsCost = malfunctionsCost;
      this.servicesCost = servicesCost;
      totalCost = fuelFillCost + malfunctionsCost + servicesCost;
      isLoading = false;
    });
  }

  Widget loadingBody() => const Center(
      child: CircularProgressIndicator(
        value: null,
      )
  );

  Widget normalBody() => SizedBox(
    height: 250,
    child: PieChart(
      PieChartData(
        sections: [
          _buildPieChartSection(fuelFillCost!, totalCost!, CostsPieChart.pieChartColors[widget.theme]!['fuel']!, "fuel"),
          _buildPieChartSection(malfunctionsCost!, totalCost!, CostsPieChart.pieChartColors[widget.theme]!['malfunction']!, "malfunction"),
          _buildPieChartSection(servicesCost!, totalCost!, CostsPieChart.pieChartColors[widget.theme]!['service']!, "service"),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 50,
      ),
    ),
  );

  Widget getBody() {
    if (isLoading) {
      return loadingBody();
    }

    if (totalCost! == 0) {
      return const SizedBox();
    }

    return normalBody();
  }

  @override
  Widget build(BuildContext context) => getBody();

  PieChartSectionData _buildPieChartSection(double cost, double total, Color color, String title) {
    if (cost == 0) return PieChartSectionData(value: 0); // Hide sections with no cost

    return PieChartSectionData(
      value: cost,
      title: "${(cost / total * 100).toStringAsFixed(1)}%",
      color: color,
      radius: 80,
      titleStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

}