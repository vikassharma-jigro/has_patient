import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hms_patient/app_helpers/assets/app_assets.dart';
import 'package:hms_patient/app_helpers/theme/app_colors.dart';
import 'package:hms_patient/app_helpers/theme/app_spacings.dart';
import 'package:hms_patient/app_helpers/theme/app_typography.dart';
import 'package:hms_patient/app_helpers/utils/form_utils.dart';
import 'package:hms_patient/app_helpers/widgets/custom_app_bar.dart';
import 'package:hms_patient/app_helpers/widgets/custom_drop_down_field.dart';
import 'package:hms_patient/app_helpers/widgets/custom_field.dart';
import 'package:hms_patient/app_helpers/widgets/app_button.dart';
import 'package:hms_patient/presentation/bloc/paitent_bloc/patient_registration_bloc.dart';

class PatientRegistrationForm extends StatelessWidget {
  const PatientRegistrationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PatientRegistrationBloc(),
      child: const _PatientRegistrationFormView(),
    );
  }
}

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
  final _step3FormKey = GlobalKey<FormState>();

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
              'Complete registration in 4 simple steps',
              style: AppTypography.bodySmall
                  .withColor(AppColors.textOnPrimary)
                  .responsive(context),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          BlocBuilder<PatientRegistrationBloc, PatientRegistrationState>(
            buildWhen: (p, c) => p.currentStep != c.currentStep,
            builder: (context, state) {
              return _StepIndicator(currentStep: state.currentStep);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: AppSpacing.symmetric(
                context: context,
                vertical: AppSizeTokens.size2x,
                horizontal: AppSizeTokens.size4x,
              ),
              child: BlocBuilder<PatientRegistrationBloc, PatientRegistrationState>(
                buildWhen: (p, c) => p.currentStep != c.currentStep,
                builder: (context, state) {
                  return IndexedStack(
                    index: state.currentStep,
                    children: [
                      _BasicDetailsStep(formKey: _step1FormKey),
                      _InsuranceStep(formKey: _step2FormKey),
                      _DiseaseStep(formKey: _step3FormKey),
                      const _ReviewStep(),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const _NavigationButtons(),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});

  static const _stepLabels = [
    'Basic Details',
    'Insurance',
    'Disease',
    'Review',
  ];

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
        children: List.generate(_stepLabels.length * 2 - 1, (i) {
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
                child: Text(_stepLabels[stepIndex]),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _BasicDetailsStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const _BasicDetailsStep({required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TypeRadioSelection(),
          AppSpacing.h12(context),
          Row(
            children: [
              Expanded(
                child: CustomField(
                  label: 'First Name',
                  hintText: 'First name',
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
                  onChanged: (v) => context.read<PatientRegistrationBloc>().add(
                    UpdateFieldEvent(lastName: v),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child:
                    BlocBuilder<
                      PatientRegistrationBloc,
                      PatientRegistrationState
                    >(
                      buildWhen: (p, c) => p.gender != c.gender,
                      builder: (context, state) {
                        return CustomDropdown<String>(
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
                        );
                      },
                    ),
              ),
              AppSpacing.w12(context),
              Expanded(
                child: CustomField(
                  label: 'Date of Birth',
                  hintText: 'DD/MM/YYYY',
                  keyboardType: TextInputType.datetime,
                  onChanged: (v) => context.read<PatientRegistrationBloc>().add(
                    UpdateFieldEvent(dob: v),
                  ),
                  validator: AppFormValidators.date(),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CustomField(
                  label: 'Age',
                  inputFormatters: [
                    AppInputFormatters.digitsOnly,
                    AppInputFormatters.lengthLimit(3),
                  ],
                  hintText: 'Enter age',
                  keyboardType: TextInputType.number,
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
                  hintText: 'Enter mobile number',
                  inputFormatters: [AppInputFormatters.phoneFormatter],
                  keyboardType: TextInputType.phone,
                  onChanged: (v) => context.read<PatientRegistrationBloc>().add(
                    UpdateFieldEvent(mobile: v),
                  ),
                  validator: AppFormValidators.mobile(),
                ),
              ),
            ],
          ),
          CustomField(
            label: 'Email',
            hintText: 'Enter email address',
            keyboardType: TextInputType.emailAddress,
            onChanged: (v) => context.read<PatientRegistrationBloc>().add(
              UpdateFieldEvent(email: v),
            ),
            validator: AppFormValidators.email(),
          ),
          CustomField(
            label: 'Address',
            hintText: 'Enter full address',
            onChanged: (v) => context.read<PatientRegistrationBloc>().add(
              UpdateFieldEvent(address: v),
            ),
            validator: AppFormValidators.required(fieldName: 'address'),
          ),
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
          Row(
            children: [
              Expanded(
                child: CustomField(
                  label: 'Pincode',
                  hintText: 'Enter pincode',
                  inputFormatters: [AppInputFormatters.pincodeFormatter],
                  keyboardType: TextInputType.number,
                  onChanged: (v) => context.read<PatientRegistrationBloc>().add(
                    UpdateFieldEvent(pincode: v),
                  ),
                  validator: AppFormValidators.required(fieldName: 'pincode'),
                ),
              ),
              AppSpacing.w12(context),
              Expanded(
                child: CustomField(
                  label: 'ID Proof Type',
                  hintText: 'Aadhar/PAN etc.',
                  onChanged: (v) => context.read<PatientRegistrationBloc>().add(
                    UpdateFieldEvent(idProofType: v),
                  ),
                  validator: AppFormValidators.required(
                    fieldName: 'ID proof type',
                  ),
                ),
              ),
            ],
          ),
          AppButton(
            onPressed: () {},
            text: 'Upload ID Document',
            type: AppButtonType.outlined,
            icon: const Icon(Icons.upload_file, size: 18),
            borderColor: AppColors.secondary,
            textColor: AppColors.secondary,
          ),
        ],
      ),
    );
  }
}

class _TypeRadioSelection extends StatelessWidget {
  const _TypeRadioSelection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientRegistrationBloc, PatientRegistrationState>(
      buildWhen: (p, c) => p.isOPD != c.isOPD,
      builder: (context, state) {
        return Padding(
          padding: AppSpacing.symmetric(
            context: context,
            horizontal: AppPaddingTokens.padding4x,
            vertical: AppPaddingTokens.padding2x,
          ),
          child: Row(
            children: [
              _radioOption(context, 'OPD', true, state.isOPD),
              AppSpacing.w24(context),
              _radioOption(context, 'Emergency', false, state.isOPD),
            ],
          ),
        );
      },
    );
  }

  Widget _radioOption(
    BuildContext context,
    String label,
    bool value,
    bool groupValue,
  ) {
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
          }},
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

class _InsuranceStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const _InsuranceStep({required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: BlocBuilder<PatientRegistrationBloc, PatientRegistrationState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Insurance & Medical History',
                style: AppTypography.titleMedium.semiBold.responsive(context),
              ),
              AppSpacing.h16(context),
              Row(
                children: [
                  _CustomToggle(
                    label: 'Insurance Available?',
                    isSelected: state.hasInsurance,
                    onTap: () => context.read<PatientRegistrationBloc>().add(
                      const UpdateFieldEvent(hasInsurance: true),
                    ),
                  ),
                  AppSpacing.w24(context),
                  _CustomToggle(
                    label: 'No',
                    isSelected: !state.hasInsurance,
                    onTap: () => context.read<PatientRegistrationBloc>().add(
                      const UpdateFieldEvent(hasInsurance: false),
                    ),
                  ),
                ],
              ),
              AppSpacing.h16(context),
              if (state.hasInsurance) ...[
                CustomDropdown<String>(
                  label: 'Insurance Type',
                  hintText: 'Select insurance type',
                  items: const [
                    'Life Insurance',
                    'Health Insurance',
                    'General',
                  ],
                  value: state.insuranceType,
                  onChanged: (v) => context.read<PatientRegistrationBloc>().add(
                    UpdateFieldEvent(insuranceType: v),
                  ),
                  itemLabel: (item) => item,
                  validator: AppFormValidators.required(
                    fieldName: 'insurance type',
                  ),
                ),
                CustomField(
                  label: 'Insurance Schema Name',
                  hintText: 'Enter scheme name',
                  onChanged: (v) => context.read<PatientRegistrationBloc>().add(
                    UpdateFieldEvent(insuranceSchema: v),
                  ),
                ),
                CustomField(
                  label: 'Insurance Number',
                  hintText: 'Enter policy number',
                  keyboardType: TextInputType.number,
                  onChanged: (v) => context.read<PatientRegistrationBloc>().add(
                    UpdateFieldEvent(insuranceNumber: v),
                  ),
                  validator: AppFormValidators.required(
                    fieldName: 'insurance number',
                  ),
                ),
              ],
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
              AppSpacing.h16(context),
              if (state.anyAllergy) ...[
                CustomField(
                  label: 'Allergy Name',
                  hintText: 'Enter allergy name',
                  onChanged: (v) => context.read<PatientRegistrationBloc>().add(
                    UpdateFieldEvent(allergyName: v),
                  ),
                ),
                CustomField(
                  label: 'Allergy Details',
                  maxLines: 3,
                  hintText: 'Describe symptoms or details',
                  onChanged: (v) => context.read<PatientRegistrationBloc>().add(
                    UpdateFieldEvent(allergyDetail: v),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _CustomToggle extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? activeColor;

  const _CustomToggle({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.activeColor,  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? AppColors.secondary;
    return InkWell(
      onTap: onTap,
      borderRadius: AppBorderRadiusTokens.circular1x,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? color : AppColors.grey300,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    ),
                  )
                : null,
          ),
          AppSpacing.w8(context),
          Text(
            label,
            style: AppTypography.bodyMedium.medium.responsive(context),
          ),
        ],
      ),
    );
  }
}

class _YesNoRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _YesNoRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

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
        Row(
          children: [
            _SmallToggle(
              label: 'Yes',
              isSelected: value,
              color: AppColors.success,
              onTap: () => onChanged(true),
            ),
            AppSpacing.w16(context),
            _SmallToggle(
              label: 'No',
              isSelected: !value,
              color: AppColors.error,
              onTap: () => onChanged(false),
            ),
          ],
        ),
      ],
    );
  }
}

