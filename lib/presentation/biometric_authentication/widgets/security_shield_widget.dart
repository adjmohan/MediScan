import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SecurityShieldWidget extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> pulseAnimation;

  const SecurityShieldWidget({
    Key? key,
    required this.animation,
    required this.pulseAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([animation, pulseAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value * pulseAnimation.value,
          child: Container(
            width: 25.w,
            height: 25.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.05),
                ],
              ),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Center(
              child: Container(
                width: 18.w,
                height: 18.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'security',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 8.w,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
