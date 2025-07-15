import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';

class UserProfileSettings extends StatefulWidget {
  const UserProfileSettings({Key? key}) : super(key: key);

  @override
  State<UserProfileSettings> createState() => _UserProfileSettingsState();
}

class _UserProfileSettingsState extends State<UserProfileSettings>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Mock user data
  final Map<String, dynamic> userData = {
    "name": "Dr. Sarah Johnson",
    "age": 34,
    "avatar":
        "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
    "healthScore": 85,
    "email": "sarah.johnson@email.com",
    "phone": "+1 (555) 123-4567",
    "bloodType": "O+",
    "height": "5'6\"",
    "weight": "140 lbs"
  };

  // Settings state
  bool biometricEnabled = true;
  bool dataBackupEnabled = true;
  bool healthReminders = true;
  bool riskAlerts = true;
  bool medicationReminders = true;
  bool darkModeEnabled = false;
  String selectedLanguage = "English";
  String selectedUnits = "Imperial";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProfileTab(),
                _buildSettingsTab(),
                _buildSupportTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      title: Text(
        'Profile Settings',
        style: AppTheme.lightTheme.textTheme.titleLarge,
      ),
      actions: [
        TextButton(
          onPressed: _showEditProfileDialog,
          child: Text(
            'Edit',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Profile'),
          Tab(text: 'Settings'),
          Tab(text: 'Support'),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          ProfileHeaderWidget(
            userData: userData,
            onEditPressed: _showEditProfileDialog,
          ),
          SizedBox(height: 4.h),
          _buildHealthProfileSection(),
          SizedBox(height: 3.h),
          _buildEmergencyContactsSection(),
          SizedBox(height: 3.h),
          _buildMedicalHistorySection(),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          _buildPrivacySecuritySection(),
          SizedBox(height: 3.h),
          _buildNotificationSection(),
          SizedBox(height: 3.h),
          _buildAppPreferencesSection(),
          SizedBox(height: 3.h),
          _buildDataManagementSection(),
        ],
      ),
    );
  }

  Widget _buildSupportTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          _buildHelpSupportSection(),
          SizedBox(height: 3.h),
          _buildAboutSection(),
          SizedBox(height: 3.h),
          _buildSignOutSection(),
        ],
      ),
    );
  }

  Widget _buildHealthProfileSection() {
    return SettingsSectionWidget(
      title: 'Health Profile',
      children: [
        SettingsItemWidget(
          title: 'Medical History',
          subtitle: 'Manage your medical conditions',
          leadingIcon: 'medical_services',
          onTap: () => Navigator.pushNamed(context, '/health-profile-setup'),
        ),
        SettingsItemWidget(
          title: 'Current Medications',
          subtitle: '3 active medications',
          leadingIcon: 'medication',
          onTap: () => _showMedicationsDialog(),
        ),
        SettingsItemWidget(
          title: 'Allergies',
          subtitle: 'Penicillin, Shellfish',
          leadingIcon: 'warning',
          onTap: () => _showAllergiesDialog(),
        ),
        SettingsItemWidget(
          title: 'Blood Type',
          subtitle: userData["bloodType"] ?? 'Not specified',
          leadingIcon: 'bloodtype',
          onTap: () => _showBloodTypeDialog(),
        ),
      ],
    );
  }

  Widget _buildEmergencyContactsSection() {
    return SettingsSectionWidget(
      title: 'Emergency Contacts',
      children: [
        SettingsItemWidget(
          title: 'Primary Contact',
          subtitle: 'John Johnson - Spouse',
          leadingIcon: 'contact_emergency',
          onTap: () => _showEmergencyContactDialog(),
        ),
        SettingsItemWidget(
          title: 'Secondary Contact',
          subtitle: 'Dr. Michael Smith - Physician',
          leadingIcon: 'contact_phone',
          onTap: () => _showEmergencyContactDialog(),
        ),
        SettingsItemWidget(
          title: 'Add Contact',
          subtitle: 'Add new emergency contact',
          leadingIcon: 'add_circle',
          onTap: () => _showAddContactDialog(),
        ),
      ],
    );
  }

  Widget _buildMedicalHistorySection() {
    return SettingsSectionWidget(
      title: 'Medical History',
      children: [
        SettingsItemWidget(
          title: 'Previous Reports',
          subtitle: '12 reports uploaded',
          leadingIcon: 'description',
          onTap: () => Navigator.pushNamed(context, '/health-dashboard'),
        ),
        SettingsItemWidget(
          title: 'Health Trends',
          subtitle: 'View your health analytics',
          leadingIcon: 'trending_up',
          onTap: () => Navigator.pushNamed(context, '/health-dashboard'),
        ),
      ],
    );
  }

  Widget _buildPrivacySecuritySection() {
    return SettingsSectionWidget(
      title: 'Privacy & Security',
      children: [
        SettingsItemWidget(
          title: 'Biometric Authentication',
          subtitle: biometricEnabled ? 'Face ID enabled' : 'Disabled',
          leadingIcon: 'fingerprint',
          trailing: Switch(
            value: biometricEnabled,
            onChanged: (value) {
              setState(() {
                biometricEnabled = value;
              });
              if (value) {
                Navigator.pushNamed(context, '/biometric-authentication');
              }
            },
          ),
        ),
        SettingsItemWidget(
          title: 'Data Encryption',
          subtitle: 'End-to-end encryption enabled',
          leadingIcon: 'security',
          onTap: () => _showEncryptionInfoDialog(),
        ),
        SettingsItemWidget(
          title: 'Data Backup',
          subtitle: dataBackupEnabled ? 'Cloud sync enabled' : 'Local only',
          leadingIcon: 'backup',
          trailing: Switch(
            value: dataBackupEnabled,
            onChanged: (value) {
              setState(() {
                dataBackupEnabled = value;
              });
              _showBackupInfoDialog();
            },
          ),
        ),
        SettingsItemWidget(
          title: 'Privacy Policy',
          subtitle: 'View our privacy policy',
          leadingIcon: 'policy',
          onTap: () => _showPrivacyPolicyDialog(),
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    return SettingsSectionWidget(
      title: 'Notifications',
      children: [
        SettingsItemWidget(
          title: 'Health Reminders',
          subtitle: 'Checkup and test reminders',
          leadingIcon: 'notifications',
          trailing: Switch(
            value: healthReminders,
            onChanged: (value) {
              setState(() {
                healthReminders = value;
              });
            },
          ),
        ),
        SettingsItemWidget(
          title: 'Risk Alerts',
          subtitle: 'Critical health risk notifications',
          leadingIcon: 'warning',
          trailing: Switch(
            value: riskAlerts,
            onChanged: (value) {
              setState(() {
                riskAlerts = value;
              });
            },
          ),
        ),
        SettingsItemWidget(
          title: 'Medication Reminders',
          subtitle: 'Daily medication schedules',
          leadingIcon: 'schedule',
          trailing: Switch(
            value: medicationReminders,
            onChanged: (value) {
              setState(() {
                medicationReminders = value;
              });
            },
          ),
        ),
        SettingsItemWidget(
          title: 'Notification Settings',
          subtitle: 'Manage notification preferences',
          leadingIcon: 'settings',
          onTap: () => _showNotificationSettingsDialog(),
        ),
      ],
    );
  }

  Widget _buildAppPreferencesSection() {
    return SettingsSectionWidget(
      title: 'App Preferences',
      children: [
        SettingsItemWidget(
          title: 'Units',
          subtitle: selectedUnits,
          leadingIcon: 'straighten',
          onTap: () => _showUnitsDialog(),
        ),
        SettingsItemWidget(
          title: 'Language',
          subtitle: selectedLanguage,
          leadingIcon: 'language',
          onTap: () => _showLanguageDialog(),
        ),
        SettingsItemWidget(
          title: 'Theme',
          subtitle: darkModeEnabled ? 'Dark' : 'Light',
          leadingIcon: 'palette',
          trailing: Switch(
            value: darkModeEnabled,
            onChanged: (value) {
              setState(() {
                darkModeEnabled = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDataManagementSection() {
    return SettingsSectionWidget(
      title: 'Data Management',
      children: [
        SettingsItemWidget(
          title: 'Export Health Data',
          subtitle: 'Download your health archive',
          leadingIcon: 'download',
          onTap: () => _showExportDataDialog(),
        ),
        SettingsItemWidget(
          title: 'Clear Cache',
          subtitle: 'Free up storage space',
          leadingIcon: 'clear',
          onTap: () => _showClearCacheDialog(),
        ),
        SettingsItemWidget(
          title: 'Delete Account',
          subtitle: 'Permanently delete your account',
          leadingIcon: 'delete_forever',
          onTap: () => _showDeleteAccountDialog(),
        ),
      ],
    );
  }

  Widget _buildHelpSupportSection() {
    return SettingsSectionWidget(
      title: 'Help & Support',
      children: [
        SettingsItemWidget(
          title: 'Help Center',
          subtitle: 'FAQs and user guides',
          leadingIcon: 'help',
          onTap: () => _showHelpDialog(),
        ),
        SettingsItemWidget(
          title: 'Contact Support',
          subtitle: 'Get help from our team',
          leadingIcon: 'support_agent',
          onTap: () => _showContactSupportDialog(),
        ),
        SettingsItemWidget(
          title: 'Send Feedback',
          subtitle: 'Help us improve the app',
          leadingIcon: 'feedback',
          onTap: () => _showFeedbackDialog(),
        ),
        SettingsItemWidget(
          title: 'Rate App',
          subtitle: 'Rate us on the App Store',
          leadingIcon: 'star',
          onTap: () => _showRateAppDialog(),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return SettingsSectionWidget(
      title: 'About',
      children: [
        SettingsItemWidget(
          title: 'Version',
          subtitle: '1.2.3 (Build 456)',
          leadingIcon: 'info',
          onTap: () => _showVersionInfoDialog(),
        ),
        SettingsItemWidget(
          title: 'Terms of Service',
          subtitle: 'View terms and conditions',
          leadingIcon: 'description',
          onTap: () => _showTermsDialog(),
        ),
        SettingsItemWidget(
          title: 'Licenses',
          subtitle: 'Open source licenses',
          leadingIcon: 'copyright',
          onTap: () => _showLicensesDialog(),
        ),
      ],
    );
  }

  Widget _buildSignOutSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: ElevatedButton(
        onPressed: _showSignOutDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 6.h),
        ),
        child: Text(
          'Sign Out',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: userData["name"],
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: userData["email"],
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone',
                hintText: userData["phone"],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Profile updated successfully')),
              );
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showMedicationsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Current Medications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Metformin 500mg - Twice daily'),
            Text('• Lisinopril 10mg - Once daily'),
            Text('• Vitamin D3 1000IU - Once daily'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showAllergiesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Allergies'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Penicillin - Severe reaction'),
            Text('• Shellfish - Moderate reaction'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showBloodTypeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Blood Type'),
        content: Text('Your blood type is ${userData["bloodType"]}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Emergency Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'John Johnson',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Relationship',
                hintText: 'Spouse',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone',
                hintText: '+1 (555) 987-6543',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Emergency contact updated')),
              );
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Emergency Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Relationship',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Emergency contact added')),
              );
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEncryptionInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Data Encryption'),
        content: Text(
          'Your health data is protected with end-to-end encryption. This means only you can access your information, and it remains secure even during transmission and storage.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showBackupInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Data Backup'),
        content: Text(
          dataBackupEnabled
              ? 'Your health data is now backed up to the cloud with encryption. You can access it from any device.'
              : 'Data backup has been disabled. Your information will only be stored locally on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Understood'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Text(
            'MedScanAI Privacy Policy\n\nWe are committed to protecting your privacy and health information. Your data is encrypted and stored securely...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notification Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Manage your notification preferences in device settings.'),
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Open device settings
              },
              child: Text('Open Settings'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showUnitsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Units'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('Imperial (lbs, ft)'),
              value: 'Imperial',
              groupValue: selectedUnits,
              onChanged: (value) {
                setState(() {
                  selectedUnits = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('Metric (kg, cm)'),
              value: 'Metric',
              groupValue: selectedUnits,
              onChanged: (value) {
                setState(() {
                  selectedUnits = value!;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('English'),
              value: 'English',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('Spanish'),
              value: 'Spanish',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('French'),
              value: 'French',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showExportDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Health Data'),
        content: Text(
          'This will create a comprehensive archive of your health data including reports, trends, and medical history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Health data export started')),
              );
            },
            child: Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Cache'),
        content: Text(
          'This will clear temporary files and free up storage space. Your health data will not be affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text(
          'This action cannot be undone. All your health data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showFinalDeleteConfirmation();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showFinalDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Final Confirmation'),
        content: Text('Type "DELETE" to confirm account deletion:'),
        actions: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Type DELETE here',
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Account deletion initiated')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
                child: Text('Confirm Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Help Center'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Frequently Asked Questions:',
                  style: AppTheme.lightTheme.textTheme.titleMedium),
              SizedBox(height: 1.h),
              Text('• How to upload medical reports?'),
              Text('• Understanding health predictions'),
              Text('• Managing medication reminders'),
              Text('• Privacy and data security'),
              SizedBox(height: 2.h),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('View Full Guide'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showContactSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Get help from our support team:'),
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Email Support'),
            ),
            SizedBox(height: 1.h),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Live Chat'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Send Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Tell us what you think...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Feedback sent successfully')),
              );
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showRateAppDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rate MedScanAI'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enjoying MedScanAI? Please rate us on the App Store!'),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => CustomIconWidget(
                  iconName: 'star',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Thank you for rating us!')),
              );
            },
            child: Text('Rate Now'),
          ),
        ],
      ),
    );
  }

  void _showVersionInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Version Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MedScanAI v1.2.3'),
            Text('Build: 456'),
            Text('Release Date: July 15, 2025'),
            SizedBox(height: 2.h),
            Text('What\'s New:',
                style: AppTheme.lightTheme.textTheme.titleMedium),
            Text('• Improved OCR accuracy'),
            Text('• Enhanced health predictions'),
            Text('• Bug fixes and performance improvements'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Terms of Service'),
        content: SingleChildScrollView(
          child: Text(
            'MedScanAI Terms of Service\n\nBy using this application, you agree to the following terms and conditions...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLicensesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Open Source Licenses'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Flutter Framework - BSD License'),
              Text('Dart Language - BSD License'),
              Text('Material Icons - Apache License 2.0'),
              Text('Google Fonts - SIL Open Font License'),
              SizedBox(height: 2.h),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('View Full Licenses'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign Out'),
        content: Text(
          'Are you sure you want to sign out? Your data will remain secure and available when you sign back in.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/biometric-authentication',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
