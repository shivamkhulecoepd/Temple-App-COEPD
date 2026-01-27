import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mslgd/blocs/language/language_bloc.dart';
import 'package:mslgd/blocs/theme/theme_bloc.dart';
import 'package:mslgd/services/storage_service.dart';
import 'package:mslgd/services/translation_service.dart';
import 'package:mslgd/services/theme_service.dart';
import 'package:mslgd/screens/authentication/splash_screen.dart';

void main() {
  runApp(TempleApp());
}

class TempleApp extends StatelessWidget {
  const TempleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => TranslationService()),
        RepositoryProvider(create: (context) => StorageService()),
        RepositoryProvider(create: (context) => ThemeService()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LanguageBloc(
              translationService: context.read<TranslationService>(),
              storageService: context.read<StorageService>(),
            )..add(LoadLanguage()),
          ),
          BlocProvider(
            create: (context) => ThemeBloc(
              storageService: context.read<StorageService>(),
            )..add(LoadTheme()),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: themeState.themeMode == ThemeModeType.light 
                  ? ThemeMode.light 
                  : themeState.themeMode == ThemeModeType.dark 
                      ? ThemeMode.dark 
                      : ThemeMode.system,
              theme: TempleTheme.lightTheme(),
              darkTheme: TempleTheme.darkTheme(),
              home: Builder(
                builder: (context) {
                  final mediaQuery = MediaQuery.of(context);
                  final screenSize = mediaQuery.size;
                  return ScreenUtilInit(
                    designSize: Size(screenSize.width, screenSize.height),
                    minTextAdapt: true,
                    builder: (_, child) {
                      return const SplashScreen();
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}