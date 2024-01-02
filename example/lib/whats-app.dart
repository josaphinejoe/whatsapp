import 'package:example/services/theme-provider.dart';
import 'package:example/widgets/shell/shell.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';


class WhatsApp extends StatelessWidgetBase{
  final ThemeProvider themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context)
  {
    return ValueListenableBuilder(
      valueListenable: themeProvider.themeNotifier, 
      builder: (context, isDarkMode,child) {
        return MaterialApp(
          home: Shell(),
          theme: themeProvider.currentTheme
        );
      });
  }
}