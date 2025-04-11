import 'package:currency_exchange/src/core/design_system/edit_text_dropdown.dart';
import 'package:currency_exchange/src/presentation/home_page/model/ui_currency_model.dart';
import 'package:flutter/material.dart';

class CurrencyDropdown extends StatelessWidget {
  final List<UiCurrencyModel> values;
  final UiCurrencyModel? selectedValue;
  final TextEditingController controller;
  final String? label;
  final String? error;
  final bool isEnabled;
  final bool showAlsoPlate;
  final void Function(UiCurrencyModel selected) onSelectedChanged;
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
    return EditTextDropdown<UiCurrencyModel>(
      icon: Icons.keyboard_arrow_down,
      items: values.map((uiCurrencyModel) {
        return DropdownItem<UiCurrencyModel>(
          value: uiCurrencyModel,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child:
                Text('${uiCurrencyModel.code}: ${uiCurrencyModel.description}'),
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
