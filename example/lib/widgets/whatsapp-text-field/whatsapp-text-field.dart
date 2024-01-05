import 'package:example/widgets/whatsapp-text-field/whatsapp-text-field-state.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class WhatsappTextField extends StatefulWidgetBase<WhatsappTextFieldState> {
  static const _defaultBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  final String initialValue;
  final String label;
  final ValueChanged<String> onChange;
  final bool isNumbersOnly;
  final bool isPassword;
  final String? errorMessage;
  final int? maxLength;

  WhatsappTextField({
    required this.label,
    required this.onChange,
    this.isNumbersOnly = false,
    this.isPassword = false,
    this.maxLength,
    this.errorMessage,
    this.initialValue = "",
  }) : super(() => WhatsappTextFieldState());

  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      maxLength: this.maxLength,
      controller: this.state.controller,
      keyboardType: this.isNumbersOnly ? TextInputType.number : null,
      obscureText: this.isPassword,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: this.label,
        border: _defaultBorder,
        errorText: this.errorMessage,
        errorMaxLines: 2,
      ),
      style: TextStyle(color: Colors.grey),
    );
  }
}
