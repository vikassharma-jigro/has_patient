import 'package:flutter/material.dart';
import 'package:hms_patient/app_helpers/theme/app_typography.dart';
import 'package:pinput/pinput.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacings.dart';

class OtpFields extends StatelessWidget {
  final int length;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;

  const OtpFields({
    super.key,
    required this.length,
    required this.controller,
    this.validator,
    this.onCompleted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final defaultTheme = PinTheme(
      constraints: BoxConstraints(
        minWidth: AppSpacing.value(context, 65),
        minHeight: AppSpacing.value(context, 70),
      ),
      padding: AppSpacing.all(context, 16),
      textStyle: AppTypography.titleLarge.responsive(context),
      decoration: BoxDecoration(
        color: AppColors.onPrimary,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: AppColors.grey400, width: 1),
      ),
    );

    return Pinput(
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      controller: controller,
      validator: validator,
      length: length,
      autofocus: true,
      closeKeyboardWhenCompleted: true,
      enableInteractiveSelection: true,
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      onCompleted: onCompleted,
      onChanged: onChanged,
      onClipboardFound: (value) => controller.text = value,
      defaultPinTheme: defaultTheme,
      focusedPinTheme: defaultTheme.copyDecorationWith(
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      followingPinTheme: defaultTheme,
      submittedPinTheme: defaultTheme,

      errorTextStyle: AppTypography.labelMedium
          .withColor(AppColors.error)
          .responsive(context),
      errorPinTheme: defaultTheme.copyDecorationWith(
        border: Border.all(color: AppColors.error, width: 1.5),
      ),
    );
  }
}
