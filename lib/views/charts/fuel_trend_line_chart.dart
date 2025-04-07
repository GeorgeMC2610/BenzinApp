import 'package:BenzinApp/services/classes/fuel_fill_record.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FuelTrendLineChart extends StatelessWidget {
  const FuelTrendLineChart({
      super.key,
      required this.data,
      required this.size,
      required this.focusType,
      required this.context,
  });

  final List<FuelFillRecord> data;
  final double size;
  final ChartDisplayFocus focusType;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
            child: Text(
          _getMetric(),
          style: const TextStyle(
            letterSpacing: 0,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )),

        const SizedBox(height: 15),

        SizedBox(
          height: size,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 50),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 50),
                ),
                topTitles: const AxisTitles(),
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
                            ));
                      }).toList();
                    }),
                touchCallback:
                    (FlTouchEvent event, LineTouchResponse? response) {
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
                  curveSmoothness: 0,
                  barWidth: 2,
                  isStrokeCapRound: false,
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        )
      ],
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

  // TODO: Strings must be somehow localized
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

  String _getMetric() {
    switch (focusType) {
      case ChartDisplayFocus.consumption:
        return 'lt./100km';
      case ChartDisplayFocus.efficiency:
        return 'km/lt';
      case ChartDisplayFocus.travelCost:
        return '€/km';
    }
  }
}

enum ChartDisplayFocus { consumption, efficiency, travelCost }
