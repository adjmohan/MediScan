import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MedicationSectionWidget extends StatefulWidget {
  final TextEditingController medicationController;
  final List<Map<String, String>> medications;
  final List<Map<String, dynamic>> medicationDatabase;
  final Function(Map<String, String>) onMedicationAdded;
  final Function(int) onMedicationRemoved;

  const MedicationSectionWidget({
    super.key,
    required this.medicationController,
    required this.medications,
    required this.medicationDatabase,
    required this.onMedicationAdded,
    required this.onMedicationRemoved,
  });

  @override
  State<MedicationSectionWidget> createState() =>
      _MedicationSectionWidgetState();
}

class _MedicationSectionWidgetState extends State<MedicationSectionWidget> {
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  List<Map<String, dynamic>> _filteredMedications = [];
  bool _showSuggestions = false;
  String _selectedMedication = '';

  @override
  void initState() {
    super.initState();
    _filteredMedications = widget.medicationDatabase;
  }

  @override
  void dispose() {
    _dosageController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  void _filterMedications(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMedications = widget.medicationDatabase;
        _showSuggestions = false;
      } else {
        _filteredMedications = widget.medicationDatabase
            .where((med) => (med["name"] as String)
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
        _showSuggestions = true;
      }
    });
  }

  void _selectMedication(Map<String, dynamic> medication) {
    setState(() {
      widget.medicationController.text = medication["name"] as String;
      _selectedMedication = medication["name"] as String;
      _showSuggestions = false;
    });
  }

  void _addMedication() {
    if (widget.medicationController.text.isNotEmpty &&
        _dosageController.text.isNotEmpty &&
        _frequencyController.text.isNotEmpty) {
      final medication = {
        'name': widget.medicationController.text,
        'dosage': _dosageController.text,
        'frequency': _frequencyController.text,
      };

      widget.onMedicationAdded(medication);

      // Clear form
      widget.medicationController.clear();
      _dosageController.clear();
      _frequencyController.clear();
      setState(() {
        _selectedMedication = '';
        _showSuggestions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Medications',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Add any medications you\'re currently taking. This helps us identify potential interactions and provide better health insights.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Current Medications List
          if (widget.medications.isNotEmpty) ...[
            _buildSectionTitle('Your Medications'),
            SizedBox(height: 2.h),
            ...widget.medications.asMap().entries.map((entry) {
              final index = entry.key;
              final medication = entry.value;
              return _buildMedicationCard(medication, index);
            }).toList(),
            SizedBox(height: 3.h),
          ],

          // Add New Medication Form
          _buildSectionTitle('Add New Medication'),
          SizedBox(height: 2.h),

          // Medication Name Input with Autocomplete
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Medication Name',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: widget.medicationController,
                decoration: InputDecoration(
                  hintText: 'Search for medication...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
                onChanged: _filterMedications,
              ),

              // Medication Suggestions
              if (_showSuggestions && _filteredMedications.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(top: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: _filteredMedications.take(5).map((medication) {
                      return ListTile(
                        title: Text(
                          medication["name"] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        subtitle: Text(
                          medication["category"] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        onTap: () => _selectMedication(medication),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),

          SizedBox(height: 2.h),

          // Dosage and Frequency Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dosage',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _dosageController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., 500mg',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Frequency',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _frequencyController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., Twice daily',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Add Medication Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addMedication,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              label: const Text('Add Medication'),
            ),
          ),

          SizedBox(height: 3.h),

          // No Medications Option
          _buildNoMedicationsCard(),

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

  Widget _buildMedicationCard(Map<String, String> medication, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'medication',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medication['name'] ?? '',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${medication['dosage']} • ${medication['frequency']}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => widget.onMedicationRemoved(index),
            icon: CustomIconWidget(
              iconName: 'delete',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoMedicationsCard() {
    final isSelected = widget.medications.isEmpty;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          // Clear all medications
          for (int i = widget.medications.length - 1; i >= 0; i--) {
            widget.onMedicationRemoved(i);
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.tertiaryContainer
              : AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.tertiary
                : AppTheme.lightTheme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.tertiary
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : AppTheme.lightTheme.colorScheme.outline,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isSelected
                  ? CustomIconWidget(
                      iconName: 'check',
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No Current Medications',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'I\'m not currently taking any medications',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
