import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/authentication_options_widget.dart';
import './widgets/biometric_prompt_widget.dart';
import './widgets/security_shield_widget.dart';

class BiometricAuthentication extends StatefulWidget {
  const BiometricAuthentication({Key? key}) : super(key: key);

  @override
  State<BiometricAuthentication> createState() =>
      _BiometricAuthenticationState();
}

class _BiometricAuthenticationState extends State<BiometricAuthentication>
    with TickerProviderStateMixin {
  late AnimationController _shieldAnimationController;
  late AnimationController _pulseAnimationController;
  late Animation<double> _shieldAnimation;
  late Animation<double> _pulseAnimation;

  bool _isAuthenticating = false;
  bool _showFallbackOptions = false;
  int _failedAttempts = 0;
  String _biometricType = 'Face ID'; // Default, will be determined by platform

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _determineBiometricType();
    _startAutoAuthentication();
  }

  void _initializeAnimations() {
    _shieldAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _shieldAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shieldAnimationController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));

    _shieldAnimationController.forward();
    _pulseAnimationController.repeat(reverse: true);
  }

  void _determineBiometricType() {
    // Simulate platform detection
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      setState(() {
        _biometricType = 'Face ID';
      });
    } else {
      setState(() {
        _biometricType = 'Fingerprint';
      });
    }
  }

  void _startAutoAuthentication() {
    // Auto-trigger biometric authentication on iOS
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      Future.delayed(const Duration(milliseconds: 800), () {
        _authenticateWithBiometrics();
      });
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      // Simulate biometric authentication
      await Future.delayed(const Duration(milliseconds: 1500));

      // Simulate random success/failure for demo
      final isSuccess = DateTime.now().millisecond % 3 != 0;

      if (isSuccess) {
        _onAuthenticationSuccess();
      } else {
        _onAuthenticationFailure();
      }
    } catch (e) {
      _onAuthenticationError();
    }
  }

  void _onAuthenticationSuccess() {
    HapticFeedback.lightImpact();

    setState(() {
      _isAuthenticating = false;
    });

    // Navigate to health dashboard or profile setup
    Navigator.pushReplacementNamed(context, '/health-dashboard');
  }

  void _onAuthenticationFailure() {
    HapticFeedback.heavyImpact();

    setState(() {
      _isAuthenticating = false;
      _failedAttempts++;

      if (_failedAttempts >= 3) {
        _showFallbackOptions = true;
      }
    });

    _showErrorDialog('Authentication Failed',
        'Please try again or use an alternative method.');
  }

  void _onAuthenticationError() {
    setState(() {
      _isAuthenticating = false;
      _showFallbackOptions = true;
    });

    _showErrorDialog('Biometric Error',
        'Unable to access biometric sensor. Please check your device settings.');
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _usePasscode() {
    // Navigate to passcode entry or alternative authentication
    Navigator.pushReplacementNamed(context, '/health-profile-setup');
  }

  void _openSettings() {
    // Open device settings for biometric configuration
    _showErrorDialog('Settings',
        'Please enable biometric authentication in your device settings.');
  }

  void _contactSupport() {
    // Navigate to support or show contact information
    _showErrorDialog('Support',
        'For technical assistance, please contact our support team at support@medscanai.com');
  }

  void _exitApp() {
    SystemNavigator.pop();
  }

  @override
  void dispose() {
    _shieldAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _exitApp();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Security Shield Animation
                SecurityShieldWidget(
                  animation: _shieldAnimation,
                  pulseAnimation: _pulseAnimation,
                ),

                SizedBox(height: 6.h),

                // Main Heading
                Text(
                  'Secure Health Access',
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 2.h),

                // Subtitle
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    'Your medical data is protected with advanced biometric security. Please authenticate to access your health information.',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 8.h),

                // Biometric Prompt
                BiometricPromptWidget(
                  biometricType: _biometricType,
                  isAuthenticating: _isAuthenticating,
                  onAuthenticate: _authenticateWithBiometrics,
                ),

                SizedBox(height: 4.h),

                // Authentication Options
                if (_showFallbackOptions)
                  AuthenticationOptionsWidget(
                    onUsePasscode: _usePasscode,
                    onOpenSettings: _openSettings,
                    onContactSupport: _contactSupport,
                  ),

                const Spacer(flex: 3),

                // Security Notice
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'security',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          'HIPAA-compliant security • Auto-timeout in 30s',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
