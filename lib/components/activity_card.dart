import 'package:bitacora_ejercicios/model/activity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 72),
      child: Container(
        width: double.infinity,
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: AppColors.cardBackground),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.only(right: 16),
              decoration: ShapeDecoration(
                color: AppColors.chipBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Icon(Icons.task, size: 24),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.name, style: AppTextStyles.taskTitle),
                Text(activity.description, style: AppTextStyles.taskTime),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppColors {
  static const primaryText = Color(0xFF0F1419);
  static const secondaryText = Color(0xFF59728C);
  static const cardBackground = Color(0xFFF9F9F9);
  static const chipBackground = Color(0xFFE8EDF2);
}

class AppTextStyles {
  static const header = TextStyle(
    color: AppColors.primaryText,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.28,
  );

  static const taskTitle = TextStyle(
    color: AppColors.primaryText,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.50,
  );

  static const taskTime = TextStyle(
    color: AppColors.secondaryText,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.50,
  );

  static const chipText = TextStyle(
    color: AppColors.primaryText,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.50,
  );
}
