import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/app_export.dart';

class PermissionActionsWidget extends StatelessWidget {
  const PermissionActionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary action button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _handleAllowCamera(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryLight,
              foregroundColor: AppTheme.backgroundLight,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt,
                  size: 5.w,
                  color: AppTheme.backgroundLight,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Allow Camera Access',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Secondary action button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _handleUseGallery(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.textSecondaryLight,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              side: BorderSide(
                color: AppTheme.borderLight,
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_library,
                  size: 5.w,
                  color: AppTheme.textSecondaryLight,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Use Gallery Instead',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleAllowCamera(BuildContext context) async {
    try {
      // Request camera permission
      await _requestCameraPermission();

      // Save permission status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('camera_permission_granted', true);

      // Navigate to document scanner
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.documentScanner);
      }
    } catch (e) {
      // Handle permission denied
      _showPermissionDeniedDialog(context);
    }
  }

  void _handleUseGallery(BuildContext context) {
    // Navigate to gallery picker or document scanner with gallery mode
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.documentScanner,
      arguments: {'mode': 'gallery'},
    );
  }

  Future<void> _requestCameraPermission() async {
    // Mock permission request - in real app, use permission_handler package
    await Future.delayed(const Duration(milliseconds: 500));

    // Simulate permission granted (in real app, this would be actual permission result)
    // throw Exception('Permission denied'); // Uncomment to test denial
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Camera Permission Denied',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        content: Text(
          'Camera access is required for document scanning. You can enable it in your device settings or use the gallery option instead.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.textSecondaryLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondaryLight,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _openDeviceSettings();
            },
            child: Text(
              'Open Settings',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openDeviceSettings() {
    // Mock opening device settings - in real app, use app_settings package
    Fluttertoast.showToast(
      msg: 'Opening device settings...',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}