import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temple_app/blocs/language/language_bloc.dart';
import 'package:temple_app/services/theme_service.dart';
import 'package:temple_app/widgets/translated_text.dart';
import 'package:temple_app/services/translation_service.dart';
import 'package:temple_app/screens/authentication/welcome_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final List<String> _languages = [
    'English',
    'Hindi',
    'Telugu',
    'Kannada',
    'Tamil',
    'Malayalam',
    'Marathi',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(22.w, 28.h, 22.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  TranslatedText(
                    'Choose Your Language',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 3.h,
                    width: 70.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      gradient: const LinearGradient(
                        colors: [TempleTheme.gradientStart, TempleTheme.gradientEnd],
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  TranslatedText(
                    'Select your preferred language to receive divine content and continue your spiritual journey.',
                    style: TextStyle(
                      fontFamily: 'inter',
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.6,
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
                        final isSelected =
                            state.selectedLanguageCode ==
                            TranslationService.getLanguageCode(language);
                        return _buildLanguageCard(
                          context,
                          language,
                          isSelected,
                        );
                      },
                    ),
                  ),

                  /// Continue Button
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        HapticFeedback.vibrate();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WelcomeScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TempleTheme.primaryOrange,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: TempleTheme.primaryOrange.withValues(alpha: 
                          0.45,
                        ),
                        elevation: 6.r,
                        shadowColor: TempleTheme.primaryOrange.withValues(alpha: 0.45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                      ),
                      child: state.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const TranslatedText(
                              'Continue',
                              style: TextStyle(
                                fontFamily: 'aBeeZee',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageCard(
    BuildContext context,
    String language,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        context.read<LanguageBloc>().add(ChangeLanguage(language));
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
                  ? const Color(0xFFF15A29).withValues(alpha: 0.45)
                  : Colors.black.withValues(alpha: 0.06),
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
              color: isSelected ? Colors.white : Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
