import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/car.dart';
import 'package:benzinapp/services/managers/fuel_fill_record_manager.dart';
import 'package:benzinapp/services/managers/malfunction_manager.dart';
import 'package:benzinapp/services/managers/service_manager.dart';
import 'package:benzinapp/views/shared/cards/loading_data_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../services/locale_string_converter.dart';
import  '../charts/costs_pie_chart.dart';

import '../../services/theme_provider.dart';

class CostPieChartCard extends StatefulWidget {
  const CostPieChartCard({super.key});

  @override createState() => _CostPieChartCardState();
}

class _CostPieChartCardState extends State<CostPieChartCard> {

  double? totalServiceCosts, totalMalfunctionCosts, totalFuelFillCosts;

  Widget normalBody() => SizedBox(
    width: MediaQuery.sizeOf(context).width,
    child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: AutoSizeText(
                    translate('combinedCosts'),
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                    )
                ),
              ),

              const SizedBox(height: 20),

              Consumer<ThemeProvider>
                (builder: (BuildContext context, ThemeProvider value, Widget? child) {
                return Column(
                  children: [
                    CostsPieChart(theme: value.themeMode.name),

                    const SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "◉ ",
                          style: TextStyle(
                              color: CostsPieChart.pieChartColors[value.themeMode.name]!['fuel'],
                              fontSize: 25
                          ),
                        ),
                        Text('${translate('fuelFills')} - €${LocaleStringConverter.formattedDouble(context, totalFuelFillCosts!)}')
                      ],
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "◉ ",
                          style: TextStyle(
                              color: CostsPieChart.pieChartColors[value.themeMode.name]!['malfunction'],
                              fontSize: 25
                          ),
                        ),
                        Text('${translate('malfunctions')} - €${LocaleStringConverter.formattedDouble(context, totalMalfunctionCosts!)}')
                      ],
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "◉ ",
                          style: TextStyle(
                              color: CostsPieChart.pieChartColors[value.themeMode.name]!['service'],
                              fontSize: 25
                          ),
                        ),
                        Text('${translate('services')} - €${LocaleStringConverter.formattedDouble(context, totalServiceCosts!)}')
                      ],
                    ),
                  ],
                );
              }),
            ],
          ),
        )
    ),
  );

  @override
  Widget build(BuildContext context) => Consumer3<FuelFillRecordManager, MalfunctionManager, ServiceManager>(
    builder: (context, fuelManager, malfunctionManager, serviceManager, _) {
      if (fuelManager.local == null || malfunctionManager.local == null || serviceManager.local == null) {
        return const LoadingDataCard();
      }

      totalServiceCosts = Car.getTotalServiceCosts();
      totalMalfunctionCosts = Car.getTotalMalfunctionCosts();
      totalFuelFillCosts = Car.getTotalFuelFillCosts();

      return normalBody();
    },
  );

}