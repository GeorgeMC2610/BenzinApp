import 'package:benzinapp/services/data_holder.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CostsPieChart extends StatelessWidget {

  const CostsPieChart({super.key, required this.buildContext});

  final BuildContext buildContext;

  @override
  Widget build(BuildContext context) {

    final fuelFillCost = DataHolder.getTotalFuelFillCosts();
    final malfunctionsCost = DataHolder.getTotalMalfunctionCosts();
    final servicesCost = DataHolder.getTotalServiceCosts();
    final totalCost = fuelFillCost + malfunctionsCost + servicesCost;

    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sections: [
            _buildPieChartSection(fuelFillCost, totalCost, Colors.lightGreen.shade500, "Fuel"),
            _buildPieChartSection(malfunctionsCost, totalCost, Colors.green.shade700, "Malfunctions"),
            _buildPieChartSection(servicesCost, totalCost, Colors.amber, "Services"),
          ],
          sectionsSpace: 2,
          centerSpaceRadius: 50,
        ),
      ),
    );
  }

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