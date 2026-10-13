import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'language_provider.dart';

/// The decimal and grouping separators a locale writes numbers with
/// (e.g. `.` / `,` for English, `,` / `.` for Greek).
class NumberSeparators {
  const NumberSeparators({required this.decimal, required this.group});

  final String decimal;
  final String group;

  static const english = NumberSeparators(decimal: '.', group: ',');

  factory NumberSeparators.forLocale(String locale) {
    final verified = Intl.verifiedLocale(locale, NumberFormat.localeExists, onFailure: (_) => 'en')!;
    final symbols = NumberFormat.decimalPattern(verified).symbols;
    return NumberSeparators(decimal: symbols.DECIMAL_SEP, group: symbols.GROUP_SEP);
  }

  /// The separators of the app's current language.
  factory NumberSeparators.of(BuildContext context, {bool listen = true}) {
    final locale = Provider.of<LanguageProvider>(context, listen: listen).currentLocale;
    return NumberSeparators.forLocale(locale.toLanguageTag());
  }

  @override
  bool operator ==(Object other) =>
      other is NumberSeparators && other.decimal == decimal && other.group == group;

  @override
  int get hashCode => Object.hash(decimal, group);
}

/// Converts between doubles and their localized text (e.g. 50000.5 <-> "50.000,5").
class LocalizedNumber {
  static final RegExp _whitespace = RegExp(r'[\s  ]');
  static final RegExp _canonical = RegExp(r'^-?(\d+(\.\d*)?|\.\d+)$');

  static String format(double value, NumberSeparators separators) {
    // Round to 10 decimal places to handle the "mantissa" problem (e.g. 0.30000000000000004)
    String s = value.toStringAsFixed(10);
    if (s.contains('.')) {
      // Remove trailing zeros and the decimal point if it's no longer needed
      s = s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }
    if (s == '-0') s = '0';

    final negative = s.startsWith('-');
    if (negative) s = s.substring(1);
    final parts = s.split('.');
    return assemble(
      negative: negative,
      integer: parts[0],
      fraction: parts.length > 1 ? parts[1] : null,
      separators: separators,
    );
  }

  /// Parses text written with [separators]. Returns null when it isn't a number.
  static double? parse(String text, NumberSeparators separators) {
    String s = text
        .replaceAll(separators.group, '')
        .replaceAll(_whitespace, '')
        .replaceAll('−', '-')
        .replaceAll(separators.decimal, '.');
    // "12," is a number the user is still typing
    if (s.endsWith('.')) s = s.substring(0, s.length - 1);
    if (!_canonical.hasMatch(s)) return null;
    return double.tryParse(s);
  }

  /// Joins the pieces of a number, grouping the integer digits in threes.
  /// A non-null [fraction] always gets a decimal separator, even when empty.
  static String assemble({
    required bool negative,
    required String integer,
    required String? fraction,
    required NumberSeparators separators,
  }) {
    final buffer = StringBuffer(negative ? '-' : '');
    for (int i = 0; i < integer.length; i++) {
      if (i > 0 && (integer.length - i) % 3 == 0) buffer.write(separators.group);
      buffer.write(integer[i]);
    }
    if (fraction != null) buffer..write(separators.decimal)..write(fraction);
    return buffer.toString();
  }
}

/// A [TextEditingController] whose text is a localized number.
/// Read and write the number through [numericValue] instead of parsing [text].
class NumericTextController extends TextEditingController {
  NumericTextController({double? value}) {
    if (value != null) numericValue = value;
  }

  NumberSeparators _separators = NumberSeparators.english;

  NumberSeparators get separators => _separators;

  /// Switches locale, re-rendering the current number with the new separators.
  set separators(NumberSeparators value) {
    if (value == _separators) return;
    final current = numericValue;
    _separators = value;
    if (current != null) numericValue = current;
  }

  double? get numericValue => LocalizedNumber.parse(text, _separators);

  set numericValue(double? value) {
    text = value == null ? '' : LocalizedNumber.format(value, _separators);
  }
}

/// Keeps a text field's contents a well-formed localized number while typing.
///
/// Thousand separators are inserted automatically, so any `.` or `,` the user
/// types is taken as the decimal separator. This matters on iOS, where the
/// decimal pad only offers the separator of the keyboard's region.
class LocalizedNumberInputFormatter extends TextInputFormatter {
  LocalizedNumberInputFormatter({required this.separators, this.allowNegative = false});

  final NumberSeparators separators;
  final bool allowNegative;

  static bool _isDigit(String c) {
    final unit = c.codeUnitAt(0);
    return unit >= 0x30 && unit <= 0x39;
  }

  static bool _isSeparatorKey(String c) => c == '.' || c == ',';

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;
    int cursor = newValue.selection.isValid ? newValue.selection.extentOffset.clamp(0, text.length) : text.length;

