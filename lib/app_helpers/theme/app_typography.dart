import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

// ═══════════════════════════════════════════════════════════════════════════
// FONT SIZE TOKENS (from Font Size.json)
// ═══════════════════════════════════════════════════════════════════════════

class AppFontSizeTokens {
  AppFontSizeTokens._();

  static const double fontSize2xs = 10;
  static const double fontSizeXs = 12;
  static const double fontSizeSm = 14;
  static const double fontSizeMd = 16;
  static const double fontSizeLg = 18;
  static const double fontSizeXl = 20;
  static const double fontSize2xl = 24;
  static const double fontSize3xl = 28;
  static const double fontSizeHuge = 32;
  static const double fontSizeGiant = 36;
  static const double fontSizeEnormous = 40;
  static const double fontSize2xenormous = 44;
}

// ═══════════════════════════════════════════════════════════════════════════
// LINE HEIGHT TOKENS (from Line Height.json)
// ═══════════════════════════════════════════════════════════════════════════

class AppLineHeightTokens {
  AppLineHeightTokens._();

  static const double lineHeight2xs = 16;
  static const double lineHeightXs = 20;
  static const double lineHeightSm = 24;
  static const double lineHeightMd = 28;
  static const double lineHeightLg = 32;
  static const double lineHeightXl = 36;
  static const double lineHeight2xl = 40;
  static const double lineHeight3xl = 44;
  static const double lineHeightHuge = 52;
  static const double lineHeightGiant = 64;
}

// ═══════════════════════════════════════════════════════════════════════════
// LETTER SPACING TOKENS (from Letter Spacing.json)
// ═══════════════════════════════════════════════════════════════════════════

class AppLetterSpacingTokens {
  AppLetterSpacingTokens._();

  static const double letterSpacing0 = 0;
  static const double letterSpacingXs = 0.15;
  static const double letterSpacingSm = 0.5;
  static const double letterSpacingMd = 0.25;
}

class AppTypography {
  AppTypography._();

  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  static TextStyle get displayLarge => GoogleFonts.poppins(
    fontSize: AppFontSizeTokens.fontSize2xenormous,
    fontWeight: regular,
    height:
        AppLineHeightTokens.lineHeightGiant /
        AppFontSizeTokens.fontSize2xenormous,
    letterSpacing: AppLetterSpacingTokens.letterSpacing0,
    color: AppColors.textPrimary,
  );

  static TextStyle get displayMedium => GoogleFonts.poppins(
    fontSize: AppFontSizeTokens.fontSizeGiant,
    fontWeight: regular,
    height:
        AppLineHeightTokens.lineHeightHuge / AppFontSizeTokens.fontSizeGiant,
    letterSpacing: AppLetterSpacingTokens.letterSpacing0,
    color: AppColors.textPrimary,
  );

