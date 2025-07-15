import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricPromptWidget extends StatelessWidget {
  final String biometricType;
  final bool isAuthenticating;
  final VoidCallback onAuthenticate;

  const BiometricPromptWidget({
    Key? key,
    required this.biometricType,
    required this.isAuthenticating,
    required this.onAuthenticate,
  }) : super(key: key);

  String get _biometricIcon {
    switch (biometricType) {
      case 'Face ID':
        return 'face';
      case 'Touch ID':
        return 'fingerprint';
      case 'Fingerprint':
        return 'fingerprint';
      default:
        return 'fingerprint';
    }
  }

  String get _promptText {
    switch (biometricType) {
      case 'Face ID':
        return 'Authenticate with Face ID';
      case 'Touch ID':
        return 'Authenticate with Touch ID';
      case 'Fingerprint':
        return 'Authenticate with Fingerprint';
      default:
        return 'Authenticate with Biometrics';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Biometric Button
        GestureDetector(
          onTap: isAuthenticating ? null : onAuthenticate,
          child: Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isAuthenticating
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.7)
                  : AppTheme.lightTheme.colorScheme.primary,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: isAuthenticating
                  ? SizedBox(
                      width: 6.w,
                      height: 6.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : CustomIconWidget(
                      iconName: _biometricIcon,
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 8.w,
                    ),
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // Prompt Text
        Text(
          isAuthenticating ? 'Authenticating...' : _promptText,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 1.h),

        // Instruction Text
        if (!isAuthenticating)
          Text(
            biometricType == 'Face ID'
                ? 'Look at your device to authenticate'
                : 'Place your finger on the sensor',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
