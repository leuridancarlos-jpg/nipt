import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF14130F);
  static const Color card = Color(0xFF1E1C16);
  static const Color border = Color(0xFF33302A);
  static const Color textPrimary = Color(0xFFF2EDE0);
  static const Color textMuted = Color(0xFF8A857A);
  static const Color accent = Color(0xFFD9FF47);
  static const Color ignore = Color(0xFF4A463E);
  static const Color urgent = Color(0xFFFF6A2B);
  static const Color surface = Color(0xFF1E1C16);
}

class AppTextStyles {
  static TextStyle heading1 = GoogleFonts.bricolageGrotesque(
    fontSize: 48,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.05,
  );

  static TextStyle heading2 = GoogleFonts.bricolageGrotesque(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle heading3 = GoogleFonts.bricolageGrotesque(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle body = GoogleFonts.hankenGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMuted = GoogleFonts.hankenGrotesk(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static TextStyle label = GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    letterSpacing: 1.5,
  );

  static TextStyle mono = GoogleFonts.jetBrainsMono(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle monoMuted = GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    letterSpacing: 0.5,
  );

  static TextStyle promise = GoogleFonts.hankenGrotesk(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.5,
  );

  static TextStyle buttonPrimary = GoogleFonts.bricolageGrotesque(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.background,
    letterSpacing: 0.2,
  );

  static TextStyle ignore = GoogleFonts.hankenGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.ignore,
    decoration: TextDecoration.lineThrough,
    decorationColor: AppColors.ignore,
  );
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.background,
        primary: AppColors.accent,
        secondary: AppColors.urgent,
        onPrimary: AppColors.background,
        onSurface: AppColors.textPrimary,
        outline: AppColors.border,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.heading1,
        displayMedium: AppTextStyles.heading2,
        displaySmall: AppTextStyles.heading3,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.bodyMuted,
        labelSmall: AppTextStyles.label,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.bricolageGrotesque(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.background,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.buttonPrimary,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textMuted,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),
    );
  }
}
