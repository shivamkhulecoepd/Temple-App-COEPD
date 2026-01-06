import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/screens/authentication/language_selection.dart';

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
      Navigator.of(context).push(
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
    // Initialize ScreenUtil here (recommended for individual screens)
    // Assuming your design is based on a common mobile size like iPhone 14 (390x844) or standard 360x780.
    // Adjust designSize to match your Figma/Design mockup width & height in logical pixels.
    ScreenUtil.init(
      context,
      designSize: const Size(390, 844), // Change this to your actual design size
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3E8),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ganapathi / Temple Symbol
                Container(
                  height: 140.h,
                  width: 140.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE26400), Color(0xFF9B0200)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFF15A29).withOpacity(0.45),
                        blurRadius: 22.r, // .r for radius/blur (scales like width)
                        spreadRadius: 3.r,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.self_improvement, // Replace with Ganapathi SVG later
                      color: Colors.white,
                      size: 72.sp, // Use .sp for icons if you want them to scale with text
                    ),
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
                    color: const Color(0xFF043342),
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
                    color: const Color(0xFF124660),
                    letterSpacing: 0.8,
                  ),
                ),

                SizedBox(height: 36.h),

                // Loader
                SizedBox(
                  width: 32.w,
                  height: 32.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3, // strokeWidth scales less commonly, keep fixed or use .r if needed
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFFF9800),
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