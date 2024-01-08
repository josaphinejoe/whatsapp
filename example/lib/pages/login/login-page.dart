import 'package:example/pages/login/login-page-state.dart';
import 'package:example/widgets/whatsapp-text-field/whatsapp-text-field.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidgetBase<LoginPageState> {
  LoginPage() : super(() => LoginPageState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _LoginAppBar(),
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
            const SizedBox(
              height: 40.0,
            ),
            _LoginButton(
              hasErrors: this.state.hasErrors,
              login: this.state.login,
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

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.hasErrors,
    required this.login,
    Key? key,
  }) : super(key: key);

  final bool hasErrors;
  final VoidCallback login;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green[500]),
      onPressed: this.hasErrors ? null : this.login,
      child: const Text(
        "Log In",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class _LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _LoginAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "Log In",
        style: const TextStyle(color: Colors.white, fontSize: 25),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