class _SmallToggle extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _SmallToggle({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppBorderRadiusTokens.circular1x,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? color : AppColors.grey300,
                width: 1.5,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    ),
                  )
                : null,
          ),
          AppSpacing.w4(context),
          Text(label, style: AppTypography.labelMedium.responsive(context)),
        ],
      ),
    );
  }
}

class _DiseaseStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const _DiseaseStep({required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: BlocBuilder<PatientRegistrationBloc, PatientRegistrationState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Additional Medical Information',
                style: AppTypography.titleMedium.semiBold.responsive(context),
              ),
              AppSpacing.h16(context),
              CustomDropdown<String>(
                label: 'Serious Diseases',
                hintText: 'Select if applicable',
                items: const ['Cancer', 'Diabetes', 'Heart Disease', 'None'],
                value: state.selectedDisease,
                onChanged: (v) => context.read<PatientRegistrationBloc>().add(
                  UpdateFieldEvent(selectedDisease: v),
                ),
                itemLabel: (item) => item,
              ),
              AppSpacing.h12(context),
              Text(
                'Note: Please ensure all medical details are accurate for proper clinical evaluation.',
                style: AppTypography.bodySmall.italic
                    .withColor(AppColors.textGrey)
                    .responsive(context),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReviewStep extends StatelessWidget {
  const _ReviewStep();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientRegistrationBloc, PatientRegistrationState>(
      builder: (context, state) {
        return Column(
          children: [
            _ReviewSection(
              title: 'Patient Details',
              rows: [
                _ReviewRowData(
                  'Full Name',
                  state.firstName.isEmpty
                      ? '-'
                      : '${state.firstName} ${state.lastName}',
                  'Gender',
                  state.gender.isEmpty ? '-' : state.gender,
                ),
                _ReviewRowData(
                  'Mobile Number',
                  state.mobile.isEmpty ? '-' : state.mobile,
                  'Email',
                  state.email.isEmpty ? '-' : state.email,
                ),
                _ReviewRowData(
                  'Age',
                  state.age.isEmpty ? '-' : state.age,
                  'DOB',
                  state.dob.isEmpty ? '-' : state.dob,
                ),
                _ReviewRowData(
                  'Address',
                  state.address.isEmpty ? '-' : state.address,
                  'City',
                  state.city.isEmpty ? '-' : state.city,
                ),
              ],
            ),
            AppSpacing.h12(context),
            _ReviewSection(
              title: 'Insurance & Medical Info',
              rows: [
                _ReviewRowData(
                  'Insurance Type',
                  state.insuranceType ?? '-',
                  'Scheme',
                  state.insuranceSchema.isEmpty ? '-' : state.insuranceSchema,
                ),
                _ReviewRowData(
                  'Policy Number',
                  state.insuranceNumber.isEmpty ? '-' : state.insuranceNumber,
                  'Infection',
                  state.anyInfection ? 'Yes' : 'No',
                ),
                _ReviewRowData(
                  'Allergies',
                  state.anyAllergy ? 'Yes' : 'No',
                  'Serious Diseases',
                  state.selectedDisease ?? '-',
                ),
              ],
            ),
            AppSpacing.h24(context),
            Padding(
              padding: AppSpacing.symmetric(context: context, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey300),
                  borderRadius: AppBorderRadiusTokens.circular2x,
                  color: AppColors.grey50,
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
        );
      },
    );
  }
}

class _ReviewSection extends StatelessWidget {
  final String title;
  final List<_ReviewRowData> rows;

  const _ReviewSection({required this.title, required this.rows});

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyLarge.bold.responsive(context),
                  ),
                  const Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: AppColors.secondary,
                  ),
                ],
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
  final _ReviewRowData row;
  const _ReviewRowWidget({required this.row});

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
  final String label1, value1, label2, value2;
  const _ReviewRowData(this.label1, this.value1, this.label2, this.value2);
}

