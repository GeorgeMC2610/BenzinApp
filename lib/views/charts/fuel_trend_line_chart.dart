import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FuelTrendLineChart extends StatelessWidget {
  const FuelTrendLineChart({
    super.key,
    required this.data,
    required this.lineColor,
    required this.title,
    required this.size
  });

  final List<Map<String, dynamic>> data;
  final Color lineColor;
  final String title;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            topTitles: AxisTitles(),
            bottomTitles: AxisTitles(
              axisNameSize: 50,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 77,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: AxisSide.top,
                    angle: 1.2,
                    space: 50,
                    child: Text(
                      _formatDate(value.toInt()),
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.black),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: const LineTouchTooltipData(
              tooltipBgColor: Colors.blueAccent,
            ),
            touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
              if (event is FlPanStartEvent) {
                // Handle panning start
              }
            },
            handleBuiltInTouches: true,
          ),
          extraLinesData: ExtraLinesData(),
          lineBarsData: [
            LineChartBarData(
              spots: getChartData(), // Convert dates to double values
              isCurved: false,
              color: Colors.blue,
              barWidth: 2,
              isStrokeCapRound: false,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),

      ),
    );
  }

  String _formatDate(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat("yyyy-MM-dd").format(date);
  }
}