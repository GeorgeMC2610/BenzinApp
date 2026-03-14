import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/car.dart';
import 'package:benzinapp/services/distance_metric_provider.dart';
import 'package:benzinapp/services/fuel_metric_service.dart';
import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/services/volume_metric_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../services/locale_string_converter.dart';
import '../../services/managers/fuel_fill_record_manager.dart';
import '../../services/managers/malfunction_manager.dart';
import '../../services/managers/service_manager.dart';
import '../shared/cards/loading_data_card.dart';

class TotalCostCardContainer extends StatefulWidget {
  const TotalCostCardContainer({super.key});

  @override
  State<StatefulWidget> createState() => _TotalCostCardContainerState();
}

class _TotalCostCardContainerState extends State<TotalCostCardContainer> {

  double? totalEfficiency, totalConsumption, totalTravelCost;

  Widget normalBody() {
    final distanceProvider = Provider.of<DistanceMetricProvider>(context);
    final volumeProvider = Provider.of<VolumeMetricProvider>(context);

    final convertedConsumption = FuelMetricService.getConvertedConsumption(totalConsumption!, distanceProvider.metric, volumeProvider.metric);
    final convertedEfficiency = FuelMetricService.getConvertedEfficiency(totalEfficiency!, distanceProvider.metric, volumeProvider.metric);
    final convertedTravelCost = FuelMetricService.getConvertedTravelCost(totalTravelCost!, distanceProvider.metric);

    return SizedBox(
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
                          translate('averageConsumption'),
                          maxLines: 1,
                          maxFontSize: 25,
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                          )
                      )
                  ),

                  const SizedBox(height: 15),

                  Text(translate('consumption'),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text('${LocaleStringConverter.formattedDouble(context, convertedConsumption)} ${FuelMetricService.getConsumptionLabel(distanceProvider.metric, volumeProvider.metric)}',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(translate('efficiency'),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text('${LocaleStringConverter.formattedDouble(context, convertedEfficiency)} ${FuelMetricService.getEfficiencyLabel(distanceProvider.metric, volumeProvider.metric)}',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(translate('travel_cost'),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text('${CarManager().watchingCar!.toCurrency(LocaleStringConverter.formattedDouble(context, convertedTravelCost))}/${distanceProvider.label}',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) => Consumer3<FuelFillRecordManager, MalfunctionManager, ServiceManager>(
    builder: (context, fuelManager, malfunctionManager, serviceManager, _) {
      if (fuelManager.local == null || malfunctionManager.local == null || serviceManager.local == null) {
        return const LoadingDataCard();
      }

      totalEfficiency = Car.getTotalEfficiency();
      totalConsumption = Car.getTotalConsumption();
      totalTravelCost = Car.getTotalTravelCost();

      return normalBody();
    },
  );
}
