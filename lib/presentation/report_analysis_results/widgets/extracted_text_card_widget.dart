import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExtractedTextCardWidget extends StatelessWidget {
  final String extractedText;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;

  const ExtractedTextCardWidget({
    Key? key,
    required this.extractedText,
    required this.isExpanded,
    required this.onToggleExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomIconWidget(
                    iconName: 'text_fields',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OCR Extracted Text',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Tap to ${isExpanded ? 'collapse' : 'expand'} full text',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _copyToClipboard,
                      child: Container(
                        padding: EdgeInsets.all(1.5.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        child: CustomIconWidget(
                          iconName: 'copy',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 16,
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    GestureDetector(
                      onTap: onToggleExpanded,
                      child: Container(
                        padding: EdgeInsets.all(1.5.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        child: CustomIconWidget(
                          iconName: isExpanded ? 'expand_less' : 'expand_more',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: AppTheme.lightTheme.colorScheme.outline,
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: isExpanded ? null : 15.h,
              child: SingleChildScrollView(
                physics: isExpanded ? null : NeverScrollableScrollPhysics(),
                child: SelectableText(
                  extractedText,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
          if (!isExpanded)
            Container(
              width: double.infinity,
              height: 4.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.lightTheme.cardColor.withValues(alpha: 0.0),
                    AppTheme.lightTheme.cardColor,
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: extractedText));
  }
}
