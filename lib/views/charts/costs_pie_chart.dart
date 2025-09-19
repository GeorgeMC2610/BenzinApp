import 'package:benzinapp/services/classes/car.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CostsPieChart extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final double fuelFillCost = Car.getTotalFuelFillCosts();
    final double malfunctionsCost = Car.getTotalMalfunctionCosts();
    final double servicesCost = Car.getTotalServiceCosts();
    final double totalCost = fuelFillCost + malfunctionsCost + servicesCost;

    if (totalCost == 0) return const SizedBox();

    final chartData = [
      _CostData(translate('fuelFills'), fuelFillCost,
          pieChartColors[theme]!["fuel"]!),
      _CostData(translate('malfunctions'), malfunctionsCost,
          pieChartColors[theme]!["malfunction"]!),
      _CostData(translate('services'), servicesCost,
          pieChartColors[theme]!["service"]!),
    ].where((d) => d.value > 0).toList(); // filter out empty slices

    return SizedBox(
      height: 250,
      child: SfCircularChart(
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        series: <CircularSeries>[
          PieSeries<_CostData, String>(
            dataSource: chartData,
            xValueMapper: (d, _) => d.title,
            yValueMapper: (d, _) => d.value,
            pointColorMapper: (d, _) => d.color,
            dataLabelMapper: (d, _) {
              // Example: translated + percentage
              final percent = (d.value / totalCost * 100).toStringAsFixed(1);
              return "${d.title}\n$percent%";
            },
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
            ),
            radius: '80%',
            explode: true,
            explodeOffset: '5%',
          )
        ],
      ),
    );
  }
}

class _CostData {
  final String title;
  final double value;
  final Color color;
  _CostData(this.title, this.value, this.color);
}
