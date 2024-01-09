import 'package:example/pages/user/settings/widgets/display/display.dart';
import 'package:example/services/theme-provider.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class DisplayState extends WidgetStateBase<Display> {
  final _themeProvider = ServiceLocator.instance.resolve<ThemeProvider>();

  ValueNotifier<bool> get themeNotifier => _themeProvider.themeNotifier;

  bool get isDarkMode => this._themeProvider.isDarkMode;

  DisplayState() : super();

  void toggleTheme(bool val) {
    this._themeProvider.toggleTheme(val);
    this.triggerStateChange();
  }
}
