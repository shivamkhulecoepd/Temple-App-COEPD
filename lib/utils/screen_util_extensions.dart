import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Safe extensions for ScreenUtil to prevent NaN values
extension SafeScreenUtil on num {
  /// Safe width extension with fallback
  double get sw => isFinite ? w : toDouble();
  
  /// Safe height extension with fallback
  double get sh => isFinite ? h : toDouble();
  
  /// Safe font size extension with fallback
  double get ssp => isFinite ? sp : toDouble();
  
  /// Safe radius extension with fallback
  double get sr => isFinite ? r : toDouble();
  
  /// Clamp width with safe bounds
  double get safeW => w.clamp(0.0, 1000.0);
  
  /// Clamp height with safe bounds
  double get safeH => h.clamp(0.0, 1000.0);
  
  /// Clamp font size with safe bounds
  double get safeSp => sp.clamp(8.0, 100.0);
  
  /// Clamp radius with safe bounds
  double get safeR => r.clamp(0.0, 100.0);
}