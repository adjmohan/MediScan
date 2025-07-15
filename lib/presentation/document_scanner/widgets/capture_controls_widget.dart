import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CaptureControlsWidget extends StatelessWidget {
  final bool isCapturing;
  final bool documentDetected;
  final VoidCallback onCapture;
  final VoidCallback onOpenGallery;

  const CaptureControlsWidget({
    Key? key,
    required this.isCapturing,
    required this.documentDetected,
    required this.onCapture,
    required this.onOpenGallery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 4.h,
      left: 0,
      right: 0,
      child: Container(
        height: 20.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gallery Button
            GestureDetector(
              onTap: onOpenGallery,
              child: Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Stack(
                  children: [
                    // Mock gallery preview
                    ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: CustomImageWidget(
                        imageUrl:
                            'https://images.pixabay.com/photo/2017/07/25/01/22/cat-2536662_1280.jpg',
                        width: 15.w,
                        height: 15.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'photo_library',
                          color: Colors.white,
                          size: 6.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Capture Button
            GestureDetector(
              onTap: isCapturing ? null : onCapture,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: documentDetected
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : Colors.white,
                  border: Border.all(
                    color: documentDetected
                        ? AppTheme.lightTheme.colorScheme.tertiary
                        : Colors.white.withValues(alpha: 0.8),
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: isCapturing
                    ? Center(
                        child: SizedBox(
                          width: 8.w,
                          height: 8.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              documentDetected
                                  ? Colors.white
                                  : AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: documentDetected
                                ? Colors.white
                                : AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ),
              ),
            ),

            // Auto Mode Toggle
            GestureDetector(
              onTap: () {
                // Toggle auto capture mode
              },
              child: Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'auto_awesome',
                      color: Colors.white,
                      size: 5.w,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'AUTO',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontSize: 8.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
