import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mslgd/screens/authentication/auth_screen.dart';
import 'package:mslgd/widgets/layout_screen.dart';

import 'package:mslgd/widgets/translated_text.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/welcome_screen_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          /// Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.5),
                    Theme.of(
                      context,
                    ).colorScheme.secondary.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ),

          /// Content
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 30.h),
                    // Glass Card
                    Container(
                      padding: EdgeInsets.all(22.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 18.r,
                            offset: Offset(0, 10.h),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Title
                          TranslatedText(
                            'Begin Your Day with a Divine Moment',
                            style: TextStyle(
                              fontFamily: 'aBeeZee',
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              // color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          SizedBox(height: 12.h),

                          /// Subtitle
                          TranslatedText(
                            'Connect with Marakatha Sri Lakshmi Ganapathi Devasthanam through darshan, pujas and sacred updates.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15.sp,
                              color: Colors.white,
                              // color: Theme.of(context).colorScheme.surface,
                              height: 1.6,
                            ),
                          ),

                          SizedBox(height: 24.h),

                          /// Feature Highlights
                          _featureRow(
                            icon: Icons.temple_hindu_outlined,
                            text: 'Book Pujas & Sevas easily',
                          ),
                          SizedBox(height: 12.h),
                          _featureRow(
                            icon: Icons.notifications_active_outlined,
                            text: 'Receive daily divine notifications',
                          ),
                          SizedBox(height: 12.h),
                          _featureRow(
                            icon: Icons.favorite_border_outlined,
                            text: 'Stay spiritually connected anytime',
                          ),

                          SizedBox(height: 28.h),

                          /// Continue Button
                          SizedBox(
                            width: double.infinity,
                            height: 54.h,
                            child: ElevatedButton(
                              onPressed: () {
                                HapticFeedback.vibrate();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AuthScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                // backgroundColor: const Color(0xFFFF9800),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.secondary,
                                // foregroundColor: Colors.white,
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.surface,

                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              child: TranslatedText(
                                'Continue for Login',
                                style: TextStyle(
                                  fontFamily: 'aBeeZee',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 14.h),

                          /// Skip Button
                          Center(
                            child: TextButton(
                              onPressed: () {
                                HapticFeedback.heavyImpact();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LayoutScreen(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: TranslatedText(
                                'Skip for now',
                                style: TextStyle(
                                  fontFamily: 'aBeeZee',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  // color: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.secondary.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            size: 20.sp,
            // color: Theme.of(context).colorScheme.surface,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: TranslatedText(
            text,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 14.5.sp,
              color: Colors.white,
              // color: Theme.of(context).colorScheme.surface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
