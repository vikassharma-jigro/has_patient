import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hms_patient/app_helpers/theme/app_spacings.dart';
import 'package:hms_patient/app_helpers/theme/app_typography.dart';

import '../theme/app_colors.dart';

class CustomField<T> extends StatefulWidget {
  const CustomField({
    this.hintstyle,
    super.key,
    required this.hintText,
    this.controller,
    this.maxL,
    this.validator,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.isPassword = false,
    this.maxLines = 1,
    this.spacing = AppSizeTokens.size4x,
    this.contentPadding,
    this.inputFormatters,
    this.textInputAction = TextInputAction.next,
    this.onTap,
    this.onChanged,
    this.keyboardType,
    this.labelstyle,
    this.labelColor,
  });

  final TextEditingController? controller;
  final String hintText;
  final TextStyle? hintstyle;
  final String? label;
  final int? maxL;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? labelstyle;
  final Color? labelColor;

  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool isPassword;
  final int? maxLines;
  final double spacing;
  final TextInputAction? textInputAction;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  @override
  State<CustomField<T>> createState() => _CustomFieldState<T>();
}

class _CustomFieldState<T> extends State<CustomField<T>>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;

  final _focusNode = FocusNode();

  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _initController();
    _obscureText = widget.isPassword;
  }

  void _initController() {
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
    }
  }

  @override
  void didUpdateWidget(covariant CustomField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        _controller.dispose();
      }
      _initController();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label ?? ' ',
            style:
                widget.labelstyle ??
                AppTypography.bodyMedium.semiBold
                    .responsive(context)
                    .withColor(widget.labelColor ?? AppColors.textPrimary),
          ),
          AppSpacing.h8(context),
        ],

        _buildTextField(),
        SizedBox(height: widget.spacing),
      ],
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxL,
      style: widget.enabled
          ? AppTypography.labelLarge
                .withSize(15)
                .responsive(context)
                .withColor(AppColors.fieldstyle)
          : AppTypography.labelLarge
                .withSize(15)
                .responsive(context)
                .withColor(AppColors.textGrey),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      scrollPhysics: const AlwaysScrollableScrollPhysics(),
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      obscureText: _obscureText,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      inputFormatters: widget.inputFormatters,
      onTap: widget.enabled ? widget.onTap : null,
      onChanged: widget.onChanged,
      validator: widget.validator,
      decoration: _buildInputDecoration(),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      hintText: widget.hintText,
      filled: true,
      fillColor: widget.enabled ? AppColors.onPrimary : AppColors.grey400,
      contentPadding:
          widget.contentPadding ??
          AppSpacing.symmetric(context: context, horizontal: 14, vertical: 14),
      prefixIcon: widget.prefixIcon,
      suffixIcon: _buildSuffixIcon(),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppBorderRadiusTokens.circular2x,
        borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppBorderRadiusTokens.circular2x,
        borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppBorderRadiusTokens.circular2x,
        borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppBorderRadiusTokens.circular2x,
        borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
      ),
      border: OutlineInputBorder(
        borderRadius: AppBorderRadiusTokens.circular2x,
        borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: AppBorderRadiusTokens.circular2x,
        borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
      ),
      enabled: widget.enabled,
      errorStyle: AppTypography.labelSmall
          .responsive(context)
          .withColor(AppColors.error),
      hintStyle:
          widget.enabled == false ||
              widget.readOnly == true ||
              widget.hintstyle != null
          ? widget.hintstyle
          : AppTypography.labelLarge
                .withSize(15)
                .responsive(context)
                .withColor(AppColors.textGrey),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPassword) {
      return IconButton(
        onPressed: () => setState(() => _obscureText = !_obscureText),

        icon: Icon(
          _obscureText
              ? CupertinoIcons.eye_fill
              : CupertinoIcons.eye_slash_fill,
          color: AppColors.textGrey,
          size: 20,
        ),
      );
    }
    if (widget.suffixIcon != null) {
      return widget.suffixIcon;
    }
    return null;
  }
}
