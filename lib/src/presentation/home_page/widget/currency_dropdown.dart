import 'package:currency_exchange/src/core/design_system/edit_text_dropdown.dart';
import 'package:flutter/material.dart';

class CurrencyDropdown extends StatelessWidget {
  final List<String> values;
  final String? selectedValue;
  final TextEditingController controller;
  final String? label;
  final String? error;
  final bool isEnabled;
  final bool showAlsoPlate;
  final void Function(String selected) onSelectedChanged;
  final void Function(String filteredText) onFilteredText;

  const CurrencyDropdown({
    required this.values,
    required this.onSelectedChanged,
    required this.controller,
    required this.onFilteredText,
    this.label,
    this.selectedValue,
    this.isEnabled = true,
    this.showAlsoPlate = false,
    this.error,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return EditTextDropdown<String>(
      icon: Icons.keyboard_arrow_down,
      items: values.map((e) {
        return DropdownItem<String>(
          value: e,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(e),
          ),
        );
      }).toList(),
      onChange: (int index) => onSelectedChanged(values[index]),
      filterItems: onFilteredText,
      controller: controller,
      labelText: 'Currency',
    );
  }
}
