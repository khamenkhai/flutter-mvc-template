import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_frame/controller/theme_cubit/theme_cubit.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();

    return IconButton(
      icon: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          // Determine which icon to show based on current theme mode
          final icon = state.themeMode == ThemeMode.dark ||
                  (state.themeMode == ThemeMode.system &&
                      Theme.of(context).brightness == Brightness.dark)
              ? const Icon(Icons.wb_sunny, key: Key('sun'))
              : const Icon(Icons.nightlight_round, key: Key('moon'));

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: Tween(begin: 0.5, end: 1.0).animate(animation),
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: icon,
          );
        },
      ),
      onPressed: () => themeCubit.toggleTheme(),
    );
  }
}

class SunMoonThemeSelector extends StatelessWidget {
  const SunMoonThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return PopupMenuButton<ThemeMode>(
          icon: Icon(
            state.themeMode == ThemeMode.system
                ? Icons.settings_suggest_outlined
                : state.themeMode == ThemeMode.light
                    ? Icons.wb_sunny
                    : Icons.nightlight_round,
          ),
          onSelected: (mode) => themeCubit.setThemeMode(mode),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: ThemeMode.system,
              child: Row(
                children: [
                  const Icon(Icons.settings_suggest_outlined),
                  const SizedBox(width: 8),
                  const Text('System Theme'),
                  if (state.themeMode == ThemeMode.system)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.check, size: 16),
                    ),
                ],
              ),
            ),
            PopupMenuItem(
              value: ThemeMode.light,
              child: Row(
                children: [
                  const Icon(Icons.wb_sunny, color: Colors.amber),
                  const SizedBox(width: 8),
                  const Text('Light Mode'),
                  if (state.themeMode == ThemeMode.light)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.check, size: 16),
                    ),
                ],
              ),
            ),
            PopupMenuItem(
              value: ThemeMode.dark,
              child: Row(
                children: [
                  const Icon(Icons.nightlight_round, color: Colors.indigo),
                  const SizedBox(width: 8),
                  const Text('Dark Mode'),
                  if (state.themeMode == ThemeMode.dark)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.check, size: 16),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
