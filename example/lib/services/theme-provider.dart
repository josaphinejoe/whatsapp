import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeProvider {
  final FlutterSecureStorage _themeStorage = FlutterSecureStorage();
  final _storageKey = "theme";

  final ThemeData _lightTheme = ThemeData(
    primaryColor: const Color(0xFF387463),
    brightness: Brightness.light,
  );

  final ThemeData _darkTheme = ThemeData(
    primaryColor: Colors.grey[900],
    brightness: Brightness.dark,
  );

  final ValueNotifier<bool> _themeNotifier = ValueNotifier<bool>(false);

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeData get currentTheme => _isDarkMode ? _darkTheme : _lightTheme;

  ValueNotifier<bool> get themeNotifier => _themeNotifier;

  void toggleTheme(bool val) {
    _isDarkMode = val;
    this._themeNotifier.value = this._isDarkMode;
    this._updateThemeInStorage();
  }

  Future<void> loadThemeFromStorage() async {
    final storedValue = await this._themeStorage.read(key: this._storageKey);
    if (storedValue != null) {
      // ignore: sdk_version_since
      this._isDarkMode = bool.parse(storedValue, caseSensitive: false);
      this._themeNotifier.value = this._isDarkMode;
    } else {
      await this._updateThemeInStorage();
    }
  }

  Future<void> _updateThemeInStorage() async {
    await _themeStorage.write(key: this._storageKey, value: this._isDarkMode.toString());
  }
}
