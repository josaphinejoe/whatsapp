import 'package:example/pages/login/login-page-state.dart';
import 'package:example/widgets/whatsapp-text-field/whatsapp-text-field.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidgetBase<LoginPageState> {
  LoginPage() : super(() => LoginPageState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Log In",
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
            Image.network(
              "https://cdn.pixabay.com/photo/2016/04/27/20/39/whatsapp-1357489_1280.jpg",
              height: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 30.0,
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
            Visibility(
              visible: this.state.isErrorTextNeeded,
              child: Text(
                "Authentication Failed",
                style: TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[500]),
              onPressed: this.state.hasErrors ? null : this.state.login,
              child: const Text(
                "Log In",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextButton(
              onPressed: () => this.state.goToSignUp(),
              child: Text(
                "Sign up",
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
