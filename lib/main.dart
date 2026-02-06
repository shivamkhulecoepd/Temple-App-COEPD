import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mslgd/blocs/language/language_bloc.dart';
import 'package:mslgd/blocs/theme/theme_bloc.dart';
import 'package:mslgd/services/storage_service.dart';
import 'package:mslgd/services/translation_service.dart';
import 'package:mslgd/services/theme_service.dart';
import 'package:mslgd/screens/authentication/splash_screen.dart';
import 'package:mslgd/utils/error_handler.dart';

void main() {
  // Set up error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    ErrorHandler.handleError(
      details.exception,
      details.stack ?? StackTrace.empty,
    );
  };

  runApp(const TempleApp());
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
            create: (context) =>
                ThemeBloc(storageService: context.read<StorageService>())
                  ..add(LoadTheme()),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812), // Standard design size
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return BlocBuilder<ThemeBloc, ThemeState>(
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
                  builder: (context, widget) {
                    // Handle any remaining widget errors
                    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                      return ErrorHandler.buildErrorWidget(errorDetails);
                    };
                    return widget ?? const SizedBox.shrink();
                  },
                  home: const SplashScreen(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
