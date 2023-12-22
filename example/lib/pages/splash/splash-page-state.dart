import 'package:example/sdk/models/user-status.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:floater/floater.dart';
import 'splash-page.dart';
import 'package:example/pages/routes.dart';

class SplashPageState extends WidgetStateBase<SplashPage> {
  final _navigator = NavigationService.instance
      .retrieveNavigator("/"); 
  final _userService = ServiceLocator.instance.resolve<UserService>();


  SplashPageState() : super() {
    this.onInitState(() {
      this._pauseAndGo();
    });
  }

  Future<void> _pauseAndGo() async {
    final userStatus = await this._userService.getUserStatus();
    await Future.delayed(Duration(seconds: 2));
    if(userStatus == UserStatus.authenticated)
        this._navigator.pushReplacementNamed(Routes.home);
    else if(userStatus== UserStatus.created)
        this._navigator.pushReplacementNamed(Routes.login);
      else
      this._navigator.pushReplacementNamed(Routes.signUp);
    }
}
