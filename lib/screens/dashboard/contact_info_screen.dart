import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temple_app/widgets/common/gallery_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:temple_app/blocs/theme/theme_bloc.dart';
import 'package:temple_app/widgets/translated_text.dart';

// ── TEMPORARY: In future → fetch from API / Bloc / Firebase ──
const Map<String, dynamic> contactInfo = {
  "id": "1",
  "address":
      "Plot 6, Military Dairy Farm Road, Sai Nagar, Kanajiguda, Secunderabad - 5000",
  "phone1": "9550317277",
  "phone2": "9949060885",
  "email": "info@ganapathitemple.org",
  "map_embed":
      "<iframe src=\"https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3805.465338810557!2d78.49195257383163!3d17.485286299980125!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3bcb9a93ed4c27cf%3A0x841315cfc51aa611!2sMarakatha%20Sri%20Lakshmi%20Ganapathi%20Temple!5e0!3m2!1sen!2sin!4v1766726802785!5m2!1sen!2sin\" width=\"600\" height=\"450\" style=\"border:0;\" allowfullscreen=\"\" loading=\"lazy\" referrerpolicy=\"no-referrer-when-downgrade\"></iframe>",
  "updated_at": "2025-12-27 11:50:29",
};

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  String? _selectedService;

  final List<String> _services = [
    'General Inquiry',
    'Donation Related',
    'Prasadam Booking',
    'Temple Visit / Darshan',
    'Feedback / Complaint',
    'Other',
  ];

  late final WebViewController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(_getCleanMapHtml(contactInfo['map_embed']));
  }

  // Clean up iframe attributes that may cause issues in WebView
  String _getCleanMapHtml(String rawIframe) {
    // You can further sanitize if needed (remove width/height or override via CSS)
    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        body, html { margin:0; padding:0; height:100%; overflow:hidden; }
        iframe { width:100% !important; height:100% !important; border:0; }
      </style>
    </head>
    <body>
      $rawIframe
    </body>
    </html>
    ''';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TranslatedText('Form submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // TODO: Send to backend (include name, phone, email, service, subject, message)
      _formKey.currentState?.reset();
      setState(() => _selectedService = null);
      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: TranslatedText(
              'Contact Us',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'aBeeZee',
              ),
            ),
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          body: Stack(
            children: [
              // Background image
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background/main_bg1.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Black overlay in dark mode
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withValues(alpha: 0.8)
                      : Colors.transparent,
                ),
              ),
              // Main Content
              SafeArea(
                child: SingleChildScrollView(
                  // padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Contact Form ──
                      Container(
                        padding: EdgeInsets.all(16.w),
                        margin: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: theme.cardColor.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.12),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TranslatedText(
                                'Get in Touch',
                                style: TextStyle(
                                  fontFamily: 'aBeeZee',
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              TranslatedText(
                                'We would love to hear from you',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: 'aBeeZee',
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 14.h),

                              // Name
                              _buildTextField(
                                controller: _nameController,
                                label: 'Enter your Name',
                                validator: (v) => v?.trim().isEmpty ?? true
                                    ? 'Please enter your name'
                                    : null,
                              ),
                              SizedBox(height: 14.h),

                              // Phone
                              _buildTextField(
                                controller: _phoneController,
                                label: 'Enter your Phone',
                                keyboardType: TextInputType.phone,
                                validator: (v) {
                                  if (v?.trim().isEmpty ?? true) {
                                    return 'Please enter phone number';
                                  }
                                  if ((v?.length ?? 0) < 10) {
                                    return 'Invalid phone number';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 14.h),

                              // Email
                              _buildTextField(
                                controller: _emailController,
                                label: 'Enter your Email ID',
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                  if (v?.trim().isEmpty ?? true) {
                                    return 'Please enter email';
                                  }
                                  if (!RegExp(
                                    r'^[^@]+@[^@]+\.[^@]+',
                                  ).hasMatch(v ?? '')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 14.h),

                              // Service Dropdown
                              _buildDropdown(),
                              SizedBox(height: 20.h),

                              // Subject
                              _buildTextField(
                                controller: _subjectController,
                                label: 'Enter your Subject',
                                validator: (v) => v?.trim().isEmpty ?? true
                                    ? 'Please enter subject'
                                    : null,
                              ),
                              SizedBox(height: 14.h),

                              // Message
                              _buildTextField(
                                controller: _messageController,
                                label: 'Enter your Message...',
                                maxLines: 5,
                                minLines: 4,
                                validator: (v) => v?.trim().isEmpty ?? true
                                    ? 'Please enter your message'
                                    : null,
                              ),
                              SizedBox(height: 28.h),

                              // Submit Button
                              SizedBox(
                                width: double.infinity,
                                height: 54.h,
                                child: ElevatedButton(
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    elevation: 3,
                                  ),
                                  child: TranslatedText(
                                    'Submit',
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
                      ),
                      // ── Temple Contact & Live Location ──
                      Container(
                        padding: EdgeInsets.all(20.w),
                        margin: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.12),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: theme.colorScheme.secondary,
                                  size: 28.w,
                                ),
                                SizedBox(width: 12.w),
                                TranslatedText(
                                  'Temple Location',
                                  style: TextStyle(
                                    fontFamily: 'aBeeZee',
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),

                            _infoRow(
                              Icons.home,
                              'Address',
                              contactInfo['address'],
                              isTranslation: true,
                            ),
                            SizedBox(height: 12.h),
                            _infoRow(
                              Icons.phone,
                              'Phone',
                              contactInfo['phone1'],
                            ),
                            if (contactInfo['phone2'] != null &&
                                contactInfo['phone2'].isNotEmpty) ...[
                              SizedBox(height: 8.h),
                              _infoRow(
                                Icons.phone,
                                'Alternate Phone',
                                contactInfo['phone2'],
                              ),
                            ],
                            SizedBox(height: 8.h),
                            _infoRow(
                              Icons.email,
                              'Email',
                              contactInfo['email'],
                            ),

                            SizedBox(height: 20.h),

                            TranslatedText(
                              'Find us on map',
                              style: TextStyle(
                                fontFamily: 'aBeeZee',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                            SizedBox(height: 12.h),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: SizedBox(
                                height: 240.h,
                                child: WebViewWidget(
                                  controller: _mapController,
                                ),
                              ),
                            ),

                            if (contactInfo['updated_at'] != null) ...[
                              SizedBox(height: 12.h),
                              TranslatedText(
                                'Last updated: ${contactInfo['updated_at']}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: 'aBeeZee',
                                  color: isDark
                                      ? Colors.grey[500]
                                      : Colors.grey[700],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),
                      GalleryWidget(title: 'Image Gallery'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(
    IconData icon,
    String label,
    String value, {
    bool isTranslation = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20.w, color: Theme.of(context).colorScheme.secondary),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TranslatedText(
                label,
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 2.h),
              isTranslation
                  ? TranslatedText(
                      value,
                      style: TextStyle(
                        fontFamily: 'aBeeZee',
                        fontSize: 15.sp,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.black87,
                      ),
                    )
                  : Text(
                      value,
                      style: TextStyle(
                        fontFamily: 'aBeeZee',
                        fontSize: 15.sp,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.black87,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int minLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontFamily: 'aBeeZee',
          fontSize: 15.sp,
          color: Colors.grey[600],
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
        ),
      ),
      style: TextStyle(fontSize: 16.sp, fontFamily: 'aBeeZee'),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedService,
      isExpanded: true,
      hint: TranslatedText(
        'Select a Service',
        style: TextStyle(
          fontFamily: 'aBeeZee',
          fontSize: 15.sp,
          color: Colors.grey[600],
        ),
      ),
      items: _services.map((service) {
        return DropdownMenuItem(
          value: service,
          child: TranslatedText(
            service,
            style: TextStyle(fontFamily: 'aBeeZee', fontSize: 15.sp),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedService = value),
      validator: (v) => v == null ? 'Required' : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
        ),
      ),
    );
  }
}
