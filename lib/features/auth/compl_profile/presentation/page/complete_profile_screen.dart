import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../utils/extensions/extension.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../utils/constants/app_string.dart';
import '../../../../../core/di/service_locator.dart';
import '../bloc/complete_profile_bloc.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController ageController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    ageController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CompleteProfileBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Complete Profile")),
        body: BlocListener<CompleteProfileBloc, CompleteProfileState>(
          listener: (context, state) {
            if (state is CompleteProfileFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is CompleteProfileSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Profile Completed Successfully!")),
              );
              // Navigator.pushNamed(context, AppRoutes.home);
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
                    text: "Complete Your Profile",
                    fontSize: 28,
                    bottom: 24,
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
                    validator: (v) => v!.isEmpty ? AppString.thisFieldIsRequired : null,
                  ),

                  const CommonText(text: "Phone Number", bottom: 8, top: 16),
                  CommonTextField(
                    controller: phoneController,
                    hintText: "Enter Phone Number",
                    keyboardType: TextInputType.phone,
                    validator: (v) => v!.isEmpty ? AppString.thisFieldIsRequired : null,
                  ),

                  const CommonText(text: "Age", bottom: 8, top: 16),
                  CommonTextField(
                    controller: ageController,
                    hintText: "Enter Your Age",
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? AppString.thisFieldIsRequired : null,
                  ),

                  40.height,

                  BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
                    builder: (context, state) {
                      return CommonButton(
                        titleText: "Submit Profile",
                        isLoading: state is CompleteProfileLoading,
                        onTap: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          context.read<CompleteProfileBloc>().add(
                            CompleteProfileData(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                              age: int.tryParse(ageController.text) ?? 0,
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
