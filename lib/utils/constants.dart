import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor = Color(0xFF6A11CB);
  static const accentColor = Color(0xFF8E2DE2);
  static const backgroundColor = Colors.white;
  static const textPrimary = Colors.black87;
  static const textSecondary = Colors.grey;
  static const shadowColor = Colors.black26;
  static const buttonColor = Color(0xFF8E2DE2);
  static const buttonHoverColor = Color(0xFF6A11CB);
}

class AppTextStyles {
  static const heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const body = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const caption = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
}

class AppPadding {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;

  static const screenPadding = EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0);
}
