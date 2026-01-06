import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:temple_app/screens/authentication/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          final mediaQuery = MediaQuery.of(context);
          final screenSize = mediaQuery.size;
          return ScreenUtilInit(
            designSize: Size(screenSize.width, screenSize.height),
            minTextAdapt: true,
            builder: (_, child) {
              return SplashScreen();
            },
          );
        },
      ),
    );
  }
}

