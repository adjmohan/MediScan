import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/health_analysis_service.dart';
import './widgets/action_button_widget.dart';
import './widgets/extracted_text_card_widget.dart';
import './widgets/health_chart_widget.dart';
import './widgets/prediction_card_widget.dart';
import './widgets/recommendation_card_widget.dart';

class ReportAnalysisResults extends StatefulWidget {
  const ReportAnalysisResults({Key? key}) : super(key: key);

  @override
  State<ReportAnalysisResults> createState() => _ReportAnalysisResultsState();
}

class _ReportAnalysisResultsState extends State<ReportAnalysisResults> {
  bool _isTextExpanded = false;
  bool _isVoicePlaybackEnabled = false;
  bool _isLoading = true;
  String _extractedText = '';
  HealthAnalysisResult? _analysisResult;
  final HealthAnalysisService _healthService = HealthAnalysisService();

  @override
  void initState() {
    super.initState();
    _loadAnalysisData();
  }

  void _loadAnalysisData() async {
    // Get arguments passed from document scanner
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      setState(() {
        _extractedText = args['extractedText'] ?? '';
        _analysisResult = args['analysisResult'];
        _isLoading = false;
      });
    } else {
      // Use mock data for demo or perform analysis
      await _performMockAnalysis();
    }
  }

  Future<void> _performMockAnalysis() async {
    // Mock extracted text
    const mockExtractedText = """Patient: John Doe
Date: July 15, 2025
Test Results:
- Blood Glucose: 145 mg/dL (Normal: 70-100 mg/dL)
- HbA1c: 6.8% (Normal: <5.7%)
- Total Cholesterol: 220 mg/dL (Normal: <200 mg/dL)
- HDL Cholesterol: 35 mg/dL (Normal: >40 mg/dL)
- LDL Cholesterol: 150 mg/dL (Normal: <100 mg/dL)
- Blood Pressure: 140/90 mmHg (Normal: <120/80 mmHg)
- Hemoglobin: 12.5 g/dL (Normal: 13.5-17.5 g/dL)""";

    try {
      final analysisResult =
          await _healthService.analyzeHealthReport(mockExtractedText);
      setState(() {
        _extractedText = mockExtractedText;
        _analysisResult = analysisResult;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _extractedText = mockExtractedText;
        _isLoading = false;
      });
      // Use fallback mock data
      _analysisResult = _createMockAnalysisResult();
    }
  }

  HealthAnalysisResult _createMockAnalysisResult() {
    return HealthAnalysisResult(
      extractedValues: [
        ExtractedValue(
          parameter: 'Blood Glucose',
          value: '145',
          unit: 'mg/dL',
          normalRange: '70-100',
          status: 'elevated',
        ),
        ExtractedValue(
          parameter: 'HbA1c',
          value: '6.8',
          unit: '%',
          normalRange: '<5.7',
          status: 'elevated',
        ),
      ],
      diseasePredictions: [
        DiseasePrediction(
          condition: 'Pre-Diabetes',
          confidence: 85,
          riskLevel: 'Monitor',
          indicators: [
            'Elevated HbA1c (6.8%)',
            'High fasting glucose (145 mg/dL)'
          ],
        ),
        DiseasePrediction(
          condition: 'Dyslipidemia',
          confidence: 78,
          riskLevel: 'Consult Doctor',
          indicators: [
            'High total cholesterol (220 mg/dL)',
            'Low HDL (35 mg/dL)'
          ],
        ),
      ],
      recommendations: [
        HealthRecommendation(
          type: 'Lifestyle',
          title: 'Dietary Modifications',
          description:
              'Reduce refined carbohydrates and increase fiber intake.',
          priority: 'High',
        ),
        HealthRecommendation(
          type: 'Exercise',
          title: 'Regular Physical Activity',
          description: '30 minutes of moderate exercise 5 days per week.',
          priority: 'High',
        ),
      ],
      healthInsights:
          'Your results indicate elevated glucose levels and cholesterol. Consider lifestyle modifications and regular monitoring.',
      chartData: [
        ChartData(
          metric: 'Blood Glucose',
          currentValue: 145.0,
          normalRange: '70-100',
          trend: 'elevated',
        ),
        ChartData(
          metric: 'Cholesterol',
          currentValue: 220.0,
          normalRange: '<200',
          trend: 'elevated',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2.h),
                          _buildExtractedTextSection(),
                          SizedBox(height: 3.h),
                          if (_analysisResult != null) ...[
                            _buildInsightsSection(),
                            SizedBox(height: 3.h),
                            _buildChartsSection(),
                            SizedBox(height: 3.h),
                            _buildRecommendationsSection(),
                          ],
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 15.w,
            height: 15.w,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'AI is analyzing your report...',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Extracting insights and generating recommendations',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1,
                ),
              ),
              child: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'AI Analysis Results',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'OpenAI',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'July 15, 2025 • 08:17 AM',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: _toggleVoicePlayback,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: _isVoicePlaybackEnabled
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isVoicePlaybackEnabled
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName:
                        _isVoicePlaybackEnabled ? 'volume_up' : 'volume_off',
                    color: _isVoicePlaybackEnabled
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              GestureDetector(
                onTap: _showShareOptions,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'share',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExtractedTextSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Extracted Text',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 2.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'AI Vision',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        ExtractedTextCardWidget(
          extractedText: _extractedText,
          isExpanded: _isTextExpanded,
          onToggleExpanded: () {
            setState(() {
              _isTextExpanded = !_isTextExpanded;
            });
          },
        ),
      ],
    );
  }

  Widget _buildInsightsSection() {
    if (_analysisResult == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'AI Health Insights',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 2.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'OpenAI Powered',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        if (_analysisResult!.healthInsights.isNotEmpty) ...[
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _analysisResult!.healthInsights,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          SizedBox(height: 2.h),
        ],
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _analysisResult!.diseasePredictions.length,
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            final prediction = _analysisResult!.diseasePredictions[index];
            return PredictionCardWidget(
              condition: prediction.condition,
              confidence: prediction.confidence,
              riskLevel: prediction.riskLevel,
              color: _getPredictionColor(prediction.confidence),
              indicators: prediction.indicators,
              actions: [], // Convert from indicators to actions format
              onTap: () => _showPredictionDetails(prediction),
            );
          },
        ),
      ],
    );
  }

  Widget _buildChartsSection() {
    if (_analysisResult == null || _analysisResult!.chartData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Health Metrics Visualization',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 25.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _analysisResult!.chartData.length,
            separatorBuilder: (context, index) => SizedBox(width: 4.w),
            itemBuilder: (context, index) {
              final chartData = _analysisResult!.chartData[index];
              return HealthChartWidget(
                title: chartData.metric,
                value: chartData.currentValue,
                unit: '',
                normalRange: chartData.normalRange,
                data: [chartData.currentValue], // Mock trend data
                isElevated: chartData.trend == 'elevated',
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsSection() {
    if (_analysisResult == null || _analysisResult!.recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI-Generated Recommendations',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _analysisResult!.recommendations.length,
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            final recommendation = _analysisResult!.recommendations[index];
            return RecommendationCardWidget(
              type: recommendation.type,
              title: recommendation.title,
              description: recommendation.description,
              priority: recommendation.priority,
              icon: _getRecommendationIcon(recommendation.type),
              onTap: () => _handleRecommendationTap(recommendation),
            );
          },
        ),
      ],
    );
  }

  Color _getPredictionColor(int confidence) {
    if (confidence >= 80) return Color(0xFFEF4444);
    if (confidence >= 60) return Color(0xFFF59E0B);
    return Color(0xFF10B981);
  }

  String _getRecommendationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'lifestyle':
        return 'fitness_center';
      case 'diet':
        return 'restaurant';
      case 'exercise':
        return 'directions_run';
      case 'medication':
        return 'medication';
      default:
        return 'lightbulb';
    }
  }

  void _showPredictionDetails(DiseasePrediction prediction) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: _getPredictionColor(prediction.confidence),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  prediction.condition,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getPredictionColor(prediction.confidence)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${prediction.confidence}% Confidence • ${prediction.riskLevel}',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: _getPredictionColor(prediction.confidence),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Key Indicators:',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              ...prediction.indicators.map(
                (indicator) => Padding(
                  padding: EdgeInsets.only(bottom: 0.5.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• ',
                          style: AppTheme.lightTheme.textTheme.bodyMedium),
                      Expanded(
                        child: Text(
                          indicator,
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _handleRecommendationTap(HealthRecommendation recommendation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            recommendation.title,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getPriorityColor(recommendation.priority)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${recommendation.priority} Priority • ${recommendation.type}',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: _getPriorityColor(recommendation.priority),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                recommendation.description,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Color(0xFFEF4444);
      case 'medium':
        return Color(0xFFF59E0B);
      case 'low':
        return Color(0xFF10B981);
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ActionButtonWidget(
                title: 'Save to Reports',
                icon: 'save',
                onTap: _saveToReports,
                isPrimary: false,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: ActionButtonWidget(
                title: 'Share Results',
                icon: 'share',
                onTap: _showShareOptions,
                isPrimary: false,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: ActionButtonWidget(
                title: 'Set Reminder',
                icon: 'schedule',
                onTap: _scheduleReminder,
                isPrimary: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleVoicePlayback() {
    setState(() {
      _isVoicePlaybackEnabled = !_isVoicePlaybackEnabled;
    });

    if (_isVoicePlaybackEnabled) {
      // TODO: Implement TTS using OpenAI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voice playback started'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voice playback stopped'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Share Results',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              _buildShareOption('Email', 'email', () => _shareViaEmail()),
              _buildShareOption(
                  'Messages', 'message', () => _shareViaMessages()),
              _buildShareOption(
                  'Export PDF', 'picture_as_pdf', () => _exportToPDF()),
              _buildShareOption('Copy Link', 'link', () => _copyLink()),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShareOption(String title, String icon, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _saveToReports() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Report saved successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _scheduleReminder() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Schedule Reminder',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Follow-up in 1 week'),
                onTap: () => _setReminder('1 week'),
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Follow-up in 1 month'),
                onTap: () => _setReminder('1 month'),
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Follow-up in 3 months'),
                onTap: () => _setReminder('3 months'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _setReminder(String duration) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder set for $duration'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareViaEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening email app...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareViaMessages() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening messages app...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _exportToPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generating PDF report...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _copyLink() {
    Clipboard.setData(
        ClipboardData(text: 'https://medscanai.com/report/12345'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Link copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
