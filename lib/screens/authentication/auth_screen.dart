import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temple_app/blocs/theme/theme_bloc.dart';
import 'package:temple_app/services/theme_service.dart';
import 'package:temple_app/widgets/translated_text.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844));

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _templeHeader(),
                  SizedBox(height: 30.h),

                  /// TITLE
                  TranslatedText(
                    isLogin ? "Sign In" : "Sign Up",
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      color: TempleTheme.primaryOrange,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  /// SUBTITLE
                  TranslatedText(
                    isLogin
                        // ? "Welcome back, please login to your account"
                        ? "Welcome back please login to your account"
                        : "Create an Account",
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 15.sp,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),

                  SizedBox(height: 30.h),

                  if (!isLogin) ...[
                    _label("Display Name"),
                    _input(nameCtrl, "Please enter your full name"),
                    SizedBox(height: 20.h),
                  ],

                  _label("Mobile Number"),
                  _input(
                    phoneCtrl,
                    "+91 XXXXX XXXXX",
                    keyboard: TextInputType.phone,
                  ),

                  SizedBox(height: 20.h),

                  _label("Password"),
                  _input(passCtrl, "Enter your password", obscure: true),

                  SizedBox(height: 20.h),

                  if (!isLogin) ...[
                    _label("Confirm Password"),
                    _input(confirmCtrl, "Confirm your password", obscure: true),
                    SizedBox(height: 20.h),
                    _termsText(),
                  ],

                  SizedBox(height: 30.h),

                  _primaryButton(),

                  SizedBox(height: 40.h),

                  _switchAuthMode(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ================= COMPONENTS =================

  Widget _templeHeader() => Center(
    child: Column(
      children: [
        Image.asset(
          'assets/images/temple2.png',
          height: 80.h,
          color: TempleTheme.yellowButton,
        ),
        SizedBox(height: 10.h),
        Text(
          "Marakatha Sri Lakshmi \nGanapathi Devalayam",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    ),
  );

  Widget _label(String text) => Padding(
    padding: EdgeInsets.only(bottom: 6.h),
    child: TranslatedText(
      text,
      style: TextStyle(
        fontFamily: 'aBeeZee',
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).textTheme.headlineLarge?.color,
      ),
    ),
  );

  Widget _input(
    TextEditingController controller,
    String hint, {
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      decoration: InputDecoration(
        // We use 'label' because it accepts a Widget (TranslatedText)
        label: TranslatedText(hint),
        // This ensures the label doesn't float up, making it look like a hint
        floatingLabelBehavior: FloatingLabelBehavior.never,

        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
        enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
        // Match the hint style to your label style if needed
        labelStyle: TextStyle(
          color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
          fontSize: 15.sp,
          fontFamily: 'aBeeZee',
        ),
      ),
      style: TextStyle(
        fontSize: 15.sp,
        color: Theme.of(context).textTheme.bodyMedium?.color,
      ),
    );
  }

  Widget _primaryButton() => SizedBox(
    width: 180.w,
    height: 48.h,
    child: ElevatedButton(
      onPressed: isLogin ? _login : _register,
      style: ElevatedButton.styleFrom(
        backgroundColor: TempleTheme.primaryOrange,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: TranslatedText(
        isLogin ? "Sign In" : "Sign Up",
        style: TextStyle(
          fontFamily: 'aBeeZee',
          fontSize: 16.sp,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );

  Widget _switchAuthMode() => Wrap(
    alignment: WrapAlignment.center,
    children: [
      TranslatedText(
        isLogin ? "Don't have an account? " : "Already have an account? ",
        style: TextStyle(fontFamily: 'aBeeZee'),
      ),
      GestureDetector(
        onTap: () => setState(() => isLogin = !isLogin),
        child: TranslatedText(
          isLogin ? "Sign Up" : "Sign In",
          style: TextStyle(
            fontFamily: 'aBeeZee',
            color: TempleTheme.primaryOrange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );

  Widget _termsText() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 13.sp,
            color: Colors.black,
          ),
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: TranslatedText("By signing up, you agree to the "),
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: () => print("Terms tapped"),
                child: TranslatedText(
                  "Terms & Conditions",
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp, // Match the parent font size
                  ),
                ),
              ),
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: TranslatedText(" and "),
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: () => print("Privacy tapped"),
                child: TranslatedText(
                  "Privacy Policy",
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= LOGIC =================

  void _login() {}

  void _register() {
    if (passCtrl.text != confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TranslatedText("Passwords do not match")),
      );
      return;
    }
    _showOtp();
  }

  void _showOtp() {
    showModalBottomSheet(context: context, builder: (_) => const _OtpSheet());
  }
}

// ================= OTP =================

class _OtpSheet extends StatelessWidget {
  const _OtpSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TranslatedText(
            "Verify OTP",
            style: TextStyle(
              fontSize: 22.sp, 
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.headlineMedium?.color,
            ),
          ),
          SizedBox(height: 10.h),
          TranslatedText(
            "Enter the 6-digit code sent to your mobile",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          SizedBox(height: 30.h),
          Pinput(length: 6),
          SizedBox(height: 30.h),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: TempleTheme.primaryOrange,
              foregroundColor: Colors.white,
            ),
            child: TranslatedText("Verify"),
          ),
        ],
      ),
    );
  }
}
