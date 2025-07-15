import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/camera_demo_widget.dart';
import './widgets/permission_actions_widget.dart';
import './widgets/permission_benefits_widget.dart';
import './widgets/privacy_assurance_widget.dart';

class CameraPermissionsScreen extends StatefulWidget {
  const CameraPermissionsScreen({Key? key}) : super(key: key);

  @override
  State<CameraPermissionsScreen> createState() =>
      _CameraPermissionsScreenState();
}

class _CameraPermissionsScreenState extends State<CameraPermissionsScreen> {
  bool _showLearnMore = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppTheme.textPrimaryLight,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Camera Access',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 4.h),

                      // Camera demonstration
                      CameraDemoWidget(),

                      SizedBox(height: 4.h),

                      // Main heading
                      Text(
                        'Camera Access Required',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimaryLight,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 2.h),

                      // Explanation text
                      Text(
                        'We need access to your camera to scan medical documents and provide accurate health analysis.',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.textSecondaryLight,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 4.h),

                      // Permission benefits
                      PermissionBenefitsWidget(),

                      SizedBox(height: 4.h),

                      // Learn more toggle
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showLearnMore = !_showLearnMore;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight.withAlpha(26),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.primaryLight.withAlpha(77),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _showLearnMore
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: AppTheme.primaryLight,
                                size: 5.w,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                _showLearnMore ? 'Show Less' : 'Learn More',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.primaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Privacy assurance (expandable)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: _showLearnMore ? null : 0,
                        child: _showLearnMore
                            ? Column(
                                children: [
                                  SizedBox(height: 3.h),
                                  PrivacyAssuranceWidget(),
                                ],
                              )
                            : null,
                      ),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),

              // Action buttons
              PermissionActionsWidget(),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
