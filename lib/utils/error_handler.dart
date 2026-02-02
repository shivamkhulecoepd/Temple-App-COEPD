import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 16),
              const TranslatedText(
                'Something went wrong!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (kDebugMode)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TranslatedText(
                    details.exception.toString(),
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Try to restart the app or go back
                  // This is a simplified approach - in production you might want
                  // to navigate to a safe screen
                },
                child: const TranslatedText('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}