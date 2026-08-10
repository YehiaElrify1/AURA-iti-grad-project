// lib/app/core/theme/theme_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences _prefs;
  static const _key = 'theme_mode';

  ThemeCubit(this._prefs) : super(_load(_prefs));

  static ThemeMode _load(SharedPreferences prefs) {
    final saved = prefs.getString(_key);
    if (saved == 'dark') return ThemeMode.dark;
    if (saved == 'light') return ThemeMode.light;
    return ThemeMode.dark; // default
  }

  void setDark() => _save(ThemeMode.dark);
  void setLight() => _save(ThemeMode.light);

  void toggle() {
    if (state == ThemeMode.dark) {
      _save(ThemeMode.light);
    } else {
      _save(ThemeMode.dark);
    }
  }

  void _save(ThemeMode mode) {
    emit(mode);
    _prefs.setString(_key, mode == ThemeMode.dark ? 'dark' : 'light');
  }
}
