import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum AppButtonType { elevated, outlined, text }
enum AppButtonIconPosition { start, end }
class AppButton extends StatelessWidget {
  // Common properties
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final Widget? icon;
  final AppButtonIconPosition iconPosition;
  final double? width;
  final double height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool isLoading;
  final bool enableHaptic;

  // Style properties
  final Color? backgroundColor;
  final Color? disabledColor;
  final Color? textColor;
  final TextStyle? textStyle;
  
  // Border properties
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final BorderRadius? borderShape;
  
  // Shadow properties
  final List<BoxShadow>? boxShadow;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.elevated,
    this.icon,
    this.iconPosition = AppButtonIconPosition.start,
    this.width,
    this.height = 56,
    this.padding,
    this.margin,
    this.isLoading = false,
    this.enableHaptic = true,
    this.backgroundColor,
    this.disabledColor,
    this.textColor,
    this.textStyle,
    this.borderColor,
    this.borderWidth = 2.0,
    this.borderRadius = 16,
    this.borderShape,
    this.boxShadow,
  });

  bool get _isDisabled => onPressed == null;

  @override
  Widget build(BuildContext context) {
    Widget button = _buildButton(context);
    
    // Apply width and margin constraints properly
    if (width != null) {
      button = SizedBox(
        width: width,
        child: button,
      );
    }
    
    if (margin != null) {
      button = Padding(
        padding: margin!,
        child: button,
      );
    }
    
    return button;
  }

  Widget _buildButton(BuildContext context) {
    final buttonContent = _buildButtonContent(context);
    
    // Return appropriate button type without animations
    switch (type) {
      case AppButtonType.elevated:
        return _buildElevatedButton(buttonContent);
      case AppButtonType.outlined:
        return _buildOutlinedButton(buttonContent);
      case AppButtonType.text:
        return _buildTextButton(buttonContent);
    }
  }

  Widget _buildElevatedButton(Widget child) {
    return ElevatedButton(
      onPressed: _isDisabled || isLoading ? null : _handlePress,
      style: ElevatedButton.styleFrom(
        backgroundColor: _getBackgroundColor(),
        foregroundColor: _getTextColor(),
        disabledBackgroundColor: disabledColor ?? _getDisabledColor(),
        disabledForegroundColor: _getDisabledTextColor(),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        shape: _getButtonShape(),
        elevation: 0,
        shadowColor: Colors.transparent,
        minimumSize: Size(double.infinity, height), // Allow width to be flexible
      ),
      child: child,
    );
  }

  Widget _buildOutlinedButton(Widget child) {
    return OutlinedButton(
      onPressed: _isDisabled || isLoading ? null : _handlePress,
      style: OutlinedButton.styleFrom(
        foregroundColor: _getTextColor(),
        disabledForegroundColor: _getDisabledTextColor(),
        side: BorderSide(
          color: _getBorderColor(),
          width: borderWidth,
        ),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        shape: _getButtonShape(),
        minimumSize: Size(double.infinity, height), // Allow width to be flexible
      ),
      child: child,
    );
  }

  Widget _buildTextButton(Widget child) {
    return TextButton(
      onPressed: _isDisabled || isLoading ? null : _handlePress,
      style: TextButton.styleFrom(
        foregroundColor: _getTextColor(),
        disabledForegroundColor: _getDisabledTextColor(),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        shape: _getButtonShape(),
          
      ),
      child: child,
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
        ),
      );
    }

    final List<Widget> children = [];
    
    // Add leading icon
    if (icon != null && iconPosition == AppButtonIconPosition.start) {
      children.add(_buildIcon());
      children.add(const SizedBox(width: 8));
    }
    
    // Add text
    children.add(
      Text(
        text,
        style: (textStyle ?? AppTypography.buttonText).copyWith(
          color: _getTextColor(),
        ),
      ),
    );
    
    // Add trailing icon
    if (icon != null && iconPosition == AppButtonIconPosition.end) {
      children.add(const SizedBox(width: 8));
      children.add(_buildIcon());
    }
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget _buildIcon() {
    return IconTheme(
      data: IconThemeData(
        color: _getTextColor(),
        size: 20,
      ),
      child: icon!,
    );
  }

  OutlinedBorder _getButtonShape() {
    if (borderShape != null) {
      return RoundedRectangleBorder(
        borderRadius: borderShape!,
      );
    }
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  Color _getBackgroundColor() {
    if (type == AppButtonType.elevated) {
      return backgroundColor ?? AppColors.primary;
    }
    return Colors.transparent;
  }

  Color _getTextColor() {
    if (_isDisabled) {
      return _getDisabledTextColor();
    }
    
    if (type == AppButtonType.elevated) {
      return textColor ?? Colors.white;
    }
    if (type == AppButtonType.outlined || type == AppButtonType.text) {
      return textColor ?? AppColors.primary;
    }
    return textColor ?? AppColors.primary;
  }

  Color _getDisabledColor() {
    return disabledColor ?? Colors.grey[300] ?? const Color(0xFFE0E0E0);
  }

  Color _getDisabledTextColor() {
    return (textColor ?? Colors.grey[600] ?? const Color(0xFF757575)).withValues(alpha: 0.6);
  }

  Color _getBorderColor() {
    if (type == AppButtonType.outlined) {
      if (_isDisabled) {
        return Colors.grey[300] ?? const Color(0xFFE0E0E0);
      }
      return borderColor ?? AppColors.primary;
    }
    return Colors.transparent;
  }

  void _handlePress() {
    if (enableHaptic && !_isDisabled && !isLoading) {
      HapticFeedback.lightImpact();
    }
    onPressed?.call();
  }
}

