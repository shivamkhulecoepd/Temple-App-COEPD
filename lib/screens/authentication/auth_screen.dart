import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

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

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3E8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _templeHeader(),
              SizedBox(height: 30.h),

              /// TITLE
              Text(
                isLogin ? "Sign In" : "Sign Up",
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF9B0200),
                ),
              ),

              SizedBox(height: 6.h),

              /// SUBTITLE
              Text(
                isLogin
                    ? "Welcome back, please login to your account"
                    : "Create an Account",
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontSize: 15.sp,
                  color: Colors.black54,
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
  }

  // ================= COMPONENTS =================

  Widget _templeHeader() => Center(
    child: Column(
      children: [
        Image.asset(
          'assets/images/temple2.png',
          height: 80.h,
          color: const Color(0xFFFF9800),
        ),
        SizedBox(height: 10.h),
        Text(
          "Marakatha Sri Lakshmi \nGanapathi Devalayam",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF043342),
          ),
        ),
      ],
    ),
  );

  Widget _label(String text) => Padding(
    padding: EdgeInsets.only(bottom: 6.h),
    child: Text(
      text,
      style: TextStyle(
        fontFamily: 'aBeeZee',
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
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
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(fontSize: 15.sp),
    );
  }

  Widget _primaryButton() => SizedBox(
    width: 180.w,
    height: 48.h,
    child: ElevatedButton(
      onPressed: isLogin ? _login : _register,
      // style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF15A29), enableFeedback: true),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF15A29),
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Text(
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
      Text(
        isLogin ? "Don't have an account? " : "Already have an account? ",
        style: TextStyle(fontFamily: 'aBeeZee'),
      ),
      GestureDetector(
        onTap: () => setState(() => isLogin = !isLogin),
        child: Text(
          isLogin ? "Sign Up" : "Sign In",
          style: const TextStyle(
            fontFamily: 'aBeeZee',
            color: Color(0xFFF15A29),
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
          children: const [
            TextSpan(text: "By signing up, you agree to the "),
            TextSpan(
              text: "Terms & Conditions",
              style: TextStyle(
                color: Colors.amber, // Yellow shade
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(text: " and "),
            TextSpan(
              text: "Privacy Policy",
              style: TextStyle(
                color: Colors.amber, // Yellow shade
                fontWeight: FontWeight.w600,
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Passwords do not match")));
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
          Text(
            "Verify OTP",
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.h),
          Text(
            "Enter the 6-digit code sent to your mobile",
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30.h),
          Pinput(length: 6),
          SizedBox(height: 30.h),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Verify"),
          ),
        ],
      ),
    );
  }
}
