import 'package:benzinapp/i18n/strings.g.dart';

class TranslationLookup {

  /// Looks up a translation by a key only known at runtime, e.g. one sent by
  /// the server in a push notification. Prefer the generated `t.someKey`
  /// accessors whenever the key is known in code, since those are checked at
  /// compile time.
  ///
  /// Falls back to the base locale for keys the current locale is missing.
  /// Returns null if the key doesn't exist, or if [args] don't match its
  /// placeholders.
  static String? byKey(String key, {Map<String, dynamic>? args}) {
    final base = LocaleSettings.instance.getTranslations(AppLocaleUtils.instance.baseLocale);
    final value = t[key] ?? base[key];

    if (value is String) return value;
    if (value is! Function) return null;

    try {
      return Function.apply(value, const [], {
        for (final entry in (args ?? const {}).entries) Symbol(entry.key): entry.value,
      }) as String;
    } on NoSuchMethodError {
      return null;
    }
  }
}
