import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AppSettingsProvider extends ChangeNotifier {
  final Box _box = Hive.box('settings');
  ThemeMode _themeMode = ThemeMode.system;
  double _quranFontSize = 30;
  Color _seedColor = const Color(0xFF0F766E);

  AppSettingsProvider() {
    final mode = _box.get('themeMode', defaultValue: 'system');
    _themeMode = switch (mode) { 'light' => ThemeMode.light, 'dark' => ThemeMode.dark, _ => ThemeMode.system };
    _quranFontSize = (_box.get('quranFontSize', defaultValue: 30) as num).toDouble();
    _seedColor = Color(_box.get('seedColor', defaultValue: 0xFF0F766E) as int);
  }

  ThemeMode get themeMode => _themeMode;
  double get quranFontSize => _quranFontSize;
  Color get seedColor => _seedColor;

  Future<void> setThemeMode(ThemeMode value) async {
    _themeMode = value;
    await _box.put('themeMode', value.name);
    notifyListeners();
  }

  Future<void> setQuranFontSize(double value) async {
    _quranFontSize = value;
    await _box.put('quranFontSize', value);
    notifyListeners();
  }

  Future<void> setSeedColor(Color value) async {
    _seedColor = value;
    await _box.put('seedColor', value.toARGB32());
    notifyListeners();
  }
}