class _NavigationButtons extends StatelessWidget {
  const _NavigationButtons();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientRegistrationBloc, PatientRegistrationState>(
      builder: (context, state) {
        final showBack = state.currentStep > 0;
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
                    onPressed: () => context
                        .read<PatientRegistrationBloc>()
                        .add(PreviousStepEvent()),
                  ),
                ),
                AppSpacing.w8(context),
              ],
              Expanded(
                flex: 2,
                child: AppButton(
                  text: state.currentStep == 3 ? 'Submit for Approval' : 'Next',
                  height: 48,
                  backgroundColor: AppColors.secondary,
                  icon: state.currentStep == 3
                      ? null
                      : const Icon(Icons.arrow_forward, size: 16),
                  iconPosition: AppButtonIconPosition.end,
                  onPressed: () {
                    final viewState = context
                        .findAncestorStateOfType<
                          _PatientRegistrationFormViewState
                        >();
                    bool isValid = true;
                    if (state.currentStep == 0) {
                      isValid =
                          viewState?._step1FormKey.currentState?.validate() ??
                          false;
                    }
                    if (state.currentStep == 1) {
                      isValid =
                          viewState?._step2FormKey.currentState?.validate() ??
                          false;
                    }
                    if (state.currentStep == 2) {
                      isValid =
                          viewState?._step3FormKey.currentState?.validate() ??
                          false;
                    }

                    if (isValid) {
                      if (state.currentStep < 3) {
                        context.read<PatientRegistrationBloc>().add(
                          NextStepEvent(),
                        );
                      } else {
                        // Handle Submit
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
