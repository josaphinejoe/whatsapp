import 'package:example/sdk/services/contacts-service/contacts-service.dart';
import 'package:example/sdk/services/contacts-service/mock-contact-service.dart';
import 'package:example/sdk/services/user-service/mock-user-service.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:example/services/bottom-nav-manager.dart';
import 'package:example/services/theme-provider.dart';
import 'package:floater/floater.dart';

class Installer extends ServiceInstaller {
  @override
  void install(ServiceRegistry registry) {
    registry.registerSingleton<UserService>(() => MockUserService());
    registry.registerSingleton<ContactService>(() => MockContactService());

    registry.registerSingleton<BottomNavManager>(() => BottomNavManager());
    registry.registerSingleton<ThemeProvider>(() => ThemeProvider());
  }
}
