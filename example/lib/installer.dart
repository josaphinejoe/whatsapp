import 'package:example/dialogs/dialog_service.dart';
import 'package:example/sdk/services/file-service/default-file-service.dart';
import 'package:example/sdk/services/file-service/file-service.dart';
import 'package:example/sdk/services/user-service/mock-user-service.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:example/services/theme-provider.dart';
import 'package:floater/floater.dart';

class Installer extends ServiceInstaller {
  @override
  void install(ServiceRegistry registry) {
    registry
      ..registerSingleton<UserService>(() => MockUserService())
      ..registerSingleton<FileService>(() => DefaultFileService())
      ..registerSingleton<ThemeProvider>(() => ThemeProvider())
      ..registerSingleton<DialogService>(() => DialogService());
  }
}