    // Deleting a thousand separator deletes the digit next to it instead,
    // otherwise re-formatting would put the separator straight back.
    final old = oldValue.text;
    if (old.length == text.length + 1 &&
        cursor < old.length &&
        old[cursor] == separators.group &&
        old.substring(0, cursor) + old.substring(cursor + 1) == text &&
        oldValue.selection.isCollapsed) {
      final isBackspace = oldValue.selection.extentOffset == cursor + 1;
      if (isBackspace && cursor > 0) {
        text = text.substring(0, cursor - 1) + text.substring(cursor);
        cursor--;
      } else if (!isBackspace && cursor < text.length) {
        text = text.substring(0, cursor) + text.substring(cursor + 1);
      }
    }

    // The part of the text the user just typed or pasted. Separators outside it
    // were written by this formatter, so they follow the locale strictly.
    int prefix = 0;
    while (prefix < text.length && prefix < old.length && text[prefix] == old[prefix]) {
      prefix++;
    }
    int suffix = 0;
    while (suffix < text.length - prefix &&
        suffix < old.length - prefix &&
        text[text.length - 1 - suffix] == old[old.length - 1 - suffix]) {
      suffix++;
    }
    final insertedEnd = text.length - suffix;
    final typedDecimal = _decimalIndexIn(text, prefix, insertedEnd);

    bool negative = false;
    bool hasDecimal = false;
    final integer = <(String, bool)>[];
    final fraction = <(String, bool)>[];
    bool? decimalBeforeCursor;
    bool minusBeforeCursor = false;

    for (int i = 0; i < text.length; i++) {
      final c = text[i];
      final beforeCursor = i < cursor;
      final inserted = i >= prefix && i < insertedEnd;

      if (_isDigit(c)) {
        (hasDecimal ? fraction : integer).add((c, beforeCursor));
      } else if (inserted ? i == typedDecimal : c == separators.decimal) {
        // a second decimal separator: ignore the keystroke
        if (hasDecimal) return oldValue;
        hasDecimal = true;
        decimalBeforeCursor = beforeCursor;
      } else if ((c == '-' || c == '−') && allowNegative && integer.isEmpty && !hasDecimal) {
        negative = true;
        minusBeforeCursor |= beforeCursor;
      }
      // anything else (thousand separators, letters, misplaced signs) is dropped
    }

    // "007" -> "7", but keep the zero of "0,5"
    while (integer.length > 1 && integer.first.$1 == '0') {
      integer.removeAt(0);
    }
    // "," -> "0,"
    if (hasDecimal && integer.isEmpty) integer.add(('0', decimalBeforeCursor!));

    if (!negative && integer.isEmpty) {
      return const TextEditingValue(selection: TextSelection.collapsed(offset: 0));
    }

    // Rebuild the text, placing the cursor right after the last character
    // that was before it.
    final buffer = StringBuffer();
    int newCursor = 0;
    if (negative) {
      buffer.write('-');
      if (minusBeforeCursor) newCursor = buffer.length;
    }
    for (int i = 0; i < integer.length; i++) {
      if (i > 0 && (integer.length - i) % 3 == 0) buffer.write(separators.group);
      buffer.write(integer[i].$1);
      if (integer[i].$2) newCursor = buffer.length;
    }
    if (hasDecimal) {
      buffer.write(separators.decimal);
      if (decimalBeforeCursor!) newCursor = buffer.length;
      for (final (digit, beforeCursor) in fraction) {
        buffer.write(digit);
        if (beforeCursor) newCursor = buffer.length;
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: newCursor),
    );
  }

  /// Which `.` or `,` in `text[start, end)` is meant as the decimal separator,
  /// or -1 if none of them is.
  int _decimalIndexIn(String text, int start, int end) {
    final positions = [for (int i = start; i < end; i++) if (_isSeparatorKey(text[i])) i];
    if (positions.isEmpty) return -1;

    // "1.234,5" or "1,234.5": the last one is the decimal
    final last = positions.last;
    final mixed = positions.any((i) => text[i] != text[last]);
    if (mixed) return positions.where((i) => text[i] == text[last]).length == 1 ? last : -1;

    // "1.234.567": only thousand separators
    if (positions.length > 1) return -1;

    // A single typed key is always the decimal. A pasted "50.000" in a locale
    // grouping with "." is a thousand separator.
    if (text[last] == separators.decimal || end - start == 1) return last;
    int digitsAfter = 0;
    while (last + 1 + digitsAfter < end && _isDigit(text[last + 1 + digitsAfter])) {
      digitsAfter++;
    }
    final groupsThousands = text[last] == separators.group && digitsAfter == 3 && last + 1 + digitsAfter == end;
    return groupsThousands ? -1 : last;
  }
}
