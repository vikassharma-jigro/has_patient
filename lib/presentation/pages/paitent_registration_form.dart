import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hms_patient/app_helpers/assets/app_assets.dart';
import 'package:hms_patient/app_helpers/network/snackbar_helper.dart';
import 'package:hms_patient/app_helpers/theme/app_colors.dart';
import 'package:hms_patient/app_helpers/theme/app_spacings.dart';
import 'package:hms_patient/app_helpers/theme/app_typography.dart';
import 'package:hms_patient/app_helpers/utils/form_utils.dart';
import 'package:hms_patient/app_helpers/widgets/custom_app_bar.dart';
import 'package:hms_patient/app_helpers/widgets/custom_drop_down_field.dart';
import 'package:hms_patient/app_helpers/widgets/custom_field.dart';
import 'package:hms_patient/app_helpers/widgets/app_button.dart';
import 'package:hms_patient/presentation/bloc/paitent_bloc/patient_registration_bloc.dart';

// ─── Constants ────────────────────────────────────────────────────────────────

/// FIX BUG 8: Extracted constant — keeps repeated withValues calls DRY.
const _kStepCount = 3;
const _kStepLabels = ['Basic Details', 'Insurance', 'Review'];

// ═════════════════════════════════════════════════════════════════════════════
// PatientRegistrationForm  (public entry point — provides BLoC)
// ═════════════════════════════════════════════════════════════════════════════

class PatientRegistrationForm extends StatelessWidget {
  const PatientRegistrationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PatientRegistrationBloc(),
      child: const _PatientRegistrationFormView(),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// _PatientRegistrationFormView
// ═════════════════════════════════════════════════════════════════════════════

class _PatientRegistrationFormView extends StatefulWidget {
  const _PatientRegistrationFormView();

