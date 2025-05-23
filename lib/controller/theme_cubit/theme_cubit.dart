// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_frame/core/const/theme_const.dart';
import 'package:project_frame/core/local_data/shared_prefs.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPref sharedPref;
  ThemeData? _cachedLightTheme;
  ThemeData? _cachedDarkTheme;
  String? _cachedFontFamily;

  ThemeCubit({required this.sharedPref})
      : super(
          ThemeState(
            theme: AppTheme.light(fontFamily: "Outfit"),
            fontFamily: "Outfit",
            themeMode: ThemeMode.system,
          ),
        ) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final savedThemeMode = await sharedPref.getTheme();
    _cachedFontFamily ??= "Outfit";

    // Handle system theme mode
    if (savedThemeMode == 'system') {
      final brightness = WidgetsBinding.instance.window.platformBrightness;
      _updateThemeFromBrightness(brightness);
      emit(ThemeState(
        theme: brightness == Brightness.light 
            ? _cachedLightTheme ??= AppTheme.light(fontFamily: _cachedFontFamily!)
            : _cachedDarkTheme ??= AppTheme.dark(fontFamily: _cachedFontFamily!),
        fontFamily: _cachedFontFamily!,
        themeMode: ThemeMode.system,
      ));
    } 
    // Handle explicit light/dark modes
    else {
      emit(ThemeState(
        theme: savedThemeMode == 'light'
            ? _cachedLightTheme ??= AppTheme.light(fontFamily: _cachedFontFamily!)
            : _cachedDarkTheme ??= AppTheme.dark(fontFamily: _cachedFontFamily!),
        fontFamily: _cachedFontFamily!,
        themeMode: savedThemeMode == 'light' ? ThemeMode.light : ThemeMode.dark,
      ));
    }
  }

  void _updateThemeFromBrightness(Brightness brightness) {
    if (brightness == Brightness.light) {
      _cachedLightTheme ??= AppTheme.light(fontFamily: _cachedFontFamily!);
    } else {
      _cachedDarkTheme ??= AppTheme.dark(fontFamily: _cachedFontFamily!);
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    String themeModeString;
    
    switch (themeMode) {
      case ThemeMode.system:
        themeModeString = 'system';
        final brightness = WidgetsBinding.instance.window.platformBrightness;
        _updateThemeFromBrightness(brightness);
        break;
      case ThemeMode.light:
        themeModeString = 'light';
        _cachedLightTheme ??= AppTheme.light(fontFamily: _cachedFontFamily!);
        break;
      case ThemeMode.dark:
        themeModeString = 'dark';
        _cachedDarkTheme ??= AppTheme.dark(fontFamily: _cachedFontFamily!);
        break;
    }

    emit(ThemeState(
      theme: themeMode == ThemeMode.system
          ? (WidgetsBinding.instance.window.platformBrightness == Brightness.light
              ? _cachedLightTheme!
              : _cachedDarkTheme!)
          : (themeMode == ThemeMode.light ? _cachedLightTheme! : _cachedDarkTheme!),
      fontFamily: _cachedFontFamily!,
      themeMode: themeMode,
    ));

    await sharedPref.setTheme(themeModeString);
  }

  Future<void> toggleTheme() async {
    final currentMode = state.themeMode;
    
    if (currentMode == ThemeMode.system) {
      // If system mode, toggle based on current brightness
      final brightness = WidgetsBinding.instance.window.platformBrightness;
      await setThemeMode(brightness == Brightness.light ? ThemeMode.dark : ThemeMode.light);
    } else {
      // If explicit light/dark mode, just toggle between them
      await setThemeMode(currentMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
    }
  }

  void updateFontFamily(String newFontFamily) {
    _cachedFontFamily = newFontFamily;
    
    // Update both themes with new font family
    _cachedLightTheme = AppTheme.light(fontFamily: newFontFamily);
    _cachedDarkTheme = AppTheme.dark(fontFamily: newFontFamily);

    emit(ThemeState(
      theme: state.themeMode == ThemeMode.system
          ? (WidgetsBinding.instance.window.platformBrightness == Brightness.light
              ? _cachedLightTheme!
              : _cachedDarkTheme!)
          : (state.themeMode == ThemeMode.light ? _cachedLightTheme! : _cachedDarkTheme!),
      fontFamily: newFontFamily,
      themeMode: state.themeMode,
    ));
  }
}