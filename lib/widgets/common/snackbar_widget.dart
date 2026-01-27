import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mslgd/widgets/translated_text.dart';

enum SnackbarType {
  success,
  error,
  warning,
  info,
}

class AppSnackbar {
  // ─────────────── Main entry point ───────────────
  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
    bool showCloseIcon = false,
  }) {
    final snackBar = _buildSnackBar(
      message: message,
      type: type,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
      showCloseIcon: showCloseIcon,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()        // ← avoids stacking multiple snackbars
      ..showSnackBar(snackBar);
  }

  // ─────────────── Builder ───────────────
  static SnackBar _buildSnackBar({
    required String message,
    required SnackbarType type,
    String? actionLabel,
    VoidCallback? onActionPressed,
    required Duration duration,
    required bool showCloseIcon,
  }) {
    // final theme = Theme.of(context);

    // ── Colors & Icons per type ──
    final (Color bgColor, IconData iconData) = switch (type) {
      SnackbarType.success => (Colors.green.shade700, Icons.check_circle),
      SnackbarType.error   => (Colors.red.shade700,    Icons.error),
      SnackbarType.warning => (Colors.orange.shade800, Icons.warning),
      SnackbarType.info    => (Colors.blue.shade700,   Icons.info),
    };

    return SnackBar(
      content: Row(
        spacing: 12.sp,
        children: [
          Icon(iconData, color: Colors.white, size: 22.sp),
          Expanded(
            child: TranslatedText(
              message,
              style: TextStyle(color: Colors.white, fontSize: 15.sp),
            ),
          ),
        ],
      ),
      backgroundColor: bgColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h), // nice spacing
      elevation: 6.r,
      showCloseIcon: showCloseIcon,
      closeIconColor: Colors.white,
      action: (actionLabel != null && onActionPressed != null)
          ? SnackBarAction(
              label: actionLabel,
              textColor: Colors.white,
              onPressed: onActionPressed,
            )
          : null,
    );
  }

  // ─────────────── Convenience methods ───────────────
  static void success(BuildContext context, String message, {Duration? duration}) {
    show(context, message: message, type: SnackbarType.success, duration: duration ?? const Duration(seconds: 3));
  }

  static void error(BuildContext context, String message, {Duration? duration}) {
    show(context, message: message, type: SnackbarType.error, duration: duration ?? const Duration(seconds: 5));
  }

  static void warning(BuildContext context, String message, {Duration? duration}) {
    show(context, message: message, type: SnackbarType.warning, duration: duration ?? const Duration(seconds: 4));
  }

  static void info(BuildContext context, String message, {Duration? duration}) {
    show(context, message: message, type: SnackbarType.info);
  }
}