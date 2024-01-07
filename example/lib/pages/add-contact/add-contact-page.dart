import 'package:example/pages/add-contact/add-contact-page-state.dart';
import 'package:example/widgets/whatsapp-text-field/whatsapp-text-field.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class AddContactPage extends StatefulWidgetBase<AddContactPageState> {
  AddContactPage() : super(() => AddContactPageState());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const SizedBox(
            height: 30.0,
          ),
          WhatsappTextField(
            initialValue: this.state.firstName,
            label: "First Name",
            onChange: (v) => this.state.firstName = v,
            errorMessage: this.state.errors.getError("firstName"),
          ),
          const SizedBox(
            height: 16.0,
          ),
          WhatsappTextField(
            initialValue: this.state.lastName ?? "",
            label: "Last Name",
            onChange: (v) => this.state.lastName = v,
            errorMessage: this.state.errors.getError("lastName"),
          ),
          const SizedBox(
            height: 16.0,
          ),
          WhatsappTextField(
            initialValue: this.state.phone,
            label: "Phone Number",
            onChange: (v) => this.state.phone = v,
            errorMessage: this.state.errors.getError("phone"),
            isNumbersOnly: true,
          ),
          const SizedBox(
            height: 50.0,
          ),
          _saveButton(
            hasErrors: this.state.hasErrors,
            save: this.state.save,
          ),
        ],
      ),
    );
  }
}

class _saveButton extends StatelessWidget {
  final VoidCallback save;
  final bool hasErrors;
  const _saveButton({
    required this.save,
    required this.hasErrors,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[500],
      ),
      onPressed: this.hasErrors
          ? null
          : () {
              this.save();
              if (!this.hasErrors) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Contact saved successfully!",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    duration: Duration(
                      seconds: 2,
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
      child: const Text(
        "Save",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
