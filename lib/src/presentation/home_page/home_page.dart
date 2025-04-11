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
        backgroundColor: Colors.white, // or any fixed color
        elevation: 0, // prevents shadow on scroll
        title: const Text('Currency Exchange'),
        scrolledUnderElevation: 0.0,
      ),
      body: BlocProvider<CurrencyBloc>(
        create: (context) => CurrencyBloc(
          getCurrencyRates: context.read<FetchCurrencyRatesUseCase>(),
          changeCurrency: context.read<ChangeCurrencyUseCase>(),
          currencyController: TextEditingController(text: 'USD'),
          amountController: TextEditingController(text: '1'),
        ),
        child: const HomeBody(),
      ),
    );
  }
}
