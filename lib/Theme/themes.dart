import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: const Color(0xFFedeced),
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    tertiary: Colors.grey.shade500,
    inversePrimary: Colors.grey.shade900,
  ),
  fontFamily: 'Poppins',
);

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Colors.black,
    primary: const Color(0xFFedeced),
    secondary: const Color(0xFFedeced),
    tertiary: Colors.grey.shade600,
    inversePrimary: Colors.grey.shade100,
  ),
  fontFamily: 'Poppins',
);

class ThemeProvider extends ChangeNotifier with WidgetsBindingObserver {
  ThemeData _themeData = lightMode;

  ThemeProvider() {
    WidgetsBinding.instance.addObserver(this);
    // ignore: deprecated_member_use
    setThemeBasedOnSystemBrightness(
        WidgetsBinding.instance.window.platformBrightness);
  }

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    _themeData = _themeData == lightMode ? darkMode : lightMode;
    notifyListeners();
  }

  void setThemeBasedOnSystemBrightness(Brightness brightness) {
    _themeData = brightness == Brightness.dark ? darkMode : lightMode;
    notifyListeners();
  }

  @override
  void didChangePlatformBrightness() {
    // ignore: deprecated_member_use
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    setThemeBasedOnSystemBrightness(brightness);
    super.didChangePlatformBrightness();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
