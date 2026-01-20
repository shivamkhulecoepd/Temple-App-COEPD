import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temple_app/blocs/theme/theme_bloc.dart';
import 'package:temple_app/widgets/translated_text.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController(text: 'Shivam Khule');
  final _mobileController = TextEditingController(text: '8010155144');
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updateProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Call your API / Bloc to update profile
      // Example: await AuthService.updateProfile(
      //   name: _nameController.text.trim(),
      //   mobile: _mobileController.text.trim(),
      //   newPassword: _newPasswordController.text.isNotEmpty
      //       ? _newPasswordController.text
      //       : null,
      // );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TranslatedText('Profile updated successfully!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Optional: clear password fields after success
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: isDark
              ? theme.scaffoldBackgroundColor
              : const Color(0xFFF5F5F5),
          appBar: AppBar(
            backgroundColor: const Color(0xFF8B0000), // Deep maroon/red
            title: TranslatedText(
              'My Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'aBeeZee',
              ),
            ),
            centerTitle: true,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Card
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: isDark ? theme.cardColor : Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              isDark ? 0.35 : 0.12,
                            ),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          // Center(
                          //   child: TranslatedText(
                          //     'My Profile',
                          //     style: TextStyle(
                          //       fontFamily: 'aBeeZee',
                          //       fontSize: 26.sp,
                          //       fontWeight: FontWeight.bold,
                          //       color: const Color(0xFF8B0000),
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(height: 32.h),

                          // Full Name
                          _buildLabel('Full Name'),
                          _buildTextField(
                            controller: _nameController,
                            hint: 'Enter your full name',
                            validator: (v) => v?.trim().isEmpty ?? true
                                ? 'Please enter your name'
                                : null,
                          ),
                          SizedBox(height: 24.h),

                          // Mobile Number
                          _buildLabel('Mobile Number'),
                          _buildTextField(
                            controller: _mobileController,
                            hint: 'Enter your mobile number',
                            keyboardType: TextInputType.phone,
                            validator: (v) {
                              if (v?.trim().isEmpty ?? true) {
                                return 'Mobile number is required';
                              }
                              if ((v?.length ?? 0) < 10) {
                                return 'Enter a valid 10-digit number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 32.h),

                          // Password Change Section
                          TranslatedText(
                            'Change Password (optional)',
                            style: TextStyle(
                              fontFamily: 'aBeeZee',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16.h),

                          _buildLabel('New Password'),
                          _buildPasswordField(
                            controller: _newPasswordController,
                            obscure: _obscureNewPassword,
                            onToggle: () => setState(
                              () => _obscureNewPassword = !_obscureNewPassword,
                            ),
                            hint: 'Enter new password',
                          ),
                          SizedBox(height: 16.h),

                          _buildLabel('Confirm Password'),
                          _buildPasswordField(
                            controller: _confirmPasswordController,
                            obscure: _obscureConfirmPassword,
                            onToggle: () => setState(
                              () => _obscureConfirmPassword =
                                  !_obscureConfirmPassword,
                            ),
                            hint: 'Re-enter new password',
                            validator: (v) {
                              if (_newPasswordController.text.isNotEmpty) {
                                if (v?.trim().isEmpty ?? true) {
                                  return 'Please confirm password';
                                }
                                if (v != _newPasswordController.text) {
                                  return 'Passwords do not match';
                                }
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 40.h),

                          // Update Button
                          SizedBox(
                            height: 54.h,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _updateProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8B0000),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                elevation: 4,
                              ),
                              child: TranslatedText(
                                'Update Profile',
                                style: TextStyle(
                                  fontFamily: 'aBeeZee',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white70
              : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: 15.sp,
          fontFamily: 'aBeeZee',
        ),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[850]
            : Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: const Color(0xFF8B0000), width: 2),
        ),
      ),
      style: TextStyle(
        fontSize: 16.sp,
        fontFamily: 'aBeeZee',
        color: Theme.of(context).textTheme.bodyMedium?.color,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: 15.sp,
          fontFamily: 'aBeeZee',
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[850]
            : Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: const Color(0xFF8B0000), width: 2),
        ),
      ),
      style: TextStyle(fontSize: 16.sp, fontFamily: 'aBeeZee'),
    );
  }
}
