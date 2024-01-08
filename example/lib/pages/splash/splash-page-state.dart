import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';
import 'splash-page.dart';
import 'package:example/pages/routes.dart';

class SplashPageState extends WidgetStateBase<SplashPage> {
  final _navigator = NavigationService.instance.retrieveNavigator("/");
  final _userService = ServiceLocator.instance.resolve<UserService>();

  SplashPageState() : super() {
    this.onInitState(() {
      this._pauseAndGo();
    });
  }

  Future<void> _pauseAndGo() async {
    await Future.delayed(Duration(seconds: 2));

    try {
      await this._userService.loadUser();
    } catch (e) {
      debugPrint(e.toString());
    }

    if (this._userService.isAuthenticated) {
      await this._navigator.pushReplacementNamed(Routes.home);
    } else {
      await this._navigator.pushReplacementNamed(Routes.login);
    }
  }
}