// Convenience factory methods for creating specific button types
class AppButtonFactory {
  static Widget elevated({
    required String text,
    required VoidCallback? onPressed,
    Widget? icon,
    AppButtonIconPosition iconPosition = AppButtonIconPosition.start,
    double? width,
    double height = 56,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool isLoading = false,
    bool enableHaptic = true,
    Color? backgroundColor,
    Color? disabledColor,
    Color? textColor,
    TextStyle? textStyle,
    double borderRadius = 16,
    BorderRadius? borderShape,
    List<BoxShadow>? boxShadow,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: AppButtonType.elevated,
      icon: icon,
      iconPosition: iconPosition,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      isLoading: isLoading,
      enableHaptic: enableHaptic,
      backgroundColor: backgroundColor,
      disabledColor: disabledColor,
      textColor: textColor,
      textStyle: textStyle,
      borderRadius: borderRadius,
      borderShape: borderShape,
      boxShadow: boxShadow,
    );
  }

  static Widget outlined({
    required String text,
    required VoidCallback? onPressed,
    Widget? icon,
    AppButtonIconPosition iconPosition = AppButtonIconPosition.start,
    double? width,
    double height = 56,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool isLoading = false,
    bool enableHaptic = true,
    Color? textColor,
    Color? borderColor,
    TextStyle? textStyle,
    double borderWidth = 2.0,
    double borderRadius = 16,
    BorderRadius? borderShape,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: AppButtonType.outlined,
      icon: icon,
      iconPosition: iconPosition,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      isLoading: isLoading,
      enableHaptic: enableHaptic,
      textColor: textColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      textStyle: textStyle,
      borderRadius: borderRadius,
      borderShape: borderShape,
    );
  }

  static Widget text({
    required String text,
    required VoidCallback? onPressed,
    Widget? icon,
    AppButtonIconPosition iconPosition = AppButtonIconPosition.start,
    double? width,
    double height = 48,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool isLoading = false,
    bool enableHaptic = true,
    Color? textColor,
    TextStyle? textStyle,
    double borderRadius = 8,
    BorderRadius? borderShape,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: AppButtonType.text,
      icon: icon,
      iconPosition: iconPosition,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      isLoading: isLoading,
      enableHaptic: enableHaptic,
      textColor: textColor,
      textStyle: textStyle,
      borderRadius: borderRadius,
      borderShape: borderShape,
    );
  }

  static Widget flat({
    required String text,
    required VoidCallback? onPressed,
    Widget? icon,
    AppButtonIconPosition iconPosition = AppButtonIconPosition.start,
    double? width,
    double height = 48,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool isLoading = false,
    bool enableHaptic = true,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    double borderRadius = 8,
    BorderRadius? borderShape,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: AppButtonType.elevated,
      icon: icon,
      iconPosition: iconPosition,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      isLoading: isLoading,
      enableHaptic: enableHaptic,
      backgroundColor: backgroundColor ?? Colors.transparent,
      textColor: textColor ?? AppColors.primary,
      textStyle: textStyle,
      borderRadius: borderRadius,
      borderShape: borderShape,
      boxShadow: const [], // Remove shadow for flat button
    );
  }
}