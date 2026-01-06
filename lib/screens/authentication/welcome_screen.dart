import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/screens/authentication/auth_screen.dart';
import 'package:temple_app/screens/dashboard/home_screen.dart';

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
        children: [
          /// Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome_screen_bg.png',
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
                    const Color(0xFF043342).withOpacity(0.5),
                    const Color(0xFF9B0200).withOpacity(0.4),
                  ],
                ),
              ),
            ),
          ),

          /// Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  const Spacer(),

                  /// Glass Card
                  Container(
                    padding: EdgeInsets.all(22.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 18.r,
                          offset: Offset(0, 10.h),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Title
                        Text(
                          'Begin Your Day with a Divine Moment',
                          style: TextStyle(
                            fontFamily: 'aBeeZee',
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 12.h),

                        /// Subtitle
                        Text(
                          'Connect with Marakatha Sri Lakshmi Ganapathi Devalayam through darshan, pujas and sacred updates.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15.sp,
                            color: Colors.white,
                            height: 1.6,
                          ),
                        ),

                        SizedBox(height: 24.h),

                        /// Feature Highlights
                        _featureRow(
                          icon: Icons.temple_hindu,
                          text: 'Book Pujas & Sevas easily',
                        ),
                        SizedBox(height: 12.h),
                        _featureRow(
                          icon: Icons.notifications_active,
                          text: 'Receive daily divine notifications',
                        ),
                        SizedBox(height: 12.h),
                        _featureRow(
                          icon: Icons.favorite,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AuthScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF9800),
                              foregroundColor: Colors.white,
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                fontFamily: 'aBeeZee',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Skip for now',
                              style: TextStyle(
                                fontFamily: 'aBeeZee',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h), // Extra bottom space if needed
                ],
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
            color: const Color(0xFFFF9800).withOpacity(0.35),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 20.sp, color: Colors.white),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 14.5.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
