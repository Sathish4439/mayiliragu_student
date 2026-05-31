import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.backgroundStart,
      textTheme: TextTheme(
        headlineMedium: AppTextStyles.heading,
        titleMedium: AppTextStyles.subheading,
        bodyMedium: AppTextStyles.body,
      ),
    );
  }
}
