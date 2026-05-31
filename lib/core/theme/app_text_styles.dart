import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Configurable Font Family and Font Sizes
  static const String fontFamily = 'Outfit';
  
  static const double sizeHeading = 28.0;
  static const double sizeSubheading = 16.0;
  static const double sizeBody = 14.0;
  static const double sizeButton = 16.0;

  static TextStyle get heading => GoogleFonts.getFont(
        fontFamily,
        fontSize: sizeHeading,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get subheading => GoogleFonts.getFont(
        fontFamily,
        fontSize: sizeSubheading,
        color: AppColors.textSecondary,
      );

  static TextStyle get body => GoogleFonts.getFont(
        fontFamily,
        fontSize: sizeBody,
        color: AppColors.textPrimary,
      );

  static TextStyle get button => GoogleFonts.getFont(
        fontFamily,
        fontSize: sizeButton,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );
}
