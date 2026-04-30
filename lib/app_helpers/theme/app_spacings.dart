import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════════
// SPACING TOKENS (from Spacing.json)
// ═══════════════════════════════════════════════════════════════════════════

class AppSpacingTokens {
  AppSpacingTokens._();

  static const double spacing1x = 4;
  static const double spacing2x = 8;
  static const double spacing3x = 12;
  static const double spacing4x = 16;
  static const double spacing5x = 20;
  static const double spacing6x = 24;
  static const double spacing7x = 28;
  static const double spacing8x = 32;
  static const double spacing9x = 36;
  static const double spacing10x = 40;
  static const double spacing11x = 44;
  static const double spacing12x = 48;
}

// ═══════════════════════════════════════════════════════════════════════════
// PADDING TOKENS (from Padding.json)
// ═══════════════════════════════════════════════════════════════════════════

class AppPaddingTokens {
  AppPaddingTokens._();

  static const double padding1x = 4;
  static const double padding2x = 8;
  static const double padding3x = 12;
  static const double padding4x = 16;
  static const double padding5x = 20;
  static const double padding6x = 24;
  static const double padding7x = 28;
  static const double padding8x = 32;
  static const double padding9x = 36;
  static const double padding10x = 40;
  static const double padding11x = 44;
  static const double padding12x = 48;
}

// ═══════════════════════════════════════════════════════════════════════════
// SIZE TOKENS (from Size.json)
// ═══════════════════════════════════════════════════════════════════════════

class AppSizeTokens {
  AppSizeTokens._();

  static const double size1x = 4;
  static const double size2x = 8;
  static const double size3x = 12;
  static const double size4x = 16;
  static const double size5x = 20;
  static const double size6x = 24;
  static const double size7x = 28;
  static const double size8x = 32;
  static const double size9x = 36;
  static const double size10x = 40;
  static const double size11x = 44;
  static const double size12x = 48;
  static const double size13x = 52;
  static const double size14x = 56;
}

// ═══════════════════════════════════════════════════════════════════════════
// BORDER RADIUS TOKENS (from borderRadius.json)
// ═══════════════════════════════════════════════════════════════════════════

class AppBorderRadiusTokens {
  AppBorderRadiusTokens._();

  static const double size1x = 4;
  static const double size2x = 8;
  static const double size3x = 12;
  static const double size4x = 16;
  static const double size5x = 20;
  static const double size6x = 24;
  static const double size7x = 28;
  static const double size8x = 32;
  static const double size9x = 36;
  static const double size10x = 40;
  static const double size11x = 44;
  static const double size12x = 48;

  static BorderRadius circular1x = BorderRadius.circular(size1x);
  static BorderRadius circular2x = BorderRadius.circular(size2x);
  static BorderRadius circular3x = BorderRadius.circular(size3x);
  static BorderRadius circular4x = BorderRadius.circular(size4x);
  static BorderRadius circular5x = BorderRadius.circular(size5x);
  static BorderRadius circular6x = BorderRadius.circular(size6x);
  static BorderRadius circular7x = BorderRadius.circular(size7x);
  static BorderRadius circular8x = BorderRadius.circular(size8x);
  static BorderRadius circular9x = BorderRadius.circular(size9x);
  static BorderRadius circular10x = BorderRadius.circular(size10x);
  static BorderRadius circular11x = BorderRadius.circular(size11x);
  static BorderRadius circular12x = BorderRadius.circular(size12x);
}

// ═══════════════════════════════════════════════════════════════════════════
// APP SPACING UTILITIES (preserved)
// ═══════════════════════════════════════════════════════════════════════════

class AppSpacing {
  AppSpacing._();

  static const double _baseWidth = 375;
  static const double _minScale = 0.85;
  static const double _maxScale = 1.3;

  static double _scale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final scale = width / _baseWidth;
    return scale.clamp(_minScale, _maxScale);
  }

  static double value(BuildContext context, double size) {
    return size * _scale(context);
  }

  // =====================================================
  // EDGE INSETS (Padding / Margin)
  // =====================================================

  static EdgeInsets all(BuildContext context, double size) =>
      EdgeInsets.all(value(context, size));

  static EdgeInsets symmetric({
    required BuildContext context,
    double horizontal = 0,
    double vertical = 0,
  }) => EdgeInsets.symmetric(
    horizontal: value(context, horizontal),
    vertical: value(context, vertical),
  );

  static EdgeInsets only({
    required BuildContext context,
    double left = 0,
    double right = 0,
    double top = 0,
    double bottom = 0,
  }) => EdgeInsets.only(
    left: value(context, left),
    right: value(context, right),
    top: value(context, top),
    bottom: value(context, bottom),
  );

  // =====================================================
  // SIZED BOX HELPERS
  // =====================================================

  static SizedBox h(BuildContext context, double size) =>
      SizedBox(height: value(context, size));
  static SizedBox w(BuildContext context, double size) =>
      SizedBox(width: value(context, size));
  static SizedBox square(BuildContext context, double size) =>
      SizedBox(height: value(context, size), width: value(context, size));

  // =====================================================
  // COMMON PRESETS (Design System Ready)
  // =====================================================

  static SizedBox h4(BuildContext c) => h(c, 4);
  static SizedBox h8(BuildContext c) => h(c, 8);
  static SizedBox h12(BuildContext c) => h(c, 12);
  static SizedBox h16(BuildContext c) => h(c, 16);
  static SizedBox h20(BuildContext c) => h(c, 20);
  static SizedBox h24(BuildContext c) => h(c, 24);
  static SizedBox h32(BuildContext c) => h(c, 32);
  static SizedBox h40(BuildContext c) => h(c, 40);
  static SizedBox h48(BuildContext c) => h(c, 48);

  static SizedBox w4(BuildContext c) => w(c, 4);
  static SizedBox w8(BuildContext c) => w(c, 8);
  static SizedBox w12(BuildContext c) => w(c, 12);
  static SizedBox w16(BuildContext c) => w(c, 16);
  static SizedBox w20(BuildContext c) => w(c, 20);
  static SizedBox w24(BuildContext c) => w(c, 24);
  static SizedBox w32(BuildContext c) => w(c, 32);

  // =====================================================
  // DIVIDER HELPERS
  // =====================================================

  static Widget divider(
    BuildContext context, {
    double thickness = 1,
    double verticalSpace = 16,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: value(context, verticalSpace)),
      child: Divider(
        thickness: value(context, thickness),
        color: color ?? Colors.grey.shade300,
      ),
    );
  }

  static Widget verticalDivider(
    BuildContext context, {
    double thickness = 1,
    double horizontalSpace = 16,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: value(context, horizontalSpace),
      ),
      child: VerticalDivider(
        thickness: value(context, thickness),
        color: color ?? Colors.grey.shade300,
      ),
    );
  }
}

extension ResponsiveSpacing on num {
  double r(BuildContext context) {
    const baseWidth = 375;
    const minScale = 0.85;
    const maxScale = 1.3;

    final width = MediaQuery.of(context).size.width;
    final scale = (width / baseWidth).clamp(minScale, maxScale);

    return this * scale;
  }
}
