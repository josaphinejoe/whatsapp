import 'package:example/whats-app/whats-app-state.dart';
import 'package:example/widgets/shell/shell.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class WhatsApp extends StatefulWidgetBase<WhatsAppState> {
  WhatsApp() : super(() => WhatsAppState());

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: this.state.themeProvider.themeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          home: Shell(),
          theme: this.state.themeProvider.currentTheme,
        );
      },
    );
  }
}
