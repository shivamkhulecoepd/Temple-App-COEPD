import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/screens/authentication/welcome_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? _selectedLanguage;

  final List<String> _languages = [
    'English',
    'Hindi',
    'Telugu',
    'Kannada',
    'Sanskrit',
    'Tamil',
    'Malayalam',
    'Marathi',
  ];

  // Theme Colors
  static const Color bgColor = Color(0xFFF7F3E8);
  static const Color primaryBlue = Color(0xFF043342);
  static const Color secondaryBlue = Color(0xFF124660);
  static const Color primaryOrange = Color(0xFFFF9800);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(22.w, 28.h, 22.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Text(
                'Choose Your Language',
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  color: primaryBlue,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                height: 3.h,
                width: 70.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE26400), Color(0xFF9B0200)],
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                'Select your preferred language to receive divine content and continue your spiritual journey.',
                style: TextStyle(
                  fontFamily: 'inter',
                  fontSize: 15.sp,
                  color: secondaryBlue,
                  height: 1.6.h,
                ),
              ),

              SizedBox(height: 30.h),

              /// Language Grid
              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 2.8,
                  ),
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    final language = _languages[index];
                    final isSelected = _selectedLanguage == language;
                    return _buildLanguageCard(language, isSelected);
                  },
                ),
              ),

              /// Continue Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _selectedLanguage != null
                      ? () async {
                          HapticFeedback.vibrate();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WelcomeScreen(),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: primaryOrange.withOpacity(0.45),
                    elevation: 6.r,
                    shadowColor: primaryOrange.withOpacity(0.45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(String language, bool isSelected) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedLanguage = language;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFE26400), Color(0xFF9B0200)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFFF15A29).withOpacity(0.45)
                  : Colors.black.withOpacity(0.06),
              blurRadius: 12.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            language,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : primaryBlue,
            ),
          ),
        ),
      ),
    );
  }
}
