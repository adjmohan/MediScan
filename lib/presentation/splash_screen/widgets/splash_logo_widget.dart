import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SplashLogoWidget extends StatelessWidget {
  final Animation<double> fadeAnimation;

  const SplashLogoWidget({
    Key? key,
    required this.fadeAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: fadeAnimation.value,
          child: Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.backgroundLight,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryLight.withAlpha(77),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring
                Container(
                  width: 18.w,
                  height: 18.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryLight.withAlpha(128),
                      width: 2,
                    ),
                  ),
                ),

                // Inner icon
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryLight,
                  ),
                  child: Icon(
                    Icons.health_and_safety_rounded,
                    color: AppTheme.backgroundLight,
                    size: 8.w,
                  ),
                ),

                // AI indicator
                Positioned(
                  bottom: 1.w,
                  right: 1.w,
                  child: Container(
                    width: 5.w,
                    height: 5.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.successLight,
                      border: Border.all(
                        color: AppTheme.backgroundLight,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: AppTheme.backgroundLight,
                      size: 2.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
