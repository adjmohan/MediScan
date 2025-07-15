import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/health_analysis_service.dart';
import '../../../theme/app_theme.dart';

class DiagnosisResultWidget extends StatelessWidget {
  final SymptomAnalysisResult result;
  final Function(SymptomRecommendation) onRecommendationTap;

  const DiagnosisResultWidget({
    Key? key,
    required this.result,
    required this.onRecommendationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analysis Results',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        _buildSeverityIndicator(),
        SizedBox(height: 2.h),
        _buildPotentialDiagnoses(),
        SizedBox(height: 2.h),
        _buildRecommendations(),
        SizedBox(height: 2.h),
        _buildSeekHelpSection(),
      ],
    );
  }

  Widget _buildSeverityIndicator() {
    Color severityColor;
    IconData severityIcon;
    String severityText;

    switch (result.severityLevel.toLowerCase()) {
      case 'mild':
        severityColor = Colors.green;
        severityIcon = Icons.check_circle;
        severityText = 'Mild';
        break;
      case 'moderate':
        severityColor = Colors.orange;
        severityIcon = Icons.warning;
        severityText = 'Moderate';
        break;
      case 'severe':
        severityColor = Colors.red;
        severityIcon = Icons.error;
        severityText = 'Severe';
        break;
      default:
        severityColor = Colors.grey;
        severityIcon = Icons.help;
        severityText = 'Unknown';
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: severityColor.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: severityColor),
      ),
      child: Row(
        children: [
          Icon(severityIcon, color: severityColor, size: 6.w),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Severity Level: $severityText',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: severityColor,
                  ),
                ),
                Text(
                  'Based on the symptoms you\'ve described',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPotentialDiagnoses() {
    if (result.potentialDiagnoses.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Potential Conditions',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        ...result.potentialDiagnoses.map((diagnosis) {
          return Container(
            margin: EdgeInsets.only(bottom: 2.h),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        diagnosis.condition,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: _getConfidenceColor(diagnosis.confidence)
                            .withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${diagnosis.confidence}%',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: _getConfidenceColor(diagnosis.confidence),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                LinearProgressIndicator(
                  value: diagnosis.matchPercentage / 100,
                  backgroundColor:
                      AppTheme.lightTheme.colorScheme.outline.withAlpha(77),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getConfidenceColor(diagnosis.confidence),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  diagnosis.description,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildRecommendations() {
    if (result.recommendations.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        ...result.recommendations.map((recommendation) {
          return GestureDetector(
            onTap: () => onRecommendationTap(recommendation),
            child: Container(
              margin: EdgeInsets.only(bottom: 1.h),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getRecommendationIcon(recommendation.type),
                      color: Colors.white,
                      size: 4.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendation.action,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (recommendation.description.isNotEmpty) ...[
                          SizedBox(height: 0.5.h),
                          Text(
                            recommendation.description,
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 3.w,
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withAlpha(128),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSeekHelpSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.medical_services, color: Colors.red, size: 5.w),
              SizedBox(width: 3.w),
              Text(
                'When to Seek Medical Help',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            result.whenToSeekHelp,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Color _getConfidenceColor(int confidence) {
    if (confidence >= 80) return Colors.green;
    if (confidence >= 60) return Colors.orange;
    return Colors.red;
  }

  IconData _getRecommendationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'immediate':
        return Icons.access_time;
      case 'lifestyle':
        return Icons.fitness_center;
      case 'medication':
        return Icons.medication;
      case 'diet':
        return Icons.restaurant;
      default:
        return Icons.info;
    }
  }
}
