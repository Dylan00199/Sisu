import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  Locale _locale = const Locale('vi');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}

class SettingsScope extends InheritedNotifier<AppSettings> {
  const SettingsScope({
    super.key,
    required AppSettings settings,
    required super.child,
  }) : super(notifier: settings);

  static AppSettings of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SettingsScope>();
    assert(scope != null, 'SettingsScope was not found in the widget tree.');
    return scope!.notifier!;
  }
}
