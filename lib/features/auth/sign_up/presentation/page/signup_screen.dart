import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../utils/extensions/extension.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../utils/helpers/validation.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_string.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../core/di/service_locator.dart';
import '../bloc/signup_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SignUpBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Sign Up (BLoC)")),
        body: BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignUpFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is SignUpSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Registration Successful!")),
              );
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signIn, (route) => false);
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
                    text: AppString.createYourAccount,
                    fontSize: 32,
                    bottom: 20,
                    top: 36,
                  ),

                  const CommonText(text: AppString.fullName, bottom: 8),
                  CommonTextField(
                    controller: nameController,
                    hintText: AppString.fullName,
                    validator: (v) => v!.isEmpty ? AppString.thisFieldIsRequired : null,
                  ),

                  const CommonText(text: AppString.email, bottom: 8, top: 16),
                  CommonTextField(
                    controller: emailController,
                    hintText: AppString.email,
                    validator: AppValidation.email,
                  ),

                  const CommonText(text: AppString.password, bottom: 8, top: 16),
                  CommonTextField(
                    controller: passwordController,
                    isPassword: true,
                    hintText: AppString.password,
                    validator: AppValidation.password,
                  ),

                  30.height,

                  BlocBuilder<SignUpBloc, SignUpState>(
                    buildWhen: (previous, current) =>
                        current is SignUpLoading ||
                        current is SignUpInitial ||
                        current is SignUpFailure,
                    builder: (context, state) {
                      return CommonButton(
                        titleText: AppString.signUp,
                        isLoading: state is SignUpLoading,
                        onTap: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          context.read<SignUpBloc>().add(
                                SignUpSubmitted(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  role: "user",
                                ),
                              );
                        },
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
