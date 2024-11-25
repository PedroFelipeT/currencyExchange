// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../shared/theme/app_colors.dart';

class InputCurrencyWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;

  const InputCurrencyWidget({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.isFocused,
  }) : super(key: key);

  @override
  State<InputCurrencyWidget> createState() => _InputCurrencyWidgetState();
}

class _InputCurrencyWidgetState extends State<InputCurrencyWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Insert a currency';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 10,
        ),
        hintText: "Enter the currency code",
        hintStyle: const TextStyle(
          color: AppColors.neutralDark,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: AppColors.grey.withOpacity(0.35),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.branded,
            width: 2,
          ),
        ),
        disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.5,
          ),
        ),
        labelText: widget.isFocused || widget.controller.text.isNotEmpty
            ? 'Enter the currency code'
            : null,
        labelStyle: const TextStyle(
          fontSize: 16,
          color: AppColors.branded,
          fontWeight: FontWeight.w400,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      style: const TextStyle(color: AppColors.neutralDark),
    );
  }
}
