import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/screening/cv_match_response_model.dart';
import 'package:job_circle/src/provider/screening/cv_screening_provider.dart';
import 'package:job_circle/src/screen/screening/cv_match_result.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_field_for_master_data.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class CvProfileEditScreen extends StatefulWidget {
  const CvProfileEditScreen({super.key});

  @override
  State<CvProfileEditScreen> createState() => _CvProfileEditScreenState();
}

class _CvProfileEditScreenState extends State<CvProfileEditScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CvScreeningProvider>();
      if (provider.language.isEmpty) {
        provider.fetchLanguages();
      }
      provider.fetchActiveJobs();
    });
  }

  void _showJobSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _JobSelectionBottomSheet(),
    );
  }

  void _showEducationDialog(
    BuildContext context, {
    EducationItem? item,
    int? index,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _EducationEditDialog(
        item: item,
        onSave: (updated) {
          final provider = context.read<CvScreeningProvider>();
          if (index != null) {
            provider.updateEducationAt(index, updated);
          } else {
            provider.addEducation(updated);
          }
        },
      ),
    );
  }

  void _showWorkHistoryBottomSheet(
    BuildContext context, {
    WorkHistoryItem? item,
    int? index,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _WorkHistoryEditBottomSheet(
        item: item,
        onSave: (updated) {
          final provider = context.read<CvScreeningProvider>();
          if (index != null) {
            provider.updateWorkHistoryAt(index, updated);
          } else {
            provider.addWorkHistory(updated);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final provider = context.watch<CvScreeningProvider>();
    final isMatching = provider.state == ScreeningState.matching;
    final isExperience = provider.selectedExperienceLevel == 'Experience';
    final selectedJobsCount = provider.selectedJobIds.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: customText(
          title: 'Review Extracted Data',
          color: colors.headingColor,
          fontWeight: FontWeight.bold,
          fontSize: 17,
          monst: true,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.headingColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: isMatching
                ? null
                : () async {
                    final success = await context
                        .read<CvScreeningProvider>()
                        .submitAndGetRecommendations();
                    if (!context.mounted) return;
                    if (success) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CvMatchResultsScreen(),
                        ),
                      );
                    } else if (provider.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: customText(
                            title: provider.errorMessage!,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: isMatching
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 12),
                      customText(
                        title: 'Running Job Screening Matrix...',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  )
                : const customText(
                    title: 'Verify & Find Matching Jobs',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Personal Information
            _buildSectionCard(
              title: 'Personal Information',
              colors: colors,
              children: [
                _buildFieldLabel('Full Name', colors),
                CustomTextFieldforAll(
                  controller: provider.nameController,
                  hint: 'Enter candidate name',
                  isSearch: true,
                ),
                const SizedBox(height: 12),
                _buildFieldLabel('Email Address', colors),
                CustomTextFieldforAll(
                  controller: provider.emailController,
                  hint: 'Enter email address',
                  isGmail: true,
                  isSearch: true,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('DOB (YYYY-MM-DD)', colors),
                          CustomTextFieldforAll(
                            controller: provider.dobController,
                            hint: 'YYYY-MM-DD',
                            isSearch: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Gender', colors),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 24,
                            child: DropdownButtonFormField<String>(
                              value:
                                  [
                                    'Male',
                                    'Female',
                                  ].contains(provider.selectedGender)
                                  ? provider.selectedGender
                                  : null,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              items: ['Male', 'Female']
                                  .map(
                                    (g) => DropdownMenuItem(
                                      value: g,
                                      child: customText(title: g),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) => context
                                  .read<CvScreeningProvider>()
                                  .updateGender(val),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 2. Location Information
            _buildSectionCard(
              title: 'Location Information',
              colors: colors,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('City', colors),
                          CustomTextFieldForMasterData(
                            contextIn: context,
                            controller: provider.cityController,
                            hintText: "Type to search city",
                            name: "city",
                            title: "Location",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Locality / Area', colors),
                          CustomTextFieldForMasterData(
                            contextIn: context,
                            controller: provider.localityController,
                            hintText: "Type to search locality",
                            name: "location",
                            title: "Locality",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 3. Qualifications & Languages
            _buildSectionCard(
              title: 'Qualifications & Languages',
              colors: colors,
              children: [
                _buildFieldLabel('Highest Education Level*', colors),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 24,
                  child: DropdownButtonFormField<String>(
                    value:
                        [
                          'Graduate',
                          'Under_Graduate',
                        ].contains(provider.selectedEducation)
                        ? provider.selectedEducation
                        : 'Graduate',
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Graduate',
                        child: customText(title: 'Graduate'),
                      ),
                      DropdownMenuItem(
                        value: 'Under_Graduate',
                        child: customText(title: 'Under-Graduate'),
                      ),
                    ],
                    onChanged: (val) => context
                        .read<CvScreeningProvider>()
                        .updateEducation(val),
                  ),
                ),
                const SizedBox(height: 18),

                // Education List Display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFieldLabel('Education Qualifications', colors),
                    InkWell(
                      onTap: () => _showEducationDialog(context),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFC7D2FE)),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.add_rounded,
                              size: 16,
                              color: Color(0xFF4F46E5),
                            ),
                            SizedBox(width: 4),
                            customText(
                              title: 'Add',
                              color: Color(0xFF4F46E5),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                if (provider.educationList.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Center(
                      child: customText(
                        title: 'No education details found. Tap Add to record.',
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.educationList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, idx) {
                      final edu = provider.educationList[idx];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.school_outlined,
                                size: 20,
                                color: Color(0xFF4F46E5),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                    title: edu.courseName ?? 'Course / Degree',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: const Color(0xFF1E293B),
                                  ),
                                  const SizedBox(height: 2),
                                  customText(
                                    title:
                                        '${edu.fieldOfStudy ?? "Field: N/A"} • Passing Year: ${edu.passingYear ?? "N/A"}',
                                    fontSize: 11,
                                    color: const Color(0xFF64748B),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Edit Education',
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: Color(0xFF4F46E5),
                              ),
                              onPressed: () => _showEducationDialog(
                                context,
                                item: edu,
                                index: idx,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Delete',
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                size: 18,
                                color: Color(0xFFEF4444),
                              ),
                              onPressed: () => provider.removeEducationAt(idx),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 16),
                _buildFieldLabel('Languages Known', colors),
                if (provider.isLoadingLanguage)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  )
                else
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 8,
                    runSpacing: 8,
                    children: provider.language
                        .map(
                          (e) => CustomToggleButton(
                            isSelect: provider.selectedLanguages.contains(e),
                            title: e,
                            onTap: () => provider.toggleLanguage(e),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // 4. Experience Level Section
            _buildSectionCard(
              title: 'Experience Level',
              colors: colors,
              children: [
                _buildFieldLabel('Candidate Status*', colors),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 24,
                  child: DropdownButtonFormField<String>(
                    value: provider.selectedExperienceLevel,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Fresher',
                        child: customText(title: 'Fresher (0 - 5 Months)'),
                      ),
                      DropdownMenuItem(
                        value: 'Experience',
                        child: customText(title: 'Experience (6+ Months)'),
                      ),
                    ],
                    onChanged: (val) => context
                        .read<CvScreeningProvider>()
                        .updateExperienceLevel(val),
                  ),
                ),
                if (isExperience) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Years (0 - 99)', colors),
                            CustomTextFieldforAll(
                              controller: provider.expYearsController,
                              hint: '0',
                              isNumber: true,
                              maxLength: 2,
                              isSearch: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Months (0 - 11)', colors),
                            CustomTextFieldforAll(
                              controller: provider.expMonthsController,
                              hint: '0',
                              isNumber: true,
                              maxLength: 2,
                              isSearch: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            // 5. Work History Experience Section
            _buildSectionCard(
              title: 'Work History & Past Roles',
              colors: colors,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customText(
                      title: '${provider.workHistoryCount} Stint(s) Recorded',
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                    InkWell(
                      onTap: () => _showWorkHistoryBottomSheet(context),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFC7D2FE)),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.add_rounded,
                              size: 16,
                              color: Color(0xFF4F46E5),
                            ),
                            SizedBox(width: 4),
                            customText(
                              title: 'Add Role',
                              color: Color(0xFF4F46E5),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (provider.workHistoryList.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Center(
                      child: customText(
                        title:
                            'No work history parsed. Tap Add Role if experienced.',
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.workHistoryList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, idx) {
                      final item = provider.workHistoryList[idx];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: item.disqualified
                                ? const Color(0xFFFED7AA)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText(
                                        title:
                                            item.title ?? 'Designation Not Set',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: const Color(0xFF0F172A),
                                      ),
                                      const SizedBox(height: 2),
                                      customText(
                                        title:
                                            '${item.companyName ?? "Organization"} • ${item.durationMonths} Mos',
                                        fontSize: 12,
                                        color: const Color(0xFF475569),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Edit Experience',
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                    color: Color(0xFF4F46E5),
                                  ),
                                  onPressed: () => _showWorkHistoryBottomSheet(
                                    context,
                                    item: item,
                                    index: idx,
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Delete',
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    size: 18,
                                    color: Color(0xFFEF4444),
                                  ),
                                  onPressed: () =>
                                      provider.removeWorkHistoryAt(idx),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                if (item.empType != null &&
                                    item.empType!.isNotEmpty)
                                  _buildTag(
                                    item.empType!,
                                    const Color(0xFFF1F5F9),
                                    const Color(0xFF475569),
                                  ),
                                if (item.workMode != null &&
                                    item.workMode!.isNotEmpty)
                                  _buildTag(
                                    item.workMode!,
                                    const Color(0xFFF1F5F9),
                                    const Color(0xFF475569),
                                  ),
                                if (item.location != null &&
                                    item.location!.isNotEmpty)
                                  _buildTag(
                                    item.location!,
                                    const Color(0xFFF1F5F9),
                                    const Color(0xFF475569),
                                  ),
                                if (item.disqualified)
                                  _buildTag(
                                    'Tenure Excluded (<6m/Intern/Freelance)',
                                    const Color(0xFFFFF7ED),
                                    const Color(0xFFC2410C),
                                  ),
                              ],
                            ),
                            if (item.skills.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: item.skills
                                    .take(5)
                                    .map(
                                      (s) => _buildTag(
                                        s,
                                        const Color(0xFFEEF2FF),
                                        const Color(0xFF4338CA),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // 6. Job Selection Section
            _buildSectionCard(
              title: 'Target Jobs Selection (Optional)',
              colors: colors,
              children: [
                InkWell(
                  onTap: () => _showJobSelectionBottomSheet(context),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedJobsCount > 0
                            ? const Color(0xFF4F46E5)
                            : const Color(0xFFCBD5E1),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: selectedJobsCount > 0
                          ? const Color(0xFFEEF2FF)
                          : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.work_outline_rounded,
                          size: 20,
                          color: selectedJobsCount > 0
                              ? const Color(0xFF4F46E5)
                              : const Color(0xFF64748B),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                title: selectedJobsCount > 0
                                    ? '$selectedJobsCount Job(s) Selected'
                                    : 'Select Specific Jobs',
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: selectedJobsCount > 0
                                    ? const Color(0xFF4F46E5)
                                    : const Color(0xFF1E293B),
                              ),
                              const SizedBox(height: 2),
                              customText(
                                title: selectedJobsCount > 0
                                    ? 'Tap to edit or add more'
                                    : 'Screen against all active jobs by default',
                                fontSize: 11,
                                color: const Color(0xFF64748B),
                              ),
                            ],
                          ),
                        ),
                        if (selectedJobsCount > 0)
                          IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: Color(0xFFEF4444),
                            ),
                            tooltip: 'Clear Selected Jobs',
                            onPressed: () => context
                                .read<CvScreeningProvider>()
                                .resetSelectedJobs(),
                          )
                        else
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: Color(0xFF94A3B8),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildTag(String title, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: customText(
        title: title,
        fontSize: 10,
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildFieldLabel(String label, dynamic colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: customText(
        title: label,
        color: colors.headingColor,
        fontWeight: FontWeight.w600,
        fontSize: 12,
        monst: true,
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required dynamic colors,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            title: title,
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: const Color(0xFF1E293B),
            monst: true,
          ),
          const Divider(height: 20),
          ...children,
        ],
      ),
    );
  }
}

// ================= MODAL BOTTOM SHEET FOR WORK HISTORY =================
class _WorkHistoryEditBottomSheet extends StatefulWidget {
  final WorkHistoryItem? item;
  final ValueChanged<WorkHistoryItem> onSave;

  const _WorkHistoryEditBottomSheet({this.item, required this.onSave});

  @override
  State<_WorkHistoryEditBottomSheet> createState() =>
      _WorkHistoryEditBottomSheetState();
}

class _WorkHistoryEditBottomSheetState
    extends State<_WorkHistoryEditBottomSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _companyController;
  late final TextEditingController _empTypeController;
  late final TextEditingController _workModeController;
  late final TextEditingController _locationController;
  late final TextEditingController _durationController;
  late final TextEditingController _skillsController;
  late final TextEditingController _respController;
  bool _isCurrent = false;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _titleController = TextEditingController(text: item?.title ?? '');
    _companyController = TextEditingController(text: item?.companyName ?? '');
    _empTypeController = TextEditingController(
      text: item?.empType ?? 'Full-time',
    );
    _workModeController = TextEditingController(
      text: item?.workMode ?? 'Onsite',
    );
    _locationController = TextEditingController(text: item?.location ?? '');
    _durationController = TextEditingController(
      text: (item?.durationMonths ?? 0).toString(),
    );
    _skillsController = TextEditingController(
      text: (item?.skills ?? []).join(', '),
    );
    _respController = TextEditingController(
      text: (item?.responsibilities ?? []).join('\n'),
    );
    _isCurrent = item?.current ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _empTypeController.dispose();
    _workModeController.dispose();
    _locationController.dispose();
    _durationController.dispose();
    _skillsController.dispose();
    _respController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bool isEdit = widget.item != null;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 16, 8),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customText(
                      title: isEdit
                          ? 'Edit Role Experience'
                          : 'Add Role Experience',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: const Color(0xFF0F172A),
                      monst: true,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                        color: Color(0xFF64748B),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSheetLabel('Designation / Job Title*', colors),
                  CustomTextFieldforAll(
                    controller: _titleController,
                    hint: 'e.g. Inside Sales Associate',
                    isSearch: true,
                  ),
                  const SizedBox(height: 12),

                  _buildSheetLabel('Company / Organization Name*', colors),
                  CustomTextFieldforAll(
                    controller: _companyController,
                    hint: 'e.g. Star Health Insurance',
                    isSearch: true,
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSheetLabel('Duration (Months)*', colors),
                            CustomTextFieldforAll(
                              controller: _durationController,
                              hint: 'e.g. 14',
                              isNumber: true,
                              maxLength: 3,
                              isSearch: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSheetLabel('Job Location', colors),
                            CustomTextFieldforAll(
                              controller: _locationController,
                              hint: 'e.g. Thane',
                              isSearch: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSheetLabel('Employment Type', colors),
                            CustomTextFieldforAll(
                              controller: _empTypeController,
                              hint: 'Full-time / Internship',
                              isSearch: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSheetLabel('Work Mode', colors),
                            CustomTextFieldforAll(
                              controller: _workModeController,
                              hint: 'Onsite / Remote',
                              isSearch: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  _buildSheetLabel('Skills Utilized (Comma separated)', colors),
                  CustomTextFieldforAll(
                    controller: _skillsController,
                    hint: 'tele-sales, objection handling, excel',
                    isSearch: true,
                  ),
                  const SizedBox(height: 12),

                  _buildSheetLabel(
                    'Key Responsibilities (One per line)',
                    colors,
                  ),
                  TextFormField(
                    controller: _respController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText:
                          'Enter daily duties and operational achievements...',
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF94A3B8),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Checkbox(
                        value: _isCurrent,
                        activeColor: const Color(0xFF4F46E5),
                        onChanged: (val) =>
                            setState(() => _isCurrent = val ?? false),
                      ),
                      const customText(
                        title: 'I currently work in this role',
                        fontSize: 13,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  final title = _titleController.text.trim();
                  final company = _companyController.text.trim();
                  final months =
                      int.tryParse(_durationController.text.trim()) ?? 0;

                  if (title.isEmpty && company.isEmpty) {
                    Navigator.pop(context);
                    return;
                  }

                  final emp = _empTypeController.text.trim();
                  final isDisq =
                      months < 6 ||
                      emp.toLowerCase().contains('intern') ||
                      emp.toLowerCase().contains('freelance') ||
                      emp.toLowerCase().contains('part');

                  final skills = _skillsController.text
                      .split(',')
                      .map((s) => s.trim())
                      .where((s) => s.isNotEmpty)
                      .toList();

                  final resps = _respController.text
                      .split('\n')
                      .map((s) => s.trim())
                      .where((s) => s.isNotEmpty)
                      .toList();

                  widget.onSave(
                    WorkHistoryItem(
                      title: title.isEmpty ? null : title,
                      companyName: company.isEmpty ? null : company,
                      durationMonths: months,
                      empType: emp.isEmpty ? null : emp,
                      workMode: _workModeController.text.trim().isEmpty
                          ? null
                          : _workModeController.text.trim(),
                      location: _locationController.text.trim().isEmpty
                          ? null
                          : _locationController.text.trim(),
                      responsibilities: resps,
                      skills: skills,
                      current: _isCurrent,
                      disqualified: isDisq,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const customText(
                  title: 'Save Work Experience',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetLabel(String label, dynamic colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: customText(
        title: label,
        color: colors.headingColor,
        fontWeight: FontWeight.w600,
        fontSize: 12,
        monst: true,
      ),
    );
  }
}

// ================= DIALOG FOR ADD / EDIT EDUCATION =================
class _EducationEditDialog extends StatefulWidget {
  final EducationItem? item;
  final ValueChanged<EducationItem> onSave;

  const _EducationEditDialog({this.item, required this.onSave});

  @override
  State<_EducationEditDialog> createState() => _EducationEditDialogState();
}

class _EducationEditDialogState extends State<_EducationEditDialog> {
  late final TextEditingController _courseController;
  late final TextEditingController _fieldController;
  late final TextEditingController _yearController;

  @override
  void initState() {
    super.initState();
    _courseController = TextEditingController(
      text: widget.item?.courseName ?? '',
    );
    _fieldController = TextEditingController(
      text: widget.item?.fieldOfStudy ?? '',
    );
    _yearController = TextEditingController(
      text: widget.item?.passingYear ?? '',
    );
  }

  @override
  void dispose() {
    _courseController.dispose();
    _fieldController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bool isEdit = widget.item != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Color(0xFF4F46E5),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: customText(
                    title: isEdit ? 'Edit Education' : 'Add Education',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: const Color(0xFF0F172A),
                    monst: true,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                    color: Color(0xFF64748B),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 24),

            _buildDialogLabel('Course / Degree Name*', colors),
            CustomTextFieldForMasterData(
              contextIn: context,
              controller: _courseController,
              hintText: "Search course/degree",
              name: "degree",
              title: "Course / Degree",
            ),
            const SizedBox(height: 12),

            _buildDialogLabel('Field of Study', colors),
            CustomTextFieldForMasterData(
              contextIn: context,
              controller: _fieldController,
              hintText: "Search field of study",
              name: "field_of_study",
              title: "Field of Study",
            ),
            const SizedBox(height: 12),

            _buildDialogLabel('Passing Year', colors),
            CustomTextFieldforAll(
              controller: _yearController,
              hint: 'e.g. 2024',
              isNumber: true,
              maxLength: 4,
              isSearch: true,
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const customText(
                      title: 'Cancel',
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final course = _courseController.text.trim();
                      final field = _fieldController.text.trim();
                      final year = _yearController.text.trim();

                      if (course.isEmpty && field.isEmpty && year.isEmpty) {
                        Navigator.pop(context);
                        return;
                      }

                      widget.onSave(
                        EducationItem(
                          courseName: course.isEmpty ? null : course,
                          fieldOfStudy: field.isEmpty ? null : field,
                          passingYear: year.isEmpty ? null : year,
                          universityInstitute: null,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: const customText(
                      title: 'Submit',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogLabel(String label, dynamic colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: customText(
        title: label,
        color: colors.headingColor,
        fontWeight: FontWeight.w600,
        fontSize: 12,
        monst: true,
      ),
    );
  }
}

// ================= BOTTOM SHEET FOR TARGET JOB SELECTION =================
class _JobSelectionBottomSheet extends StatefulWidget {
  const _JobSelectionBottomSheet();
  @override
  State<_JobSelectionBottomSheet> createState() =>
      _JobSelectionBottomSheetState();
}

class _JobSelectionBottomSheetState extends State<_JobSelectionBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CvScreeningProvider>();
    final activeJobs = provider.activeJobs;
    final selectedIds = provider.selectedJobIds;

    final filteredJobs = activeJobs.where((job) {
      final query = _searchQuery.toLowerCase();
      final title = (job.jobHeadline ?? '').toLowerCase();
      final role = (job.role ?? '').toLowerCase();
      final industry = (job.industry ?? '').toLowerCase();
      final id = job.jobId.toString();
      return title.contains(query) ||
          role.contains(query) ||
          industry.contains(query) ||
          id.contains(query);
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 16, 8),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const customText(
                          title: 'Select Target Jobs',
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Color(0xFF0F172A),
                          monst: true,
                        ),
                        customText(
                          title: '${selectedIds.length} job(s) selected',
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                      ],
                    ),
                    if (selectedIds.isNotEmpty)
                      TextButton(
                        onPressed: () => context
                            .read<CvScreeningProvider>()
                            .resetSelectedJobs(),
                        child: const customText(
                          title: 'Reset All',
                          color: Color(0xFFEF4444),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val.trim()),
                  decoration: InputDecoration(
                    hintText: 'Search by role, title, or industry...',
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF94A3B8),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 20,
                      color: Color(0xFF64748B),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: provider.isLoadingActiveJobs
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
                  )
                : filteredJobs.isEmpty
                ? const Center(
                    child: customText(
                      title: 'No jobs found matching search',
                      color: Color(0xFF64748B),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredJobs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final job = filteredJobs[index];
                      final isSelected = selectedIds.contains(job.jobId);
                      return InkWell(
                        onTap: () => context
                            .read<CvScreeningProvider>()
                            .toggleJobSelection(job.jobId),
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFEEF2FF)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF4F46E5)
                                  : const Color(0xFFE2E8F0),
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Icon(
                                  isSelected
                                      ? Icons.check_circle_rounded
                                      : Icons.radio_button_unchecked_rounded,
                                  color: isSelected
                                      ? const Color(0xFF4F46E5)
                                      : const Color(0xFFCBD5E1),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: customText(
                                            title:
                                                job.jobHeadline ??
                                                job.companyName ??
                                                'Job #${job.jobId}',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: const Color(0xFF0F172A),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF1F5F9),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: customText(
                                            title: '#${job.jobId}',
                                            fontSize: 11,
                                            color: const Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    customText(
                                      title:
                                          '${job.role ?? 'Role'} • ${job.industry ?? 'Industry'} • ${job.process ?? ''}',
                                      fontSize: 12,
                                      color: const Color(0xFF475569),
                                    ),
                                    if (job.functionalArea != null &&
                                        job.functionalArea!.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE0E7FF),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: customText(
                                          title: job.functionalArea!,
                                          fontSize: 10,
                                          color: const Color(0xFF3730A3),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: customText(
                  title: selectedIds.isEmpty
                      ? 'Select All Jobs (Default)'
                      : 'Apply (${selectedIds.length} Selected)',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
