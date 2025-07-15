import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/health_analysis_service.dart';
import '../../theme/app_theme.dart';
import './widgets/diagnosis_result_widget.dart';
import './widgets/symptom_input_widget.dart';

class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({Key? key}) : super(key: key);

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  final TextEditingController _symptomController = TextEditingController();
  final List<String> _selectedSymptoms = [];
  bool _isAnalyzing = false;
  SymptomAnalysisResult? _analysisResult;
  final HealthAnalysisService _healthService = HealthAnalysisService();

  // Common symptoms for quick selection
  final List<String> _commonSymptoms = [
    'Headache',
    'Fever',
    'Fatigue',
    'Cough',
    'Sore throat',
    'Runny nose',
    'Nausea',
    'Dizziness',
    'Muscle pain',
    'Joint pain',
    'Chest pain',
    'Shortness of breath',
    'Stomach pain',
    'Diarrhea',
    'Constipation',
    'Loss of appetite',
    'Weight loss',
    'Skin rash',
    'Swelling',
    'Insomnia',
  ];

  void _addSymptom() {
    final symptom = _symptomController.text.trim();
    if (symptom.isNotEmpty && !_selectedSymptoms.contains(symptom)) {
      setState(() {
        _selectedSymptoms.add(symptom);
        _symptomController.clear();
      });
    }
  }

  void _removeSymptom(String symptom) {
    setState(() {
      _selectedSymptoms.remove(symptom);
    });
  }

  void _addQuickSymptom(String symptom) {
    if (!_selectedSymptoms.contains(symptom)) {
      setState(() {
        _selectedSymptoms.add(symptom);
      });
    }
  }

  void _analyzeSymptoms() async {
    if (_selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one symptom')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _analysisResult = null;
    });

    try {
      final result = await _healthService.analyzeSymptoms(_selectedSymptoms);
      setState(() {
        _analysisResult = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Analysis failed: $e')),
      );
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  void _clearSymptoms() {
    setState(() {
      _selectedSymptoms.clear();
      _analysisResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Symptom Checker',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_selectedSymptoms.isNotEmpty)
            TextButton(
              onPressed: _clearSymptoms,
              child: const Text('Clear'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            SizedBox(height: 3.h),
            _buildSymptomInput(),
            SizedBox(height: 3.h),
            _buildSelectedSymptoms(),
            SizedBox(height: 3.h),
            _buildQuickSymptoms(),
            SizedBox(height: 3.h),
            _buildAnalyzeButton(),
            SizedBox(height: 3.h),
            if (_isAnalyzing) _buildLoadingState(),
            if (_analysisResult != null) _buildAnalysisResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.health_and_safety,
                  color: Colors.white,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Symptom Analysis',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Describe your symptoms for AI-powered health insights',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.amber.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.amber, size: 4.w),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'This is not a substitute for professional medical advice',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.amber.shade700,
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

  Widget _buildSymptomInput() {
    return SymptomInputWidget(
      controller: _symptomController,
      onAddSymptom: _addSymptom,
      onSubmitted: _addSymptom,
    );
  }

  Widget _buildSelectedSymptoms() {
    if (_selectedSymptoms.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected Symptoms (${_selectedSymptoms.length})',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _selectedSymptoms.map((symptom) {
            return Chip(
              label: Text(symptom),
              backgroundColor:
                  AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
              deleteIcon: Icon(Icons.close, size: 4.w),
              onDeleted: () => _removeSymptom(symptom),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuickSymptoms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Add Common Symptoms',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _commonSymptoms.map((symptom) {
            final isSelected = _selectedSymptoms.contains(symptom);
            return GestureDetector(
              onTap: isSelected ? null : () => _addQuickSymptom(symptom),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary.withAlpha(26)
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                child: Text(
                  symptom,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAnalyzeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _selectedSymptoms.isNotEmpty && !_isAnalyzing
            ? _analyzeSymptoms
            : null,
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
            if (_isAnalyzing) ...[
              SizedBox(
                width: 4.w,
                height: 4.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 2.w),
            ],
            Icon(Icons.psychology, size: 5.w),
            SizedBox(width: 2.w),
            Text(
              _isAnalyzing ? 'Analyzing...' : 'Analyze Symptoms',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'AI is analyzing your symptoms...',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisResults() {
    if (_analysisResult == null) return const SizedBox.shrink();

    return DiagnosisResultWidget(
      result: _analysisResult!,
      onRecommendationTap: (recommendation) {
        // Handle recommendation tap
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recommendation: ${recommendation.action}')),
        );
      },
    );
  }

  @override
  void dispose() {
    _symptomController.dispose();
    super.dispose();
  }
}
