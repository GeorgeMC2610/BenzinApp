import 'package:benzinapp/views/hints/ffr_stats.dart';
import 'package:benzinapp/views/hints/odometer.dart';
import 'package:benzinapp/views/hints/price_per_liter.dart';
import 'package:flutter/material.dart';

enum Hint {
  pricePerLiter,
  odometer,
  ffrStats,
}

extension HintCollection on Hint {
  Widget get widget {
    switch (this) {
      case Hint.pricePerLiter:
        return const PricePerLiter();
      case Hint.odometer:
        return const Odometer();
      case Hint.ffrStats:
        return const FfrStats();
    }
  }
}