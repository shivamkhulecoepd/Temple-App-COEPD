import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temple_app/blocs/language/language_bloc.dart';
import 'package:temple_app/screens/dashboard/home_screen.dart';
import 'package:temple_app/services/storage_service.dart';
import 'package:temple_app/services/translation_service.dart';

import 'package:temple_app/screens/authentication/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => TranslationService()),
        RepositoryProvider(create: (context) => StorageService()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LanguageBloc(
              translationService: context.read<TranslationService>(),
              storageService: context.read<StorageService>(),
            )..add(LoadLanguage()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Builder(
            builder: (context) {
              final mediaQuery = MediaQuery.of(context);
              final screenSize = mediaQuery.size;
              return ScreenUtilInit(
                designSize: Size(screenSize.width, screenSize.height),
                minTextAdapt: true,
                builder: (_, child) {
                  // return const SplashScreen();
                  return const HomeScreen();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
