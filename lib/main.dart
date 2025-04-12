import 'package:currency_exchange/src/core/env_config/env_config.dart';
import 'package:currency_exchange/src/core/localizations/app_localizations.dart';
import 'package:currency_exchange/src/di/global_app_providers.dart';
import 'package:currency_exchange/src/presentation/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: globalAppProviders(),
      child: MaterialApp(
        title: 'Currency Exchange',
        localizationsDelegates: const [
          AppLocalizationProvider.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
        ],
        locale: const Locale('en'),
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomePage(),
      ),
    );
  }
}
