
import 'package:bitacora_ejercicios/colors/app_colors.dart';
import 'package:flutter/material.dart';
class AppTextStyles {
  static final header = TextStyle(
    color: AppColors.primaryText,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.28,
  );

  static final taskTitle = TextStyle(
    color: AppColors.primaryText,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.50,
  );

  static final taskTime = TextStyle(
    color: AppColors.secondaryText,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.50,
  );

  static final chipText = TextStyle(
    color: AppColors.primaryText,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.50,
  );
}
