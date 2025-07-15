import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/health_analysis_service.dart';
import './widgets/processing_animation_widget.dart';
import './widgets/processing_stage_widget.dart';
import './widgets/progress_indicator_widget.dart';

class OCRProcessingScreen extends StatefulWidget {
  const OCRProcessingScreen({Key? key}) : super(key: key);

  @override
  State<OCRProcessingScreen> createState() => _OCRProcessingScreenState();
}

class _OCRProcessingScreenState extends State<OCRProcessingScreen>
    with TickerProviderStateMixin {
  final HealthAnalysisService _healthService = HealthAnalysisService();

  // Processing states
  ProcessingStage _currentStage = ProcessingStage.scanning;
  double _progressValue = 0.0;
  int _estimatedTimeRemaining = 30;
  bool _isProcessing = true;
  bool _hasError = false;
  String? _errorMessage;

  // Document data
  String? _documentImageUrl;
  Uint8List? _documentImageBytes;
  String? _documentType;

  // Animation controllers
  late AnimationController _scanController;
  late AnimationController _pulseController;
  late AnimationController _celebrationController;

  // Animations
  late Animation<double> _scanAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _celebrationAnimation;

  // Timer for progress updates
  Timer? _progressTimer;
  Timer? _timeTimer;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startProcessing();
  }

  void _initializeAnimations() {
    _scanController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);

    _pulseController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);

    _celebrationController = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _scanController, curve: Curves.easeInOut));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _celebrationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _celebrationController, curve: Curves.elasticOut));

    _scanController.repeat();
    _pulseController.repeat(reverse: true);
  }

  void _startProcessing() {
    // Get document data from arguments
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _documentImageUrl = args['imageUrl'] as String?;
      _documentImageBytes = args['imageBytes'] as Uint8List?;
      _documentType = args['documentType'] as String? ?? 'health_report';
    }

    _processDocument();
  }

  Future<void> _processDocument() async {
    try {
      // Stage 1: Scanning Document
      _updateStage(ProcessingStage.scanning, 0.0, 25);
      await _simulateStageProgress(0.0, 0.25, 6000);

      // Stage 2: Extracting Text
      _updateStage(ProcessingStage.extractingText, 0.25, 20);
      await _simulateStageProgress(0.25, 0.65, 8000);

      // Actual OCR processing
      final extractedText = await _performOCRExtraction();

      // Stage 3: Analyzing Content
      _updateStage(ProcessingStage.analyzingContent, 0.65, 15);
      await _simulateStageProgress(0.65, 0.90, 6000);

      // Actual AI analysis
      final analysisResult = await _performAIAnalysis(extractedText);

      // Stage 4: Generating Insights
      _updateStage(ProcessingStage.generatingInsights, 0.90, 10);
      await _simulateStageProgress(0.90, 1.0, 4000);

      // Success completion
      _completeProcessing(extractedText, analysisResult);
    } catch (e) {
      _handleError(e.toString());
    }
  }

  Future<String> _performOCRExtraction() async {
    try {
      final extractedText = await _healthService.extractTextFromImage(
          imageUrl: _documentImageUrl, imageBytes: _documentImageBytes);
      return extractedText;
    } catch (e) {
      throw Exception('OCR extraction failed: $e');
    }
  }

  Future<dynamic> _performAIAnalysis(String extractedText) async {
    try {
      final analysisResult =
          await _healthService.analyzeHealthReport(extractedText);
      return analysisResult;
    } catch (e) {
      throw Exception('AI analysis failed: $e');
    }
  }

  Future<void> _simulateStageProgress(
      double startValue, double endValue, int durationMs) async {
    final steps = 20;
    final stepDuration = Duration(milliseconds: durationMs ~/ steps);
    final stepIncrement = (endValue - startValue) / steps;

    for (int i = 0; i < steps; i++) {
      if (!_isProcessing) break;

      await Future.delayed(stepDuration);

      if (mounted) {
        setState(() {
          _progressValue = startValue + (stepIncrement * (i + 1));
        });
      }
    }
  }

  void _updateStage(ProcessingStage stage, double progress, int timeRemaining) {
    if (mounted) {
      setState(() {
        _currentStage = stage;
        _progressValue = progress;
        _estimatedTimeRemaining = timeRemaining;
      });
    }

    // Start countdown timer
    _timeTimer?.cancel();
    _timeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_estimatedTimeRemaining > 0) {
        setState(() {
          _estimatedTimeRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _completeProcessing(String extractedText, dynamic analysisResult) {
    if (mounted) {
      setState(() {
        _isProcessing = false;
        _progressValue = 1.0;
        _estimatedTimeRemaining = 0;
      });
    }

    // Play celebration animation
    _celebrationController.forward();
    HapticFeedback.vibrate();

    // Navigate to results after celebration
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/report-analysis-results',
            arguments: {
              'extractedText': extractedText,
              'analysisResult': analysisResult,
              'imageUrl': _documentImageUrl,
              'imageBytes': _documentImageBytes,
            });
      }
    });
  }

  void _handleError(String error) {
    if (mounted) {
      setState(() {
        _isProcessing = false;
        _hasError = true;
        _errorMessage = error;
      });
    }

    HapticFeedback.vibrate();
    _scanController.stop();
    _pulseController.stop();
  }

  void _retryProcessing() {
    setState(() {
      _isProcessing = true;
      _hasError = false;
      _errorMessage = null;
      _currentStage = ProcessingStage.scanning;
      _progressValue = 0.0;
      _estimatedTimeRemaining = 30;
    });

    _scanController.repeat();
    _pulseController.repeat(reverse: true);
    _processDocument();
  }

  void _cancelProcessing() {
    HapticFeedback.lightImpact();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Cancel Processing?'),
                content: Text(
                    'Are you sure you want to cancel? You will lose any partial results.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Continue')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Go back to scanner
                      },
                      child: Text('Cancel')),
                ]));
  }

  String _getStageDescription(ProcessingStage stage) {
    switch (stage) {
      case ProcessingStage.scanning:
        return 'Scanning Document';
      case ProcessingStage.extractingText:
        return 'Extracting Text';
      case ProcessingStage.analyzingContent:
        return 'Analyzing Content';
      case ProcessingStage.generatingInsights:
        return 'Generating Insights';
    }
  }

  String _getStageDetailText(ProcessingStage stage) {
    switch (stage) {
      case ProcessingStage.scanning:
        return 'Preparing document for analysis...';
      case ProcessingStage.extractingText:
        return 'Reading text from your document...';
      case ProcessingStage.analyzingContent:
        return 'Understanding medical information...';
      case ProcessingStage.generatingInsights:
        return 'Creating personalized insights...';
    }
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    _celebrationController.dispose();
    _progressTimer?.cancel();
    _timeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.black.withAlpha(230),
                  Colors.black,
                ])),
            child: Stack(children: [
              // Blurred document preview background
              if (_documentImageUrl != null || _documentImageBytes != null)
                Positioned.fill(
                    child: Container(
                        decoration: BoxDecoration(),
                        child: _documentImageBytes != null
                            ? Image.memory(_documentImageBytes!,
                                fit: BoxFit.cover,
                                color: Colors.black.withAlpha(77))
                            : CustomImageWidget(
                                imageUrl: _documentImageUrl!,
                                fit: BoxFit.cover))),

              // Main content
              SafeArea(
                  child: Column(children: [
                // Cancel button
                Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (_isProcessing)
                            GestureDetector(
                                onTap: _cancelProcessing,
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                        color: Colors.black.withAlpha(128),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Colors.white.withAlpha(77),
                                            width: 1)),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomIconWidget(
                                              iconName: 'close',
                                              color: Colors.white,
                                              size: 5.w),
                                          SizedBox(width: 2.w),
                                          Text('Cancel',
                                              style: AppTheme.lightTheme
                                                  .textTheme.bodyMedium
                                                  ?.copyWith(
                                                      color: Colors.white)),
                                        ]))),
                        ])),

                // Processing content
                Expanded(
                    child: _hasError
                        ? _buildErrorContent()
                        : _buildProcessingContent()),
              ])),
            ])));
  }

  Widget _buildProcessingContent() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      // Processing animation
      ProcessingAnimationWidget(
          scanAnimation: _scanAnimation,
          pulseAnimation: _pulseAnimation,
          celebrationAnimation: _celebrationAnimation,
          isCompleted: !_isProcessing && !_hasError),

      SizedBox(height: 6.h),

      // Progress indicator
      ProcessingProgressIndicator(
          progress: _progressValue, stage: _currentStage),

      SizedBox(height: 4.h),

      // Stage information
      ProcessingStageWidget(
          stage: _currentStage,
          stageDescription: _getStageDescription(_currentStage),
          stageDetailText: _getStageDetailText(_currentStage),
          estimatedTimeRemaining: _estimatedTimeRemaining,
          isProcessing: _isProcessing),
    ]);
  }

  Widget _buildErrorContent() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      // Error icon
      Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.error.withAlpha(26),
              shape: BoxShape.circle),
          child: CustomIconWidget(
              iconName: 'error',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 10.w)),

      SizedBox(height: 4.h),

      // Error title
      Text('Processing Failed',
          style: AppTheme.lightTheme.textTheme.headlineSmall
              ?.copyWith(color: Colors.white),
          textAlign: TextAlign.center),

      SizedBox(height: 2.h),

      // Error message
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(_getErrorMessage(),
              style: AppTheme.lightTheme.textTheme.bodyMedium
                  ?.copyWith(color: Colors.white70),
              textAlign: TextAlign.center)),

      SizedBox(height: 6.h),

      // Action buttons
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        // Retry button
        ElevatedButton.icon(
            onPressed: _retryProcessing,
            icon: CustomIconWidget(
                iconName: 'refresh', color: Colors.white, size: 5.w),
            label: Text('Retry'),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h))),

        SizedBox(width: 4.w),

        // Go back button
        OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
                iconName: 'arrow_back', color: Colors.white, size: 5.w),
            label: Text('Go Back'),
            style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withAlpha(128)),
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h))),
      ]),
    ]);
  }

  String _getErrorMessage() {
    if (_errorMessage?.contains('poor image quality') == true) {
      return 'The image quality is too poor to extract text. Please retake the photo with better lighting and focus.';
    } else if (_errorMessage?.contains('network') == true) {
      return 'Network connection issue. Please check your internet connection and try again.';
    } else if (_errorMessage?.contains('timeout') == true) {
      return 'Processing took too long. You can try uploading the document through alternative methods.';
    } else {
      return 'An unexpected error occurred during processing. Please try again or contact support if the problem persists.';
    }
  }
}

enum ProcessingStage {
  scanning,
  extractingText,
  analyzingContent,
  generatingInsights,
}