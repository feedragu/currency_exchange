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
    return ListView.builder(
      itemCount: rates.length,
      itemBuilder: (context, index) {
        final currency = rates.keys.elementAt(index);
        final rate = rates[currency];

        // Skip showing the base currency against itself (which is always 1.0)
        if (currency == baseCurrency) {
          return Container(); // Or you could show it as a special item
        }

        return ListTile(
          leading: CircleAvatar(
            child: Text(currency.substring(0, 1)),
          ),
          title: Text(currency),
          subtitle:
              Text('1 $baseCurrency = ${rate?.toStringAsFixed(4)} $currency'),
          trailing: Text(
            rate?.toStringAsFixed(4) ?? '-',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
