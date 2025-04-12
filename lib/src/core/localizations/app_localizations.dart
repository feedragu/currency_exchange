import 'package:currency_exchange/src/core/localizations/l10n/gen/app_localizations.g.dart';
import 'package:flutter/material.dart';

class AppLocalizationProvider {
  static AppLocalizations of(BuildContext context) {
    final localization = AppLocalizations.of(context);
    if (localization != null) {
      return localization;
    }
    throw InvalidAppLocalizationsStateException();
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizations.delegate;
}

class InvalidAppLocalizationsStateException implements Exception {}
