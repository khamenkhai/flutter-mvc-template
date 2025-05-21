part of 'theme_cubit.dart';

class ThemeState {
  final ThemeData theme;
  final String fontFamily;
  final ThemeMode themeMode;

  ThemeState({
    required this.theme,
    required this.fontFamily,
    required this.themeMode,
  });

  // Add copyWith if needed
  ThemeState copyWith({
    ThemeData? theme,
    String? fontFamily,
    ThemeMode? themeMode,
  }) {
    return ThemeState(
      theme: theme ?? this.theme,
      fontFamily: fontFamily ?? this.fontFamily,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}