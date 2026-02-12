import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mslgd/widgets/common/snackbar_widget.dart';
import 'package:mslgd/widgets/layout_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mslgd/blocs/theme/theme_bloc.dart';
import 'package:mslgd/services/theme_service.dart';
import 'package:mslgd/services/storage_service.dart';
import 'package:mslgd/models/user_model.dart';
import 'package:mslgd/widgets/translated_text.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool _isLoading = false;

  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  // Add password visibility state variables
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    passCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

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
                  _input(
                    passCtrl,
                    "Enter your password",
                    obscure: !_isPasswordVisible,
                    showIcon: true,
                    onToggleVisibility: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),

                  SizedBox(height: 20.h),

                  if (!isLogin) ...[
                    _label("Confirm Password"),
                    _input(
                      confirmCtrl,
                      "Confirm your password",
                      obscure: !_isConfirmPasswordVisible,
                      showIcon: true,
                      onToggleVisibility: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
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
        Image.asset('assets/images/about/temple_logo.png', height: 80.h),
        SizedBox(height: 10.h),
        TranslatedText(
          "Marakatha Sri Lakshmi \nGanapathi Devasthanam",
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
    bool showIcon = false,
    VoidCallback? onToggleVisibility,
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
        suffixIcon: showIcon
            ? InkWell(
                onTap: onToggleVisibility,
                child: (obscure
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility)),
              )
            : null,
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
        fontFamily: 'aBeeZee',
        fontSize: 15.sp,
        color: Theme.of(context).textTheme.bodyMedium?.color,
      ),
    );
  }

  Widget _primaryButton() => SizedBox(
    width: 180.w,
    height: 48.h,
    child: ElevatedButton(
      // onPressed: isLogin ? _login : _register,
      onPressed: _isLoading ? null : (isLogin ? _login : _register),
      style: ElevatedButton.styleFrom(
        backgroundColor: TempleTheme.primaryOrange,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : TranslatedText(
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

  Widget _switchAuthMode() => Column(
    spacing: 20.h,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Wrap(
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
      ),
      GestureDetector(
        onTap: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LayoutScreen()),
          (Route<dynamic> route) => false,
        ),
        child: TranslatedText(
          "Skip for now",
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
                onTap: () => log("Terms tapped"),
                child: TranslatedText(
                  "Terms & Conditions",
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
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
                onTap: () => log("Privacy tapped"),
                child: TranslatedText(
                  "Privacy Policy",
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
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

  void _login() async {
    final mobile = phoneCtrl.text.trim();
    final password = passCtrl.text.trim();

    if (mobile.isEmpty || password.isEmpty) {
      AppSnackbar.warning(context, 'Please enter mobile and password');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(
          'https://marakatasrilaxmiganapathi.org/api/devotee_login.php',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mobile': mobile, 'password': password}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['success'] == true) {
          final user = UserModel.fromJson(json['data'], mobile);

          // Save to storage
          final storageService = StorageService();
          await storageService.setUserLoggedIn(true);
          await storageService.saveUserData(user.toStorageString());
          await storageService.saveUserToken(user.token);

          if (mounted) {
            AppSnackbar.success(context, 'Welcome back, ${user.devoteeName}!');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LayoutScreen()),
              (route) => false,
            );
          }
        } else {
          if (mounted) {
            log("Server error: ${response.body}");
            AppSnackbar.error(context, json['message'] ?? 'Login failed');
          }
        }
      } else {
        if (mounted) {
          // log("Server error: ${response.body}");
          // AppSnackbar.error(context, 'Server error: ${response.statusCode}');
          var res = jsonDecode(response.body);
          AppSnackbar.error(context, res['message']);
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.error(context, 'Network error: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _register() async {
    final name = nameCtrl.text.trim();
    final mobile = phoneCtrl.text.trim();
    final password = passCtrl.text.trim();
    final confirm = confirmCtrl.text.trim();

    if (name.isEmpty || mobile.isEmpty || password.isEmpty || confirm.isEmpty) {
      AppSnackbar.warning(context, 'All fields are required');
      return;
    }

    if (password != confirm) {
      AppSnackbar.warning(context, 'Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(
          'https://marakatasrilaxmiganapathi.org/api/devotee_register.php',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'mobile': mobile,
          'password': password,
          'confirm_password': confirm,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['success'] == true) {
          if (mounted) {
            AppSnackbar.success(
              context,
              'Registered successfully! Please sign in.',
            );
            setState(() => isLogin = true);
            // Clear form fields
            nameCtrl.clear();
            phoneCtrl.clear();
            passCtrl.clear();
            confirmCtrl.clear();
          }
        } else {
          if (mounted) {
            AppSnackbar.error(
              context,
              json['message'] ?? 'Registration failed',
            );
          }
        }
      } else {
        if (mounted) {
          AppSnackbar.error(context, 'Server error: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.error(context, 'Network error: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
