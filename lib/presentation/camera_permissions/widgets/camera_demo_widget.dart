import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CameraDemoWidget extends StatelessWidget {
  const CameraDemoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background illustration
          Container(
            width: 70.w,
            height: 35.h,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.description,
                  size: 15.w,
                  color: AppTheme.primaryLight.withAlpha(179),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Medical Document',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),

          // Camera viewfinder overlay
          Container(
            width: 70.w,
            height: 35.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryLight,
                width: 2,
              ),
            ),
          ),

          // Detection corners
          Positioned(
            top: 5.h,
            left: 8.w,
            child: Container(
              width: 4.w,
              height: 4.w,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppTheme.successLight,
                    width: 3,
                  ),
                  left: BorderSide(
                    color: AppTheme.successLight,
                    width: 3,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 5.h,
            right: 8.w,
            child: Container(
              width: 4.w,
              height: 4.w,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppTheme.successLight,
                    width: 3,
                  ),
                  right: BorderSide(
                    color: AppTheme.successLight,
                    width: 3,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 5.h,
            left: 8.w,
            child: Container(
              width: 4.w,
              height: 4.w,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.successLight,
                    width: 3,
                  ),
                  left: BorderSide(
                    color: AppTheme.successLight,
                    width: 3,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 5.h,
            right: 8.w,
            child: Container(
              width: 4.w,
              height: 4.w,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.successLight,
                    width: 3,
                  ),
                  right: BorderSide(
                    color: AppTheme.successLight,
                    width: 3,
                  ),
                ),
              ),
            ),
          ),

          // Scan line animation
          Positioned(
            top: 15.h,
            left: 10.w,
            right: 10.w,
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppTheme.primaryLight,
                    Colors.transparent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryLight.withAlpha(128),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}