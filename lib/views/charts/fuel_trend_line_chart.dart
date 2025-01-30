import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FuelTrendLineChart extends StatelessWidget {
  const FuelTrendLineChart({
    super.key,
    required this.data,
    required this.title,
    required this.size,
    required this.focusType
  });

  final List<FuelFillRecord> data;
  final String title;
  final double size;
  final ChartDisplayFocus focusType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
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
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: _getLineColor(),
              tooltipPadding: const EdgeInsets.all(5),
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  return LineTooltipItem(
                      'Date: ${_formatDate(spot.x.toInt())}\n\n '
                      '${_getStringifiedFocusType()}: ${spot.y.toStringAsFixed(5)}',
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )
                  );
                }).toList();
              }
            ),
            touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
              if (event is FlPanStartEvent) {
                // Handle panning start
              }

            },
            handleBuiltInTouches: true,
          ),
          extraLinesData: const ExtraLinesData(),
          lineBarsData: [
            LineChartBarData(
              spots: _formatData(),
              isCurved: true,
              color: _getLineColor(),
              curveSmoothness: 0.4,
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

  List<FlSpot> _formatData() {
    switch (focusType) {
      case ChartDisplayFocus.consumption:
        return data.map((ffr) {
          double xValue = ffr.dateTime.millisecondsSinceEpoch.toDouble();
          double yValue = ffr.getConsumption();
          return FlSpot(xValue, yValue);
        }).toList();
      case ChartDisplayFocus.efficiency:
        return data.map((ffr) {
          double xValue = ffr.dateTime.millisecondsSinceEpoch.toDouble();
          double yValue = ffr.getEfficiency();
          return FlSpot(xValue, yValue);
        }).toList();
      case ChartDisplayFocus.travelCost:
        return data.map((ffr) {
          double xValue = ffr.dateTime.millisecondsSinceEpoch.toDouble();
          double yValue = ffr.getTravelCost();
          return FlSpot(xValue, yValue);
        }).toList();
    }
  }

  Color _getLineColor() {
    switch (focusType) {
      case ChartDisplayFocus.consumption:
        return Colors.blueAccent;
      case ChartDisplayFocus.efficiency:
        return Colors.redAccent;
      case ChartDisplayFocus.travelCost:
        return Colors.green;
    }
  }

  String _getStringifiedFocusType() {
    switch (focusType) {

      case ChartDisplayFocus.consumption:
        return 'Consumption';
      case ChartDisplayFocus.efficiency:
        return 'Efficiency';
      case ChartDisplayFocus.travelCost:
        return 'Travel Cost';
    }
  }
}

enum ChartDisplayFocus {
  consumption,
  efficiency,
  travelCost
}