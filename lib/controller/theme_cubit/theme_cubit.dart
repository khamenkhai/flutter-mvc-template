import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_frame/core/const/theme_const.dart';
import 'package:project_frame/core/local_data/shared_prefs.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPref sharedPref;
  ThemeData? _cachedLightTheme;
  ThemeData? _cachedDarkTheme;
  String? _cachedFontFamily; // Cache the fontFamily

  ThemeCubit({required this.sharedPref})
      : super(
          ThemeState(
            theme: AppTheme.light(fontFamily: "Outfit"),
            fontFamily: "Outfit",
          ),
        ) {
    _loadTheme();
  }

  // Load the theme and cache it
  Future<void> _loadTheme() async {
    final savedTheme = await sharedPref.getTheme();
    _cachedFontFamily ??= "Outfit"; // Cache the fontFamily

    if (savedTheme == "dark") {
      _cachedDarkTheme ??= AppTheme.dark(fontFamily: _cachedFontFamily!);
      emit(
          ThemeState(theme: _cachedDarkTheme!, fontFamily: _cachedFontFamily!),);
    } else {
      _cachedLightTheme ??= AppTheme.light(fontFamily: _cachedFontFamily!);
      emit(ThemeState(
          theme: _cachedLightTheme!, fontFamily: _cachedFontFamily!));
    }
  }

  // Toggle theme with caching
  Future<void> toggleTheme() async {
    final currentTheme = state.theme;
    String newTheme;

    if (currentTheme.brightness == Brightness.light) {
      _cachedDarkTheme ??= AppTheme.dark(fontFamily: _cachedFontFamily!);
      emit(
          ThemeState(theme: _cachedDarkTheme!, fontFamily: _cachedFontFamily!));
      newTheme = "dark";
    } else {
      _cachedLightTheme ??= AppTheme.light(fontFamily: _cachedFontFamily!);
      emit(ThemeState(
          theme: _cachedLightTheme!, fontFamily: _cachedFontFamily!));
      newTheme = "light";
    }

    await sharedPref.setTheme(newTheme);
  }

  // Update fontFamily (if needed)
  void updateFontFamily(String newFontFamily) {
    _cachedFontFamily = newFontFamily; // Update the cached fontFamily
    if (state.theme.brightness == Brightness.light) {
      _cachedLightTheme = AppTheme.light(fontFamily: newFontFamily);
      emit(ThemeState(theme: _cachedLightTheme!, fontFamily: newFontFamily));
    } else {
      _cachedDarkTheme = AppTheme.dark(fontFamily: newFontFamily);
      emit(ThemeState(theme: _cachedDarkTheme!, fontFamily: newFontFamily));
    }
  }
}
