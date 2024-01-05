import 'package:example/pages/sign-up/sign-up-page-state.dart';
import 'package:example/widgets/whatsapp-text-field/whatsapp-text-field.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidgetBase<SignUpPageState> {
  SignUpPage() : super(() => SignUpPageState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: const TextStyle(color: Colors.white, fontSize: 25),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 30.0,
            ),
            WhatsappTextField(
              label: "First Name",
              onChange: (v) => this.state.firstName = v,
              errorMessage: this.state.errors.getError("firstName"),
            ),
            const SizedBox(
              height: 16.0,
            ),
            WhatsappTextField(
              label: "Last Name",
              onChange: (v) => this.state.lastName = v,
              errorMessage: this.state.errors.getError("lastName"),
            ),
            const SizedBox(
              height: 16.0,
            ),
            WhatsappTextField(
              label: "Phone Number",
              onChange: (v) => this.state.phone = v,
              errorMessage: this.state.errors.getError("phone"),
              isNumbersOnly: true,
            ),
            const SizedBox(
              height: 16.0,
            ),
            WhatsappTextField(
              label: "Password",
              onChange: (v) => this.state.password = v,
              errorMessage: this.state.errors.getError("password"),
              isPassword: true,
              maxLength: 50,
            ),
            const SizedBox(
              height: 50.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[500]),
              onPressed: this.state.hasErrors ? null : this.state.signUp,
              child: const Text(
                "Sign Up",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextButton(
              onPressed: () => this.state.goToLogin(),
              child: Text(
                "Log In",
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
