import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mslgd/screens/authentication/language_selection.dart';
import 'package:mslgd/widgets/layout_screen.dart';
import 'package:mslgd/services/storage_service.dart';

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

    // Navigate after splash based on first launch status
    Timer(const Duration(seconds: 3), () async {
      if (!mounted) return; // Safety check
      
      try {
        final storageService = context.read<StorageService>();
        final isFirstLaunch = await storageService.isFirstLaunch();
        
        if (!mounted) return; // Safety check after async operation
        
        if (isFirstLaunch) {
          // Mark as not first launch anymore
          await storageService.setFirstLaunch(false);
          if (!mounted) return; // Safety check after async operation
          
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LanguageSelectionScreen(),
            ),
          );
        } else {
          // Go directly to main app
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LayoutScreen(),
            ),
          );
        }
      } catch (e) {
        // Fallback navigation in case of error
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LayoutScreen(),
            ),
          );
        }
      }
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ganapathi / Temple Symbol
                  Image.asset(
                    'assets/images/about/temple_logo.png',
                    height: 72.h,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 72.h,
                        width: 72.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.temple_hindu,
                          size: 36.r,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    },
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
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      letterSpacing: 0.8,
                    ),
                  ),

                  SizedBox(height: 36.h),

                  // Loader
                  SizedBox(
                    width: 32.w,
                    height: 32.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.0,
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
      ),
    );
  }
}
