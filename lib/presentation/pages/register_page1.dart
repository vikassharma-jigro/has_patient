import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hms_patient/app_helpers/assets/app_assets.dart';
import 'package:hms_patient/app_helpers/network/snackbar_helper.dart';
import 'package:hms_patient/app_helpers/theme/app_colors.dart';
import 'package:hms_patient/app_helpers/theme/app_spacings.dart';
import 'package:hms_patient/app_helpers/theme/app_typography.dart';
import 'package:hms_patient/app_helpers/utils/form_utils.dart';
import 'package:hms_patient/app_helpers/widgets/app_button.dart';
import 'package:hms_patient/app_helpers/widgets/custom_field.dart';
import 'package:hms_patient/presentation/bloc/login_bloc/login_bloc.dart';

class RegisterPageScreen1 extends StatelessWidget {
  const RegisterPageScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => LoginBloc(), child: const _RegisterView());
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => __RegisterViewState();
}

class __RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
   TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
   TextEditingController emailIdController = TextEditingController();
   TextEditingController dobController = TextEditingController();
   TextEditingController ageController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
   TextEditingController addressController = TextEditingController();
   TextEditingController pinCodeController = TextEditingController();
   TextEditingController stateController = TextEditingController();
   TextEditingController cityController = TextEditingController();
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    // _userIdController = TextEditingController();
    // _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // _userIdController.dispose();
    // _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<LoginBloc>().add(
      RegisterSubmitted(
       firstName: firstNameController.text,
        lastName: lastNameController.text,
        mobile: mobileController.text,
        gender: selectedGender,
        emailAddress: emailIdController.text,
        age: ageController.text,
        dob: dobController.text,
        address: addressController.text,
        pincode: pinCodeController.text,
        city: cityController.text,
        state: stateController.text,
      ),
    );
  }

  // void _handleForgotPassword(BuildContext context) {
  //   final TextEditingController emailController = TextEditingController();
  //   final formKey = GlobalKey<FormState>();
  //
  //   showDialog(
  //     context: context,
  //     builder: (dialogContext) => BlocProvider.value(
  //       value: context.read<LoginBloc>(),
  //       child: AlertDialog(
  //         backgroundColor: AppColors.onPrimary,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         title: Column(
  //           children: [
  //             const Icon(
  //               Icons.lock_reset_rounded,
  //               size: 50,
  //               color: Color(0xFF1E88E5),
  //             ),
  //             const SizedBox(height: 12),
  //             Text('Forgot Password', style: AppTypography.titleLarge.bold),
  //           ],
  //         ),
  //         content: Form(
  //           key: formKey,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(
  //                 'Enter your registered User ID or Email to receive a reset link.',
  //                 textAlign: TextAlign.center,
  //                 style: AppTypography.bodySmall.withColor(AppColors.grey600),
  //               ),
  //               const SizedBox(height: 20),
  //               CustomField(
  //                 controller: emailController,
  //                 label: 'User ID / Email',
  //                 hintText: 'Enter your ID',
  //                 validator: AppFormValidators.required(
  //                   fieldName: 'Identifier',
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //
  //         actions: [
  //           AppButton(
  //             height: 40,
  //             type: AppButtonType.outlined,
  //             onPressed: () => Navigator.pop(dialogContext),
  //             text: 'Cancel',
  //           ),
  //           AppButton(
  //             height: 40,
  //             text: 'Send Link',
  //             onPressed: () {
  //               if (formKey.currentState!.validate()) {
  //                 context.read<LoginBloc>().add(
  //                   ForgotPasswordSubmitted(
  //                     identifier: emailController.text.trim(),
  //                   ),
  //                 );
  //                 Navigator.pop(dialogContext);
  //               }
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            context.go('/register1');
          } else if (state is LoginFailure) {
            Snackbar.fromApiError(context, state.error);
          } else if (state is ForgotPasswordSuccess) {
            Snackbar.success(context, message: state.message);
          } else if (state is ForgotPasswordFailure) {
            Snackbar.fromApiError(context, state.error);
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.all(context, 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Logo ───────────────────────────────────────────────
                  Container(
                    padding: AppSpacing.all(context, 20),
                    decoration: BoxDecoration(
                      borderRadius: AppBorderRadiusTokens.circular4x,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E88E5), Color(0xFF2BBBAD)],
                      ),
                    ),
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: AppAssets.loginIcon,
                    ),
                  ),
                  AppSpacing.h20(context),

                  // ── Heading ────────────────────────────────────────────
                  Text(
                    'Welcome Back',
                    style: AppTypography.displaySmall
                        .withColor(AppColors.textPrimary)
                        .bold
                        .responsive(context),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.h20(context),

                  Text(
                    'Register to Hospital Management System',
                    style: AppTypography.bodyLarge
                        .withColor(AppColors.textPrimary)
                        .responsive(context),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.h32(context),

                  // ── User ID field ──────────────────────────────────────
                  CustomField(
                    key: const Key('userId_field'),
                    controller: firstNameController,
                    labelColor: AppColors.textPrimary,
                    prefixIcon: const Icon(
                      Icons.person,
                      color: AppColors.grey500,
                    ),
                    label: 'First Name',
                    hintText: 'Enter your first name',
                    validator: AppFormValidators.required(
                      fieldName: 'First Name',
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                  ),
                  AppSpacing.h16(context),
                  // ── Password field ─────────────────────────────────────
                  CustomField(
                    key: const Key('password_field'),
                    controller: lastNameController,
                    labelColor: AppColors.textPrimary,
                    label: 'Last Name',
                    hintText: 'Enter your last name',
                    // validator: AppFormValidators.password(),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    // onFieldSubmitted: (_) => _submit(),
                  ),
                  AppSpacing.h16(context),
                  // ── Password field ─────────────────────────────────────
                  CustomField(
                    key: const Key('email_field'),
                    controller: emailIdController,
                    labelColor: AppColors.textPrimary,

                    label: 'Email Address',
                    hintText: 'Enter your email address',
                    // validator: AppFormValidators.password(),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    // onFieldSubmitted: (_) => _submit(),
                  ),
                  AppSpacing.h16(context),
                  // ── Password field ─────────────────────────────────────
                  CustomField(
                    key: const Key('dob_field'),
                    controller: dobController,
                    labelColor: AppColors.textPrimary,

                    label: 'DOB ',
                    hintText: 'Select your dob',
                    readOnly: true,
                    // validator: AppFormValidators.password(),
                    textInputAction: TextInputAction.next,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        // format date (dd-MM-yyyy)
                        String formattedDate =
                            "${pickedDate.day.toString().padLeft(2, '0')}-"
                            "${pickedDate.month.toString().padLeft(2, '0')}-"
                            "${pickedDate.year}";

                        dobController.text = formattedDate;
                      }
                    },
                    // onFieldSubmitted: (_) => _submit(),
                  ),
                  AppSpacing.h16(context),

                  Align(
                    alignment: .topLeft,
                    child: Text("Gender",style: TextStyle(
                      color: AppColors.textPrimary,fontWeight: FontWeight.bold
                    ),),
                  ),
                  AppSpacing.h16(context),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(color: AppColors.grey50)
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedGender,
                      hint: Text("Select Gender"),
                      items: ["Male", "Female"].map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                    ),
                  ),
                  AppSpacing.h16(context),
                  // ── Password field ─────────────────────────────────────
                  CustomField(
                    key: const Key('age_field'),
                    controller: ageController,
                    labelColor: AppColors.textPrimary,

                    label: 'AGE ',
                    hintText: 'Enter your age',
                    // validator: AppFormValidators.password(),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    // onFieldSubmitted: (_) => _submit(),
                  ),
                  AppSpacing.h16(context),
                  // ── Password field ─────────────────────────────────────
                  CustomField(
                    key: const Key('mobile_field'),
                    controller: mobileController,
                    labelColor: AppColors.textPrimary,
                    maxL: 10,
                    label: 'Mobile Number ',
                    hintText: 'Enter your mobile number',
                    // validator: AppFormValidators.password(),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,

                    inputFormatters: [AppInputFormatters.digitsOnly],
                    // onFieldSubmitted: (_) => _submit(),
                  ),

                  AppSpacing.h16(context),
                  // ── Password field ─────────────────────────────────────
                  CustomField(
                    key: const Key('address_field'),
                    controller: addressController,
                    labelColor: AppColors.textPrimary,

                    label: 'Address ',
                    hintText: 'Enter your address',
                    // validator: AppFormValidators.password(),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    // onFieldSubmitted: (_) => _submit(),
                  ),
                  AppSpacing.h16(context),
                  // ── Password field ─────────────────────────────────────
                  CustomField(
                    key: const Key('pin_field'),
                    controller: pinCodeController,
                    labelColor: AppColors.textPrimary,

                    label: 'Pin Code ',
                    hintText: 'Enter your pin code',
                    // validator: AppFormValidators.password(),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                    ],
                    // onFieldSubmitted: (_) => _submit(),
                  ),

                  AppSpacing.h16(context),
                  // ── Password field ─────────────────────────────────────
                  CustomField(
                    key: const Key('state_field'),
                    controller: stateController,
                    labelColor: AppColors.textPrimary,

                    label: 'State ',
                    hintText: 'Enter your state',
                    // validator: AppFormValidators.password(),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    // onFieldSubmitted: (_) => _submit(),
                  ),
                  AppSpacing.h16(context),
                  // ── Password field ─────────────────────────────────────
                  CustomField(
                    key: const Key('city_field'),
                    controller: cityController,
                    labelColor: AppColors.textPrimary,

                    label: 'City ',
                    hintText: 'Enter your city',
                    // validator: AppFormValidators.password(),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    // onFieldSubmitted: (_) => _submit(),
                  ),

                  AppSpacing.h32(context),
                  BlocBuilder<LoginBloc, LoginState>(
                    buildWhen: (prev, curr) =>
                    curr is LoginLoading ||
                        curr is LoginSuccess ||
                        curr is LoginFailure ||
                        curr is LoginInitial ||
                        curr is ForgotPasswordLoading,
                    builder: (context, state) {
                      final isLoading =
                          state is LoginLoading ||
                              state is ForgotPasswordLoading;
                      return AppButtonFactory.elevated(
                        text: 'Register',
                        onPressed: isLoading ? null : _submit,
                        icon: const Icon(Icons.arrow_forward),
                        iconPosition: AppButtonIconPosition.end,
                        isLoading: isLoading,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
