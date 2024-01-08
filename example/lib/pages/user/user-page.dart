import 'package:example/pages/routes.dart';
import 'package:example/pages/user/user-page-state.dart';
import 'package:floater/floater.dart';
import 'package:flutter/cupertino.dart';

class UserPage extends StatefulWidgetBase<UserPageState> {
  UserPage() : super(() => UserPageState());
  @override
  Widget build(BuildContext context) {
    return ScopedNavigator(
      Routes.user,
      initialRoute: Routes.profile,
      scope: this.state.scope,
    );
  }
}
