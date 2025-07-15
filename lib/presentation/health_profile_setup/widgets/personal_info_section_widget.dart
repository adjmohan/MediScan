import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PersonalInfoSectionWidget extends StatelessWidget {
  final TextEditingController ageController;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final String selectedGender;
  final bool isMetricSystem;
  final Function(String) onGenderChanged;
  final Function(bool) onMetricSystemChanged;
  final VoidCallback onFieldChanged;

  const PersonalInfoSectionWidget({
    super.key,
    required this.ageController,
    required this.heightController,
    required this.weightController,
    required this.selectedGender,
    required this.isMetricSystem,
    required this.onGenderChanged,
    required this.onMetricSystemChanged,
    required this.onFieldChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tell us about yourself',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'This information helps us provide more accurate health predictions and personalized recommendations.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Age Input
          _buildSectionTitle('Age'),
          SizedBox(height: 1.h),
          TextFormField(
            controller: ageController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            decoration: InputDecoration(
              hintText: 'Enter your age',
              suffixText: 'years',
              suffixStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your age';
              }
              final age = int.tryParse(value);
              if (age == null || age < 1 || age > 120) {
                return 'Please enter a valid age';
              }
              return null;
            },
            onChanged: (_) => onFieldChanged(),
          ),
          SizedBox(height: 3.h),

          // Gender Selection
          _buildSectionTitle('Gender'),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: _buildGenderCard('Male', 'male'),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildGenderCard('Female', 'female'),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildGenderCard('Other', 'other'),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Unit System Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Measurement System',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Imperial',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: !isMetricSystem
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Switch(
                    value: isMetricSystem,
                    onChanged: onMetricSystemChanged,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Metric',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: isMetricSystem
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Height Input
          _buildSectionTitle('Height'),
          SizedBox(height: 1.h),
          TextFormField(
            controller: heightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              hintText: isMetricSystem
                  ? 'Enter height in cm'
                  : 'Enter height in inches',
              suffixText: isMetricSystem ? 'cm' : 'in',
              suffixStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your height';
              }
              final height = double.tryParse(value);
              if (height == null || height <= 0) {
                return 'Please enter a valid height';
              }
              return null;
            },
            onChanged: (_) => onFieldChanged(),
          ),
          SizedBox(height: 3.h),

          // Weight Input
          _buildSectionTitle('Weight'),
          SizedBox(height: 1.h),
          TextFormField(
            controller: weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              hintText:
                  isMetricSystem ? 'Enter weight in kg' : 'Enter weight in lbs',
              suffixText: isMetricSystem ? 'kg' : 'lbs',
              suffixStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your weight';
              }
              final weight = double.tryParse(value);
              if (weight == null || weight <= 0) {
                return 'Please enter a valid weight';
              }
              return null;
            },
            onChanged: (_) => onFieldChanged(),
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        color: AppTheme.lightTheme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildGenderCard(String label, String value) {
    final isSelected = selectedGender == value;

    return GestureDetector(
      onTap: () => onGenderChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primaryContainer
              : AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: value == 'male'
                  ? 'male'
                  : value == 'female'
                      ? 'female'
                      : 'person',
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 32,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
