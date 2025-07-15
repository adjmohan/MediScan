import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HealthChartWidget extends StatelessWidget {
  final String title;
  final double value;
  final String unit;
  final String normalRange;
  final List<double> data;
  final bool isElevated;

  const HealthChartWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.unit,
    required this.normalRange,
    required this.data,
    required this.isElevated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          Text(
                            '$value $unit',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isElevated
                                  ? Color(0xFFEF4444)
                                  : Color(0xFF10B981),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          CustomIconWidget(
                            iconName:
                                isElevated ? 'trending_up' : 'trending_down',
                            color: isElevated
                                ? Color(0xFFEF4444)
                                : Color(0xFF10B981),
                            size: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: isElevated
                        ? Color(0xFFEF4444).withValues(alpha: 0.1)
                        : Color(0xFF10B981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isElevated ? 'HIGH' : 'NORMAL',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: isElevated ? Color(0xFFEF4444) : Color(0xFF10B981),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              height: 12.h,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value);
                      }).toList(),
                      isCurved: true,
                      color: isElevated ? Color(0xFFEF4444) : Color(0xFF10B981),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: isElevated
                                ? Color(0xFFEF4444)
                                : Color(0xFF10B981),
                            strokeWidth: 2,
                            strokeColor: AppTheme.lightTheme.cardColor,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color:
                            (isElevated ? Color(0xFFEF4444) : Color(0xFF10B981))
                                .withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                  minX: 0,
                  maxX: (data.length - 1).toDouble(),
                  minY: data.reduce((a, b) => a < b ? a : b) * 0.9,
                  maxY: data.reduce((a, b) => a > b ? a : b) * 1.1,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info_outline',
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                    size: 14,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Normal range: $normalRange $unit',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
