import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DocumentPreviewWidget extends StatefulWidget {
  final String imagePath;
  final List<Offset> detectedCorners;
  final VoidCallback onRetake;
  final VoidCallback onUsePhoto;

  const DocumentPreviewWidget({
    Key? key,
    required this.imagePath,
    required this.detectedCorners,
    required this.onRetake,
    required this.onUsePhoto,
  }) : super(key: key);

  @override
  State<DocumentPreviewWidget> createState() => _DocumentPreviewWidgetState();
}

class _DocumentPreviewWidgetState extends State<DocumentPreviewWidget> {
  List<Offset> _adjustableCorners = [];
  int? _selectedCornerIndex;

  @override
  void initState() {
    super.initState();
    _adjustableCorners = List.from(widget.detectedCorners);
  }

  void _onCornerDrag(int index, Offset delta, Size imageSize) {
    setState(() {
      final Offset currentCorner = _adjustableCorners[index];
      final Offset newCorner = Offset(
        (currentCorner.dx + delta.dx / imageSize.width).clamp(0.0, 1.0),
        (currentCorner.dy + delta.dy / imageSize.height).clamp(0.0, 1.0),
      );
      _adjustableCorners[index] = newCorner;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      color: Colors.black,
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 2.h,
              left: 4.w,
              right: 4.w,
              bottom: 2.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Adjust Crop',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onRetake,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'refresh',
                          color: Colors.white,
                          size: 4.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Retake',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Image Preview with Crop Handles
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      // Document Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomImageWidget(
                          imageUrl: widget.imagePath,
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          fit: BoxFit.contain,
                        ),
                      ),

                      // Crop Overlay
                      CustomPaint(
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        painter: CropOverlayPainter(
                          corners: _adjustableCorners,
                          selectedCornerIndex: _selectedCornerIndex,
                        ),
                      ),

                      // Corner Handles
                      ..._buildCornerHandles(constraints),
                    ],
                  );
                },
              ),
            ),
          ),

          // Instructions
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Text(
              'Drag the corners to adjust the document boundaries',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Bottom Controls
          Container(
            padding: EdgeInsets.only(
              left: 4.w,
              right: 4.w,
              bottom: MediaQuery.of(context).padding.bottom + 2.h,
            ),
            child: Row(
              children: [
                // Retake Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onRetake,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'camera_alt',
                          color: Colors.white,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Retake',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 4.w),

                // Use Photo Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onUsePhoto,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'check',
                          color: Colors.white,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Use Photo',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCornerHandles(BoxConstraints constraints) {
    return _adjustableCorners.asMap().entries.map((entry) {
      final int index = entry.key;
      final Offset corner = entry.value;

      return Positioned(
        left: corner.dx * constraints.maxWidth - 6.w,
        top: corner.dy * constraints.maxHeight - 6.w,
        child: GestureDetector(
          onPanStart: (_) {
            setState(() {
              _selectedCornerIndex = index;
            });
          },
          onPanUpdate: (details) {
            _onCornerDrag(index, details.delta,
                Size(constraints.maxWidth, constraints.maxHeight));
          },
          onPanEnd: (_) {
            setState(() {
              _selectedCornerIndex = null;
            });
          },
          child: Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: _selectedCornerIndex == index
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.tertiary,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 4.w,
                height: 4.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}

class CropOverlayPainter extends CustomPainter {
  final List<Offset> corners;
  final int? selectedCornerIndex;

  CropOverlayPainter({
    required this.corners,
    this.selectedCornerIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (corners.length != 4) return;

    final Paint overlayPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw overlay
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), overlayPaint);

    // Create document path
    final Path documentPath = Path();
    final List<Offset> scaledCorners = corners.map((corner) {
      return Offset(
        corner.dx * size.width,
        corner.dy * size.height,
      );
    }).toList();

    documentPath.moveTo(scaledCorners[0].dx, scaledCorners[0].dy);
    for (int i = 1; i < scaledCorners.length; i++) {
      documentPath.lineTo(scaledCorners[i].dx, scaledCorners[i].dy);
    }
    documentPath.close();

    // Clear document area
    final Paint clearPaint = Paint()..blendMode = BlendMode.clear;
    canvas.drawPath(documentPath, clearPaint);

    // Draw border
    canvas.drawPath(documentPath, borderPaint);

    // Draw grid lines
    final Paint gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Horizontal grid lines
    for (int i = 1; i < 3; i++) {
      final double y = size.height * i / 3;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Vertical grid lines
    for (int i = 1; i < 3; i++) {
      final double x = size.width * i / 3;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CropOverlayPainter oldDelegate) {
    return oldDelegate.corners != corners ||
        oldDelegate.selectedCornerIndex != selectedCornerIndex;
  }
}
