import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AuthenticationOptionsWidget extends StatelessWidget {
  final VoidCallback onUsePasscode;
  final VoidCallback onOpenSettings;
  final VoidCallback onContactSupport;

  const AuthenticationOptionsWidget({
    Key? key,
    required this.onUsePasscode,
    required this.onOpenSettings,
    required this.onContactSupport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Alternative Options',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                thickness: 1,
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Use Passcode Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onUsePasscode,
            icon: CustomIconWidget(
              iconName: 'lock',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            label: const Text('Use Passcode'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              side: BorderSide(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: 1.5,
              ),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Additional Options Row
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: onOpenSettings,
                icon: CustomIconWidget(
                  iconName: 'settings',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 18,
                ),
                label: Text(
                  'Settings',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: TextButton.icon(
                onPressed: onContactSupport,
                icon: CustomIconWidget(
                  iconName: 'support_agent',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 18,
                ),
                label: Text(
                  'Support',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
