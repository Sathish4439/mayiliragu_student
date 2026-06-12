import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Purple Branding Colors
  static const Color brandPurple = Color(0xFF5A00EC);
  static const Color lightLavender = Color(0xFFEAECFA);
  static const Color indicatorInactive = Color(0xFFD1D1D6);

  // Academic Clarity Color System
  static const Color primary = Color(0xFF000000);
  static const Color secondary = Color(0xFFE5EEFF); // surface-container
  static const Color backgroundStart = Color(0xFFF8F9FF); // background / surface
  static const Color backgroundEnd = Color(0xFFEFF4FF); // surface-container-low
  
  static const Color accent = Color(0xFF006A61); // secondary (Vibrant Teal)
  static const Color accentDark = Color(0xFF131B2E); // primary-container (Midnight Blue)
  static const Color error = Color(0xFFBA1A1A); // error
  
  static const Color textPrimary = Color(0xFF0B1C30); // on-surface / on-background
  static const Color textSecondary = Color(0xFF45464D); // on-surface-variant
  static const Color border = Color(0xFFC6C6CD); // outline-variant
  static const Color cardBg = Color(0xFFFFFFFF); // surface-container-lowest
  
  // Extra specific colors from Academic Clarity spec
  static const Color surface = Color(0xFFF8F9FF);
  static const Color surfaceContainer = Color(0xFFE5EEFF);
  static const Color surfaceContainerHigh = Color(0xFFDCE9FF);
  static const Color surfaceContainerHighest = Color(0xFFD3E4FE);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF131B2E);
  static const Color secondaryContainer = Color(0xFF86F2E4);
  static const Color onSecondaryContainer = Color(0xFF006F66);
}
