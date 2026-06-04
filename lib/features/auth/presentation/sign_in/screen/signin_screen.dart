import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/extensions/extension.dart';
import '../../../../../utils/helpers/validation.dart';
import '../../../../../utils/constants/app_string.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../core/di/service_locator.dart';
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
  bool _rememberMe = false;
  bool _obscurePassword = true;

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
                            child: Text(
                              'R',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        8.height,
                        Text(
                          'RIZIPT',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3,
                          ),
                        ),
                        4.height,
                        Text(
                          'TRANSACTION BY RIZIPT',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.5,
                          ),
                        ),
                        20.height,
                        // Title row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              'Sign In',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w700,
                              ),
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
                              child: Text(
                                'as',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white70,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            8.width,
                            Text(
                              'Merchant',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        8.height,
                        Text(
                          'Please Sign in to Continue Our App',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                          ),
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
                                Text(
                                  AppString.email,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF1A1A2E),
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                8.height,
                                // Email field
                                _buildInputField(
                                  controller: emailController,
                                  hintText: 'your.email@example.com',
                                  prefixIcon: Icons.mail_outline_rounded,
                                  validator: AppValidation.email,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                20.height,
                                // Password label
                                Text(
                                  AppString.password,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF1A1A2E),
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                8.height,
                                // Password field
                                _buildPasswordField(),
                                16.height,
                                // Remember me + Forgot password row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 20.w,
                                          height: 20.w,
                                          child: Checkbox(
                                            value: _rememberMe,
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
                                              setState(() {
                                                _rememberMe = val ?? false;
                                              });
                                            },
                                          ),
                                        ),
                                        8.width,
                                        Text(
                                          'Remember me',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: const Color(0xFF454545),
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.forgotPassword,
                                        );
                                      },
                                      child: Text(
                                        'Forgot Password?',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF2196F3),
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                          decorationColor: const Color(
                                            0xFF2196F3,
                                          ),
                                        ),
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
                                    : Text(
                                        'Sign In',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    FormFieldValidator<String>? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUnfocus,
      validator: validator,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14.sp,
        color: const Color(0xFF1A1A2E),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.plusJakartaSans(
          fontSize: 13.sp,
          color: const Color(0xFF979797),
        ),
        prefixIcon: Icon(
          prefixIcon,
          size: 18.sp,
          color: const Color(0xFF979797),
        ),
        filled: true,
        fillColor: const Color(0xFFF0F4F8),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        errorMaxLines: 2,
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: _obscurePassword,
      autovalidateMode: AutovalidateMode.onUnfocus,
      validator: AppValidation.password,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14.sp,
        color: const Color(0xFF1A1A2E),
      ),
      decoration: InputDecoration(
        hintText: AppString.password,
        hintStyle: GoogleFonts.plusJakartaSans(
          fontSize: 13.sp,
          color: const Color(0xFF979797),
        ),
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          size: 18.sp,
          color: const Color(0xFF979797),
        ),
        suffixIcon: GestureDetector(
          onTap: () => setState(() => _obscurePassword = !_obscurePassword),
          child: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            size: 18.sp,
            color: const Color(0xFF979797),
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFF0F4F8),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        errorMaxLines: 2,
      ),
    );
  }
}
