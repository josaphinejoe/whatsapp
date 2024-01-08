import 'package:example/events/user-updated-event.dart';
import 'package:example/pages/home/home-page.dart';
import 'package:example/pages/routes.dart';
import 'package:example/sdk/proxies/user/user.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:example/services/bottom-nav-manager.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class HomePageState extends WidgetStateBase<HomePage> {
  final _bottomNavManager = ServiceLocator.instance.resolve<BottomNavManager>();
  final _userService = ServiceLocator.instance.resolve<UserService>();
  final _eventAggregator = ServiceLocator.instance.resolve<EventAggregator>();
  final _navigator = NavigationService.instance.retrieveNavigator("/");

  late GlobalKey<ScopedNavigatorState> nav0Key = this._bottomNavManager.nav0Key;
  late GlobalKey<ScopedNavigatorState> nav1Key = this._bottomNavManager.nav1Key;
  late GlobalKey<ScopedNavigatorState> nav2Key = this._bottomNavManager.nav2Key;

  late User _user;
  final List<String> _appBarTitles = ["WhatsApp", "Select Contact", "New Contact"];

  int get activeNavItem => this._bottomNavManager.currentSelectedNavItem;
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
    this._bottomNavManager.onNavSelected(index);
    this.triggerStateChange();
  }

  void onTapUser() {
    this._navigator.pushNamed(Routes.user);
  }
}
