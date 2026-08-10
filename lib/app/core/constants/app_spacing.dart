// lib/app/core/constants/app_spacing.dart
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpacing {
  AppSpacing._();

  // Horizontal spacing (width-based)
  static double get h4 => 4.w;
  static double get h8 => 8.w;
  static double get h12 => 12.w;
  static double get h16 => 16.w;
  static double get h20 => 20.w;
  static double get h24 => 24.w;
  static double get h32 => 32.w;
  static double get h40 => 40.w;
  static double get h48 => 48.w;

  // Vertical spacing (height-based)
  static double get v4 => 4.h;
  static double get v8 => 8.h;
  static double get v12 => 12.h;
  static double get v16 => 16.h;
  static double get v20 => 20.h;
  static double get v24 => 24.h;
  static double get v32 => 32.h;
  static double get v40 => 40.h;
  static double get v48 => 48.h;
  static double get v64 => 64.h;

  static const double fullWidth = double.infinity;
}

class AppRadius {
  AppRadius._();

  static double get xs => 4.r;
  static double get sm => 8.r;
  static double get md => 12.r;
  static double get lg => 16.r;
  static double get xl => 20.r;
  static double get xxl => 28.r;
  static double get circle => 100.r;
}
