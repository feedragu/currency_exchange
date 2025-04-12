import 'package:currency_exchange/src/core/design_system/app_circular_progress_indicator.dart';
import 'package:currency_exchange/src/core/design_system/app_text_field.dart';
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
          return Stack(
            children: [
              Positioned.fill(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<CurrencyBloc>().add(
                          GetCurrencyRatesEvent(),
                        );
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8,
                        ),
                        child: AppTextField(
                          labelText: 'Amount',
                          controller:
                              context.read<CurrencyBloc>().amountController,
                          onTextChanged: (newAmount) => context
                              .read<CurrencyBloc>()
                              .add(OnAmountChangedEvent(newAmount)),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          onSubmitted: (_) => FocusScope.of(context).unfocus(),
                          verticalPadding: 4,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8,
                        ),
                        child: CurrencyDropdown(
                          values: state.filteredCurrencyModels.toList(),
                          selectedValue: state.baseCurrency,
                          controller:
                              context.read<CurrencyBloc>().currencyController,
                          onSelectedChanged: (newCurrency) {
                            context.read<CurrencyBloc>().add(
                                  ChangeCurrencyEvent(newCurrency),
                                );
                          },
                          onFilteredText: (String filteredText) =>
                              context.read<CurrencyBloc>().add(
                                    FilteredItemsEvent(filteredText),
                                  ),
                        ),
                      ),
                      Expanded(
                        child: CurrencyListWidget(
                          convertedAmounts: state.convertedAmounts,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state.isLoadingChangeCurrency)
                AppCircularProgressIndicator(
                  spinnerColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.grey.withValues(
                    alpha: 0.3,
                  ),
                ),
            ],
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
