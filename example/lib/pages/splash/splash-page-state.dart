import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:floater/floater.dart';
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
    bool isAuthenticated = false;

    final isUserExist = await this._userService.isUserExist();
    if (isUserExist) isAuthenticated = await this._userService.isAuthenticated();

    await Future.delayed(Duration(seconds: 2));

    if (isUserExist && isAuthenticated)
      this._navigator.pushReplacementNamed(Routes.home);
    else if (isUserExist)
      this._navigator.pushReplacementNamed(Routes.login);
    else
      this._navigator.pushReplacementNamed(Routes.signUp);
  }
}
