import 'package:example/widgets/input-text-field/input-text-field-state.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class InputTextfield extends StatefulWidgetBase<InputTextFieldState> {
  final String initialValue;
  final ValueChanged<String> onChange;
  final VoidCallback onSave;
  final String label;

  InputTextfield({
    required this.initialValue,
    required this.label,
    required this.onChange,
    required this.onSave,
  }) : super(() => InputTextFieldState());

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 50.0,
        right: 30.0,
      ),
      child: ListTile(
        leading: const Icon(Icons.person_2),
        title: this.state.isEditable
            ? TextField(
                controller: this.state.controller,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: this.label,
                ),
              )
            : Text(
                this.initialValue,
                style: const TextStyle(fontSize: 18),
              ),
        trailing: !this.state.isEditable
            ? IconButton(
                onPressed: () => this.state.isEditable = !this.state.isEditable,
                icon: const Icon(Icons.edit),
              )
            : IconButton(
                onPressed: () {
                  this.onSave();
                  this.state.isEditable = !this.state.isEditable;
                },
                icon: const Icon(Icons.save),
              ),
      ),
    );
  }
}
