import 'package:example/installer.dart';
import 'package:example/pages/routes.dart';
import 'package:example/whats-app/whats-app.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ServiceManager.instance
    ..useInstaller(Installer())
    ..bootstrap();

  Routes.initializeNavigation();

  runApp(WhatsApp());
}
