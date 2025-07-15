import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:ui' as ui;

class CameraOverlayWidget extends StatelessWidget {
  final bool documentDetected;
  final List<Offset> detectedCorners;
  final Animation<double> pulseAnimation;

  const CameraOverlayWidget({
    Key? key,
    required this.documentDetected,
    required this.detectedCorners,
    required this.pulseAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(100.w, 100.h),
      painter: DocumentOverlayPainter(
        documentDetected: documentDetected,
        detectedCorners: detectedCorners,
        pulseValue: pulseAnimation.value,
      ),
    );
  }
}

class DocumentOverlayPainter extends CustomPainter {
  final bool documentDetected;
  final List<Offset> detectedCorners;
  final double pulseValue;

  DocumentOverlayPainter({
    required this.documentDetected,
    required this.detectedCorners,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint overlayPaint = Paint()
      ..color = Colors.black.withAlpha(128)
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = documentDetected
          ? const Color(0xFF10B981)
          : Colors.white.withAlpha(204)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final Paint cornerPaint = Paint()
      ..color = documentDetected ? const Color(0xFF10B981) : Colors.white
      ..style = PaintingStyle.fill;

    // Draw semi-transparent overlay
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), overlayPaint);

    // Calculate document frame
    final double frameWidth = size.width * 0.8;
    final double frameHeight = size.height * 0.6;
    final double frameLeft = (size.width - frameWidth) / 2;
    final double frameTop = (size.height - frameHeight) / 2;

    final Rect documentFrame = Rect.fromLTWH(
      frameLeft,
      frameTop,
      frameWidth,
      frameHeight,
    );

    // Clear the document area
    final Paint clearPaint = Paint()..blendMode = BlendMode.clear;
    canvas.drawRect(documentFrame, clearPaint);

    if (documentDetected && detectedCorners.length == 4) {
      // Draw detected document outline
      final Path documentPath = Path();
      final List<Offset> scaledCorners = detectedCorners.map((corner) {
        return Offset(
          frameLeft + corner.dx * frameWidth,
          frameTop + corner.dy * frameHeight,
        );
      }).toList();

      documentPath.moveTo(scaledCorners[0].dx, scaledCorners[0].dy);
      for (int i = 1; i < scaledCorners.length; i++) {
        documentPath.lineTo(scaledCorners[i].dx, scaledCorners[i].dy);
      }
      documentPath.close();

      // Animate border width with pulse
      borderPaint.strokeWidth = 3.0 * pulseValue;
      canvas.drawPath(documentPath, borderPaint);

      // Draw corner indicators
      for (final corner in scaledCorners) {
        _drawCornerIndicator(canvas, corner, cornerPaint, pulseValue);
      }
    } else {
      // Draw guide frame
      final RRect guideFrame = RRect.fromRectAndRadius(
        documentFrame,
        const Radius.circular(12),
      );

      // Draw dashed border
      _drawDashedRect(canvas, guideFrame, borderPaint);

      // Draw corner guides
      _drawCornerGuides(canvas, documentFrame, cornerPaint);
    }
  }

  void _drawCornerIndicator(
      Canvas canvas, Offset center, Paint paint, double pulse) {
    final double radius = 8.0 * pulse;
    canvas.drawCircle(center, radius, paint);

    // Draw inner circle
    final Paint innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.4, innerPaint);
  }

  void _drawDashedRect(Canvas canvas, RRect rect, Paint paint) {
    const double dashWidth = 20.0;
    const double dashSpace = 10.0;

    final Path path = Path()..addRRect(rect);
    final ui.PathMetrics pathMetrics = path.computeMetrics();

    for (final ui.PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final double nextDistance = distance + dashWidth;
        final Path extractPath = pathMetric.extractPath(
          distance,
          nextDistance > pathMetric.length ? pathMetric.length : nextDistance,
        );
        canvas.drawPath(extractPath, paint);
        distance = nextDistance + dashSpace;
      }
    }
  }

  void _drawCornerGuides(Canvas canvas, Rect frame, Paint paint) {
    const double cornerSize = 30.0;
    const double cornerThickness = 4.0;

    final List<Offset> corners = [
      frame.topLeft,
      frame.topRight,
      frame.bottomRight,
      frame.bottomLeft,
    ];

    for (int i = 0; i < corners.length; i++) {
      final Offset corner = corners[i];
      final Paint cornerPaint = Paint()
        ..color = paint.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = cornerThickness
        ..strokeCap = StrokeCap.round;

      // Draw L-shaped corner guides
      final Path cornerPath = Path();

      switch (i) {
        case 0: // Top-left
          cornerPath.moveTo(corner.dx, corner.dy + cornerSize);
          cornerPath.lineTo(corner.dx, corner.dy);
          cornerPath.lineTo(corner.dx + cornerSize, corner.dy);
          break;
        case 1: // Top-right
          cornerPath.moveTo(corner.dx - cornerSize, corner.dy);
          cornerPath.lineTo(corner.dx, corner.dy);
          cornerPath.lineTo(corner.dx, corner.dy + cornerSize);
          break;
        case 2: // Bottom-right
          cornerPath.moveTo(corner.dx, corner.dy - cornerSize);
          cornerPath.lineTo(corner.dx, corner.dy);
          cornerPath.lineTo(corner.dx - cornerSize, corner.dy);
          break;
        case 3: // Bottom-left
          cornerPath.moveTo(corner.dx + cornerSize, corner.dy);
          cornerPath.lineTo(corner.dx, corner.dy);
          cornerPath.lineTo(corner.dx, corner.dy - cornerSize);
          break;
      }

      canvas.drawPath(cornerPath, cornerPaint);
    }
  }

  @override
  bool shouldRepaint(DocumentOverlayPainter oldDelegate) {
    return oldDelegate.documentDetected != documentDetected ||
        oldDelegate.pulseValue != pulseValue;
  }
}
