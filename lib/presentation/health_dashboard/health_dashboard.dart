import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/health_score_indicator_widget.dart';
import './widgets/health_trends_card_widget.dart';
import './widgets/quick_actions_card_widget.dart';
import './widgets/recent_insights_card_widget.dart';

class HealthDashboard extends StatefulWidget {
  const HealthDashboard({Key? key}) : super(key: key);

  @override
  State<HealthDashboard> createState() => _HealthDashboardState();
}

class _HealthDashboardState extends State<HealthDashboard> {
  String _selectedTimeRange = 'This Week';
  final List<String> _timeRanges = ['This Week', 'This Month', 'This Year'];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: [
          _buildHeader(),
          _buildHealthScoreSection(),
          _buildQuickActionsSection(),
          _buildRecentInsightsSection(),
          _buildHealthTrendsSection(),
          SizedBox(height: 10.h),
        ]))));
  }

  Widget _buildHeader() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Good morning, John!',
                    style: AppTheme.lightTheme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
                SizedBox(height: 0.5.h),
                Row(children: [
                  Text('Your health insights are ready',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7))),
                  SizedBox(width: 1.w),
                  Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('AI Powered',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w500))),
                ]),
              ])),
          Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                CustomIconWidget(
                    iconName: 'psychology',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20),
                SizedBox(width: 2.w),
                Text('AI Health',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600)),
              ])),
        ]));
  }

  Widget _buildHealthScoreSection() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        child: HealthScoreIndicatorWidget(
          score: 75, // Adding required score parameter
        ));
  }

  Widget _buildQuickActionsSection() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: QuickActionsCardWidget(onScanReport: () {
          Navigator.pushNamed(context, '/document-scanner');
        }, onCheckSymptoms: () {
          Navigator.pushNamed(context, '/symptom-checker');
        }, onViewReports: () {
          Navigator.pushNamed(context, '/report-analysis-results');
        }, onBookAppointment: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Opening appointment booking...'),
              duration: Duration(seconds: 2)));
        }));
  }

  Widget _buildRecentInsightsSection() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: RecentInsightsCardWidget(
            insights: [
              {
                'title': 'Blood Sugar Alert',
                'description':
                    'Your glucose levels are slightly elevated (145 mg/dL). Consider reducing sugar intake.',
                'type': 'warning',
                'timestamp': '2 hours ago',
                'confidence': 85,
              },
              {
                'title': 'Cholesterol Update',
                'description':
                    'Total cholesterol at 220 mg/dL. AI recommends lifestyle changes.',
                'type': 'info',
                'timestamp': '1 day ago',
                'confidence': 78,
              },
              {
                'title': 'Exercise Reminder',
                'description':
                    'AI suggests 30 minutes of cardio based on your health profile.',
                'type': 'success',
                'timestamp': '3 days ago',
                'confidence': 92,
              },
            ],
            onViewAll: () {
              Navigator.pushNamed(context, '/report-analysis-results');
            }));
  }

  Widget _buildHealthTrendsSection() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Health Trends',
                style: AppTheme.lightTheme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline)),
                child: DropdownButton<String>(
                    value: _selectedTimeRange,
                    items: _timeRanges.map((String range) {
                      return DropdownMenuItem<String>(
                          value: range,
                          child: Text(range,
                              style: AppTheme.lightTheme.textTheme.bodySmall));
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedTimeRange = newValue;
                        });
                      }
                    },
                    underline: SizedBox.shrink(),
                    isDense: true)),
          ]),
          SizedBox(height: 2.h),
          HealthTrendsCardWidget(trends: [
            {
              'metric': 'Blood Glucose',
              'current': 145.0,
              'previous': 130.0,
              'unit': 'mg/dL',
              'trend': 'up',
              'data': [125.0, 130.0, 142.0, 145.0, 148.0, 145.0, 145.0],
            },
            {
              'metric': 'Blood Pressure',
              'current': 140.0,
              'previous': 135.0,
              'unit': 'mmHg',
              'trend': 'up',
              'data': [130.0, 135.0, 138.0, 140.0, 142.0, 140.0, 140.0],
            },
            {
              'metric': 'Cholesterol',
              'current': 220.0,
              'previous': 215.0,
              'unit': 'mg/dL',
              'trend': 'up',
              'data': [200.0, 210.0, 215.0, 220.0, 218.0, 220.0, 220.0],
            },
          ]),
        ]));
  }
}
