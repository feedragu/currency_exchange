import 'package:currency_exchange/src/presentation/home_page/bloc/currency_bloc.dart';
import 'package:currency_exchange/src/presentation/home_page/widget/currency_dropdown.dart';
import 'package:currency_exchange/src/presentation/home_page/widget/currency_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, state) {
        if (state is CurrencyInitial) {
          context.read<CurrencyBloc>().add(
                GetCurrencyRatesEvent(),
              );
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CurrencyLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CurrencyLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<CurrencyBloc>().add(GetCurrencyRatesEvent());
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CurrencyDropdown(
                    currencies: state.rates.keys.toList(),
                    selectedCurrency: state.baseCurrency,
                    onChanged: (newCurrency) {
                      context.read<CurrencyBloc>().add(
                            ChangeCurrencyEvent(newCurrency),
                          );
                    },
                  ),
                ),
                Expanded(
                  child: CurrencyListWidget(
                    baseCurrency: state.baseCurrency,
                    rates: state.rates,
                  ),
                ),
              ],
            ),
          );
        } else if (state is CurrencyError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${state.message}',
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<CurrencyBloc>().add(
                          GetCurrencyRatesEvent(),
                        );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
