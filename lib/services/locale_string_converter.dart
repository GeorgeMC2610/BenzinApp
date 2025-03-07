import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'language_provider.dart';

class LocaleStringConverter {

  static String dateDayMonthYearString(BuildContext context, DateTime date) {
    return DateFormat.yMMMMEEEEd(Provider.of<LanguageProvider>(context).currentLocale.toLanguageTag()).format(date);
  }

  static String dateShortDayMonthYearString(BuildContext context, DateTime date) {
    return DateFormat.yMMMd (Provider.of<LanguageProvider>(context).currentLocale.toLanguageTag()).format(date);
  }

  static String formattedBigInt(BuildContext context, int number) {
    final NumberFormat format = NumberFormat('#,###', Provider.of<LanguageProvider>(context).currentLocale.toLanguageTag());
    return format.format(number);
  }

  static String formattedDouble(BuildContext context, double number) {
    final NumberFormat format = NumberFormat('#,###.##', Provider.of<LanguageProvider>(context).currentLocale.toLanguageTag());
    return format.format(number);
  }

  static String formattedDoubleToFivePoints(BuildContext context, double number) {
    final NumberFormat format = NumberFormat('#,###.#####', Provider.of<LanguageProvider>(context).currentLocale.toLanguageTag());
    return format.format(number);
  }


}