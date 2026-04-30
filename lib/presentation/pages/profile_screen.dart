import 'package:flutter/material.dart';
import 'package:hms_patient/app_helpers/theme/app_colors.dart';
import 'package:hms_patient/app_helpers/theme/app_spacings.dart';
import 'package:hms_patient/app_helpers/theme/app_typography.dart';
import 'package:hms_patient/app_helpers/models/patient_model.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  late PatientProfile _profile;

  @override
  void initState() {
    super.initState();
    _profile = PatientProfile(
      fullName: 'John Smith',
      dob: 'Jan 15, 1992',
      age: '32 years',
      gender: 'Male',
      bloodGroup: 'B Positive (B+)',
      phone: '+91 34567 87654',
      email: 'shafkjdf12@gmail.com',
      address: 'Mumbai, Maharashtra',
      uhid: '2987564323456',
      doctor: 'Dr. Ravi Mehta',
      department: 'Pathology',
      registeredOn: 'Jan 05, 2024',
      status: 'Active',
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts[0].isNotEmpty) return parts[0][0].toUpperCase();
    return 'P';
  }

  void _openEditSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditProfileSheet(
        profile: _profile,
        onSave: (updated) {
          setState(() => _profile = updated);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatarSize = 88.r(context);

    return Scaffold(
      backgroundColor: AppColors.onPrimary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.r(context),
            pinned: true,
            backgroundColor: AppColors.secondary,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: AppColors.onPrimary,
                size: 18.r(context),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              GestureDetector(
                onTap: _openEditSheet,
                child: Container(
                  margin: AppSpacing.only(
                    context: context,
                    right: AppSpacingTokens.spacing4x,
                    top: 10,
                    bottom: 10,
                  ),
                  padding: AppSpacing.symmetric(
                    context: context,
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.onPrimary.withValues(alpha: 0.12),
                    borderRadius: AppBorderRadiusTokens.circular5x,
                    border: Border.all(
                      color: AppColors.onPrimary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_rounded,
                        color: AppColors.onPrimary,
                        size: 13.r(context),
                      ),
                      AppSpacing.w4(context),
                      Text(
                        'Edit',
                        style: AppTypography.labelMedium.withColor(
                          AppColors.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.secondary,
                child: SafeArea(
                  child: Padding(
                    padding: AppSpacing.only(context: context, top: 52),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: avatarSize,
                              height: avatarSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.tertiary,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  width: 3,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _getInitials(_profile.fullName),
                                  style: AppTypography.headlineMedium.bold
                                      .withColor(AppColors.onPrimary),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 3.r(context),
                              right: 3.r(context),
                              child: Container(
                                width: 13.r(context),
                                height: 13.r(context),
                                decoration: BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.secondary,
                                    width: 2.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.h8(context),
                        Text(
                          _profile.fullName,
                          style: AppTypography.headlineSmall.bold.withColor(
                            AppColors.onPrimary,
                          ),
                        ),
                        Text(
                          'Patient',
                          style: AppTypography.labelMedium.withColor(
                            AppColors.grey400,
                          ),
                        ),
                        AppSpacing.h12(context),
                        Padding(
                          padding: AppSpacing.symmetric(
                            context: context,
                            horizontal: 16,
                          ),
                          child: Wrap(
                            spacing: 6.r(context),
                            runSpacing: 6.r(context),
                            alignment: WrapAlignment.center,
                            children: [
                              _HeaderBadge(
                                icon: Icons.favorite_rounded,
                                label: _profile.bloodGroup.contains('(')
                                    ? _profile.bloodGroup
                                          .split('(')[1]
                                          .replaceAll(')', '')
                                    : _profile.bloodGroup,
                                color: AppColors.error.withValues(alpha: 0.8),
                                bgColor: AppColors.error.withValues(alpha: 0.2),
                              ),
                              _HeaderBadge(
                                icon: Icons.badge_rounded,
                                label: 'UHID ${_profile.uhid}',
                                color: AppColors.grey300,
                                bgColor: AppColors.onPrimary.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                              _HeaderBadge(
                                icon: Icons.circle,
                                label: _profile.status,
                                color: AppColors.success,
                                bgColor: AppColors.success.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.secondary.withValues(alpha: 0.9),
              child: Row(
                children: [
                  _StatItem(
                    value: _profile.age.replaceAll(' years', ''),
                    label: 'Age',
                  ),
                  _StatItem(value: _profile.gender, label: 'Gender'),
                  const _StatItem(value: '4', label: 'Visits'),
                  const _StatItem(value: '2', label: 'Reports'),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: AppSpacing.all(context, AppPaddingTokens.padding4x),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _DetailSection(
                  headerIcon: Icons.person_rounded,
                  headerIconColor: AppColors.tertiary,
                  title: 'Personal details',
                  rows: [
                    _DetailRow(
                      icon: Icons.person_rounded,
                      iconColor: AppColors.tertiary,
                      iconBg: AppColors.primary.withValues(alpha: 0.1),
                      label: 'Full name',
                      value: _profile.fullName,
                    ),
                    _DetailRow(
                      icon: Icons.calendar_today_rounded,
                      iconColor: AppColors.success,
                      iconBg: AppColors.success.withValues(alpha: 0.1),
                      label: 'Date of birth',
                      value: _profile.dob,
                    ),
                    _DetailRow(
                      icon: Icons.access_time_rounded,
                      iconColor: Colors.deepPurple,
                      iconBg: Colors.deepPurple.withValues(alpha: 0.1),
                      label: 'Age',
                      value: _profile.age,
                    ),
                    _DetailRow(
                      icon: Icons.people_rounded,
                      iconColor: Colors.orange,
                      iconBg: Colors.orange.withValues(alpha: 0.1),
                      label: 'Gender',
                      value: _profile.gender,
                    ),
                    _DetailRow(
                      icon: Icons.favorite_rounded,
                      iconColor: AppColors.error,
                      iconBg: AppColors.error.withValues(alpha: 0.1),
                      label: 'Blood group',
                      value: _profile.bloodGroup,
                    ),
                  ],
                ),
                AppSpacing.h12(context),
                _DetailSection(
                  headerIcon: Icons.call_rounded,
                  headerIconColor: AppColors.success,
                  title: 'Contact information',
                  rows: [
                    _DetailRow(
                      icon: Icons.phone_rounded,
                      iconColor: AppColors.success,
                      iconBg: AppColors.success.withValues(alpha: 0.1),
                      label: 'Phone',
                      value: _profile.phone,
                    ),
                    _DetailRow(
                      icon: Icons.email_rounded,
                      iconColor: AppColors.primary,
                      iconBg: AppColors.primary.withValues(alpha: 0.1),
                      label: 'Email',
                      value: _profile.email,
                    ),
                    _DetailRow(
                      icon: Icons.location_on_rounded,
                      iconColor: AppColors.error,
                      iconBg: AppColors.error.withValues(alpha: 0.1),
                      label: 'Address',
                      value: _profile.address,
                    ),
                  ],
                ),
                AppSpacing.h12(context),
                _DetailSection(
                  headerIcon: Icons.medical_services_rounded,
                  headerIconColor: AppColors.tertiary,
                  title: 'Hospital records',
                  rows: [
                    _DetailRow(
                      icon: Icons.badge_rounded,
                      iconColor: AppColors.tertiary,
                      iconBg: AppColors.tertiary.withValues(alpha: 0.1),
                      label: 'UHID number',
                      value: _profile.uhid,
                    ),
                    _DetailRow(
                      icon: Icons.person_search_rounded,
                      iconColor: Colors.indigo,
                      iconBg: Colors.indigo.withValues(alpha: 0.1),
                      label: 'Assigned doctor',
                      value: _profile.doctor,
                    ),
                    _DetailRow(
                      icon: Icons.local_hospital_rounded,
                      iconColor: AppColors.error,
                      iconBg: AppColors.error.withValues(alpha: 0.1),
                      label: 'Department',
                      value: _profile.department,
                    ),
                    _DetailRow(
                      icon: Icons.event_available_rounded,
                      iconColor: AppColors.success,
                      iconBg: AppColors.success.withValues(alpha: 0.1),
                      label: 'Registered on',
                      value: _profile.registeredOn,
                    ),
                  ],
                ),
                AppSpacing.h24(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;

  const _HeaderBadge({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.symmetric(
        context: context,
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppBorderRadiusTokens.circular5x,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.r(context), color: color),
          AppSpacing.w4(context),
          Text(label, style: AppTypography.labelSmall.bold.withColor(color)),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: AppSpacing.symmetric(context: context, vertical: 16),
        child: Column(
          children: [
            Text(
              value,
              style: AppTypography.titleMedium.bold.withColor(
                AppColors.onPrimary,
              ),
            ),
            Text(
              label,
              style: AppTypography.labelSmall.withColor(AppColors.grey300),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final IconData headerIcon;
  final Color headerIconColor;
  final String title;
  final List<Widget> rows;

  const _DetailSection({
    required this.headerIcon,
    required this.headerIconColor,
    required this.title,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.all(context, AppPaddingTokens.padding4x),
      decoration: BoxDecoration(
        color: AppColors.onPrimary,
        borderRadius: AppBorderRadiusTokens.circular4x,
        boxShadow: const [AppColors.shellCardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(headerIcon, size: 18.r(context), color: headerIconColor),
              AppSpacing.w8(context),
              Text(title, style: AppTypography.titleMedium.bold),
            ],
          ),
          AppSpacing.h12(context),
          const Divider(height: 1),
          ...rows,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.only(context: context, top: 12),
      child: Row(
        children: [
          Container(
            padding: AppSpacing.all(context, AppPaddingTokens.padding2x),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 14.r(context), color: iconColor),
          ),
          AppSpacing.w12(context),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.labelSmall.withColor(AppColors.grey500),
                ),
                Text(value, style: AppTypography.bodyMedium.medium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditProfileSheet extends StatefulWidget {
  final PatientProfile profile;
  final Function(PatientProfile) onSave;

  const _EditProfileSheet({required this.profile, required this.onSave});

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.fullName);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _emailController = TextEditingController(text: widget.profile.email);
    _addressController = TextEditingController(text: widget.profile.address);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.only(
        context: context,
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          AppSpacing.h16(context),
          Text('Edit Profile', style: AppTypography.headlineSmall.bold),
          AppSpacing.h20(context),
          _buildField('Full Name', _nameController),
          AppSpacing.h12(context),
          _buildField('Phone', _phoneController),
          AppSpacing.h12(context),
          _buildField('Email', _emailController),
          AppSpacing.h12(context),
          _buildField('Address', _addressController),
          AppSpacing.h24(context),
          SizedBox(
            width: double.infinity,
            height: 50.r(context),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadiusTokens.circular3x,
                ),
              ),
              onPressed: () {
                final updated = widget.profile.copyWith(
                  fullName: _nameController.text,
                  phone: _phoneController.text,
                  email: _emailController.text,
                  address: _addressController.text,
                );
                widget.onSave(updated);
                Navigator.pop(context);
              },
              child: Text('Save Changes', style: AppTypography.buttonText.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.labelMedium,
        border: OutlineInputBorder(
          borderRadius: AppBorderRadiusTokens.circular3x,
        ),
        contentPadding: AppSpacing.symmetric(
          context: context,
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
