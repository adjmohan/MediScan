import 'package:flutter/material.dart';

import '../presentation/biometric_authentication/biometric_authentication.dart';
import '../presentation/camera_permissions/camera_permissions.dart';
import '../presentation/document_scanner/document_scanner.dart';
import '../presentation/health_dashboard/health_dashboard.dart';
import '../presentation/health_profile_setup/health_profile_setup.dart';
import '../presentation/ocr_processing/ocr_processing.dart';
import '../presentation/report_analysis_results/report_analysis_results.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/user_profile_settings/user_profile_settings.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String cameraPermissions = '/camera-permissions';
  static const String biometricAuthentication = '/biometric-authentication';
  static const String healthDashboard = '/health-dashboard';
  static const String documentScanner = '/document-scanner';
  static const String ocrProcessing = '/ocr-processing';
  static const String userProfileSettings = '/user-profile-settings';
  static const String healthProfileSetup = '/health-profile-setup';
  static const String reportAnalysisResults = '/report-analysis-results';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    cameraPermissions: (context) => const CameraPermissionsScreen(),
    biometricAuthentication: (context) => const BiometricAuthentication(),
    healthDashboard: (context) => const HealthDashboard(),
    documentScanner: (context) => const DocumentScanner(),
    ocrProcessing: (context) => const OCRProcessingScreen(),
    userProfileSettings: (context) => const UserProfileSettings(),
    healthProfileSetup: (context) => const HealthProfileSetup(),
    reportAnalysisResults: (context) => const ReportAnalysisResults(),
    // TODO: Add your other routes here
  };
}
