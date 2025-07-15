import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/medical_history_section_widget.dart';
import './widgets/medication_section_widget.dart';
import './widgets/personal_info_section_widget.dart';
import './widgets/progress_indicator_widget.dart';

class HealthProfileSetup extends StatefulWidget {
  const HealthProfileSetup({super.key});

  @override
  State<HealthProfileSetup> createState() => _HealthProfileSetupState();
}

class _HealthProfileSetupState extends State<HealthProfileSetup>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _medicationController = TextEditingController();

  // Form state variables
  String _selectedGender = '';
  bool _isMetricSystem = true;
  List<String> _selectedConditions = [];
  List<Map<String, String>> _medications = [];
  int _currentStep = 0;
  bool _isFormValid = false;

  // Mock data for medical conditions
  final List<Map<String, dynamic>> _medicalConditions = [
    {
      "id": "diabetes",
      "name": "Diabetes",
      "description": "Type 1 or Type 2 diabetes mellitus",
      "isCommon": true,
    },
    {
      "id": "hypertension",
      "name": "Hypertension",
      "description": "High blood pressure condition",
      "isCommon": true,
    },
    {
      "id": "thyroid",
      "name": "Thyroid Disorders",
      "description": "Hyperthyroidism or hypothyroidism",
      "isCommon": true,
    },
    {
      "id": "asthma",
      "name": "Asthma",
      "description": "Chronic respiratory condition",
      "isCommon": false,
    },
    {
      "id": "heart_disease",
      "name": "Heart Disease",
      "description": "Cardiovascular conditions",
      "isCommon": false,
    },
    {
      "id": "arthritis",
      "name": "Arthritis",
      "description": "Joint inflammation and pain",
      "isCommon": false,
    },
  ];

  // Mock medication database
  final List<Map<String, dynamic>> _medicationDatabase = [
    {
      "name": "Metformin",
      "category": "Diabetes",
      "commonDosages": ["500mg", "850mg", "1000mg"],
    },
    {
      "name": "Lisinopril",
      "category": "Hypertension",
      "commonDosages": ["5mg", "10mg", "20mg"],
    },
    {
      "name": "Levothyroxine",
      "category": "Thyroid",
      "commonDosages": ["25mcg", "50mcg", "100mcg"],
    },
    {
      "name": "Aspirin",
      "category": "Heart Health",
      "commonDosages": ["81mg", "325mg"],
    },
    {
      "name": "Atorvastatin",
      "category": "Cholesterol",
      "commonDosages": ["10mg", "20mg", "40mg"],
    },
  ];

  @override
  void initState() {
    super.initState();
    _validateForm();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _medicationController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _ageController.text.isNotEmpty &&
          _selectedGender.isNotEmpty &&
          _heightController.text.isNotEmpty &&
          _weightController.text.isNotEmpty;
    });
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeSetup();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeSetup() {
    // Save profile data locally
    _saveProfileData();

    // Show celebration animation
    _showCelebrationDialog();
  }

  void _saveProfileData() {
    // Mock data saving - in real app, this would save to secure storage
    final profileData = {
      'age': _ageController.text,
      'gender': _selectedGender,
      'height': _heightController.text,
      'weight': _weightController.text,
      'isMetric': _isMetricSystem,
      'medicalConditions': _selectedConditions,
      'medications': _medications,
      'setupCompleted': true,
      'timestamp': DateTime.now().toIso8601String(),
    };

    // In real implementation, encrypt and save to secure storage
    debugPrint('Profile data saved: \$profileData');
  }

  void _showCelebrationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 64,
              ),
              SizedBox(height: 2.h),
              Text(
                'Profile Setup Complete!',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'Your health profile has been created successfully. You can now start analyzing your medical reports.',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(
                        context, '/health-dashboard');
                  },
                  child: const Text('Continue to Dashboard'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _skipSetup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Skip Profile Setup?',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            'You can complete your profile later, but some AI predictions may be less accurate without this information.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continue Setup'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/health-dashboard');
              },
              child: const Text('Skip for Now'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                onPressed: _previousStep,
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              )
            : IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
        title: Text(
          'Health Profile Setup',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          TextButton(
            onPressed: _skipSetup,
            child: Text(
              'Skip',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            ProgressIndicatorWidget(
              currentStep: _currentStep,
              totalSteps: 3,
            ),

            // Form Content
            Expanded(
              child: Form(
                key: _formKey,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // Step 1: Personal Information
                    PersonalInfoSectionWidget(
                      ageController: _ageController,
                      heightController: _heightController,
                      weightController: _weightController,
                      selectedGender: _selectedGender,
                      isMetricSystem: _isMetricSystem,
                      onGenderChanged: (gender) {
                        setState(() {
                          _selectedGender = gender;
                        });
                        _validateForm();
                      },
                      onMetricSystemChanged: (isMetric) {
                        setState(() {
                          _isMetricSystem = isMetric;
                        });
                      },
                      onFieldChanged: _validateForm,
                    ),

                    // Step 2: Medical History
                    MedicalHistorySectionWidget(
                      medicalConditions: _medicalConditions,
                      selectedConditions: _selectedConditions,
                      onConditionToggled: (conditionId) {
                        setState(() {
                          if (_selectedConditions.contains(conditionId)) {
                            _selectedConditions.remove(conditionId);
                          } else {
                            _selectedConditions.add(conditionId);
                          }
                        });
                      },
                    ),

                    // Step 3: Current Medications
                    MedicationSectionWidget(
                      medicationController: _medicationController,
                      medications: _medications,
                      medicationDatabase: _medicationDatabase,
                      onMedicationAdded: (medication) {
                        setState(() {
                          _medications.add(medication);
                        });
                      },
                      onMedicationRemoved: (index) {
                        setState(() {
                          _medications.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Action Buttons
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        child: const Text('Previous'),
                      ),
                    ),
                  if (_currentStep > 0) SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (_currentStep == 0 && !_isFormValid)
                          ? null
                          : _nextStep,
                      child:
                          Text(_currentStep == 2 ? 'Complete Setup' : 'Next'),
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
