import 'package:bitacora_ejercicios/colors/app_colors.dart';
import 'package:bitacora_ejercicios/model/activity.dart';
import 'package:flutter/material.dart';

import '../colors/app_text_styles.dart';

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



