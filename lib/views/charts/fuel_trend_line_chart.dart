import 'package:benzinapp/services/distance_metric_provider.dart';
import 'package:benzinapp/services/volume_metric_provider.dart';
import 'package:benzinapp/services/fuel_metric_service.dart';
import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:benzinapp/services/classes/fuel_fill_record.dart';

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
    final distanceProvider = Provider.of<DistanceMetricProvider>(context);
    final volumeProvider = Provider.of<VolumeMetricProvider>(context);

    return Column(
      children: [
        SizedBox(
          key: ValueKey(focusType),
          height: size,
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              dateFormat: DateFormat("yyyy-MM-dd"),
              intervalType: DateTimeIntervalType.days,
              majorGridLines: const MajorGridLines(width: 0.5),
            ),
            primaryYAxis: const NumericAxis(
              opposedPosition: true,
              labelFormat: '{value}',
              majorGridLines: MajorGridLines(width: 0.5),
            ),
            zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true,      // pinch to zoom
              enablePanning: true,       // drag to move
              zoomMode: ZoomMode.x,      // zoom horizontally (or ZoomMode.xy)
              enableDoubleTapZooming: true
            ),
            title: ChartTitle(text: _getMetric(distanceProvider, volumeProvider)),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              canShowMarker: true,
              format: 'point.x : point.y',
              builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getLineColor(),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${DateFormat("yyyy-MM-dd").format(data.dateTime)}\n\n'
                        '${_getStringifiedFocusType()}\n '
                        '${point.y.toStringAsFixed(3)} ${_getMetric(distanceProvider, volumeProvider)}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
            series: <CartesianSeries<FuelFillRecord, DateTime>>[
              AreaSeries<FuelFillRecord, DateTime>(
                dataSource: data,
                xValueMapper: (ffr, _) => ffr.dateTime,
                yValueMapper: (ffr, _) {
                  return FuelMetricService.getChartValue(
                      ffr,
                      focusType.name,
                      distanceProvider.metric,
                      volumeProvider.metric
                  );
                },
                color: _getLineColor().withOpacity(0.5),
                borderColor: _getLineColor(),
                markerSettings: const MarkerSettings(
                  isVisible: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
        return translate('consumption');
      case ChartDisplayFocus.efficiency:
        return translate('efficiency');
      case ChartDisplayFocus.travelCost:
        return translate('travel_cost');
    }
  }

  String _getMetric(DistanceMetricProvider distanceProvider, VolumeMetricProvider volumeProvider) {
    final isMiles = distanceProvider.metric == DistanceMetric.miles;
    final isGallons = volumeProvider.metric == VolumeMetric.gallons;

    switch (focusType) {
      case ChartDisplayFocus.consumption:
        return "${volumeProvider.label}./100${distanceProvider.label}";
      case ChartDisplayFocus.efficiency:
        if (isMiles && isGallons) return "mpg";
        return "${distanceProvider.label}/${volumeProvider.label}";
      case ChartDisplayFocus.travelCost:
        return '${CarManager().watchingCar!.currency}/${distanceProvider.label}';
    }
  }
}

enum ChartDisplayFocus { consumption, efficiency, travelCost }
