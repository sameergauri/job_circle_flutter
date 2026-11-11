import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/screening/user_job_compo_model.dart';
import 'package:job_circle/src/provider/screening/cv_screening_provider.dart';
import 'package:job_circle/src/screen/screening/cv_profile_edit.dart'; // Import aapki JobSelectionBottomSheet ke liye
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class RecomputeJobsScreen extends StatefulWidget {
  const RecomputeJobsScreen({super.key});

  @override
  State<RecomputeJobsScreen> createState() => _RecomputeJobsScreenState();
}

class _RecomputeJobsScreenState extends State<RecomputeJobsScreen> {
  int? _userId;
  bool _isLoadingUser = true;
  bool _debugMode = false;

  @override
  void initState() {
    super.initState();
    // Deferred: calling this synchronously here runs while the widget tree
    // is still in its first build, and fetchActiveJobs()'s notifyListeners()
    // (fired before its first await) then tries to rebuild the
    // CvScreeningProvider's ancestor InheritedProviderScope mid-build, which
    // Flutter's framework disallows ("setState()/markNeedsBuild() called
    // during build").
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserIdAndJobs();
    });
  }

  Future<void> _loadUserIdAndJobs() async {
    final provider = context.read<CvScreeningProvider>();
    provider.clearRecomputedResults();
    // SharedPreferences me 'userId' int ya string ke roop me ho sakta hai
    final id = SharedPrefsHelper.getInt(ESharedPreferences.user_id);

    setState(() {
      _userId = id; // Agar key null ho toh 1494 fallback
      _isLoadingUser = false;
    });

    if (mounted) {
      provider.fetchActiveJobs();
    }
  }

  void _openJobSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const JobSelectionBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final provider = context.watch<CvScreeningProvider>();
    final selectedCount = provider.selectedJobIds.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: customText(
          title: 'Recompute Recommendations',
          color: colors.headingColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
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
          height: 48,
          child: ElevatedButton(
            onPressed: (_isLoadingUser || provider.isRecomputing)
                ? null
                : () async {
                    if (_userId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: customText(
                            title: 'User ID missing in local storage',
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return;
                    }

                    final success = await provider.triggerRecomputeJobs(
                      _userId!,
                      debug: _debugMode,
                    );
                    if (!mounted) return;

                    if (!success && provider.recomputeError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: customText(
                            title: provider.recomputeError!,
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
            child: provider.isRecomputing
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 12),
                      customText(
                        title: 'Recomputing Matrix...',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  )
                : customText(
                    title: selectedCount > 0
                        ? 'Run Match for $selectedCount Job(s)'
                        : 'Select Jobs to Recompute',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
          ),
        ),
      ),
      body: _isLoadingUser
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User ID & Target Selector Card
                  Container(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const customText(
                                  title: 'Candidate Target ID',
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                                const SizedBox(height: 2),
                                customText(
                                  title: 'User #$_userId',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0F172A),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const customText(
                                title: 'From Preferences',
                                fontSize: 11,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        InkWell(
                          onTap: () => _openJobSelection(context),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: selectedCount > 0
                                  ? const Color(0xFFEEF2FF)
                                  : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: selectedCount > 0
                                    ? const Color(0xFF4F46E5)
                                    : const Color(0xFFCBD5E1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.checklist_rounded,
                                  color: selectedCount > 0
                                      ? const Color(0xFF4F46E5)
                                      : const Color(0xFF64748B),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText(
                                        title: selectedCount > 0
                                            ? '$selectedCount Job(s) Selected'
                                            : 'Select Target Job IDs',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: selectedCount > 0
                                            ? const Color(0xFF4F46E5)
                                            : const Color(0xFF1E293B),
                                      ),
                                      customText(
                                        title: selectedCount > 0
                                            ? 'IDs: ${provider.selectedJobIds.join(', ')}'
                                            : 'Tap to pick specific jobs to benchmark',
                                        fontSize: 11,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  color: Color(0xFF94A3B8),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Debug toggle: when on, the recompute call asks the
                        // API for the full scoring breakdown (?debug=true)
                        // instead of just the final matches.
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: _debugMode
                                ? const Color(0xFFFFF7ED)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _debugMode
                                  ? const Color(0xFFF59E0B)
                                  : const Color(0xFFCBD5E1),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.bug_report_rounded,
                                size: 20,
                                color: _debugMode
                                    ? const Color(0xFFD97706)
                                    : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    customText(
                                      title: 'Debug Mode',
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: _debugMode
                                          ? const Color(0xFFD97706)
                                          : const Color(0xFF1E293B),
                                    ),
                                    customText(
                                      title:
                                          'Show the full scoring breakdown for each job',
                                      fontSize: 11,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: _debugMode,
                                activeThumbColor: const Color(0xFFD97706),
                                onChanged: (value) {
                                  setState(() => _debugMode = value);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Debug Insights Section (only present when the toggle
                  // above was on for the last run)
                  if (provider.recomputeDebugInfo != null) ...[
                    _buildDebugInfoSection(
                      provider.recomputeDebugInfo!,
                      provider,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Results Section Header
                  if (provider.recomputedResults.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customText(
                          title:
                              'Recomputed Output (${provider.recomputedResults.length})',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: const Color(0xFF1E293B),
                        ),
                        TextButton(
                          onPressed: () => provider.clearRecomputedResults(),
                          child: const customText(
                            title: 'Clear',
                            fontSize: 12,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.recomputedResults.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = provider.recomputedResults[index];
                        return _buildRecomputedJobCard(item);
                      },
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildRecomputedJobCard(RecomputedJobItem item) {
    final bool isRecommended = item.screeningStatus == 'RECOMMENDED';
    final Color badgeColor = isRecommended
        ? const Color(0xFF16A34A)
        : const Color(0xFFDC2626);
    final Color badgeBg = isRecommended
        ? const Color(0xFFDCFCE7)
        : const Color(0xFFFEE2E2);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Job ID & Match Score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.work_outline_rounded,
                      size: 20,
                      color: Color(0xFF4F46E5),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        title: 'Job #${item.jobId}',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: const Color(0xFF0F172A),
                      ),
                      customText(
                        title: 'Label: ${item.matchLabel}',
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  customText(
                    title: '${item.matchPercentage}%',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF4F46E5),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: customText(
                      title: item.screeningStatus,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Recruiter Summary
          if (item.recruiterSummary.isNotEmpty) ...[
            const customText(
              title: 'Recruiter Assessment',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF475569),
            ),
            const SizedBox(height: 4),
            customText(
              title: item.recruiterSummary,
              fontSize: 12,
              color: const Color(0xFF1E293B),
            ),
            const SizedBox(height: 12),
          ],

          if (item.workStatus.isNotEmpty) ...[
            const customText(
              title: 'User Work Status',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF475569),
            ),
            const SizedBox(height: 4),
            customText(
              title: item.workStatus,
              fontSize: 12,
              color: const Color(0xFF1E293B),
            ),
            const SizedBox(height: 12),
          ],

          if (item.seniorityAnalysis != null) ...[
            const customText(
              title: 'Seniority Analysis',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF475569),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                customText(
                  title:
                      "User Seniority: ${item.seniorityAnalysis!.userSeniority}",
                  fontSize: 12,
                  color: const Color(0xFF1E293B),
                ),
                customText(
                  title:
                      "Job Seniority: ${item.seniorityAnalysis!.targetJobSeniority}",
                  fontSize: 12,
                  color: const Color(0xFF1E293B),
                ),
                customText(
                  title:
                      "Is Seniority Match: ${item.seniorityAnalysis!.isSeniorityMatched ? 'Yes' : 'No'}",
                  fontSize: 12,
                  color: const Color(0xFF1E293B),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // Why Matched Chips
          if (item.whyMatched.isNotEmpty) ...[
            const customText(
              title: 'Key Strengths',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF16A34A),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: item.whyMatched
                  .map(
                    (w) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: customText(
                        title: w,
                        fontSize: 11,
                        color: const Color(0xFF15803D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
          ],

          // Missing Requirements Chips
          if (item.missingRequirements.isNotEmpty) ...[
            const customText(
              title: 'Gaps / Missing Criteria',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFFDC2626),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: item.missingRequirements
                  .map(
                    (m) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFFECACA)),
                      ),
                      child: customText(
                        title: m,
                        fontSize: 11,
                        color: const Color(0xFFB91C1C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
          ],
          if (item.actionableSuggestions.isEmpty) ...[
            Center(
              child: customText(
                title: 'No actionable suggestions available.',
                fontSize: 12,
                color: const Color(0xFF64748B),
              ),
            ),
          ],

          // Actionable Suggestions
          if (item.actionableSuggestions.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.tips_and_updates_outlined,
                    size: 16,
                    color: Color(0xFFD97706),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: item.actionableSuggestions
                          .map(
                            (s) => customText(
                              title: s,
                              fontSize: 11,
                              color: const Color(0xFF92400E),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDebugInfoSection(
    RecomputeDebugInfo debug,
    CvScreeningProvider provider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customText(
              title: 'Debug Insights',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: const Color(0xFF1E293B),
            ),
            TextButton(
              onPressed: () => provider.clearRecomputedResults(),
              child: const customText(
                title: 'Clear',
                fontSize: 12,
                color: Color(0xFFEF4444),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Summary banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.insights_rounded,
                    size: 18,
                    color: Color(0xFFD97706),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: customText(
                      title: debug.summary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF92400E),
                    ),
                  ),
                ],
              ),
              if (debug.settings != null) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _debugChip(
                      'AI ${debug.settings!.aiEnabled ? "On" : "Off"}',
                    ),
                    _debugChip(
                      'Min AI score ${debug.settings!.minStructuredScoreForAi}',
                    ),
                    _debugChip('AI top K ${debug.settings!.aiTopK}'),
                    _debugChip(
                      'Recommend >= ${debug.settings!.recommendedThreshold}',
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Candidate snapshot (collapsible)
        if (debug.user != null) _buildCandidateSnapshot(debug.user!),

        const SizedBox(height: 12),

        // Per-job debug cards
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: debug.jobs.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) =>
              _buildDebugJobCard(debug.jobs[index]),
        ),
      ],
    );
  }

  Widget _debugChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: customText(
        title: label,
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF92400E),
      ),
    );
  }

  Widget _buildCandidateSnapshot(RecomputeDebugUser user) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          leading: const Icon(
            Icons.person_search_rounded,
            color: Color(0xFF4F46E5),
          ),
          title: customText(
            title: 'Candidate Snapshot',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
          subtitle: customText(
            title: user.track,
            fontSize: 11,
            color: const Color(0xFF64748B),
          ),
          children: [
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _debugChip('${user.gender}, ${user.age}y'),
                _debugChip(
                  user.currentLocation.trim().isEmpty
                      ? '-'
                      : user.currentLocation.trim(),
                ),
                _debugChip(
                  '${(user.totalExperienceMonths / 12).toStringAsFixed(1)} yrs exp',
                ),
                _debugChip('Seniority L${user.currentSeniorityLevel}'),
                _debugChip(
                  user.jobPreferenceEnabled ? 'Open to jobs' : 'Not looking',
                ),
              ],
            ),
            if (user.educationLevels.isNotEmpty) ...[
              const SizedBox(height: 10),
              const customText(
                title: 'Education',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF475569),
              ),
              const SizedBox(height: 4),
              customText(
                title: user.educationLevels.join(', '),
                fontSize: 12,
                color: const Color(0xFF1E293B),
              ),
            ],
            if (user.languages.isNotEmpty) ...[
              const SizedBox(height: 10),
              const customText(
                title: 'Languages',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF475569),
              ),
              const SizedBox(height: 4),
              customText(
                title: user.languages.join(', '),
                fontSize: 12,
                color: const Color(0xFF1E293B),
              ),
            ],
            if (user.skills.isNotEmpty) ...[
              const SizedBox(height: 10),
              const customText(
                title: 'Skills',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF475569),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: user.skills
                    .map(
                      (s) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: customText(
                          title: s,
                          fontSize: 11,
                          color: const Color(0xFF4F46E5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
            if (user.experiences.isNotEmpty) ...[
              const SizedBox(height: 12),
              const customText(
                title: 'Experience (newest first)',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF475569),
              ),
              const SizedBox(height: 6),
              ...user.experiences.map(_buildExperienceRow),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceRow(RecomputeDebugExperience exp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: customText(
                  title: exp.title,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              if (exp.current)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const customText(
                    title: 'Current',
                    fontSize: 9,
                    color: Color(0xFF16A34A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          customText(
            title:
                '${exp.functionalArea} • ${exp.industry} • ${exp.durationMonths} mo • Tier: ${exp.aiTier} (L${exp.level})',
            fontSize: 11,
            color: const Color(0xFF64748B),
          ),
        ],
      ),
    );
  }

  Widget _buildDebugJobCard(RecomputeDebugJob debugJob) {
    final job = debugJob.job;
    final result = debugJob.result;
    final isDropped = (result?.status ?? '').toUpperCase() == 'DROPPED';
    final statusColor = isDropped
        ? const Color(0xFFDC2626)
        : const Color(0xFF16A34A);
    final statusBg = isDropped
        ? const Color(0xFFFEE2E2)
        : const Color(0xFFDCFCE7);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      title: (job != null && job.roleName.isNotEmpty)
                          ? job.roleName
                          : 'Job #${debugJob.jobId}',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                    customText(
                      title: job != null
                          ? 'Job #${debugJob.jobId} • ${job.functionalArea} • ${job.industry}'
                          : 'Job #${debugJob.jobId}',
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                  ],
                ),
              ),
              if (job != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: customText(
                    title: job.jobStatus,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF475569),
                  ),
                ),
            ],
          ),
          if (job != null) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _debugChip(job.workMode),
                _debugChip(job.levelOfHiring),
                _debugChip(job.experienceRequired),
                if (job.locationNames.isNotEmpty)
                  _debugChip(job.locationNames.join(', ')),
              ],
            ),
          ],
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Hard filters
          if (debugJob.hardFilters.isNotEmpty) ...[
            const customText(
              title: 'Hard Filters',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF475569),
            ),
            const SizedBox(height: 6),
            ...debugJob.hardFilters.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      f.passed
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      size: 15,
                      color: f.passed
                          ? const Color(0xFF16A34A)
                          : const Color(0xFFDC2626),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customText(
                            title: f.filter,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                          customText(
                            title: f.rule,
                            fontSize: 10,
                            color: const Color(0xFF64748B),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],

          // Result banner
          if (result != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isDropped
                            ? Icons.block_rounded
                            : Icons.verified_rounded,
                        size: 16,
                        color: statusColor,
                      ),
                      const SizedBox(width: 6),
                      customText(
                        title: result.status,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                      if (result.droppedAt != null) ...[
                        const SizedBox(width: 6),
                        customText(
                          title: '@ ${result.droppedAt}',
                          fontSize: 10,
                          color: statusColor,
                        ),
                      ],
                    ],
                  ),
                  if (result.reason != null && result.reason!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    customText(
                      title: result.reason!,
                      fontSize: 11,
                      color: statusColor,
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
