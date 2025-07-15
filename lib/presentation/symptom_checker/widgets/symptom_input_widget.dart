import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SymptomInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAddSymptom;
  final VoidCallback onSubmitted;

  const SymptomInputWidget({
    Key? key,
    required this.controller,
    required this.onAddSymptom,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Describe Your Symptoms',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'e.g., Headache, Fever, Fatigue...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                  ),
                  onSubmitted: (_) => onSubmitted(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 2.w),
                child: IconButton(
                  onPressed: onAddSymptom,
                  icon: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 4.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Add one symptom at a time. Be specific about your symptoms.',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(179),
          ),
        ),
      ],
    );
  }
}
