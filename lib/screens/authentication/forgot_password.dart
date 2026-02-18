import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mslgd/services/db_functions.dart';
import 'package:mslgd/services/theme_service.dart';
import 'package:mslgd/widgets/common/snackbar_widget.dart';
import 'package:mslgd/widgets/translated_text.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isSubmitting = false;
  String? _successMessage;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TranslatedText(
          'Forgot Password',
          style: TextStyle(fontFamily: 'aBeeZee'),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),

                // Header
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.lock_reset_rounded,
                        size: 80.sp,
                        color: TempleTheme.primaryOrange,
                      ),
                      SizedBox(height: 16.h),
                      TranslatedText(
                        "Reset Your Password",
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TranslatedText(
                        "Enter your registered email to receive a reset link",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 15.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 48.h),

                // Email Field
                _buildLabel('Email Address'),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration('Enter your registered email'),
                  style: TextStyle(fontFamily: 'aBeeZee'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 40.h),

                // Messages
                if (_errorMessage != null) ...[
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: TranslatedText(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red.shade800,
                        fontFamily: 'aBeeZee',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],

                if (_successMessage != null) ...[
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: TranslatedText(
                      _successMessage!,
                      style: TextStyle(color: Colors.green.shade800),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 54.h,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitResetRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TempleTheme.primaryOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : TranslatedText(
                            'Send Reset Link',
                            style: TextStyle(
                              fontFamily: 'aBeeZee',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Back to login
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: TranslatedText(
                      'Back to Sign In',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontFamily: 'aBeeZee',
                        color: TempleTheme.primaryOrange,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: TranslatedText(
        text,
        style: TextStyle(
          fontFamily: 'aBeeZee',
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      // fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    );
  }

  Future<void> _submitResetRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final result = await DBFunctions().forgotPassword(
        _emailController.text.trim(),
      );

      setState(() {
        if (result['success'] == true) {
          _successMessage = result['message'] ??
              'Reset link sent! Check your email (including spam).';
          _isSubmitting = false;
        } else {
          _errorMessage = result['message'] ?? 'An error occurred. Please try again.';
          _isSubmitting = false;
        }
      });

      if (result['success'] == true) {
        AppSnackbar.success(context, _successMessage!);
        // Optional: auto navigate back to login after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) Navigator.pop(context);
        });
      } else {
        AppSnackbar.error(context, _errorMessage!);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isSubmitting = false;
      });
      AppSnackbar.error(context, _errorMessage!);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
