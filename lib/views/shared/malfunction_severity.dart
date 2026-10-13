import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

/// Labels, colors and icons for a malfunction's severity (1 = lowest, 5 = highest).
class MalfunctionSeverity {

  static String label(int severity) => switch (severity) {
    1 => translate('severityLowest'),
    2 => translate('severityLow'),
    3 => translate('severityNormal'),
    4 => translate('severityHigh'),
    _ => translate('severityHighest'),
  };

  static Color color(int severity) => switch (severity) {
    1 => Colors.blue,
    2 => Colors.lightBlue,
    3 => Colors.orange,
    4 => Colors.red,
    _ => const Color.fromARGB(255, 128, 0, 0),
  };

  static IconData icon(int severity) => switch (severity) {
    1 => Icons.arrow_downward,
    2 => Icons.keyboard_arrow_down,
    3 => Icons.horizontal_rule_sharp,
    4 => Icons.keyboard_arrow_up,
    _ => Icons.arrow_upward,
  };

}
