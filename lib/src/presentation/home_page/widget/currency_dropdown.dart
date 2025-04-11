import 'package:flutter/material.dart';

class CurrencyDropdown extends StatelessWidget {
  const CurrencyDropdown({
    super.key,
    required this.currencies,
    required this.selectedCurrency,
    required this.onChanged,
  });

  final List<String> currencies;
  final String selectedCurrency;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: selectedCurrency,
        underline: Container(),
        // Remove the default underline
        items: currencies.map((String currency) {
          return DropdownMenuItem<String>(
            value: currency,
            child: Text(currency),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
      ),
    );
  }
}
