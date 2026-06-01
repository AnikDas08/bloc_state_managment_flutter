import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../utils/extensions/extension.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../utils/helpers/validation.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_string.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../sign_in/presentation/widgets/do_not_account.dart';
import '../cubit/signin_cubit.dart';
import '../cubit/signin_cubit_state.dart';

class SignInCubitScreen extends StatefulWidget {
  const SignInCubitScreen({super.key});

  @override
  State<SignInCubitScreen> createState() => _SignInCubitScreenState();
}

class _SignInCubitScreenState extends State<SignInCubitScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SignInCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Sign In with Cubit")),
        body: BlocListener<SignInCubit, SignInCubitState>(
          listener: (context, state) {
            if (state is SignInCubitFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is SignInCubitSuccess) {
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: AppString.logIntoYourAccount,
                    fontSize: 32,
                    bottom: 20,
                    top: 36,
                  ),
                  const CommonText(text: AppString.email, bottom: 8),
                  CommonTextField(
                    controller: emailController,
                    hintText: AppString.email,
                    validator: AppValidation.email,
                  ),
                  const CommonText(
                    text: AppString.password,
                    bottom: 8,
                    top: 24,
                  ),
                  CommonTextField(
                    controller: passwordController,
                    isPassword: true,
                    hintText: AppString.password,
                    validator: AppValidation.password,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.forgotPassword);
                      },
                      child: const CommonText(
                        text: AppString.forgotThePassword,
                        top: 10,
                        bottom: 30,
                        color: AppColors.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  BlocBuilder<SignInCubit, SignInCubitState>(
                    buildWhen: (previous, current) =>
                        current is SignInCubitLoading ||
                        current is SignInCubitInitial ||
                        current is SignInCubitFailure,
                    builder: (context, state) {
                      return CommonButton(
                        titleText: AppString.signIn,
                        isLoading: state is SignInCubitLoading,
                        onTap: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          context.read<SignInCubit>().signIn(
                                email: emailController.text,
                                password: passwordController.text,
                                role: "user",
                              );
                        },
                      );
                    },
                  ),
                  30.height,
                  const DoNotHaveAccount(),
                  30.height,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
