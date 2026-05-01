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

class RegisterPageScreen2 extends StatelessWidget {
  const RegisterPageScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => LoginBloc(), child: const _RegisterView1());
  }
}

class _RegisterView1 extends StatefulWidget {
  const _RegisterView1();

  @override
  State<_RegisterView1> createState() => __RegisterView1State();
}

class __RegisterView1State extends State<_RegisterView1> {
  final _formKey = GlobalKey<FormState>();

  List<String> diseases = [];
  String? selectedGender;

  final idController = TextEditingController();
  final insuranceSchemaNameController = TextEditingController();
  final insuranceNumberController = TextEditingController();
  final allergyDetailsController = TextEditingController();
  String infection = "No";
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

    // context.read<LoginBloc>().add(
    //   RegisterSubmitted(
    //     firstName: firstNameController.text,
    //     lastName: lastNameController.text,
    //     mobile: mobileController.text,
    //     gender: selectedGender,
    //     emailAddress: emailIdController.text,
    //     age: ageController.text,
    //     dob: dobController.text,
    //     address: addressController.text,
    //     pincode: pinCodeController.text,
    //     city: cityController.text,
    //     state: stateController.text,
    //   ),
    // );
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

                  // ── User ID field ──────────────────────────────────────
                  CustomField(
                    key: const Key('userId_field'),
                    labelColor: AppColors.textPrimary,
                    prefixIcon: const Icon(
                      Icons.person,
                      color: AppColors.grey500,
                    ),
                    label: 'ID Proof Number',
                    hintText: 'Enter your ID Proof Number',
                    validator: AppFormValidators.required(
                      fieldName: 'ID Proof Number',
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                  ),
                  AppSpacing.h16(context),
                  // ── Password field ─────────────────────────────────────
                  CustomField(
                    key: const Key('password_field'),
                    controller: insuranceSchemaNameController,
                    labelColor: AppColors.textPrimary,
                    label: 'Insurance Schema Name ',
                    hintText: 'Enter your Insurance Schema Name ',
                    // validator: AppFormValidators.password(),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    // onFieldSubmitted: (_) => _submit(),
                  ),
                  AppSpacing.h16(context),
                  // ── Password field ─────────────────────────────────────
                  CustomField(
                    key: const Key('email_field'),
                    controller: insuranceNumberController,
                    labelColor: AppColors.textPrimary,

                    label: 'Insurance Number',
                    hintText: 'Enter your Insurance Number',
                    // validator: AppFormValidators.password(),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    // onFieldSubmitted: (_) => _submit(),
                  ),

                  // ── Password field ─────────────────────────────────────
                  AppSpacing.h16(context),

                  Align(
                    alignment: .topLeft,
                    child: Text("ID Proof Type",style: TextStyle(
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
                      hint: Text("ID Proof Type"),
                      items: ["Aadhar", "Pan","Voter Id"].map((String gender) {
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
                  Align(
                    alignment: .topLeft,
                    child: Text("Any Infection ",style: TextStyle(
                        color: AppColors.textPrimary,fontWeight: FontWeight.bold
                    ),),
                  ),

                  AppSpacing.h16(context),

          Row(
          children: [
            Row(
            children: [
            Radio<String>(
            value: "Yes",
            groupValue: infection,
            onChanged: (value) {
              setState(() {
                infection = value!;
              });
            },
          ),
          Text("Yes"),
          ],
        ),

        SizedBox(width: 20),

        Row(
          children: [
            Radio<String>(
              value: "No",
              groupValue: infection,
              onChanged: (value) {
                setState(() {
                  infection = value!;
                });
              },
            ),
            Text("No"),
          ],
        ),
        ],
      ),
                  AppSpacing.h16(context),
                  Align(
                    alignment: .topLeft,
                    child: Text("Any Allergy ",style: TextStyle(
                        color: AppColors.textPrimary,fontWeight: FontWeight.bold
                    ),),
                  ),
                  AppSpacing.h16(context),
                  Row(
                    children: [
                      Row(
                        children: [
                          Radio<String>(
                            value: "Yes",
                            groupValue: infection,
                            onChanged: (value) {
                              setState(() {
                                infection = value!;
                              });
                            },
                          ),
                          Text("Yes"),
                        ],
                      ),

                      SizedBox(width: 20),

                      Row(
                        children: [
                          Radio<String>(
                            value: "No",
                            groupValue: infection,
                            onChanged: (value) {
                              setState(() {
                                infection = value!;
                              });
                            },
                          ),
                          Text("No"),
                        ],
                      ),
                    ],
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
