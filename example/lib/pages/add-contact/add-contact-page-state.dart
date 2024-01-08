import 'package:example/dialogs/dialog_service.dart';
import 'package:example/pages/add-contact/add-contact-page.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class AddContactPageState extends WidgetStateBase<AddContactPage> {
  final _userService = ServiceLocator.instance.resolve<UserService>();
  final _dialogService = ServiceLocator.instance.resolve<DialogService>();

  late Validator<AddContactPageState> _validator;

  String _firstName = "";
  String _lastName = "";
  String _phone = "";

  String get firstName => this._firstName;
  set firstName(String value) => (this.._firstName = value).triggerStateChange();

  String? get lastName => this._lastName;
  set lastName(String? value) => (this.._lastName = value ?? "").triggerStateChange();

  String get phone => this._phone;
  set phone(String value) => (this.._phone = value).triggerStateChange();

  bool get hasErrors => this._validator.hasErrors;
  ValidationErrors get errors => this._validator.errors;

  AddContactPageState() : super() {
    this._createValidator();
    this.onStateChange(() {
      this._validate();
    });
  }

  Future<void> save() async {
    this._validator.enable();
    if (!this._validate()) {
      this.triggerStateChange();
      return;
    }

    this.showLoading();
    try {
      final user = this._userService.authenticatedUser;
      await user.addContact(this.firstName, this.phone, this.lastName);
      this._dialogService.showSuccessMessage("Contact saved successfully!");
    } catch (e) {
      debugPrint(e.toString());
      this._dialogService.showErrorMessage(e.toString());
      return;
    } finally {
      this.hideLoading();
      this._reset();
    }
  }

  void _reset() {
    this._firstName = "";
    this._lastName = "";
    this._phone = "";
    this._validator.disable();
    this.triggerStateChange();
  }

  bool _validate() {
    this._validator.validate(this);
    return this._validator.isValid;
  }

  void _createValidator() {
    this._validator = Validator(disabled: true);

    this._validator.prop("firstName", (t) => t.firstName).isRequired().withMessage(message: "FirstName is required.");

    this._validator.prop("lastName", (t) => t.lastName).isOptional();

    this
        ._validator
        .prop("phone", (t) => t.phone)
        .isRequired()
        .withMessage(message: "Phone number is required.")
        .isPhoneNumber()
        .withMessage(message: "Invalid phone number.");
  }
}
