import 'package:example/pages/routes.dart';
import 'package:example/pages/settings/settings-page.dart';
import 'package:example/sdk/proxies/user/user.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:example/services/theme-provider.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class SettingsPageState extends WidgetStateBase<SettingsPage> {
  final _navigator = NavigationService.instance.retrieveNavigator("/");
  final _userService = ServiceLocator.instance.resolve<UserService>();
  final _themeProvider = ServiceLocator.instance.resolve<ThemeProvider>();

  bool _isReady = false;
  late User _user;

  bool get isReady => this._isReady;
  set isReady(bool value) => (this.._isReady = value).triggerStateChange();

  ValueNotifier<bool> get themeNotifier => _themeProvider.themeNotifier;

  bool get isDarkMode => this._themeProvider.isDarkMode;

  String get userName => this._user.firstName;

  SettingsPageState() : super() {
    this.onInitState(() async {
      await this._loadUser();
      this._isReady = true;
      this.triggerStateChange();
    });
  }

  void goBack() {
    this._navigator.pop();
  }

  void toggleTheme() {
    this._themeProvider.toggleTheme();
    this.triggerStateChange();
  }

  void logout() async {
    this.showLoading();
    try {
      await this._userService.logout();
      this._navigator.popUntil((route) => route.isFirst);
      this._navigator.pushReplacementNamed(Routes.login);
    } catch (e) {
      debugPrint(e.toString());
      return;
    } finally {
      this.hideLoading();
    }
  }

  Future<void> _loadUser() async {
    this.showLoading();
    try {
      this._user = await this._userService.getAuthenticatedUser();
    } catch (e) {
      return;
    } finally {
      this.hideLoading();
    }
  }
}
