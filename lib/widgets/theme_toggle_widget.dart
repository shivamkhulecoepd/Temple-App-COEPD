import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mslgd/blocs/theme/theme_bloc.dart';
import 'package:mslgd/services/theme_service.dart';

class ThemeToggleWidget extends StatelessWidget {
  const ThemeToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return PopupMenuButton<ThemeModeType>(
          icon: Icon(
            _getThemeIcon(state.themeMode),
            color: Colors.white,
          ),
          tooltip: 'Theme Settings',
          onSelected: (ThemeModeType themeMode) {
            context.read<ThemeBloc>().add(ChangeTheme(themeMode));
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: ThemeModeType.light,
              child: Row(
                children: [
                  Icon(
                    Icons.light_mode,
                    color: state.themeMode == ThemeModeType.light 
                        ? TempleTheme.primaryOrange 
                        : null,
                  ),
                  const SizedBox(width: 8),
                  const Text('Light'),
                  if (state.themeMode == ThemeModeType.light)
                    const Spacer(),
                  if (state.themeMode == ThemeModeType.light)
                    Icon(
                      Icons.check,
                      color: TempleTheme.primaryOrange,
                    ),
                ],
              ),
            ),
            PopupMenuItem(
              value: ThemeModeType.dark,
              child: Row(
                children: [
                  Icon(
                    Icons.dark_mode,
                    color: state.themeMode == ThemeModeType.dark 
                        ? TempleTheme.primaryOrange 
                        : null,
                  ),
                  const SizedBox(width: 8),
                  const Text('Dark'),
                  if (state.themeMode == ThemeModeType.dark)
                    const Spacer(),
                  if (state.themeMode == ThemeModeType.dark)
                    Icon(
                      Icons.check,
                      color: TempleTheme.primaryOrange,
                    ),
                ],
              ),
            ),
            PopupMenuItem(
              value: ThemeModeType.system,
              child: Row(
                children: [
                  Icon(
                    Icons.settings,
                    color: state.themeMode == ThemeModeType.system 
                        ? TempleTheme.primaryOrange 
                        : null,
                  ),
                  const SizedBox(width: 8),
                  const Text('System'),
                  if (state.themeMode == ThemeModeType.system)
                    const Spacer(),
                  if (state.themeMode == ThemeModeType.system)
                    Icon(
                      Icons.check,
                      color: TempleTheme.primaryOrange,
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  IconData _getThemeIcon(ThemeModeType themeMode) {
    switch (themeMode) {
      case ThemeModeType.light:
        return Icons.light_mode;
      case ThemeModeType.dark:
        return Icons.dark_mode;
      case ThemeModeType.system:
        return Icons.settings;
    }
  }
}