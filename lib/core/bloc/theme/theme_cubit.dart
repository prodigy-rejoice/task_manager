import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:task_manager/core/bloc/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'isDarkMode';
  final Box<bool> _themeBox;

  ThemeCubit(this._themeBox) : super(const ThemeState(ThemeMode.system)) {
    _loadTheme();
  }

  void _loadTheme() {
    final bool? isDark = _themeBox.get(_themeKey);

    if (isDark != null) {
      emit(ThemeState(isDark ? ThemeMode.dark : ThemeMode.light));
    }
  }

  void toggleTheme() async {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    emit(ThemeState(newMode));

    final bool saveAsDark = newMode == ThemeMode.dark;
    await _themeBox.put(_themeKey, saveAsDark);
  }
}
