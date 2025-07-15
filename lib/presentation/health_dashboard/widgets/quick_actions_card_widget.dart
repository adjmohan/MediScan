import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsCardWidget extends StatelessWidget {
  final VoidCallback onScanReport;
  final VoidCallback onCheckSymptoms;
  final VoidCallback onViewReports;
  final VoidCallback onBookAppointment;

  const QuickActionsCardWidget({
    Key? key,
    required this.onScanReport,
    required this.onCheckSymptoms,
    required this.onViewReports,
    required this.onBookAppointment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Quick Actions',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'AI Enhanced',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 1.2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            children: [
              _buildActionTile(
                icon: 'document_scanner',
                title: 'Scan Report',
                subtitle: 'AI Document Analysis',
                gradient: LinearGradient(
                  colors: [
                    AppTheme.lightTheme.colorScheme.primary,
                    AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.7),
                  ],
                ),
                onTap: onScanReport,
              ),
              _buildActionTile(
                icon: 'psychology',
                title: 'Check Symptoms',
                subtitle: 'AI Health Assistant',
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF10B981),
                    Color(0xFF10B981).withValues(alpha: 0.7),
                  ],
                ),
                onTap: onCheckSymptoms,
              ),
              _buildActionTile(
                icon: 'assessment',
                title: 'View Reports',
                subtitle: 'Past Analyses',
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFF59E0B),
                    Color(0xFFF59E0B).withValues(alpha: 0.7),
                  ],
                ),
                onTap: onViewReports,
              ),
              _buildActionTile(
                icon: 'calendar_today',
                title: 'Book Appointment',
                subtitle: 'Schedule Visit',
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF8B5CF6),
                    Color(0xFF8B5CF6).withValues(alpha: 0.7),
                  ],
                ),
                onTap: onBookAppointment,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String icon,
    required String title,
    required String subtitle,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: Colors.white,
                size: 6.w,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              subtitle,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
