import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final BoxConstraints? suffixIconConstraints;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? icon;
  final FocusNode? focusNode;
  final String? errorText;
  final bool obscureText;
  final bool? isDisabled;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final void Function(String)? onTextChanged;
  final TextCapitalization? textCapitalization;
  final int? maxLength;
  final List<TextInputFormatter>? textInputFormatter;
  final void Function(String)? onSubmitted;
  final bool readOnly;
  final bool enableInteractiveSelection;
  final void Function()? onTap;
  final void Function()? onTapSuffixIcon;
  final double labelPadding;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final bool? isDense;
  final double verticalPadding;
  final Function(PointerDownEvent event)? onTapOutside;
  final bool hideTracking;

  const AppTextField({
    required this.controller,
    super.key,
    this.labelText,
    this.enableInteractiveSelection = true,
    this.errorText,
    this.isDisabled,
    this.obscureText = false,
    this.suffixIconConstraints,
    this.prefix,
    this.suffix,
    this.textInputAction,
    this.icon,
    this.focusNode,
    this.keyboardType,
    this.maxLines,
    this.onTextChanged,
    this.textCapitalization,
    this.autofillHints,
    this.maxLength,
    this.textInputFormatter,
    this.onSubmitted,
    this.readOnly = false,
    this.onTap,
    this.onTapOutside,
    this.onTapSuffixIcon,
    this.textStyle,
    this.labelStyle,
    this.isDense,
    this.labelPadding = 16.0,
    this.verticalPadding = 11.0,
    this.hideTracking = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: errorText != null ? Colors.red : Colors.grey,
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: [],
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: TextFormField(
            autocorrect: keyboardType != TextInputType.emailAddress,
            onTap: onTap,
            readOnly: readOnly,
            maxLines: maxLines ?? 1,
            enabled: isDisabled != null ? !isDisabled! : true,
            focusNode: focusNode,
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            autofillHints: autofillHints,
            obscureText: obscureText,
            decoration: InputDecoration(
              isDense: isDense,
              icon: icon,
              suffixIconConstraints: suffixIconConstraints,
              prefix: prefix,
              suffix: suffix,
              contentPadding: const EdgeInsets.only(
                left: 16.0,
                top: 5.0,
                bottom: 5.0,
              ),
              border: const UnderlineInputBorder(borderSide: BorderSide.none),
              labelText: labelText,
            ),
            onChanged: (text) {
              if (onTextChanged != null) {
                onTextChanged?.call(text);
              }
            },
            inputFormatters: textInputFormatter ?? [],
            onFieldSubmitted: onSubmitted ?? (_) => {},
          ),
        ),
      ),
    );
  }
}
