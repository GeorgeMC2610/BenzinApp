import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cards/car_card.dart';

class CarList extends StatelessWidget {
  const CarList({super.key, this.owned = false});

  final bool owned;

  @override
  Widget build(BuildContext context) => Consumer<CarManager>(
    builder: (BuildContext context, CarManager value, Widget? child) => GridView.extent(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      maxCrossAxisExtent: 200,
      crossAxisSpacing: 10,
      childAspectRatio: 3 / 4,
      mainAxisSpacing: 10,
      children: [
        ...getCarCards(),
        if (owned) const CarCard(car: null),
      ],
    )
  );

  List<CarCard> getCarCards() =>
      CarManager().local!.where((car) => car.isOwned() == owned).map((car) => CarCard(car: car)).toList();

}