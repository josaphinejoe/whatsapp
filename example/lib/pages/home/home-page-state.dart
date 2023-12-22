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


  late final GlobalKey<ScopedNavigatorState> nav0Key =
      this._bottomNavManager.nav0Key;
  late final GlobalKey<ScopedNavigatorState> nav1Key =
      this._bottomNavManager.nav1Key;
  late final GlobalKey<ScopedNavigatorState> nav2Key =
      this._bottomNavManager.nav2Key;

  late User _user;
  bool _isReady=false;
  final List<String> _appBarTitles =["WhatsApp","Select Contact","New Contact"];


  bool get isReady => this._isReady;

  int get activeNavItem => this._bottomNavManager.currentSelectedNavItem;
  List<String> get appBarTitles => this._appBarTitles;
  NavigatorState get currentNavigator => this._bottomNavManager.navigatorState;


  HomePageState() : super() {
   this.onInitState(() async{
      this._user= await this._userService.getUser();
      this._isReady=true;
      this.triggerStateChange();
    });
    this.watch<UserUpdatedEvent>(this._eventAggregator.subscribe<UserUpdatedEvent>(),(event){
      this._user=event.user;
    });
  }


  ImageProvider<Object> getImage()
    {
      if(this._user.displayPicture !=null){
        return FileImage(this._user.displayPicture!);
      }
      else{
        return const NetworkImage("https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgPp7AelDxUJQ_t928VVlyIqM4sAMLIOsHyWkVgVRPzvFaUuJkNZG6U7DV8oYjIwpwzVKWwEGOFqQ_8jBTwiz8iDrR0GlQUVom65RMzoaLrYvNhVbwcFdgo2glP2lgp076Dvl6oNjrOuQp5oQstI1SCbVXITSPofI12AdM-KaB0rQBPAyRR5qpE-z8hDg/s16000-rw/blank-profile-picture-hd-images-photo-5.JPG");
      }
    }


  void onActiveNavItemChanged(int index) {
    this._bottomNavManager.onNavSelected(index);
    this.triggerStateChange();
  }

  Future<void> onTapUser() async {
    this._navigator.pushNamed(Routes.user);
  }
}