import 'package:flutter/material.dart';
import 'package:hms_patient/app_helpers/theme/app_spacings.dart';
import 'package:hms_patient/app_helpers/theme/app_typography.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String hintText;
  final List<T> items;
  final T? value;
  final String? label;
  final TextStyle? labelStyle;
  final Color? labelColor;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemLabel;
  final String? Function(T?)? validator;
  final bool isExpanded;
  final EdgeInsets? contentPadding;
  final double borderRadius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isRequired;
  final String? errorText;
  final double? spacing;

  const CustomDropdown({
    super.key,
    this.label,
    required this.hintText,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.itemLabel,
    this.labelColor,
    this.labelStyle,
    this.validator,
    this.isExpanded = true,
    this.contentPadding,
    this.borderRadius = 10,
    this.prefixIcon,
    this.suffixIcon,
    this.isRequired = false,
    this.errorText,
    this.spacing = AppSizeTokens.size4x,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure value exists in items or set to null
    final resolvedValue = items.any((item) => item == value) ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Row(
            children: [
              Text(
                label!,
                style: (labelStyle ?? AppTypography.bodyMedium.semiBold)
                    .copyWith(color: labelColor)
                    .responsive(context),
              ),
              if (isRequired)
                Text(
                  ' *',
                  style: AppTypography.bodyMedium.semiBold
                      .copyWith(color: Colors.red)
                      .responsive(context),
                ),
            ],
          ),
          AppSpacing.h8(context),
        ],
        DropdownButtonFormField<T>(
          initialValue: resolvedValue,
          
          isExpanded: false,
          decoration: InputDecoration(
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
            contentPadding:
                contentPadding ??
                AppSpacing.symmetric(
                  context: context,
                  horizontal: 14,
                  vertical: 14,
                ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            errorText: errorText,
          ),
          hint: Text(
            hintText,
            style: AppTypography.bodyMedium
                .withColor(Colors.grey.shade500)
                .responsive(context),
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemLabel(item),
                style: AppTypography.bodyMedium.responsive(context),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
          dropdownColor: Colors.white,
          elevation: 0,
          icon: suffixIcon ?? const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          isDense: true,
          style: AppTypography.bodyMedium.responsive(context),
          selectedItemBuilder: (context) {
            return items.map((item) {
              return Center(
                child: Text(
                  itemLabel(item),
                  style: AppTypography.bodyMedium.responsive(context),
                ),
              );
            }).toList();
          },
        ),
        SizedBox(height: spacing),
      ],
    );
  }
}
