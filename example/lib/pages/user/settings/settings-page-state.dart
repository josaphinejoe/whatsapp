import 'package:example/pages/routes.dart';
import 'package:example/pages/user/settings/settings-page.dart';
import 'package:example/sdk/proxies/user/user.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class SettingsPageState extends WidgetStateBase<SettingsPage> {
  final _rootNavigator = NavigationService.instance.retrieveNavigator("/");
  final _userService = ServiceLocator.instance.resolve<UserService>();
  final _scopedNavigator = NavigationService.instance.retrieveNavigator(Routes.user);

  late User _user;

  String get userName => this._user.firstName;

  SettingsPageState() : super() {
    this._user = this._userService.authenticatedUser;
  }

  void goBack() {
    this._scopedNavigator.pop();
  }

  Future<void> logout() async {
    this.showLoading();
    try {
      await this._userService.logout();
      this._rootNavigator.popUntil((_) => false);
      await this._rootNavigator.pushNamed(Routes.login);
    } catch (e) {
      debugPrint(e.toString());
      return;
    } finally {
      this.hideLoading();
    }
  }
}
