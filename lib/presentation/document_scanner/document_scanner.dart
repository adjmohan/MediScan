import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/health_analysis_service.dart';
import './widgets/camera_overlay_widget.dart';
import './widgets/capture_controls_widget.dart';
import './widgets/document_preview_widget.dart';

class DocumentScanner extends StatefulWidget {
  const DocumentScanner({Key? key}) : super(key: key);

  @override
  State<DocumentScanner> createState() => _DocumentScannerState();
}

class _DocumentScannerState extends State<DocumentScanner>
    with TickerProviderStateMixin {
  bool _isFlashOn = false;
  bool _isCapturing = false;
  bool _showPreview = false;
  bool _documentDetected = false;
  bool _isProcessing = false;
  String? _capturedImagePath;
  Uint8List? _capturedImageBytes;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  final HealthAnalysisService _healthService = HealthAnalysisService();

  // Mock document detection coordinates
  final List<Offset> _detectedCorners = [
    const Offset(0.1, 0.2),
    const Offset(0.9, 0.2),
    const Offset(0.9, 0.8),
    const Offset(0.1, 0.8),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _simulateDocumentDetection();
  }

  void _initializeAnimations() {
    _pulseController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _fadeController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);

    _pulseController.repeat(reverse: true);
    _fadeController.forward();
  }

  void _simulateDocumentDetection() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _documentDetected = true;
        });
      }
    });
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    HapticFeedback.lightImpact();
  }

  void _captureDocument() async {
    if (_isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    HapticFeedback.mediumImpact();

    // Simulate capture delay
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isCapturing = false;
      _showPreview = true;
      _capturedImagePath =
          'https://images.unsplash.com/photo-1584515933487-779824d29309?fm=jpg&q=60&w=3000';
    });
  }

  void _retakePhoto() {
    setState(() {
      _showPreview = false;
      _capturedImagePath = null;
      _capturedImageBytes = null;
    });
    HapticFeedback.lightImpact();
  }

  void _usePhoto() async {
    if (_capturedImagePath == null && _capturedImageBytes == null) return;

    setState(() {
      _isProcessing = true;
    });

    HapticFeedback.mediumImpact();

    try {
      // Extract text from the captured image using OpenAI Vision
      final extractedText = await _healthService.extractTextFromImage(
          imageUrl: _capturedImagePath, imageBytes: _capturedImageBytes);

      // Analyze the extracted text
      final analysisResult =
          await _healthService.analyzeHealthReport(extractedText);

      // Navigate to results with the analysis
      Navigator.pushNamed(context, '/report-analysis-results', arguments: {
        'extractedText': extractedText,
        'analysisResult': analysisResult,
        'imageUrl': _capturedImagePath,
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Analysis failed: $e')));
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _openGallery() {
    HapticFeedback.lightImpact();
    // Simulate gallery selection
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildGalleryBottomSheet());
  }

  void _selectFromGallery() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();

        setState(() {
          _capturedImageBytes = imageBytes;
          _showPreview = true;
          _capturedImagePath = null; // Clear URL since we're using bytes
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to select image: $e')));
    }
  }

  Widget _buildGalleryBottomSheet() {
    return Container(
        height: 25.h,
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(children: [
          Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 1.h),
              decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2))),
          Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(children: [
                Text('Select Document',
                    style: AppTheme.lightTheme.textTheme.titleLarge),
                SizedBox(height: 3.h),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildGalleryOption(
                          icon: 'photo_library',
                          label: 'Gallery',
                          onTap: () {
                            Navigator.pop(context);
                            _selectFromGallery();
                          }),
                      _buildGalleryOption(
                          icon: 'picture_as_pdf',
                          label: 'PDF',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                                context, '/report-analysis-results');
                          }),
                      _buildGalleryOption(
                          icon: 'file_present',
                          label: 'Files',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                                context, '/report-analysis-results');
                          }),
                    ]),
              ])),
        ]));
  }

  Widget _buildGalleryOption({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16)),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CustomIconWidget(
                  iconName: icon,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 8.w),
              SizedBox(height: 1.h),
              Text(label,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary)),
            ])));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          // Camera Preview Background
          Container(
              width: 100.w,
              height: 100.h,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color(0xFF1a1a1a),
                    Color(0xFF000000),
                  ])),
              child: CustomImageWidget(
                  imageUrl:
                      'https://images.pexels.com/photos/4386466/pexels-photo-4386466.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                  width: 100.w,
                  height: 100.h,
                  fit: BoxFit.cover)),

          // Document Detection Overlay
          if (!_showPreview)
            CameraOverlayWidget(
                documentDetected: _documentDetected,
                detectedCorners: _detectedCorners,
                pulseAnimation: _pulseAnimation),

          // Document Preview
          if (_showPreview &&
              (_capturedImagePath != null || _capturedImageBytes != null))
            DocumentPreviewWidget(
                imagePath: _capturedImagePath ?? '',
                detectedCorners: _detectedCorners,
                onRetake: _retakePhoto,
                onUsePhoto: _usePhoto),

          // Top Controls
          if (!_showPreview)
            Positioned(
                top: MediaQuery.of(context).padding.top + 2.h,
                left: 4.w,
                right: 4.w,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Close Button
                      GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                              width: 12.w,
                              height: 12.w,
                              decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle),
                              child: CustomIconWidget(
                                  iconName: 'close',
                                  color: Colors.white,
                                  size: 6.w))),

                      // Flash Toggle
                      GestureDetector(
                          onTap: _toggleFlash,
                          child: Container(
                              width: 12.w,
                              height: 12.w,
                              decoration: BoxDecoration(
                                  color: _isFlashOn
                                      ? AppTheme.lightTheme.colorScheme.primary
                                          .withValues(alpha: 0.8)
                                      : Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle),
                              child: CustomIconWidget(
                                  iconName:
                                      _isFlashOn ? 'flash_on' : 'flash_off',
                                  color: Colors.white,
                                  size: 6.w))),
                    ])),

          // Guidance Text
          if (!_showPreview)
            Positioned(
                top: 25.h,
                left: 4.w,
                right: 4.w,
                child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 2.h),
                        decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(children: [
                          Text(
                              _documentDetected
                                  ? 'Document Detected'
                                  : 'Position document in frame',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(color: Colors.white),
                              textAlign: TextAlign.center),
                          if (!_documentDetected) ...[
                            SizedBox(height: 1.h),
                            Text('Align all corners within the frame',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(color: Colors.white70),
                                textAlign: TextAlign.center),
                          ],
                        ])))),

          // Bottom Controls
          if (!_showPreview)
            CaptureControlsWidget(
                isCapturing: _isCapturing,
                documentDetected: _documentDetected,
                onCapture: _captureDocument,
                onOpenGallery: _openGallery),

          // Loading Overlay
          if (_isCapturing)
            Container(
                width: 100.w,
                height: 100.h,
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      SizedBox(
                          width: 15.w,
                          height: 15.w,
                          child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.primary))),
                      SizedBox(height: 3.h),
                      Text('Capturing Document...',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(color: Colors.white)),
                    ]))),

          // Processing Overlay
          if (_isProcessing)
            Container(
                width: 100.w,
                height: 100.h,
                color: Colors.black.withValues(alpha: 0.7),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      SizedBox(
                          width: 15.w,
                          height: 15.w,
                          child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.primary))),
                      SizedBox(height: 3.h),
                      Text('AI is analyzing your document...',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(color: Colors.white)),
                      SizedBox(height: 1.h),
                      Text('Extracting text and generating insights',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70)),
                    ]))),
        ]));
  }
}
