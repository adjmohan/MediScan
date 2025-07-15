import 'dart:convert';
import 'dart:typed_data';

import './openai_client.dart';
import './openai_service.dart';

class HealthAnalysisService {
  static final HealthAnalysisService _instance =
      HealthAnalysisService._internal();
  late final OpenAIClient _openAIClient;

  factory HealthAnalysisService() {
    return _instance;
  }

  HealthAnalysisService._internal() {
    final openAIService = OpenAIService();
    _openAIClient = OpenAIClient(openAIService.dio);
  }

  /// Extract text from medical report image using OpenAI Vision
  Future<String> extractTextFromImage({
    String? imageUrl,
    Uint8List? imageBytes,
  }) async {
    try {
      final prompt = '''
Analyze this medical report image and extract all text content. 
Please provide a structured extraction including:
1. Patient information (name, date, etc.)
2. Test results with values and units
3. Reference ranges where available
4. Any medical observations or notes

Format the output as clear, structured text that can be easily parsed for medical analysis.
''';

      final response = await _openAIClient.generateTextFromImage(
        imageUrl: imageUrl,
        imageBytes: imageBytes,
        promptText: prompt,
        model: 'gpt-4o',
      );

      return response.text;
    } catch (e) {
      throw Exception('Failed to extract text from image: $e');
    }
  }

  /// Analyze medical report text and provide health insights
  Future<HealthAnalysisResult> analyzeHealthReport(String extractedText) async {
    try {
      final prompt = '''
You are a medical AI assistant. Analyze the following medical report data and provide:

1. EXTRACTED_VALUES: Key health metrics with values and units
2. DISEASE_PREDICTIONS: Potential health conditions with confidence levels (0-100)
3. RISK_ASSESSMENTS: Risk levels (Low/Monitor/Consult Doctor/Urgent)
4. RECOMMENDATIONS: Specific actionable advice
5. HEALTH_INSIGHTS: Important observations about the patient's health

Medical Report Data:
$extractedText

Please respond in JSON format with the following structure:
{
  "extracted_values": [
    {"parameter": "Blood Glucose", "value": "145", "unit": "mg/dL", "normal_range": "70-100", "status": "elevated"}
  ],
  "disease_predictions": [
    {"condition": "Pre-Diabetes", "confidence": 85, "risk_level": "Monitor", "indicators": ["High glucose", "Elevated HbA1c"]}
  ],
  "recommendations": [
    {"type": "Lifestyle", "title": "Dietary Changes", "description": "...", "priority": "High"}
  ],
  "health_insights": "Overall health summary and key concerns",
  "chart_data": [
    {"metric": "Blood Glucose", "current_value": 145, "normal_range": "70-100", "trend": "elevated"}
  ]
}
''';

      final messages = [
        Message(role: 'user', content: prompt),
      ];

      final response = await _openAIClient.createChatCompletion(
        messages: messages,
        model: 'gpt-4o',
        options: {'temperature': 0.3},
      );

      return _parseHealthAnalysisResult(response.text);
    } catch (e) {
      throw Exception('Failed to analyze health report: $e');
    }
  }

  /// Analyze symptoms and provide potential diagnoses
  Future<SymptomAnalysisResult> analyzeSymptoms(List<String> symptoms) async {
    try {
      final symptomsText = symptoms.join(', ');

      final prompt = '''
You are a medical AI assistant. Analyze the following symptoms and provide potential diagnoses:

Symptoms: $symptomsText

Please respond in JSON format with the following structure:
{
  "potential_diagnoses": [
    {"condition": "Common Cold", "confidence": 75, "match_percentage": 80, "description": "..."}
  ],
  "recommendations": [
    {"type": "immediate", "action": "Rest and hydration", "description": "..."}
  ],
  "when_to_seek_help": "Seek medical attention if symptoms worsen or persist beyond 7 days",
  "severity_level": "mild"
}

Focus on common conditions and always recommend consulting healthcare professionals for proper diagnosis.
''';

      final messages = [
        Message(role: 'user', content: prompt),
      ];

      final response = await _openAIClient.createChatCompletion(
        messages: messages,
        model: 'gpt-4o',
        options: {'temperature': 0.3},
      );

      return _parseSymptomAnalysisResult(response.text);
    } catch (e) {
      throw Exception('Failed to analyze symptoms: $e');
    }
  }

  /// Generate personalized health recommendations
  Future<List<HealthRecommendation>> generateHealthRecommendations({
    required String healthData,
    required String patientProfile,
  }) async {
    try {
      final prompt = '''
Based on the following health data and patient profile, generate personalized health recommendations:

Health Data: $healthData
Patient Profile: $patientProfile

Please provide recommendations in JSON format:
{
  "recommendations": [
    {
      "type": "Diet",
      "title": "Reduce Sugar Intake",
      "description": "Limit processed foods and sugary drinks",
      "priority": "High",
      "category": "Lifestyle"
    }
  ]
}
''';

      final messages = [
        Message(role: 'user', content: prompt),
      ];

      final response = await _openAIClient.createChatCompletion(
        messages: messages,
        model: 'gpt-4o',
        options: {'temperature': 0.4},
      );

      final jsonResponse = jsonDecode(response.text);
      final recommendationsData = jsonResponse['recommendations'] as List;

      return recommendationsData
          .map((rec) => HealthRecommendation.fromJson(rec))
          .toList();
    } catch (e) {
      throw Exception('Failed to generate health recommendations: $e');
    }
  }