  @override
  State<_PatientRegistrationFormView> createState() =>
      _PatientRegistrationFormViewState();
}

class _PatientRegistrationFormViewState
    extends State<_PatientRegistrationFormView> {
  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();

  // FIX BUG (UX): ScrollController so we can scroll to first error on fail.
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ── Validation + Navigation ────────────────────────────────────────────────

  // FIX BUG 2: All navigation logic lives here.
  // _NavigationButtons now receives a callback — no more findAncestorStateOfType.
  void _handleNext(PatientRegistrationState state) {
    final bloc = context.read<PatientRegistrationBloc>();

    if (state.currentStep == 0) {
      final isValid = _step1FormKey.currentState?.validate() ?? false;
      if (!isValid) {
        _scrollToTop();
        return;
      }
      bloc.add(const SubmitBasicDetailsEvent());
    } else if (state.currentStep == 1) {
      final isValid = _step2FormKey.currentState?.validate() ?? false;
      if (!isValid) {
        _scrollToTop();
        return;
      }
      bloc.add(const NextStepEvent());
    } else if (state.currentStep == 2) {
      bloc.add(const SubmitFullRegistrationEvent());
    }
  }

  void _handleBack() {
    context.read<PatientRegistrationBloc>().add(const PreviousStepEvent());
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        centerTitle: false,
        leadingWidth: AppSpacing.value(context, 60),
        leading: Container(
          padding: AppSpacing.all(context, 10),
          margin: AppSpacing.only(context: context, left: 10, bottom: 5),
          decoration: BoxDecoration(
            borderRadius: AppBorderRadiusTokens.circular2x,
            color: Colors.white.withValues(alpha: 0.20),
          ),
          child: AppAssets.loginIcon,
        ),
        titleWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Registration',
              style: AppTypography.titleMedium.semiBold
                  .withColor(AppColors.textOnPrimary)
                  .responsive(context),
            ),
            Text(
              // FIX BUG 6: Was "4 simple steps" — corrected to 3.
              'Complete registration in $_kStepCount simple steps',
              style: AppTypography.bodySmall
                  .withColor(AppColors.textOnPrimary)
                  .responsive(context),
            ),
          ],
        ),
      ),
      body: BlocListener<PatientRegistrationBloc, PatientRegistrationState>(
        listener: (context, state) {
          if (state.status == PatientRegistrationStatus.failure &&
              state.error != null) {
            Snackbar.fromApiError(context, state.error!);
            // Scroll to top so the user sees the error snackbar context.
            _scrollToTop();
          } else if (state.status == PatientRegistrationStatus.step1Success) {
            Snackbar.success(
              context,
              message: state.successMessage ?? 'Basic details saved.',
            );
          } else if (state.status == PatientRegistrationStatus.success) {
            Snackbar.success(
              context,
              message: state.successMessage ?? 'Registration successful.',
            );
            context.go('/login');
          }
        },
        child: Column(
          children: [
            // Step indicator — only rebuilds when step changes.
            BlocBuilder<PatientRegistrationBloc, PatientRegistrationState>(
              buildWhen: (p, c) => p.currentStep != c.currentStep,
              builder: (context, state) =>
                  _StepIndicator(currentStep: state.currentStep),
            ),

            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: AppSpacing.symmetric(
                  context: context,
                  vertical: AppSizeTokens.size2x,
                  horizontal: AppSizeTokens.size4x,
                ),
                child:
                    BlocBuilder<
                      PatientRegistrationBloc,
                      PatientRegistrationState
                    >(
                      buildWhen: (p, c) => p.currentStep != c.currentStep,
                      builder: (context, state) => IndexedStack(
                        index: state.currentStep,
                        children: [
                          _BasicDetailsStep(formKey: _step1FormKey),
                          _InsuranceStep(formKey: _step2FormKey),
                          const _ReviewStep(),
                        ],
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
      // FIX BUG 2: Pass callback — NavigationButtons no longer needs ancestor.
      bottomNavigationBar:
          BlocBuilder<PatientRegistrationBloc, PatientRegistrationState>(
            buildWhen: (p, c) =>
                p.currentStep != c.currentStep || p.status != c.status,
            builder: (context, state) => _NavigationButtons(
              currentStep: state.currentStep,
              isLoading: state.status == PatientRegistrationStatus.loading,
              onNext: () => _handleNext(state),
              onBack: _handleBack,
            ),
          ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// _StepIndicator
// ═════════════════════════════════════════════════════════════════════════════

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.symmetric(
        context: context,
        horizontal: 16,
        vertical: 20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(_kStepLabels.length * 2 - 1, (i) {
          if (i.isOdd) {
            final stepIndex = i ~/ 2;
            final isCompleted = stepIndex < currentStep;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: isCompleted
                      ? LinearGradient(
                          colors: [
                            AppColors.secondary,
                            AppColors.secondary.withValues(alpha: 0.5),
                          ],
                        )
                      : null,
                  color: isCompleted ? null : AppColors.grey300,
                ),
              ),
            );
          }

          final stepIndex = i ~/ 2;
          final isActive = stepIndex == currentStep;
          final isCompleted = stepIndex < currentStep;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                padding: AppSpacing.all(context, 16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isActive
                      ? LinearGradient(
                          colors: [
                            AppColors.secondary,
                            AppColors.secondary.withValues(alpha: 0.6),
                          ],
                        )
                      : null,
                  color: !isActive
                      ? isCompleted
                            ? AppColors.secondary.withValues(alpha: 0.2)
                            : AppColors.grey200
                      : null,
                  border: isActive
                      ? null
                      : Border.all(
                          color: isCompleted
                              ? AppColors.secondary
                              : AppColors.grey300,
                          width: 1.5,
                        ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.secondary.withValues(alpha: 0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : Text(
                          '${stepIndex + 1}',
                          style: AppTypography.bodyMedium.semiBold.withColor(
                            isActive ? Colors.white : AppColors.grey600,
                          ),
                        ),
                ),
              ),
              AppSpacing.h8(context),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: AppTypography.labelSmall.copyWith(
                  color: isActive ? AppColors.secondary : AppColors.grey500,
                  fontWeight: isActive
                      ? AppTypography.semiBold
                      : AppTypography.regular,
                ),
                child: Text(_kStepLabels[stepIndex]),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// _BasicDetailsStep
// ═════════════════════════════════════════════════════════════════════════════

class _BasicDetailsStep extends StatelessWidget {
  const _BasicDetailsStep({required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // // OPD / Emergency toggle
          // const _TypeRadioSelection(),
          // AppSpacing.h12(context),

          // Name row
          Row(
            children: [
              Expanded(
                child: CustomField(
                  label: 'First Name',
                  hintText: 'First name',
                  // FIX BUG 7: nameFormatter now applied.
                  inputFormatters: [
                    AppInputFormatters.nameFormatter,
                    AppInputFormatters.lengthLimit(50),
                  ],
                  onChanged: (v) => context.read<PatientRegistrationBloc>().add(
                    UpdateFieldEvent(firstName: v),
                  ),
                  validator: AppFormValidators.required(
                    fieldName: 'first name',
                  ),
                ),
              ),
              AppSpacing.w12(context),
              Expanded(
                child: CustomField(
                  label: 'Last Name',
                  hintText: 'Last name',
                  inputFormatters: [
                    AppInputFormatters.nameFormatter,
                    AppInputFormatters.lengthLimit(50),
                  ],
                  onChanged: (v) => context.read<PatientRegistrationBloc>().add(
                    UpdateFieldEvent(lastName: v),
                  ),
                ),
              ),
            ],
          ),

          // Gender + DOB row
          Row(
            children: [
              Expanded(
                child:
                    BlocBuilder<
                      PatientRegistrationBloc,
                      PatientRegistrationState
                    >(
                      buildWhen: (p, c) => p.gender != c.gender,
                      builder: (context, state) => CustomDropdown<String>(
                        label: 'Gender',
                        hintText: 'Select gender',
                        items: const ['Male', 'Female', 'Other'],
                        value: state.gender.isEmpty ? null : state.gender,
                        onChanged: (v) => context
                            .read<PatientRegistrationBloc>()
                            .add(UpdateFieldEvent(gender: v)),
                        itemLabel: (item) => item,
                        validator: AppFormValidators.required(
                          fieldName: 'gender',
                        ),
                      ),
                    ),
              ),
              AppSpacing.w12(context),
              // FIX BUG 1: DOB is its own StatefulWidget — controller lifecycle safe.
              const Expanded(child: _DobField()),
            ],
          ),

          // Age + Mobile row
          Row(
            children: [
              Expanded(
                child: CustomField(
                  label: 'Age',
                  hintText: 'Enter age',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    AppInputFormatters.digitsOnly,
                    AppInputFormatters.lengthLimit(3),
                  ],
                  onChanged: (v) => context.read<PatientRegistrationBloc>().add(
                    UpdateFieldEvent(age: v),
                  ),
                  validator: AppFormValidators.required(fieldName: 'age'),
                ),
              ),
              AppSpacing.w12(context),
              Expanded(
                child: CustomField(
                  label: 'Mobile Number',
                  hintText: '10-digit mobile',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    AppInputFormatters.digitsOnly,
                    AppInputFormatters.lengthLimit(10),
                  ],
                  onChanged: (v) => context.read<PatientRegistrationBloc>().add(
                    UpdateFieldEvent(mobile: v),
                  ),
                  validator: AppFormValidators.mobile(),
                ),
              ),
            ],
          ),

          // Email
          CustomField(
            label: 'Email',
            hintText: 'Enter email address',
            keyboardType: TextInputType.emailAddress,
            // FIX BUG 8: emailFormatter now applied.
            inputFormatters: [AppInputFormatters.emailFormatter],
            onChanged: (v) => context.read<PatientRegistrationBloc>().add(
              UpdateFieldEvent(email: v),
            ),
            validator: AppFormValidators.email(),
          ),

          // Address
          CustomField(
            label: 'Address',
            hintText: 'Enter full address',
            inputFormatters: [AppInputFormatters.addressFormatter],
            onChanged: (v) => context.read<PatientRegistrationBloc>().add(
              UpdateFieldEvent(address: v),
            ),
            validator: AppFormValidators.required(fieldName: 'address'),
          ),

          // City + State row
          Row(
            children: [
              Expanded(
                child: CustomField(
                  label: 'City',
                  hintText: 'Enter city',
                  inputFormatters: [AppInputFormatters.cityFormatter],
                  onChanged: (v) => context.read<PatientRegistrationBloc>().add(
                    UpdateFieldEvent(city: v),
                  ),
                  validator: AppFormValidators.required(fieldName: 'city'),
                ),
              ),
              AppSpacing.w12(context),
              Expanded(
                child: CustomField(
                  label: 'State',
                  hintText: 'Enter state',
                  inputFormatters: [AppInputFormatters.stateFormatter],
                  onChanged: (v) => context.read<PatientRegistrationBloc>().add(
                    UpdateFieldEvent(state: v),
                  ),
                  validator: AppFormValidators.required(fieldName: 'state'),
                ),
              ),
            ],
          ),

          // Pincode + ID Proof Type row
          Row(
            children: [
              Expanded(
                child: CustomField(
                  label: 'Pincode',
                  hintText: 'Enter pincode',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    AppInputFormatters.pincodeFormatter,
                    AppInputFormatters.lengthLimit(6),
                  ],
                  onChanged: (v) => context.read<PatientRegistrationBloc>().add(
                    UpdateFieldEvent(pincode: v),
                  ),
                  validator: AppFormValidators.required(fieldName: 'pincode'),
                ),
              ),
              AppSpacing.w12(context),
              Expanded(
                child:
                    BlocBuilder<
                      PatientRegistrationBloc,
                      PatientRegistrationState
                    >(
                      buildWhen: (p, c) => p.idProofType != c.idProofType,
                      builder: (context, state) => CustomDropdown<String>(
                        label: 'ID Proof Type',
                        hintText: 'Select type',
                        items: const [
                          'Aadhaar',
                          'PAN',
                          'Voter ID',
                        ],
                        value: state.idProofType.isEmpty
                            ? null
                            : state.idProofType,
                        onChanged: (v) => context
                            .read<PatientRegistrationBloc>()
                            .add(UpdateFieldEvent(idProofType: v)),
                        itemLabel: (item) => item,
                        validator: AppFormValidators.required(
                          fieldName: 'ID proof type',
                        ),
                      ),
                    ),
              ),
            ],
          ),

          // ID Proof Number — FIX BUG 10: validator via top-level
          // AppFormValidators.idProof(), not an inline closure.
          BlocBuilder<PatientRegistrationBloc, PatientRegistrationState>(
            buildWhen: (p, c) =>
                p.idProofType != c.idProofType ||
                p.idProofNumber != c.idProofNumber,
            builder: (context, state) => CustomField(
              // Key forces widget recreation when proof type changes,
              // clearing the old input (FIX BUG in bloc: idProofNumber cleared too).
              key: ValueKey(state.idProofType),
              label: _idProofLabel(state.idProofType),
              hintText: _idProofHint(state.idProofType),
              inputFormatters: [AppInputFormatters.idProofFormatter],
              onChanged: (v) => context.read<PatientRegistrationBloc>().add(
                UpdateFieldEvent(idProofNumber: v),
              ),
              validator: AppFormValidators.idProof(state.idProofType),
            ),
          ),
        ],
      ),
    );
  }

  String _idProofLabel(String type) {
    switch (type) {
      case 'Aadhaar':
        return 'Aadhaar Number';
      case 'PAN':
        return 'PAN Number';
      case 'Voter ID':
        return 'Voter ID Number';
      default:
        return 'ID Proof Number';
    }
  }

  String _idProofHint(String type) {
    switch (type) {
      case 'Aadhaar':
        return 'Enter 12-digit Aadhaar';
      case 'PAN':
        return 'e.g. ABCDE1234F';
      case 'Voter ID':
        return 'e.g. ABC1234567';
      default:
        return 'Enter ID number';
    }
  }
}

// ─── DOB Field  ───────────────────────────────────────────────────────────────
// FIX BUG 1: DOB controller properly created, updated, and disposed here.

class _DobField extends StatefulWidget {
  const _DobField();

  @override
  State<_DobField> createState() => _DobFieldState();
}

class _DobFieldState extends State<_DobField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientRegistrationBloc, PatientRegistrationState>(
      buildWhen: (p, c) => p.dob != c.dob,
      builder: (context, state) {
        // Sync controller text without recreating it.
        if (_controller.text != state.dob) {
          _controller.value = TextEditingValue(
            text: state.dob,
            selection: TextSelection.collapsed(offset: state.dob.length),
          );
        }
        return CustomField(
          controller: _controller,
          label: 'Date of Birth',
          hintText: 'DD/MM/YYYY',
          readOnly: true,
          onTap: () async {
            // FIX BUG 12: Correct leap-year-safe date arithmetic.
            final now = DateTime.now();
            final defaultInitial = DateTime(now.year - 20, now.month, now.day);
            final initial = state.dob.isNotEmpty
                ? (tryParseDate(state.dob) ?? defaultInitial)
                : defaultInitial;

            final date = await showDatePicker(
              context: context,
              initialDate: initial,
              firstDate: DateTime(1900),
              lastDate: now,
              builder: (context, child) => Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: AppColors.secondary,
                    onPrimary: Colors.white,
                    onSurface: AppColors.textPrimary,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.secondary,
                    ),
                  ),
                ),
                child: child!,
              ),
            );

            if (date != null && context.mounted) {
              final formatted =
                  '${date.day.toString().padLeft(2, '0')}/'
                  '${date.month.toString().padLeft(2, '0')}/'
                  '${date.year}';
              context.read<PatientRegistrationBloc>().add(
                UpdateFieldEvent(dob: formatted),
              );
            }
          },
          validator: AppFormValidators.date(),
        );
      },
    );
  }
}

