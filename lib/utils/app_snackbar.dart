import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'constants/app_colors.dart';

class AppSnackbar {
  AppSnackbar._();

  // Success snackbar
  static void success({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    _showSnackbar(
      context: context,
      title: kDebugMode ? title : 'Success',
      message: message,
      backgroundColor: AppColors.black,
    );
  }

  // Error snackbar
  static void error({
    required BuildContext context,
    String? title,
    required String message,
  }) {
    _showSnackbar(
      context: context,
      title: kDebugMode ? (title ?? 'Error') : 'Oops',
      message: message,
      backgroundColor: AppColors.red,
    );
  }

  // Main native snackbar builder
  static void _showSnackbar({
    required BuildContext context,
    required String title,
    required String message,
    required Color backgroundColor,
  }) {
    // Hide active snackbar if any before showing a new one
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
