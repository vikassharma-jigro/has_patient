import 'package:flutter/material.dart';
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

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => LoginBloc(), child: const _LoginView());
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _userIdController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _userIdController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<LoginBloc>().add(
      LoginSubmitted(
        userId: _userIdController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  void _handleForgotPassword(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<LoginBloc>(),
        child: AlertDialog(
          backgroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              const Icon(
                Icons.lock_reset_rounded,
                size: 50,
                color: Color(0xFF1E88E5),
              ),
              const SizedBox(height: 12),
              Text('Forgot Password', style: AppTypography.titleLarge.bold),
            ],
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter your registered User ID or Email to receive a reset link.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.withColor(AppColors.grey600),
                ),
                const SizedBox(height: 20),
                CustomField(
                  controller: emailController,
                  label: 'User ID / Email',
                  hintText: 'Enter your ID',
                  validator: AppFormValidators.required(
                    fieldName: 'Identifier',
                  ),
                ),
              ],
            ),
          ),

          actions: [
            AppButton(
              height: 40,
              type: AppButtonType.outlined,
              onPressed: () => Navigator.pop(dialogContext),
              text: 'Cancel',
            ),
            AppButton(
              height: 40,
              text: 'Send Link',
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context.read<LoginBloc>().add(
                    ForgotPasswordSubmitted(
                      identifier: emailController.text.trim(),
                    ),
                  );
                  Navigator.pop(dialogContext);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            context.go('/home');
          } else if (state is LoginFailure) {
            Snackbar.fromApiError(context, state.error);
          } else if (state is ForgotPasswordSuccess) {
            Snackbar.success(context, message: state.message);
          } else if (state is ForgotPasswordFailure) {
            Snackbar.fromApiError(context, state.error);
          }
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AppAssets.bgImage.image,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),
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
                          .withColor(AppColors.textOnPrimary)
                          .bold
                          .responsive(context),
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.h20(context),

                    Text(
                      'Login to Hospital Management System',
                      style: AppTypography.bodyLarge
                          .withColor(AppColors.textOnPrimary)
                          .responsive(context),
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.h32(context),

                    // ── User ID field ──────────────────────────────────────
                    CustomField(
                      key: const Key('userId_field'),
                      controller: _userIdController,
                      labelColor: AppColors.textOnPrimary,
                      prefixIcon: const Icon(
                        Icons.person,
                        color: AppColors.grey500,
                      ),
                      label: 'User ID',
                      hintText: 'Enter your user ID',
                      validator: AppFormValidators.required(
                        fieldName: 'User ID',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                    ),
                    AppSpacing.h16(context),
                    // ── Password field ─────────────────────────────────────
                    CustomField(
                      key: const Key('password_field'),
                      controller: _passwordController,
                      labelColor: AppColors.textOnPrimary,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: AppColors.grey500,
                      ),
                      isPassword: true,
                      label: 'Password',
                      hintText: 'Enter your password',
                      // validator: AppFormValidators.password(),
                      textInputAction: TextInputAction.done,
                      // onFieldSubmitted: (_) => _submit(),
                    ),

                    // ── Forgot password ────────────────────────────────────
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppButton(
                        backgroundColor: AppColors.onPrimary,
                        text: 'Forgot Password',
                        padding: EdgeInsets.zero,
                        onPressed: () => _handleForgotPassword(context),
                        height: 30,
                        width: 120.r(context),
                        textColor: AppColors.textPrimary,
                        textStyle: AppTypography.bodySmall.bold.responsive(
                          context,
                        ),
                      ),
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
                          text: 'Login',
                          onPressed: isLoading ? null : _submit,
                          icon: const Icon(Icons.arrow_forward),
                          iconPosition: AppButtonIconPosition.end,
                          isLoading: isLoading,
                        );
                      },
                    ),
                    AppSpacing.h16(context),
                    AppButtonFactory.elevated(
                      text: 'Register Patient',
                      onPressed: () => context.push('/patient-registration'),
                      textColor: AppColors.textOnPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
