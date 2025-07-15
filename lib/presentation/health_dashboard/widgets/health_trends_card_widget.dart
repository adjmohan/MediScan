import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HealthTrendsCardWidget extends StatelessWidget {
  final List<Map<String, dynamic>> trends;
  final VoidCallback? onViewDetails;

  const HealthTrendsCardWidget({
    Key? key,
    required this.trends,
    this.onViewDetails,
  }) : super(key: key);

  Color _getTrendColor(String trend) {
    switch (trend.toLowerCase()) {
      case 'up':
        return AppTheme.lightTheme.colorScheme.error;
      case 'down':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'stable':
        return const Color(0xFFF59E0B);
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getTrendIcon(String trend) {
    switch (trend.toLowerCase()) {
      case 'up':
        return 'trending_up';
      case 'down':
        return 'trending_down';
      case 'stable':
        return 'trending_flat';
      default:
        return 'trending_flat';
    }
  }

  Widget _buildTrendItem(Map<String, dynamic> trend) {
    final List<double> data = (trend["data"] as List).cast<double>();

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          // Metric Info
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trend["metric"] as String,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  trend["current"] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: _getTrendIcon(trend["trend"] as String),
                      size: 16,
                      color: _getTrendColor(trend["trend"] as String),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      (trend["trend"] as String).toUpperCase(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: _getTrendColor(trend["trend"] as String),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Mini Chart
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 8.h,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value);
                      }).toList(),
                      isCurved: true,
                      color: _getTrendColor(trend["trend"] as String),
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: _getTrendColor(trend["trend"] as String)
                            .withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                  minX: 0,
                  maxX: (data.length - 1).toDouble(),
                  minY: data.reduce((a, b) => a < b ? a : b) * 0.95,
                  maxY: data.reduce((a, b) => a > b ? a : b) * 1.05,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Health Trends",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: onViewDetails,
                child: Text("View Details"),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Trends List
          ...trends.take(3).map((trend) => _buildTrendItem(trend)).toList(),
        ],
      ),
    );
  }
}
