import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProcessingAnimationWidget extends StatelessWidget {
  final Animation<double> scanAnimation;
  final Animation<double> pulseAnimation;
  final Animation<double> celebrationAnimation;
  final bool isCompleted;

  const ProcessingAnimationWidget({
    Key? key,
    required this.scanAnimation,
    required this.pulseAnimation,
    required this.celebrationAnimation,
    required this.isCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([
          scanAnimation,
          pulseAnimation,
          celebrationAnimation,
        ]),
        builder: (context, child) {
          return Container(
              width: 60.w,
              height: 60.w,
              child: Stack(alignment: Alignment.center, children: [
                // Outer pulse ring
                if (!isCompleted)
                  Transform.scale(
                      scale: pulseAnimation.value,
                      child: Container(
                          width: 60.w,
                          height: 60.w,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withAlpha(77),
                                  width: 2)))),

                // Middle pulse ring
                if (!isCompleted)
                  Transform.scale(
                      scale: pulseAnimation.value * 0.8,
                      child: Container(
                          width: 45.w,
                          height: 45.w,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withAlpha(128),
                                  width: 1.5)))),

                // Document icon container
                Transform.scale(
                    scale: isCompleted ? celebrationAnimation.value : 1.0,
                    child: Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withAlpha(26),
                            shape: BoxShape.circle),
                        child: Stack(alignment: Alignment.center, children: [
                          // Document icon
                          CustomIconWidget(
                              iconName:
                                  isCompleted ? 'check_circle' : 'description',
                              color: isCompleted
                                  ? AppTheme.lightTheme.colorScheme.tertiary
                                  : AppTheme.lightTheme.colorScheme.primary,
                              size: 12.w),

                          // Scanning beam effect
                          if (!isCompleted)
                            Positioned(
                                top: 8.w + (14.w * scanAnimation.value),
                                left: 6.w,
                                right: 6.w,
                                child: Container(
                                    height: 0.5.h,
                                    decoration: BoxDecoration(
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.primary
                                                  .withAlpha(153),
                                              blurRadius: 4,
                                              spreadRadius: 1),
                                        ]))),
                        ]))),

                // Success particles
                if (isCompleted)
                  ...List.generate(8, (index) => _buildSuccessParticle(index)),
              ]));
        });
  }

  Widget _buildSuccessParticle(int index) {
    final angle = (index * 45) * (3.14159 / 180); // Convert to radians
    final distance = 20.w * celebrationAnimation.value;

    return Positioned(
        child: Transform.scale(
            scale: celebrationAnimation.value,
            child: Container(
                width: 2.w,
                height: 2.w,
                decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    shape: BoxShape.circle))));
  }
}
