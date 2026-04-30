import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_patient/app_helpers/theme/app_typography.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // ──────────────────────────────────────────────────────────────────────────
  // ☀️ LIGHT THEME
  // ──────────────────────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return _baseTheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.background,
      surface: AppColors.surface,
      onSurface: AppColors.grey800,
      border: AppColors.borderColor,
      error: AppColors.error,
    ).copyWith(scaffoldBackgroundColor: AppColors.background);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 🍎 CUPERTINO THEME
  // ──────────────────────────────────────────────────────────────────────────
  static CupertinoThemeData get cupertinoTheme {
    return const CupertinoThemeData(
      primaryColor: AppColors.primary,
      barBackgroundColor: AppColors.onPrimary,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: CupertinoTextThemeData(primaryColor: AppColors.primary),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 🏗️ BASE THEME ENGINE
  // ──────────────────────────────────────────────────────────────────────────
  static ThemeData _baseTheme({
    required Brightness brightness,
    required Color primary,
    required Color secondary,
    required Color background,
    required Color surface,
    required Color onSurface,
    required Color border,
    required Color error,
  }) {
    final isDark = brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.onPrimary : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.onPrimary
        : AppColors.textSecondary;

    return ThemeData(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      useMaterial3: true,
      brightness: brightness,
      primaryColor: primary,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: AppColors.onPrimary,
        secondary: secondary,
        onSecondary: AppColors.onSecondary,
        surface: surface,
        onSurface: onSurface,
        error: error,
        onError: AppColors.error,
        outline: border,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.onPrimary,
        type: BottomNavigationBarType.fixed,

        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
      ),

      // 📝 TYPOGRAPHY
      fontFamily: 'DM Sans',
      textTheme: _buildTextTheme(textPrimary, textSecondary),

      // 🏢 APP BAR
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.titleLarge.copyWith(color: textPrimary),
        iconTheme: IconThemeData(color: textPrimary, size: 24),
      ),

      // 🔘 BUTTONS
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: AppColors.onPrimary,
          textStyle: AppTypography.buttonText,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // 📥 INPUT / FORMS
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? AppColors.grey800.withValues(alpha: 0.5)
            : AppColors.grey50,
        contentPadding: const EdgeInsets.all(16),
        border: _border(border),
        enabledBorder: _border(border),
        focusedBorder: _border(primary, width: 2),
        errorBorder: _border(error),
        focusedErrorBorder: _border(error, width: 2),
        hintStyle: AppTypography.bodyMedium.copyWith(color: textSecondary),
        labelStyle: AppTypography.titleSmall.copyWith(color: textPrimary),
      ),

      // 🃏 CARDS
      cardTheme: CardThemeData(
        color: surface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(0),
      ),

      // 🍿 SNACKBAR
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.grey800 : AppColors.grey900,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: Colors.white,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // 📅 PICKERS
      timePickerTheme: TimePickerThemeData(
        backgroundColor: surface,
        hourMinuteColor: isDark ? AppColors.grey700 : AppColors.grey400,
        dayPeriodColor: primary,
        helpTextStyle: AppTypography.titleMedium.copyWith(color: primary),
      ),

      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),

      // ☑️ CHECKBOX
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return null; // Default
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide(
          color: isDark ? AppColors.grey500 : AppColors.grey400,
          width: 2,
        ),
      ),

      // 🔘 RADIO
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return isDark ? AppColors.grey500 : AppColors.grey400;
        }),
      ),

      // 🎚️ SWITCH
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.onPrimary;
          return isDark ? AppColors.grey400 : AppColors.grey500;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return isDark ? AppColors.grey700 : AppColors.grey300;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // 💬 DIALOG
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent, // Disable M3 tint
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: AppTypography.titleLarge.copyWith(color: textPrimary),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: textSecondary,
        ),
      ),

      // ⬆️ BOTTOM SHEET
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      // ➕ FLOATING ACTION BUTTON
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // 📄 LIST TILE
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Colors.transparent,
        selectedTileColor: primary.withValues(alpha: 0.1),
        iconColor: textSecondary,
        textColor: textPrimary,
      ),
    );
  }

  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return GoogleFonts.dmSansTextTheme(
      TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(color: primary),
        displayMedium: AppTypography.displayMedium.copyWith(color: primary),
        displaySmall: AppTypography.displaySmall.copyWith(color: primary),
        headlineLarge: AppTypography.headlineLarge.copyWith(color: primary),
        headlineMedium: AppTypography.headlineMedium.copyWith(color: primary),
        headlineSmall: AppTypography.headlineSmall.copyWith(color: primary),
        titleLarge: AppTypography.titleLarge.copyWith(color: primary),
        titleMedium: AppTypography.titleMedium.copyWith(color: primary),
        titleSmall: AppTypography.titleSmall.copyWith(color: primary),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: primary),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: primary),
        bodySmall: AppTypography.bodySmall.copyWith(color: primary),
        labelLarge: AppTypography.labelLarge.copyWith(color: secondary),
        labelMedium: AppTypography.labelMedium.copyWith(color: secondary),
        labelSmall: AppTypography.labelSmall.copyWith(color: secondary),
      ),
    );
  }

  static OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
