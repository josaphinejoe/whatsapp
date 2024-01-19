import 'dart:async';

import 'package:example/dialogs/dialog_service.dart';
import 'package:example/pages/login/login-page.dart';
import 'package:example/pages/routes.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class LoginPageState extends WidgetStateBase<LoginPage> {
  final _navigator = NavigationService.instance.retrieveNavigator("/");
  final _userService = ServiceLocator.instance.resolve<UserService>();
  final _dialogService = ServiceLocator.instance.resolve<DialogService>();

  late Validator<LoginPageState> _validator;
  String _phone = "";
  String _password = "";

  String get phone => this._phone;
  set phone(String value) => (this.._phone = value).triggerStateChange();

  String get password => this._password;
  set password(String value) => (this.._password = value).triggerStateChange();

  bool get hasErrors => this._validator.hasErrors;
  ValidationErrors get errors => this._validator.errors;

  LoginPageState() : super() {
    this._createValidator();
    this.onStateChange(() {
      this._validate();
    });
  }

  Future<void> login() async {
    this._validator.enable();
    if (!this._validate()) {
      this.triggerStateChange();
      return;
    }
    this.showLoading();
    try {
      await this._userService.authenticate(this.phone, this.password);
      this._dialogService.showSuccessMessage("Successfully logged in");
      unawaited(this._navigator.pushReplacementNamed(Routes.home));
    } catch (e) {
      debugPrint(e.toString());
      this._dialogService.showErrorMessage(e.toString());
      return;
    } finally {
      this.hideLoading();
      this._reset();
    }
  }

  void goToSignUp() {
    this._navigator.pushNamed(Routes.signUp);
  }

  void _reset() {
    this._password = "";
    this._phone = "";
  }

  bool _validate() {
    this._validator.validate(this);
    return this._validator.isValid;
  }

  void _createValidator() {
    this._validator = Validator(disabled: true);

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
