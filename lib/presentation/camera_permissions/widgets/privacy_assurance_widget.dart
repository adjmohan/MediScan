import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PrivacyAssuranceWidget extends StatelessWidget {
  const PrivacyAssuranceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.successLight.withAlpha(26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.successLight.withAlpha(77),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security,
                color: AppTheme.successLight,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Your Privacy is Protected',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildPrivacyPoint(
            '• Photos are processed locally on your device',
          ),
          SizedBox(height: 1.h),
          _buildPrivacyPoint(
            '• No images are stored permanently after processing',
          ),
          SizedBox(height: 1.h),
          _buildPrivacyPoint(
            '• HIPAA-compliant data handling and encryption',
          ),
          SizedBox(height: 1.h),
          _buildPrivacyPoint(
            '• Only extracted text is saved, not the actual images',
          ),
          SizedBox(height: 1.h),
          _buildPrivacyPoint(
            '• You can revoke camera access anytime in settings',
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.backgroundLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified_user,
                  color: AppTheme.successLight,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'All data processing follows strict medical privacy standards',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyPoint(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppTheme.textSecondaryLight,
        height: 1.4,
      ),
    );
  }
}
