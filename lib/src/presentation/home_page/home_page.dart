import 'package:currency_exchange/src/domain/usecases/change_currency_use_case.dart';
import 'package:currency_exchange/src/domain/usecases/fetch_currency_rates_use_case.dart';
import 'package:currency_exchange/src/presentation/home_page/bloc/currency_bloc.dart';
import 'package:currency_exchange/src/presentation/home_page/widget/home_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Exchange'),
        elevation: 0,
      ),
      body: BlocProvider<CurrencyBloc>(
        create: (context) => CurrencyBloc(
          getCurrencyRates: context.read<FetchCurrencyRatesUseCase>(),
          changeCurrency: context.read<ChangeCurrencyUseCase>(),
        ),
        child: const HomeBody(),
      ),
    );
  }
}
