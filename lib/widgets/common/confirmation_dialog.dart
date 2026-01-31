import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mslgd/widgets/translated_text.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;
  final IconData? icon;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Yes',
    this.cancelText = 'Cancel',
    this.confirmColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: confirmColor ?? Theme.of(context).colorScheme.secondary,
              size: 24.r,
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: TranslatedText(
              title,
              style: TextStyle(
                fontFamily: 'aBeeZee',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
      content: TranslatedText(
        message,
        style: TextStyle(
          fontFamily: 'aBeeZee',
          fontSize: 15.sp,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: TranslatedText(
            cancelText,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor ?? Theme.of(context).colorScheme.secondary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: TranslatedText(
            confirmText,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Show confirmation dialog and return true if confirmed
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'Cancel',
    Color? confirmColor,
    IconData? icon,
  }) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return ConfirmationDialog(
              title: title,
              message: message,
              confirmText: confirmText,
              cancelText: cancelText,
              confirmColor: confirmColor,
              icon: icon,
            );
          },
        ) ??
        false;
  }
}