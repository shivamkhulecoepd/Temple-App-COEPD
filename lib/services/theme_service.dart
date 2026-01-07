import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModeType { system, light, dark }

class TempleTheme {
  // Temple Color Palette
  static const Color primaryBlue = Color(0xFF043342); // #043342
  static const Color lightBlue = Color(0xFF0066CC); // #0066cc - for minor buttons
  static const Color primaryOrange = Color(0xFFFF5621); // #ff5621 - alternate to #f15a29
  static const Color gradientStart = Color(0xFFE26400); // #e26400 - orange gradient start
  static const Color gradientEnd = Color(0xFF9B0200); // #9b0200 - orange gradient end
  static const Color secondaryBlue = Color(0xFF124660); // #124660
  static const Color backgroundTertiary = Color(0xFFF7F3E8); // #f7f3e8 - for background
  static const Color yellowButton = Color(0xFFFF9800); // #ff9800 - for buttons
  static const Color greenMinor = Color(0xFF0F8F2F); // #0f8f2f - for minor buttons

  // Light theme colors
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundTertiary,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.light,
        primary: primaryBlue,
        secondary: primaryOrange,
        surface: backgroundTertiary,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: primaryBlue,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: primaryBlue,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primaryBlue,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryBlue,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: primaryBlue,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: primaryBlue,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: primaryBlue,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: primaryBlue,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryBlue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryOrange, width: 2),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: secondaryBlue,
        thickness: 1,
      ),
    );
  }

  // Dark theme colors
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: secondaryBlue,
      // primaryColor: backgroundTertiary,
      scaffoldBackgroundColor: primaryBlue,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.dark,
        primary: primaryBlue,
        // primary: backgroundTertiary,
        secondary: primaryOrange,
        surface: primaryBlue,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineSmall: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleMedium: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: secondaryBlue,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondaryBlue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryBlue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryOrange, width: 2),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: lightBlue,
        thickness: 1,
      ),
    );
  }
}

class ThemeService extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';

  ThemeModeType _themeMode = ThemeModeType.system;
  ThemeModeType get themeMode => _themeMode;

  ThemeMode get flutterThemeMode {
    switch (_themeMode) {
      case ThemeModeType.light:
        return ThemeMode.light;
      case ThemeModeType.dark:
        return ThemeMode.dark;
      case ThemeModeType.system:
      default:
        return ThemeMode.system;
    }
  }

  bool get isDarkMode {
    if (_themeMode == ThemeModeType.system) {
      // This will be handled by Flutter's system theme
      return false; // We'll let Flutter handle system detection
    }
    return _themeMode == ThemeModeType.dark;
  }

  ThemeService() {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_themeModeKey) ?? 'system';
    _themeMode = ThemeModeType.values.firstWhere(
      (e) => e.toString().split('.').last == savedMode,
      orElse: () => ThemeModeType.system,
    );
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeModeType mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.toString().split('.').last);
    notifyListeners();
  }

  ThemeData getThemeData() {
    return _themeMode == ThemeModeType.dark 
        ? TempleTheme.darkTheme() 
        : TempleTheme.lightTheme();
  }
}