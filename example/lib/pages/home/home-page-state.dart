import 'package:example/events/user-updated-event.dart';
import 'package:example/pages/home/home-page.dart';
import 'package:example/pages/routes.dart';
import 'package:example/sdk/proxies/user/user.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class HomePageState extends WidgetStateBase<HomePage> {
  final _userService = ServiceLocator.instance.resolve<UserService>();
  final _eventAggregator = ServiceLocator.instance.resolve<EventAggregator>();
  final _navigator = NavigationService.instance.retrieveNavigator("/");

  int _currentSelectedNavItem = 0;
  late User _user;
  final List<String> _appBarTitles = ["WhatsApp", "Select Contact", "New Contact"];

  int get activeNavItem => this._currentSelectedNavItem;
  List<String> get appBarTitles => this._appBarTitles;

  HomePageState() : super() {
    this.onInitState(() {
      this._user = this._userService.authenticatedUser;
      this.triggerStateChange();
    });
    this.watch<UserUpdatedEvent>(this._eventAggregator.subscribe<UserUpdatedEvent>(), (event) {
      this._user = event.user;
    });
  }

  ImageProvider<Object>? getImage() {
    if (this._user.profilePicture != null) {
      return FileImage(this._user.profilePicture!);
    } else {
      return null;
    }
  }

  void onActiveNavItemChanged(int index) {
    if (this._currentSelectedNavItem == index) {
      return;
    } else {
      this._currentSelectedNavItem = index;
    }
    this.triggerStateChange();
  }

  void onTapUser() {
    this._navigator.pushNamed(Routes.user);
  }
}
