import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mslgd/screens/authentication/language_selection.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    // Navigate after splash
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LanguageSelectionScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF7F3E8),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ganapathi / Temple Symbol
                Center(
                  child: Image.asset(
                    'assets/images/about/temple_logo.png',
                    height: 72.h,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(height: 28.h),

                // Temple Name
                Text(
                  "Marakatha Sri Lakshmi\nGanapathi Devalayam",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    // color: const Color(0xFF043342),
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.3,
                  ),
                ),

                SizedBox(height: 14.h),

                // Subtitle
                Text(
                  "Divine Blessings • Peace • Prosperity",
                  style: TextStyle(
                    fontFamily: 'inter',
                    fontSize: 14.sp,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: 0.8,
                  ),
                ),

                SizedBox(height: 36.h),

                // Loader
                SizedBox(
                  width: 32.w,
                  height: 32.h,
                  child: CircularProgressIndicator(
                    strokeWidth:
                        3, // strokeWidth scales less commonly, keep fixed or use .r if needed
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
