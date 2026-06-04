import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_string.dart';

class DoNotHaveAccount extends StatelessWidget {
  const DoNotHaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "Don't have an account? ",
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF454545),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: AppString.signUp,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, AppRoutes.signUp);
                },
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF2196F3),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFF2196F3),
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
