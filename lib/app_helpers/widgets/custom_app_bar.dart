import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hms_patient/app_helpers/theme/app_colors.dart';
import 'package:hms_patient/app_helpers/theme/app_spacings.dart';
import 'package:hms_patient/app_helpers/theme/app_typography.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final Color? surfaceTintColor;
  final Color? foregroundColor;
  final bool? forceMaterialTransparency;
  final Color? backgroundColor;
  final double? elevation;
  final double? leadingWidth;
  final bool? centerTitle;
  final void Function()? onBackButtonPressed;
  final bool showBackButton;
  final bool showTitle;

  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.bottom,
    this.titleWidget,
    this.systemOverlayStyle,
    this.surfaceTintColor = AppColors.secondary,
    this.foregroundColor = AppColors.secondary,
    this.forceMaterialTransparency = false,
    this.backgroundColor = AppColors.secondary,
    this.elevation = 0,
    this.leadingWidth = 35,
    this.centerTitle = true,
    this.onBackButtonPressed,
    this.showBackButton = true,
    this.showTitle = true,
  });

  @override
  Size get preferredSize {
    return Size.fromHeight(
      kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actionsIconTheme: const IconThemeData(color: AppColors.onPrimary),
      actionsPadding: AppSpacing.only(
        context: context,
        right: AppSizeTokens.size3x,
      ),
      title: _buildTitle(context),
      leading: _buildLeading(context),
      leadingWidth: leadingWidth,
      actions: actions,
      bottom: bottom,
      systemOverlayStyle: systemOverlayStyle ??  SystemUiOverlayStyle(
        statusBarBrightness: Theme.brightnessOf(context),
    statusBarIconBrightness: Theme.brightnessOf(context) == Brightness.dark
    ? Brightness.light
        : Brightness.dark,
    statusBarColor: Colors.transparent,
    ),
      surfaceTintColor: surfaceTintColor,
      foregroundColor: foregroundColor,
      forceMaterialTransparency: forceMaterialTransparency ?? false,
      backgroundColor: backgroundColor,
      elevation: elevation,
      centerTitle: centerTitle ?? true,
    );
  }

  Widget? _buildTitle(BuildContext context) {
    // If titleWidget is provided, use it regardless of showTitle
    if (titleWidget != null) {
      return titleWidget;
    }
    
    // If showTitle is false, return null (no title)
    if (!showTitle) {
      return null;
    }
    
    // Otherwise show text title
    if (title != null && title!.isNotEmpty) {
      return Text(
        title!,
        style: AppTypography.titleLarge
            .withColor(AppColors.onPrimary)
            .semiBold
            .responsive(context),
      );
    }
    
    // Return null if no title available
    return null;
  }

  Widget? _buildLeading(BuildContext context) {
    if (!showBackButton) {
      return null;
    }
    
    if (leading != null) {
      return leading;
    }
    
    return BackButton(
      color: AppColors.onPrimary,
      onPressed: onBackButtonPressed ?? () {
        if (context.canPop()) {
          context.pop();
        }
      },
    );
  }
}