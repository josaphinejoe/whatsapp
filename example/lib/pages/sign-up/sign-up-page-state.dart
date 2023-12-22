import 'package:example/pages/routes.dart';
import 'package:example/pages/sign-up/sign-up-page.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class SignUpPageState extends WidgetStateBase<SignUpPage>
{
  final _navigator = NavigationService.instance.retrieveNavigator("/");
  final _userService = ServiceLocator.instance.resolve<UserService>();


  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController =TextEditingController();
  TextEditingController _lastNameController =TextEditingController();
  TextEditingController _phoneController =TextEditingController();
  TextEditingController _passwordController =TextEditingController();


  late Validator<SignUpPageState> _validator;


  TextEditingController get firstNameController => this._firstNameController;
  TextEditingController get lastNameController => this._lastNameController;
  TextEditingController get phoneController => this._phoneController;
  TextEditingController get passwordController => this._passwordController;


  String get firstName => this._firstNameController.text;
  set firstName(String value) => (this.._firstNameController.text=value).triggerStateChange();

  String? get lastName => this._lastNameController.text;
  set lastName(String? value)=>(this.._lastNameController.text=value??"").triggerStateChange();

  String get phone => this._phoneController.text;
  set phone(String value)=>(this.._phoneController.text=value).triggerStateChange();

  String get password => this._passwordController.text;
  set password(String value)=>(this.._passwordController.text=value).triggerStateChange();

  GlobalKey<FormState> get formKey => this._formKey;
  

  bool get hasErrors => this._validator.hasErrors;
  ValidationErrors get errors => this._validator.errors;


  SignUpPageState() : super()
  {
    this._createValidator();
    this.onStateChange(() {
      this._validate();
    });
  }


  void signUp() async 
  {
    this._validator.enable();
    if(!this._validate()){
      this.triggerStateChange();
      return;
    }
    this.showLoading();
    try
    {
      await this._userService.createUser(this.firstName, this.lastName, this.phone, this.password);
      this._navigator.pushReplacementNamed(Routes.login);
    }
    catch(e)
    {
      debugPrint(e.toString());
      return;
    }
    finally
    {
      this.hideLoading();
      this._reset();
    }
  }


  void _reset() 
  {
    this._firstNameController.clear();
    this._lastNameController.clear();
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
    .prop("firstName", (t) => t.firstName)
    .isRequired()
    .withMessage(message: "FirstName is required.");

    this._validator
    .prop("lastName", (t) => t.lastName)
    .isOptional();

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