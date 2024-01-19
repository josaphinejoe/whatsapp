import 'package:example/pages/user/settings/widgets/settings-display/settings-display.dart';
import 'package:example/services/theme-provider.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class SettingsDisplayState extends WidgetStateBase<SettingsDisplay> {
  final _themeProvider = ServiceLocator.instance.resolve<ThemeProvider>();

  ValueNotifier<bool> get themeNotifier => _themeProvider.themeNotifier;

  bool get isDarkMode => this._themeProvider.isDarkMode;

  SettingsDisplayState() : super();

  void toggleTheme(bool val) {
    this._themeProvider.toggleTheme(val);
  }
}