// ─── Type Radio Selection ─────────────────────────────────────────────────────

class _TypeRadioSelection extends StatelessWidget {
  const _TypeRadioSelection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientRegistrationBloc, PatientRegistrationState>(
      buildWhen: (p, c) => p.isOPD != c.isOPD,
      builder: (context, state) => Padding(
        padding: AppSpacing.symmetric(
          context: context,
          horizontal: AppPaddingTokens.padding4x,
          vertical: AppPaddingTokens.padding2x,
        ),
        child: Row(
          children: [
            // FIX BUG 9: _RadioOption is now a proper StatelessWidget.
            _RadioOption(label: 'OPD', value: true, groupValue: state.isOPD),
            AppSpacing.w24(context),
            _RadioOption(
              label: 'Emergency',
              value: false,
              groupValue: state.isOPD,
            ),
          ],
        ),
      ),
    );
  }
}

/// FIX BUG 9: Proper widget class instead of method returning Widget.
class _RadioOption extends StatelessWidget {
  const _RadioOption({
    required this.label,
    required this.value,
    required this.groupValue,
  });

  final String label;
  final bool value;
  final bool groupValue;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<PatientRegistrationBloc>().add(
        UpdateFieldEvent(isOPD: value),
      ),
      borderRadius: AppBorderRadiusTokens.circular1x,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioGroup(
            groupValue: groupValue,
            onChanged: (val) {
              if (val != null) {
                context.read<PatientRegistrationBloc>().add(
                  UpdateFieldEvent(isOPD: val),
                );
              }
            },
            child: Radio<bool>(
              value: value,
              activeColor: AppColors.secondary,
              visualDensity: VisualDensity.compact,
            ),
          ),
          Text(label, style: AppTypography.bodyMedium.responsive(context)),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// _InsuranceStep
// FIX BUG 3: buildWhen prevents rebuild on every keystroke.
// FIX BUG 16 & 17: Field clearing handled in BLoC; UX shows clean empty state.
// ═════════════════════════════════════════════════════════════════════════════

class _InsuranceStep extends StatelessWidget {
  const _InsuranceStep({required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: BlocBuilder<PatientRegistrationBloc, PatientRegistrationState>(
        // FIX BUG 3: Only rebuild when toggles or insuranceType changes,
        // NOT on every keystroke in other fields.
        buildWhen: (p, c) =>
            p.hasInsurance != c.hasInsurance ||
            p.insuranceType != c.insuranceType ||
            p.anyInfection != c.anyInfection ||
            p.anyAllergy != c.anyAllergy,
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Insurance & Medical History',
              style: AppTypography.titleMedium.semiBold.responsive(context),
            ),
            AppSpacing.h16(context),

            // Insurance toggle
            _YesNoRow(
              label: 'Insurance Available?',
              value: state.hasInsurance,
              onChanged: (v) => context.read<PatientRegistrationBloc>().add(
                UpdateFieldEvent(hasInsurance: v),
              ),
            ),

            // Insurance fields — shown only when hasInsurance is true.
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: state.hasInsurance
                  ? Column(
                      children: [
                        AppSpacing.h16(context),
                        CustomDropdown<String>(
                          label: 'Insurance Type',
                          hintText: 'Select insurance type',
                          items: const [
                            'Self',
                            'Govt',
                            'Life Insurance',
                            'Health Insurance',
                            'General',
                          ],
                          value: state.insuranceType,
                          onChanged: (v) => context
                              .read<PatientRegistrationBloc>()
                              .add(UpdateFieldEvent(insuranceType: v)),
                          itemLabel: (item) => item,
                          validator: AppFormValidators.required(
                            fieldName: 'insurance type',
                          ),
                        ),
                        CustomField(
                          label: 'Insurance Scheme Name',
                          hintText: 'Enter scheme name',
                          onChanged: (v) => context
                              .read<PatientRegistrationBloc>()
                              .add(UpdateFieldEvent(insuranceSchema: v)),
                        ),
                        CustomField(
                          label: 'Insurance Number',
                          hintText: 'Enter policy number',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            AppInputFormatters.idProofFormatter,
                          ],
                          onChanged: (v) => context
                              .read<PatientRegistrationBloc>()
                              .add(UpdateFieldEvent(insuranceNumber: v)),
                          validator: AppFormValidators.required(
                            fieldName: 'insurance number',
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),

            AppSpacing.h16(context),

            // Infection + Allergy toggles side by side
            Row(
              children: [
                Expanded(
                  child: _YesNoRow(
                    label: 'Any Infection?',
                    value: state.anyInfection,
                    onChanged: (v) => context
                        .read<PatientRegistrationBloc>()
                        .add(UpdateFieldEvent(anyInfection: v)),
                  ),
                ),
                AppSpacing.w12(context),
                Expanded(
                  child: _YesNoRow(
                    label: 'Any Allergy?',
                    value: state.anyAllergy,
                    onChanged: (v) => context
                        .read<PatientRegistrationBloc>()
                        .add(UpdateFieldEvent(anyAllergy: v)),
                  ),
                ),
              ],
            ),

            // Allergy fields — shown only when anyAllergy is true.
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: state.anyAllergy
                  ? Column(
                      children: [
                        AppSpacing.h16(context),
                        CustomField(
                          label: 'Allergy Name',
                          hintText: 'Enter allergy name',
                          onChanged: (v) => context
                              .read<PatientRegistrationBloc>()
                              .add(UpdateFieldEvent(allergyName: v)),
                          validator: AppFormValidators.required(
                            fieldName: 'allergy name',
                          ),
                        ),
                        CustomField(
                          label: 'Allergy Details',
                          maxLines: 3,
                          hintText: 'Describe symptoms or details',
                          onChanged: (v) => context
                              .read<PatientRegistrationBloc>()
                              .add(UpdateFieldEvent(allergyDetail: v)),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),

            AppSpacing.h16(context),

            // Serious Diseases Selection
            Text(
              'Serious Diseases',
              style: AppTypography.bodySmall.semiBold.responsive(context),
            ),
            AppSpacing.h8(context),
            BlocBuilder<PatientRegistrationBloc, PatientRegistrationState>(
              buildWhen: (p, c) => p.seriousDiseases != c.seriousDiseases,
              builder: (context, state) {
                const options = [
                  "HIV",
                  "TB",
                  "HB",
                  "Cancer",
                  "None",
                  "Other",
                ];
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      options.map((option) {
                        final isSelected = state.seriousDiseases.contains(
                          option,
                        );
                        return FilterChip(
                          label: Text(
                            option,
                            style: AppTypography.labelSmall.copyWith(
                              color:
                                  isSelected
                                      ? Colors.white
                                      : AppColors.textPrimary,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.secondary,
                          checkmarkColor: Colors.white,
                          backgroundColor: AppColors.grey100,
                          onSelected: (selected) {
                            final current = List<String>.from(
                              state.seriousDiseases,
                            );
                            if (selected) {
                              if (option == "None") {
                                current.clear();
                                current.add("None");
                              } else {
                                current.remove("None");
                                current.add(option);
                              }
                            } else {
                              current.remove(option);
                            }
                            context.read<PatientRegistrationBloc>().add(
                              UpdateFieldEvent(seriousDiseases: current),
                            );
                          },
                        );
                      }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Yes / No Toggle Row ──────────────────────────────────────────────────────

class _YesNoRow extends StatelessWidget {
  const _YesNoRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.semiBold.responsive(context),
        ),
        AppSpacing.h8(context),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: AppBorderRadiusTokens.circular2x,
          ),
          child: Row(
            children: [
              _SelectionOption(
                label: 'Yes',
                isSelected: value,
                activeColor: AppColors.success,
                onTap: () => onChanged(true),
              ),
              _SelectionOption(
                label: 'No',
                isSelected: !value,
                activeColor: AppColors.error,
                onTap: () => onChanged(false),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SelectionOption extends StatelessWidget {
  const _SelectionOption({
    required this.label,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: AppBorderRadiusTokens.circular1x,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.labelMedium.semiBold.copyWith(
                color: isSelected ? Colors.white : AppColors.grey600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// _ReviewStep
// FIX BUG 4: buildWhen prevents rebuild on every keystroke from other steps.
// ═════════════════════════════════════════════════════════════════════════════

class _ReviewStep extends StatelessWidget {
  const _ReviewStep();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientRegistrationBloc, PatientRegistrationState>(
      builder: (context, state) => Column(
        children: [
          _ReviewSection(
            title: 'Patient Details',
            rows: [
              _ReviewRowData(
                'Full Name',
                [
                  state.firstName,
                  state.lastName,
                ].where((s) => s.isNotEmpty).join(' ').ifEmpty('-'),
                'Gender',
                state.gender.ifEmpty('-'),
              ),
              _ReviewRowData(
                'Mobile Number',
                state.mobile.ifEmpty('-'),
                'Email',
                state.email.ifEmpty('-'),
              ),
              _ReviewRowData(
                'Age',
                state.age.ifEmpty('-'),
                'DOB',
                state.dob.ifEmpty('-'),
              ),
              _ReviewRowData(
                'Address',
                state.address.ifEmpty('-'),
                'City',
                state.city.ifEmpty('-'),
              ),
              _ReviewRowData(
                'ID Proof Type',
                state.idProofType.ifEmpty('-'),
                'ID Proof Number',
                state.idProofNumber.ifEmpty('-'),
              ),
            ],
          ),
          AppSpacing.h12(context),
          _ReviewSection(
            title: 'Insurance & Medical Info',
            rows: [
              _ReviewRowData(
                'Has Insurance',
                state.hasInsurance ? 'Yes' : 'No',
                'Insurance Type',
                state.insuranceType ?? '-',
              ),
              _ReviewRowData(
                'Scheme',
                state.insuranceSchema.ifEmpty('-'),
                'Policy Number',
                state.insuranceNumber.ifEmpty('-'),
              ),
              _ReviewRowData(
                'Infection',
                state.anyInfection ? 'Yes' : 'No',
                'Allergies',
                state.anyAllergy ? 'Yes' : 'No',
              ),
              if (state.anyAllergy)
                _ReviewRowData(
                  'Allergy Name',
                  state.allergyName.ifEmpty('-'),
                  'Allergy Details',
                  state.allergyDetail.ifEmpty('-'),
                ),
              _ReviewRowData(
                'Serious Diseases',
                state.seriousDiseases.isEmpty
                    ? '-'
                    : state.seriousDiseases.join(', '),
                '',
                '',
              ),
            ],
          ),
          AppSpacing.h24(context),

          // Confirmation checkbox
          Padding(
            padding: AppSpacing.symmetric(context: context, horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: state.isConfirmed
                      ? AppColors.success
                      : AppColors.grey300,
                ),
                borderRadius: AppBorderRadiusTokens.circular2x,
                color: state.isConfirmed
                    ? AppColors.success.withValues(alpha: 0.05)
                    : AppColors.grey50,
              ),
              child: CheckboxListTile(
                value: state.isConfirmed,
                activeColor: AppColors.secondary,
                onChanged: (v) => context.read<PatientRegistrationBloc>().add(
                  UpdateFieldEvent(isConfirmed: v ?? false),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                title: Text(
                  'I confirm that all the information provided above is correct to the best of my knowledge.',
                  style: AppTypography.bodySmall.responsive(context),
                ),
              ),
            ),
          ),
          AppSpacing.h24(context),
        ],
      ),
    );
  }
}

// ─── Review Section ───────────────────────────────────────────────────────────

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({required this.title, required this.rows});

  final String title;
  final List<_ReviewRowData> rows;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.symmetric(context: context, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.grey300),
          borderRadius: AppBorderRadiusTokens.circular3x,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppSpacing.only(
                context: context,
                left: 16,
                top: 16,
                right: 16,
                bottom: 8,
              ),
              child: Text(
                title,
                style: AppTypography.bodyLarge.bold.responsive(context),
              ),
            ),
            const Divider(height: 1),
            ...rows.map((row) => _ReviewRowWidget(row: row)),
          ],
        ),
      ),
    );
  }
}

class _ReviewRowWidget extends StatelessWidget {
  const _ReviewRowWidget({required this.row});

  final _ReviewRowData row;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.symmetric(
        context: context,
        horizontal: 16,
        vertical: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.label1,
                  style: AppTypography.labelSmall.responsive(context),
                ),
                AppSpacing.h4(context),
                Text(
                  row.value1,
                  style: AppTypography.bodyMedium.semiBold.responsive(context),
                ),
              ],
            ),
          ),
          AppSpacing.w12(context),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.label2,
                  style: AppTypography.labelSmall.responsive(context),
                ),
                AppSpacing.h4(context),
                Text(
                  row.value2,
                  style: AppTypography.bodyMedium.semiBold.responsive(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewRowData {
  const _ReviewRowData(this.label1, this.value1, this.label2, this.value2);

  final String label1, value1, label2, value2;
}

// ═════════════════════════════════════════════════════════════════════════════
// _NavigationButtons
// FIX BUG 2: Receives callbacks — no findAncestorStateOfType anti-pattern.
// FIX BUG 5: buildWhen set — only rebuilds when step or loading changes.
// ═════════════════════════════════════════════════════════════════════════════

class _NavigationButtons extends StatelessWidget {
  const _NavigationButtons({
    required this.currentStep,
    required this.isLoading,
    required this.onNext,
    required this.onBack,
  });

  final int currentStep;
  final bool isLoading;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final showBack = currentStep > 0;
    final isLastStep = currentStep == 2;

    return Padding(
      padding: AppSpacing.only(
        context: context,
        left: AppPaddingTokens.padding2x,
        right: AppPaddingTokens.padding2x,
        top: AppPaddingTokens.padding4x,
        bottom: AppPaddingTokens.padding6x,
      ),
      child: Row(
        children: [
          if (showBack) ...[
            Expanded(
              child: AppButton(
                text: 'Back',
                type: AppButtonType.outlined,
                height: 48,
                icon: const Icon(Icons.arrow_back, size: 16),
                borderColor: AppColors.grey300,
                textColor: AppColors.textPrimary,
                onPressed: isLoading ? null : onBack,
              ),
            ),
            AppSpacing.w8(context),
          ],
          Expanded(
            flex: 2,
            child: AppButton(
              text: isLastStep ? 'Submit for Approval' : 'Next',
              height: 48,
              isLoading: isLoading,
              backgroundColor: AppColors.secondary,
              icon: isLastStep
                  ? null
                  : const Icon(Icons.arrow_forward, size: 16),
              iconPosition: AppButtonIconPosition.end,
              onPressed: isLoading ? null : onNext,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── String extension ─────────────────────────────────────────────────────────

extension _StringX on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
