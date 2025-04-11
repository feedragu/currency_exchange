import 'package:flutter/material.dart';

class CurrencyListWidget extends StatelessWidget {
  const CurrencyListWidget({
    super.key,
    required this.baseCurrency,
    required this.rates,
  });

  final String baseCurrency;
  final Map<String, double> rates;

  @override
  Widget build(BuildContext context) {
    final filteredRates =
        rates.entries.where((entry) => entry.key != baseCurrency).toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      padding: const EdgeInsets.all(16),
      itemCount: filteredRates.length,
      itemBuilder: (context, index) {
        final currency = filteredRates[index].key;
        final amountValue = filteredRates[index].value;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 35,
                child: Text(
                  currency.length >= 3
                      ? currency.substring(0, 3)
                      : currency.substring(0, 1),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                amountValue.toStringAsFixed(2),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
