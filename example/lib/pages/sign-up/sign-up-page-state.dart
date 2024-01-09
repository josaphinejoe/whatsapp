import 'package:example/dialogs/dialog_service.dart';
import 'package:example/pages/routes.dart';
import 'package:example/pages/sign-up/sign-up-page.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class SignUpPageState extends WidgetStateBase<SignUpPage> {
  final _navigator = NavigationService.instance.retrieveNavigator("/");
  final _userService = ServiceLocator.instance.resolve<UserService>();
  final _dialogService = ServiceLocator.instance.resolve<DialogService>();

  late Validator<SignUpPageState> _validator;

  String _firstName = "";
  String _lastName = "";
  String _phone = "";
  String _password = "";

  String get firstName => this._firstName;
  set firstName(String value) => (this.._firstName = value).triggerStateChange();

  String? get lastName => this._lastName;
  set lastName(String? value) => (this.._lastName = value ?? "").triggerStateChange();

  String get phone => this._phone;
  set phone(String value) => (this.._phone = value).triggerStateChange();

  String get password => this._password;
  set password(String value) => (this.._password = value).triggerStateChange();

  bool get hasErrors => this._validator.hasErrors;
  ValidationErrors get errors => this._validator.errors;

  SignUpPageState() : super() {
    this._createValidator();
    this.onStateChange(() {
      this._validate();
    });
  }

  Future<void> signUp() async {
    this._validator.enable();
    if (!this._validate()) {
      this.triggerStateChange();
      return;
    }
    this.showLoading();
    try {
      await this._userService.createUser(this.firstName, this.lastName, this.phone, this.password);
      this._dialogService.showSuccessMessage("User created successfully");
      this._navigator.popUntil((route) => route == "/");
      await this._navigator.pushNamed(Routes.login);
    } catch (e) {
      debugPrint(e.toString());
      this._dialogService.showErrorMessage(e.toString());
      return;
    } finally {
      this.hideLoading();
      this._reset();
    }
  }

  void goToLogin() {
    this._navigator.popUntil((route) => route == "/");
    this._navigator.pushNamed(Routes.login);
  }

  void _reset() {
    this._firstName = "";
    this._lastName = "";
    this._password = "";
    this._phone = "";
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

    this
        ._validator
        .prop("password", (t) => t.password)
        .isRequired()
        .withMessage(message: "Enter Password.")
        .hasMaxLength(50)
        .hasMinLength(8);
  }
}
