import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/car.dart';
import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/services/managers/fuel_fill_record_manager.dart';
import 'package:benzinapp/services/managers/malfunction_manager.dart';
import 'package:benzinapp/services/managers/service_manager.dart';
import 'package:benzinapp/views/shared/cards/loading_data_card.dart';
import 'package:benzinapp/views/shared/date_range_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../services/locale_string_converter.dart';
import '../charts/costs_pie_chart.dart';

import '../../services/theme_provider.dart';

class CostPieChartCard extends StatefulWidget {
  const CostPieChartCard({super.key});

  @override
  createState() => _CostPieChartCardState();
}

class _CostPieChartCardState extends State<CostPieChartCard> {
  DateTime _startDate = DateTime(2000);
  DateTime _endDate = DateTime.now();

  Widget normalBody(double fuelCost, double malfunctionCost, double serviceCost) => SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: AutoSizeText(translate('combinedCosts'),
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: DateRangePicker(
                      onRangeSelected: (start, end) {
                        setState(() {
                          _startDate = start;
                          _endDate = end;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Consumer<ThemeProvider>(builder:
                      (BuildContext context, ThemeProvider value, Widget? child) {
                    return Column(
                      children: [
                        CostsPieChart(
                          theme: value.themeMode.name,
                          fuelFillCost: fuelCost,
                          malfunctionsCost: malfunctionCost,
                          servicesCost: serviceCost,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "◉ ",
                              style: TextStyle(
                                  color: CostsPieChart.pieChartColors[
                                      value.themeMode.name]!['fuel'],
                                  fontSize: 25),
                            ),
                            Text(
                                '${translate('fuelFills')} - ${CarManager().watchingCar!.toCurrency(LocaleStringConverter.formattedDouble(context, fuelCost))}')
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "◉ ",
                              style: TextStyle(
                                  color: CostsPieChart.pieChartColors[
                                      value.themeMode.name]!['malfunction'],
                                  fontSize: 25),
                            ),
                            Text(
                                '${translate('malfunctions')} - ${CarManager().watchingCar!.toCurrency(LocaleStringConverter.formattedDouble(context, malfunctionCost))}')
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "◉ ",
                              style: TextStyle(
                                  color: CostsPieChart.pieChartColors[
                                      value.themeMode.name]!['service'],
                                  fontSize: 25),
                            ),
                            Text(
                                '${translate('services')} - ${CarManager().watchingCar!.toCurrency(LocaleStringConverter.formattedDouble(context, serviceCost))}')
                          ],
                        ),
                      ],
                    );
                  }),
                ],
              ),
            )),
      );

  @override
  Widget build(BuildContext context) =>
      Consumer3<FuelFillRecordManager, MalfunctionManager, ServiceManager>(
        builder: (context, fuelManager, malfunctionManager, serviceManager, _) {
          if (fuelManager.local == null ||
              malfunctionManager.local == null ||
              serviceManager.local == null) {
            return const LoadingDataCard();
          }

          final start = _startDate.subtract(const Duration(seconds: 1));
          final end = _endDate.add(const Duration(days: 1));

          final filteredFuel = fuelManager.local!.where((r) => r.dateTime.isAfter(start) && r.dateTime.isBefore(end));
          final fuelCost = filteredFuel.fold<double>(0, (sum, r) => sum + r.cost);

          final filteredMalfunctions = malfunctionManager.local!.where((r) => r.dateStarted.isAfter(start) && r.dateStarted.isBefore(end));
          final malfunctionCost = filteredMalfunctions.fold<double>(0, (sum, r) => sum + (r.cost ?? 0));

          final filteredServices = serviceManager.local!.where((r) => r.dateHappened.isAfter(start) && r.dateHappened.isBefore(end));
          final serviceCost = filteredServices.fold<double>(0, (sum, r) => sum + (r.cost ?? 0));

          return normalBody(fuelCost, malfunctionCost, serviceCost);
        },
      );
}
