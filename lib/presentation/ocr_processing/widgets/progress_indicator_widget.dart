import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../ocr_processing.dart';

class ProcessingProgressIndicator extends StatelessWidget {
  final double progress;
  final ProcessingStage stage;

  const ProcessingProgressIndicator({
    Key? key,
    required this.progress,
    required this.stage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      child: Column(
        children: [
          // Progress bar
          Container(
            height: 0.8.h,
            width: 80.w,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                // Progress fill
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 0.8.h,
                  width: 80.w * progress,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.lightTheme.colorScheme.primary,
                        AppTheme.lightTheme.colorScheme.primary.withAlpha(204),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withAlpha(102),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),

                // Progress shimmer effect
                if (progress > 0 && progress < 1)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    left: (80.w * progress) - 10.w,
                    child: Container(
                      height: 0.8.h,
                      width: 10.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.white.withAlpha(77),
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Progress percentage
          Text(
            '${(progress * 100).toInt()}%',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 1.h),

          // Stage indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ProcessingStage.values.map((stageItem) {
              final isActive = stageItem.index <= stage.index;
              final isCurrent = stageItem == stage;

              return _buildStageIndicator(
                isActive: isActive,
                isCurrent: isCurrent,
                stageItem: stageItem,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStageIndicator({
    required bool isActive,
    required bool isCurrent,
    required ProcessingStage stageItem,
  }) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.lightTheme.colorScheme.primary
                : Colors.white.withAlpha(77),
            shape: BoxShape.circle,
            border: isCurrent
                ? Border.all(
                    color: Colors.white,
                    width: 2,
                  )
                : null,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withAlpha(153),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          _getStageLabel(stageItem),
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: isActive ? Colors.white : Colors.white.withAlpha(128),
            fontSize: 10.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _getStageLabel(ProcessingStage stage) {
    switch (stage) {
      case ProcessingStage.scanning:
        return 'Scan';
      case ProcessingStage.extractingText:
        return 'Extract';
      case ProcessingStage.analyzingContent:
        return 'Analyze';
      case ProcessingStage.generatingInsights:
        return 'Insights';
    }
  }
}