  HealthAnalysisResult _parseHealthAnalysisResult(String responseText) {
    try {
      final jsonResponse = jsonDecode(responseText);
      return HealthAnalysisResult.fromJson(jsonResponse);
    } catch (e) {
      // Fallback parsing if JSON is malformed
      return HealthAnalysisResult(
        extractedValues: [],
        diseasePredictions: [],
        recommendations: [],
        healthInsights: responseText,
        chartData: [],
      );
    }
  }

  SymptomAnalysisResult _parseSymptomAnalysisResult(String responseText) {
    try {
      final jsonResponse = jsonDecode(responseText);
      return SymptomAnalysisResult.fromJson(jsonResponse);
    } catch (e) {
      // Fallback parsing if JSON is malformed
      return SymptomAnalysisResult(
        potentialDiagnoses: [],
        recommendations: [],
        whenToSeekHelp: responseText,
        severityLevel: 'unknown',
      );
    }
  }
}

// Data models
class HealthAnalysisResult {
  final List<ExtractedValue> extractedValues;
  final List<DiseasePrediction> diseasePredictions;
  final List<HealthRecommendation> recommendations;
  final String healthInsights;
  final List<ChartData> chartData;

  HealthAnalysisResult({
    required this.extractedValues,
    required this.diseasePredictions,
    required this.recommendations,
    required this.healthInsights,
    required this.chartData,
  });

  factory HealthAnalysisResult.fromJson(Map<String, dynamic> json) {
    return HealthAnalysisResult(
      extractedValues: (json['extracted_values'] as List? ?? [])
          .map((e) => ExtractedValue.fromJson(e))
          .toList(),
      diseasePredictions: (json['disease_predictions'] as List? ?? [])
          .map((e) => DiseasePrediction.fromJson(e))
          .toList(),
      recommendations: (json['recommendations'] as List? ?? [])
          .map((e) => HealthRecommendation.fromJson(e))
          .toList(),
      healthInsights: json['health_insights'] ?? '',
      chartData: (json['chart_data'] as List? ?? [])
          .map((e) => ChartData.fromJson(e))
          .toList(),
    );
  }
}

class ExtractedValue {
  final String parameter;
  final String value;
  final String unit;
  final String normalRange;
  final String status;

  ExtractedValue({
    required this.parameter,
    required this.value,
    required this.unit,
    required this.normalRange,
    required this.status,
  });

  factory ExtractedValue.fromJson(Map<String, dynamic> json) {
    return ExtractedValue(
      parameter: json['parameter'] ?? '',
      value: json['value'] ?? '',
      unit: json['unit'] ?? '',
      normalRange: json['normal_range'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class DiseasePrediction {
  final String condition;
  final int confidence;
  final String riskLevel;
  final List<String> indicators;

  DiseasePrediction({
    required this.condition,
    required this.confidence,
    required this.riskLevel,
    required this.indicators,
  });

  factory DiseasePrediction.fromJson(Map<String, dynamic> json) {
    return DiseasePrediction(
      condition: json['condition'] ?? '',
      confidence: json['confidence'] ?? 0,
      riskLevel: json['risk_level'] ?? '',
      indicators: (json['indicators'] as List? ?? []).cast<String>(),
    );
  }
}

class HealthRecommendation {
  final String type;
  final String title;
  final String description;
  final String priority;

  HealthRecommendation({
    required this.type,
    required this.title,
    required this.description,
    required this.priority,
  });

  factory HealthRecommendation.fromJson(Map<String, dynamic> json) {
    return HealthRecommendation(
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      priority: json['priority'] ?? '',
    );
  }
}

class ChartData {
  final String metric;
  final double currentValue;
  final String normalRange;
  final String trend;

  ChartData({
    required this.metric,
    required this.currentValue,
    required this.normalRange,
    required this.trend,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      metric: json['metric'] ?? '',
      currentValue: (json['current_value'] ?? 0).toDouble(),
      normalRange: json['normal_range'] ?? '',
      trend: json['trend'] ?? '',
    );
  }
}

class SymptomAnalysisResult {
  final List<PotentialDiagnosis> potentialDiagnoses;
  final List<SymptomRecommendation> recommendations;
  final String whenToSeekHelp;
  final String severityLevel;

  SymptomAnalysisResult({
    required this.potentialDiagnoses,
    required this.recommendations,
    required this.whenToSeekHelp,
    required this.severityLevel,
  });

  factory SymptomAnalysisResult.fromJson(Map<String, dynamic> json) {
    return SymptomAnalysisResult(
      potentialDiagnoses: (json['potential_diagnoses'] as List? ?? [])
          .map((e) => PotentialDiagnosis.fromJson(e))
          .toList(),
      recommendations: (json['recommendations'] as List? ?? [])
          .map((e) => SymptomRecommendation.fromJson(e))
          .toList(),
      whenToSeekHelp: json['when_to_seek_help'] ?? '',
      severityLevel: json['severity_level'] ?? '',
    );
  }
}

class PotentialDiagnosis {
  final String condition;
  final int confidence;
  final int matchPercentage;
  final String description;

  PotentialDiagnosis({
    required this.condition,
    required this.confidence,
    required this.matchPercentage,
    required this.description,
  });

  factory PotentialDiagnosis.fromJson(Map<String, dynamic> json) {
    return PotentialDiagnosis(
      condition: json['condition'] ?? '',
      confidence: json['confidence'] ?? 0,
      matchPercentage: json['match_percentage'] ?? 0,
      description: json['description'] ?? '',
    );
  }
}

class SymptomRecommendation {
  final String type;
  final String action;
  final String description;

  SymptomRecommendation({
    required this.type,
    required this.action,
    required this.description,
  });

  factory SymptomRecommendation.fromJson(Map<String, dynamic> json) {
    return SymptomRecommendation(
      type: json['type'] ?? '',
      action: json['action'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
