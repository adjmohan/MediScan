import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import './widgets/splash_content_widget.dart';
import './widgets/splash_logo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  int _currentStage = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitialization();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat(reverse: true);
  }

  void _startInitialization() async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Stage 1: Checking authentication
    setState(() => _currentStage = 1);
    await Future.delayed(const Duration(milliseconds: 800));

    // Stage 2: Loading preferences
    setState(() => _currentStage = 2);
    await Future.delayed(const Duration(milliseconds: 800));

    // Stage 3: Initializing AI models
    setState(() => _currentStage = 3);
    await Future.delayed(const Duration(milliseconds: 800));

    // Complete initialization
    await _completeInitialization();
  }

  Future<void> _completeInitialization() async {
    try {
      // Check authentication status
      final prefs = await SharedPreferences.getInstance();
      final isFirstTime = prefs.getBool('is_first_time') ?? true;
      final hasBiometric = prefs.getBool('biometric_enabled') ?? false;

      if (mounted) {
        if (isFirstTime) {
          // First time user - go to onboarding
          Navigator.pushReplacementNamed(context, AppRoutes.healthProfileSetup);
        } else if (hasBiometric) {
          // Returning user with biometric - go to authentication
          Navigator.pushReplacementNamed(
              context, AppRoutes.biometricAuthentication);
        } else {
          // Returning user without biometric - go to dashboard
          Navigator.pushReplacementNamed(context, AppRoutes.healthDashboard);
        }
      }
    } catch (e) {
      if (mounted) {
        // Show error and retry option
        _showErrorDialog();
      }
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Initialization Error',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        content: Text(
          'Unable to initialize the app. Please check your connection and try again.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.textSecondaryLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startInitialization();
            },
            child: Text(
              'Retry',
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryLight,
              Color(0xFFF0F7FF),
              AppTheme.backgroundLight,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // App Logo with pulse animation
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: SplashLogoWidget(
                      fadeAnimation: _fadeAnimation,
                    ),
                  );
                },
              ),

              SizedBox(height: 4.h),

              // App content
              SplashContentWidget(
                fadeAnimation: _fadeAnimation,
              ),

              const Spacer(flex: 1),

              // Loading indicator and status
              Column(
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryLight,
                    ),
                    backgroundColor: AppTheme.primaryLight.withAlpha(77),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    _getLoadingMessage(),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.textSecondaryLight,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  String _getLoadingMessage() {
    switch (_currentStage) {
      case 1:
        return 'Checking authentication status...';
      case 2:
        return 'Loading user preferences...';
      case 3:
        return 'Initializing AI models...';
      default:
        return 'Starting MedScanAI...';
    }
  }
}
