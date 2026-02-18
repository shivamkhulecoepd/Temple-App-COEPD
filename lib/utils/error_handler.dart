import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mslgd/widgets/translated_text.dart';

class ErrorHandler {
  static void handleError(Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint('Error: $error');
      debugPrint('StackTrace: $stackTrace');
    }
    // Log to file or send to analytics in release mode
    // This prevents crashes from unhandled exceptions
  }

  static Widget buildErrorWidget(FlutterErrorDetails details) {
    // Return a safe error widget instead of crashing
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 60.sp),
              SizedBox(height: 16.h),
              TranslatedText(
                'Something went wrong!',
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              if (kDebugMode)
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: TranslatedText(
                    details.exception.toString(),
                    style: TextStyle(fontFamily: 'aBeeZee', fontSize: 12.sp),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () {
                  // Try to restart the app or go back
                  // This is a simplified approach - in production you might want
                  // to navigate to a safe screen
                },
                child: const TranslatedText(
                  'Try Again',
                  style: TextStyle(fontFamily: 'aBeeZee'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
