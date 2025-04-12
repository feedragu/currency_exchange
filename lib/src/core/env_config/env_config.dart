import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static Future<void> init() async {
    await dotenv.load();
  }

  static String get currencyApiKey {
    return dotenv.env['CURRENCY_API_KEY'] ?? '';
  }
}