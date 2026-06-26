import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/extensions/extension.dart';
import '../../../../../utils/helpers/validation.dart';
import '../../../../../utils/constants/app_string.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../bloc/signin_bloc.dart';
import '../widgets/do_not_account.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final ValueNotifier<bool> _rememberMe = ValueNotifier<bool>(false);

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
    _rememberMe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SignInBloc>(),
      child: Scaffold(
        backgroundColor: const Color(0xFF2196F3),
        body: BlocListener<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state is SignInFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is SignInSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              );
            }
          },
          child: Column(
            children: [
              // ── Blue header ──────────────────────────────────────────────
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1E88E5), Color(0xFF2196F3)],
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo badge
                        Container(
                          width: 64.w,
                          height: 64.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: CommonText(
                              text: 'R',
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        8.height,
                        CommonText(
                          text: 'RIZIPT',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        4.height,
                        CommonText(
                          text: 'TRANSACTION BY RIZIPT',
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.75),
                        ),
                        20.height,
                        // Title row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            CommonText(
                              text: 'Sign In',
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            8.width,
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: CommonText(
                                text: 'as',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white70,
                              ),
                            ),
                            8.width,
                            CommonText(
                              text: 'Merchant',
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        8.height,
                        CommonText(
                          text: 'Please Sign in to Continue Our App',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── White card body ──────────────────────────────────────────
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(color: Color(0xFFF5F7FA)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Form card
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 0,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 24.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Email label
                                CommonText(
                                  text: AppString.email,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1A1A2E),
                                ),
                                8.height,
                                // Email field
                                CommonTextField(
                                  controller: emailController,
                                  hintText: 'your.email@example.com',
                                  prefixIcon: const Icon(
                                    Icons.mail_outline_rounded,
                                    size: 18,
                                    color: Color(0xFF979797),
                                  ),
                                  validator: AppValidation.email,
                                  keyboardType: TextInputType.emailAddress,
                                  fillColor: const Color(0xFFF0F4F8),
                                  borderRadius: 12,
                                ),
                                20.height,
                                // Password label
                                CommonText(
                                  text: AppString.password,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1A1A2E),
                                ),
                                8.height,
                                // Password field
                                CommonTextField(
                                  controller: passwordController,
                                  hintText: AppString.password,
                                  isPassword: true,
                                  prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                    size: 18,
                                    color: Color(0xFF979797),
                                  ),
                                  validator: AppValidation.password,
                                  fillColor: const Color(0xFFF0F4F8),
                                  borderRadius: 12,
                                  textColor: const Color(0xFF1A1A2E),
                                ),
                                16.height,
                                // Remember me + Forgot password row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ValueListenableBuilder<bool>(
                                      valueListenable: _rememberMe,
                                      builder: (context, rememberMeValue, child) {
                                        return Row(
                                          children: [
                                            SizedBox(
                                              width: 20.w,
                                              height: 20.w,
                                              child: Checkbox(
                                                value: rememberMeValue,
                                                activeColor: const Color(
                                                  0xFF2196F3,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4.r),
                                                ),
                                                side: BorderSide(
                                                  color: const Color(0xFF2196F3),
                                                  width: 1.5.w,
                                                ),
                                                onChanged: (val) {
                                                  _rememberMe.value = val ?? false;
                                                },
                                              ),
                                            ),
                                            8.width,
                                            CommonText(
                                              text: 'Remember me',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF454545),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.forgotPassword,
                                        );
                                      },
                                      child: CommonText(
                                        text: 'Forgot Password?',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF2196F3),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                color: const Color(0xFFF5F7FA),
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Sign In button
                      BlocBuilder<SignInBloc, SignInState>(
                        buildWhen: (previous, current) =>
                            current is SignInLoading ||
                            current is SignInInitial ||
                            current is SignInFailure,
                        builder: (context, state) {
                          final isLoading = state is SignInLoading;
                          return GestureDetector(
                            onTap: isLoading
                                ? null
                                : () {
                                    // context.read<SignInBloc>().add(
                                    //   SignInSubmitted(
                                    //     email: emailController.text,
                                    //     password: passwordController.text,
                                    //     role: "user",
                                    //   ),
                                    // );
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.home,
                                    );
                                  },
                            child: Container(
                              width: double.infinity,
                              height: 52.h,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF1E88E5),
                                    Color(0xFF42A5F5),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF2196F3,
                                    ).withOpacity(0.35),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: isLoading
                                    ? SizedBox(
                                        width: 24.w,
                                        height: 24.w,
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : CommonText(
                                        text: 'Sign In',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                      16.height,
                      const DoNotHaveAccount(),
                      16.height,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
