import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SisuLocalizations {
  const SisuLocalizations(this.locale, this._values);

  final Locale locale;
  final Map<String, String> _values;

  static SisuLocalizations of(BuildContext context) {
    final result = Localizations.of<SisuLocalizations>(context, SisuLocalizations);
    assert(result != null, 'SisuLocalizations was not found.');
    return result!;
  }

  String t(String key) => _values[key] ?? key;

  static Future<SisuLocalizations> load(Locale locale) async {
    final code = locale.languageCode == 'vi' ? 'vi' : 'en';
    final jsonString = await rootBundle.loadString('lib/core/l10n/$code.json');
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return SisuLocalizations(
      Locale(code),
      map.map((key, value) => MapEntry(key, value.toString())),
    );
  }
}

class SisuLocalizationsDelegate extends LocalizationsDelegate<SisuLocalizations> {
  const SisuLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'vi'].contains(locale.languageCode);

  @override
  Future<SisuLocalizations> load(Locale locale) => SisuLocalizations.load(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<SisuLocalizations> old) => false;
}

extension SisuLocalizationsX on BuildContext {
  SisuLocalizations get l10n => SisuLocalizations.of(this);
}
