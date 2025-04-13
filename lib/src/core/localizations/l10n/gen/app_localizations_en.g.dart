// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.g.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get currencyExchange => 'Currency Exchange';

  @override
  String get usd => 'USD';

  @override
  String get retry => 'Retry';

  @override
  String get amount => 'Amount';

  @override
  String get currency => 'Currency';

  @override
  String get cacheExceptionMessage => 'Data could not be loaded. Please try again later.';

  @override
  String get serverExceptionMessage => 'Server error occurred. Please try again soon.';

  @override
  String get networkExceptionMessage => 'No internet connection. Check your network settings.';

  @override
  String get genericExceptionMessage => 'Something went wrong. Please try again.';
}