  static TextStyle get displaySmall => GoogleFonts.poppins(
    fontSize: AppFontSizeTokens.fontSizeHuge,
    fontWeight: regular,
    height: AppLineHeightTokens.lineHeight3xl / AppFontSizeTokens.fontSizeHuge,
    letterSpacing: AppLetterSpacingTokens.letterSpacing0,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineLarge => GoogleFonts.poppins(
    fontSize: AppFontSizeTokens.fontSize3xl,
    fontWeight: regular,
    height: AppLineHeightTokens.lineHeightXl / AppFontSizeTokens.fontSize3xl,
    letterSpacing: AppLetterSpacingTokens.letterSpacing0,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineMedium => GoogleFonts.poppins(
    fontSize: AppFontSizeTokens.fontSize2xl,
    fontWeight: regular,
    height: AppLineHeightTokens.lineHeightLg / AppFontSizeTokens.fontSize2xl,
    letterSpacing: AppLetterSpacingTokens.letterSpacing0,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineSmall => GoogleFonts.poppins(
    fontSize: AppFontSizeTokens.fontSizeXl,
    fontWeight: regular,
    height: AppLineHeightTokens.lineHeightMd / AppFontSizeTokens.fontSizeXl,
    letterSpacing: AppLetterSpacingTokens.letterSpacing0,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleLarge => GoogleFonts.poppins(
    fontSize: AppFontSizeTokens.fontSizeLg,
    fontWeight: medium,
    height: AppLineHeightTokens.lineHeightSm / AppFontSizeTokens.fontSizeLg,
    letterSpacing: AppLetterSpacingTokens.letterSpacingXs,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleMedium => GoogleFonts.poppins(
    fontSize: AppFontSizeTokens.fontSizeMd,
    fontWeight: medium,
    height: AppLineHeightTokens.lineHeightSm / AppFontSizeTokens.fontSizeMd,
    letterSpacing: AppLetterSpacingTokens.letterSpacingXs,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleSmall => GoogleFonts.poppins(
    fontSize: AppFontSizeTokens.fontSizeSm,
    fontWeight: medium,
    height: AppLineHeightTokens.lineHeightXs / AppFontSizeTokens.fontSizeSm,
    letterSpacing: AppLetterSpacingTokens.letterSpacingXs,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyLarge => GoogleFonts.poppins(
    fontSize: AppFontSizeTokens.fontSizeMd,
    fontWeight: medium,
    height: AppLineHeightTokens.lineHeightSm / AppFontSizeTokens.fontSizeMd,
    letterSpacing: AppLetterSpacingTokens.letterSpacingSm,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
    fontSize: AppFontSizeTokens.fontSizeSm,
    fontWeight: regular,
    height: AppLineHeightTokens.lineHeightXs / AppFontSizeTokens.fontSizeSm,
    letterSpacing: AppLetterSpacingTokens.letterSpacingMd,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodySmall => GoogleFonts.poppins(
    fontSize: AppFontSizeTokens.fontSizeXs,
    fontWeight: regular,
    height: AppLineHeightTokens.lineHeight2xs / AppFontSizeTokens.fontSizeXs,
    letterSpacing: AppLetterSpacingTokens.letterSpacingMd,
    color: AppColors.textPrimary,
  );

  static TextStyle get labelLarge => GoogleFonts.poppins(
    fontSize: AppFontSizeTokens.fontSizeSm,
    fontWeight: medium,
    height: AppLineHeightTokens.lineHeightXs / AppFontSizeTokens.fontSizeSm,
    letterSpacing: AppLetterSpacingTokens.letterSpacingXs,
    color: AppColors.textSecondary,
  );

  static TextStyle get labelMedium => GoogleFonts.poppins(
    fontSize: AppFontSizeTokens.fontSizeXs,
    fontWeight: medium,
    height: AppLineHeightTokens.lineHeight2xs / AppFontSizeTokens.fontSizeXs,
    letterSpacing: AppLetterSpacingTokens.letterSpacingSm,
    color: AppColors.textSecondary,
  );

  static TextStyle get labelSmall => GoogleFonts.poppins(
    fontSize: AppFontSizeTokens.fontSize2xs,
    fontWeight: medium,
    height: AppLineHeightTokens.lineHeight2xs / AppFontSizeTokens.fontSize2xs,
    letterSpacing: AppLetterSpacingTokens.letterSpacingSm,
    color: AppColors.textSecondary,
  );

  static TextStyle get buttonText => GoogleFonts.poppins(
    fontSize: AppFontSizeTokens.fontSizeXl,
    fontWeight: regular,
    color: AppColors.onPrimary,
  );
  static TextStyle get orContinueWith => GoogleFonts.archivo(
    fontSize: AppFontSizeTokens.fontSizeMd,
    height: AppLineHeightTokens.lineHeightMd / AppFontSizeTokens.fontSizeMd,
    letterSpacing: AppLetterSpacingTokens.letterSpacing0,
    fontWeight: regular,
    color: AppColors.grey500,
  );

  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}

extension TextStyleExtensions on TextStyle {
  TextStyle get extraaBold => copyWith(fontWeight: FontWeight.w900);
  TextStyle get extraBold => copyWith(fontWeight: FontWeight.w800);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);

  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle get underlined => copyWith(decoration: TextDecoration.underline);

  TextStyle withColor(Color color) => copyWith(color: color);
  TextStyle withSize(double size) => copyWith(fontSize: size);
  TextStyle get colorPrimary => withColor(AppColors.primary);
  TextStyle withLetterSpacing(double letterSpacing) =>
      copyWith(letterSpacing: letterSpacing);
  TextStyle withLineHeight(double lineHeight) => copyWith(height: lineHeight);
}

class ResponsiveTypography {
  ResponsiveTypography._();
  static TextStyle getResponsiveStyle(
    BuildContext context,
    TextStyle baseStyle,
  ) {
    final width = MediaQuery.of(context).size.width;
    final scaleFactor = width / 375;

    final effectiveScale = scaleFactor > 1.3
        ? 1.3
        : (scaleFactor < 0.7 ? 0.7 : scaleFactor);
    final double currentFontSize = baseStyle.fontSize ?? 14.0;
    final scaledSize = currentFontSize * effectiveScale;

    return baseStyle.copyWith(fontSize: scaledSize);
  }
}

extension ResponsiveTextExtension on TextStyle {
  TextStyle responsive(BuildContext context) {
    return ResponsiveTypography.getResponsiveStyle(context, this);
  }
}
