import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../ocr_processing.dart';

class ProcessingStageWidget extends StatelessWidget {
  final ProcessingStage stage;
  final String stageDescription;
  final String stageDetailText;
  final int estimatedTimeRemaining;
  final bool isProcessing;

  const ProcessingStageWidget({
    Key? key,
    required this.stage,
    required this.stageDescription,
    required this.stageDetailText,
    required this.estimatedTimeRemaining,
    required this.isProcessing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(77),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withAlpha(26),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Stage title
          Text(
            stageDescription,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          // Stage detail text
          Text(
            stageDetailText,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 3.h),

          // Time remaining
          if (isProcessing && estimatedTimeRemaining > 0)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 1.h,
              ),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary.withAlpha(77),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'access_time',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Est. ${estimatedTimeRemaining}s remaining',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Processing tips
          if (isProcessing)
            Column(
              children: [
                SizedBox(height: 3.h),
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(13),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'info',
                            color: Colors.white.withAlpha(179),
                            size: 4.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Processing Tips',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: Colors.white.withAlpha(179),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        _getProcessingTip(),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withAlpha(153),
                          fontSize: 10.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),

          // Completion message
          if (!isProcessing)
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.tertiary.withAlpha(77),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Processing Complete!',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _getProcessingTip() {
    switch (stage) {
      case ProcessingStage.scanning:
        return 'AI is preparing to analyze your document with optimal settings';
      case ProcessingStage.extractingText:
        return 'Advanced OCR technology is reading every detail from your document';
      case ProcessingStage.analyzingContent:
        return 'Medical AI is understanding the context and meaning of your results';
      case ProcessingStage.generatingInsights:
        return 'Personalized health insights are being generated based on your data';
    }
  }
}
