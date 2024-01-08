import 'package:example/pages/routes.dart';
import 'package:example/pages/user/settings/settings-page.dart';
import 'package:example/sdk/proxies/user/user.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:example/services/theme-provider.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class SettingsPageState extends WidgetStateBase<SettingsPage> {
  final _navigator = NavigationService.instance.retrieveNavigator("/");
  final _userService = ServiceLocator.instance.resolve<UserService>();
  final _themeProvider = ServiceLocator.instance.resolve<ThemeProvider>();
  final _scopedNavigator = NavigationService.instance.retrieveNavigator(Routes.user);

  late User _user;

  ValueNotifier<bool> get themeNotifier => _themeProvider.themeNotifier;

  bool get isDarkMode => this._themeProvider.isDarkMode;

  String get userName => this._user.firstName;

  SettingsPageState() : super() {
    this._user = this._userService.authenticatedUser;
  }

  void goBack() {
    this._scopedNavigator.pop();
  }

  void toggleTheme(bool val) {
    this._themeProvider.toggleTheme(val);
    this.triggerStateChange();
  }

  Future<void> logout() async {
    this.showLoading();
    try {
      await this._userService.logout();
      this._navigator.popUntil((route) => route.isFirst);
      await this._navigator.pushReplacementNamed(Routes.login);
    } catch (e) {
      debugPrint(e.toString());
      return;
    } finally {
      this.hideLoading();
    }
  }
}
