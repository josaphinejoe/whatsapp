import 'package:example/pages/login/login-page.dart';
import 'package:example/pages/routes.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class LoginPageState extends WidgetStateBase<LoginPage>
{
  final _navigator = NavigationService.instance.retrieveNavigator("/");
  final _userService = ServiceLocator.instance.resolve<UserService>();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _phoneController =TextEditingController();
  TextEditingController _passwordController =TextEditingController();

  late Validator<LoginPageState> _validator;
  bool _isErrorTextNeeded=false;


  TextEditingController get phoneController => this._phoneController;
  TextEditingController get passwordController => this._passwordController;


  String get phone => this._phoneController.text;
  set phone(String value) =>(this.._phoneController.text=value).triggerStateChange(); 

  String get password => this._passwordController.text;
  set password(String value)=>(this.._passwordController.text=value).triggerStateChange();

  GlobalKey<FormState> get formKey => this._formKey;

  bool get hasErrors => this._validator.hasErrors;
  ValidationErrors get errors => this._validator.errors;
  bool get isErrorTextNeeded => this._isErrorTextNeeded;


    LoginPageState() : super()
    {
      this._createValidator();
      this.onStateChange(() {
        this._validate();
      });
    }


  void login() async 
  {
    this._validator.enable();
    if(!this._validate())
    {
      this.triggerStateChange();
      return;
    }
  this.showLoading();
    try
    {
      await this._userService.authenticate(this.phone, this.password);
      this._navigator.pushReplacementNamed(Routes.home);
    }
    catch(e)
    {
      debugPrint(e.toString());
      this._isErrorTextNeeded=true;
      this.triggerStateChange();
      return;
    }
    finally
    {
      this.hideLoading();
      this._reset();
    }
  }

  void clearUser() async
  {
    this._userService.clearUser();
    this._navigator.pushReplacementNamed(Routes.signUp);
  }


  void _reset() 
  {
    this._phoneController.clear();
    this._passwordController.clear();
    this._formKey.currentState?.reassemble();
    this._formKey = GlobalKey<FormState>();
  }

  bool _validate()
  {
    this._validator.validate(this);
    return this._validator.isValid;
  }

  void _createValidator()
  {
    this._validator = Validator(disabled: true);

    this._validator
    .prop("phone", (t) => t.phone)
    .isRequired()
    .withMessage(message: "Phone number is required.")
    .isPhoneNumber()
    .withMessage(message: "Invalid phone number.");

    this._validator
    .prop("password", (t) => t.password)
    .isRequired()
    .withMessage(message: "Enter Password.")
    .hasMaxLength(50)
    .hasMinLength(8);
  }
}