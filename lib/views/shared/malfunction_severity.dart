import 'package:flutter/material.dart';
import 'package:benzinapp/i18n/strings.g.dart';

/// Labels, colors and icons for a malfunction's severity (1 = lowest, 5 = highest).
class MalfunctionSeverity {

  static String label(int severity) => switch (severity) {
    1 => t.severityLowest,
    2 => t.severityLow,
    3 => t.severityNormal,
    4 => t.severityHigh,
    _ => t.severityHighest,
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
