import 'package:example/pages/user/user-page.dart';
import 'package:floater/floater.dart';

class UserPageState extends WidgetStateBase<UserPage> {
  final ServiceLocator _scope = ServiceManager.instance.createScope();

  ServiceLocator get scope => this._scope;
}
