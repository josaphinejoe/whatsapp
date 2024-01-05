import 'package:example/pages/add-contact/add-contact-page.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class AddContactPageState extends WidgetStateBase<AddContactPage> {
  final _userService = ServiceLocator.instance.resolve<UserService>();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  late Validator<AddContactPageState> _validator;

  TextEditingController get firstNameController => this._firstNameController;
  TextEditingController get lastNameController => this._lastNameController;
  TextEditingController get phoneController => this._phoneController;

  String get firstName => this._firstNameController.text;
  set firstName(String value) => (this.._firstNameController.text = value).triggerStateChange();

  String? get lastName => this._lastNameController.text;
  set lastName(String? value) => (this.._lastNameController.text = value ?? "").triggerStateChange();

  String get phone => this._phoneController.text;
  set phone(String value) => (this.._phoneController.text = value).triggerStateChange();

  GlobalKey<FormState> get formKey => this._formKey;

  bool get hasErrors => this._validator.hasErrors;
  ValidationErrors get errors => this._validator.errors;

  AddContactPageState() : super() {
    this._createValidator();
    this.onStateChange(() {
      this._validate();
    });
  }

  void save() async {
    this._validator.enable();
    if (!this._validate()) {
      this.triggerStateChange();
      return;
    }

    this.showLoading();
    try {
      final user = this._userService.authenticatedUser;
      await user.addContact(this.firstName, this.phone, this.lastName);
    } catch (e) {
      debugPrint(e.toString());
      return;
    } finally {
      this.hideLoading();
      this._reset();
    }
  }

  void _reset() {
    this._firstNameController.clear();
    this._lastNameController.clear();
    this._phoneController.clear();
    this._formKey.currentState?.reassemble();
    this._formKey = GlobalKey<FormState>();
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
