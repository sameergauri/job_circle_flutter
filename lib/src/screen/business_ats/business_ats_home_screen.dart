// ignore_for_file: undefined_hidden_name, unnecessary_underscores, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/business_ats/business_ats_model.dart';
import 'package:job_circle/src/provider/business_ats/business_ats_provider.dart';
import 'package:job_circle/src/screen/business_ats/business_ats_detail_page.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/bottom_sheet/custom_bottom_sheet_for_business_ats.dart'
    hide CustomListTile;
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/container/custom_remark_coontainer.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile_faq.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class BusinessAtsHomeScreen extends StatefulWidget {
  const BusinessAtsHomeScreen({super.key});

  @override
  State<BusinessAtsHomeScreen> createState() => _BusinessAtsHomeScreenState();
}

class _BusinessAtsHomeScreenState extends State<BusinessAtsHomeScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AtsProvider>().loadAtsData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _cancelSearch() {
    setState(() {
      _isSearching = false;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  bool _matchesQuery(AtsApplicant candidate) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return true;
    return candidate.fullName.toLowerCase().contains(query);
  }

  /// Groups applicants of a main tab into sub-status categories
  Map<String, List<AtsApplicant>> _groupApplicantsBySubStatus(
    List<AtsApplicant> applicants,
  ) {
    final Map<String, List<AtsApplicant>> grouped = {};

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    DateTime? parseDoi(String? doiStr) {
      if (doiStr == null || doiStr.trim().isEmpty) return null;
      try {
        return DateFormat("dd MMM yyyy").parse(doiStr.trim());
      } catch (_) {
        return DateTime.tryParse(doiStr.trim());
      }
    }

    for (final applicant in applicants) {
      final statusId = applicant.statusId;
      String subCategory = 'Other';

      if (statusId == 1) {
        subCategory = 'New';
      } else if (statusId == 2) {
        subCategory = 'Ringing';
      } else if (statusId == 15) {
        subCategory = 'Call Back';
      } else if (statusId == 5) {
        // Partition Interview Lineups by doiFormatted Date
        final doiDate = parseDoi(applicant.doiFormatted);

        if (doiDate == null) {
          subCategory = 'LineUp';
        } else {
          final doiClean = DateTime(doiDate.year, doiDate.month, doiDate.day);
          if (doiClean.isBefore(today)) {
            subCategory = 'Need To Connect';
          } else if (doiClean.isAtSameMomentAs(today)) {
            subCategory = 'Today';
          } else if (doiClean.isAtSameMomentAs(tomorrow)) {
            subCategory = 'Tomorrow';
          } else {
            subCategory = 'LineUp';
          }
        }
      } else if (statusId == 10 || statusId == 11 || statusId == 14) {
        subCategory = 'Back Out';
      } else if (statusId == 12) {
        subCategory = 'Offer';
      } else if (statusId == 13) {
        subCategory = 'Join';
      } else if (statusId == 3) {
        subCategory = 'Not Eligible';
      } else if (statusId == 9) {
        subCategory = 'Reject';
      } else if (statusId == 6 || statusId == 8) {
        subCategory = 'Revoke';
      }

      grouped.putIfAbsent(subCategory, () => []).add(applicant);
    }

    return grouped;
  }

  int _calculateCount(List<AtsApplicant>? applicants) {
    if (applicants == null || applicants.isEmpty) return 0;
    if (_isSearching && _searchQuery.trim().isNotEmpty) {
      return applicants.where(_matchesQuery).length;
    }
    return applicants.length;
  }

  // Desired Layer-1 order; each inner list holds acceptable name variants
  // for that slot, so we still match if the backend's exact wording differs.
  static const List<List<String>> _mainTabOrder = [
    ['Applied'],
    ['Interview Bey', 'Interview bey'],
    ['Not Shortlisted', 'Non Shortlisted'],
    ['Onboarding', 'Joining'],
  ];

  String _cleanTabTitle(String rawKey) => rawKey.split('(').first.trim();

  /// Reorders [keys] to match [priorityOrder] (name variants per slot);
  /// a missing slot is simply skipped so the next one takes its place.
  /// Anything not covered by [priorityOrder] keeps its original relative order at the end.
  List<String> _orderedByPriority(
    List<String> keys,
    List<List<String>> priorityOrder,
  ) {
    final result = <String>[];
    for (final aliases in priorityOrder) {
      final match = keys.firstWhere(
        (k) =>
            !result.contains(k) &&
            aliases.any(
              (a) => _cleanTabTitle(k).toLowerCase() == a.toLowerCase(),
            ),
        orElse: () => '',
      );
      if (match.isNotEmpty) result.add(match);
    }
    for (final k in keys) {
      if (!result.contains(k)) result.add(k);
    }
    return result;
  }

  /// Reorders [keys] to match [priorityOrder] exactly (no aliasing needed since
  /// these are our own generated sub-category names); a missing entry in
  /// [priorityOrder] is skipped so the next one takes its place, and anything
  /// not covered by [priorityOrder] keeps its original relative order at the end.
  List<String> _orderedKeys(List<String> keys, List<String> priorityOrder) {
    if (priorityOrder.isEmpty) return keys;
    final result = <String>[];
    for (final p in priorityOrder) {
      final match = keys.firstWhere(
        (k) => !result.contains(k) && k.toLowerCase() == p.toLowerCase(),
        orElse: () => '',
      );
      if (match.isNotEmpty) result.add(match);
    }
    for (final k in keys) {
      if (!result.contains(k)) result.add(k);
    }
    return result;
  }

  /// Sub-tab priority order, keyed off which main tab they belong to.
  List<String> _subTabPriorityFor(String mainTabKey) {
    final clean = _cleanTabTitle(mainTabKey).toLowerCase();
    if (clean == 'applied' || clean.contains('application')) {
      return const ['New', 'Call Back', 'Ringing'];
    }
    if (clean.contains('interview')) {
      return const ['Today', 'Tomorrow'];
    }
    if (clean.contains('onboarding') || clean.contains('joining')) {
      return const ['Offer', 'Join', 'Back Out'];
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Consumer<AtsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return Scaffold(
            backgroundColor: colors.bgColor,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.errorMessage != null) {
          return Scaffold(
            backgroundColor: colors.bgColor,
            body: Center(
              child: customText(
                title: provider.errorMessage!,
                color: colors.headingColor,
              ),
            ),
          );
        }

        if (provider.atsData == null || provider.atsData!.atsData.isEmpty) {
          return Scaffold(
            backgroundColor: colors.bgColor,
            body: Center(
              child: customText(
                title: 'No ATS data found',
                fontSize: 16,
                color: colors.headingColor,
              ),
            ),
          );
        }

        final atsData = provider.atsData!.atsData;

        // Filter out main status tabs that have 0 candidates, then apply the fixed order
        final activeMainTabs = _orderedByPriority(
          atsData.keys.where((key) {
            final count = _calculateCount(atsData[key]);
            return count > 0;
          }).toList(),
          _mainTabOrder,
        );

        return Scaffold(
          backgroundColor: colors.bgColor,
          appBar: AppBar(
            backgroundColor: colors.appbarColor,
            elevation: 0,
            titleSpacing: 0,
            iconTheme: IconThemeData(color: colors.headingColor),
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: TextStyle(color: colors.headingColor),
                    cursorColor: colors.headingColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search candidate by name',
                      hintStyle: TextStyle(color: colors.subTitleColor),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  )
                : customText(
                    title: "ATS",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colors.headingColor,
                  ),
            actions: [
              IconButton(
                icon: Icon(
                  _isSearching ? Icons.close : Icons.search,
                  color: colors.headingColor,
                ),
                onPressed: _isSearching ? _cancelSearch : _startSearch,
              ),
            ],
          ),
          body: activeMainTabs.isEmpty
              ? Center(
                  child: customText(
                    title: _isSearching
                        ? "No matching candidates found"
                        : "No applicants available",
                    fontSize: 14,
                    color: colors.subTitleColor,
                  ),
                )
              : DefaultTabController(
                  length: activeMainTabs.length,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Layer 1: Main Status Tabs (pill style) ---
                      Container(
                        color: colors.bgColor,
                        child: Builder(
                          builder: (tabBarContext) {
                            final tabController = DefaultTabController.of(
                              tabBarContext,
                            );
                            return AnimatedBuilder(
                              animation: tabController,
                              builder: (context, _) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    right: 12,
                                    top: 5,
                                  ),
                                  child: Row(
                                    children: activeMainTabs
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                          final index = entry.key;
                                          final tabKey = entry.value;
                                          final count = _calculateCount(
                                            atsData[tabKey],
                                          );
                                          final cleanTitle = tabKey
                                              .split('(')
                                              .first
                                              .trim();
                                          final isSelected =
                                              tabController.index == index;
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            child: CustomToggleButton(
                                              title: '$cleanTitle($count)',
                                              onTap: () {
                                                tabController.animateTo(index);
                                              },
                                              isSelect: isSelected,
                                            ),

                                            /*    GestureDetector(
                                          onTap: () =>
                                              tabController.animateTo(index),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 7,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? (colors.darkBlue ??
                                                        Constants.darkBlue)
                                                  : colors.bgColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: isSelected
                                                  ? null
                                                  : Border.all(
                                                      color:
                                                          colors
                                                              .subTitleColor ??
                                                          Colors.grey,
                                                      width: 1,
                                                    ),
                                            ),
                                            child: customText(
                                              title: '$cleanTitle($count)',
                                              color: isSelected
                                                  ? Colors.white
                                                  : colors.headingColor,
                                              fontSize: 13,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                            ),
                                          ),
                                        ), */
                                          );
                                        })
                                        .toList(),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      // --- Layer 2 View: Sub-Tabs & Candidate Lists ---
                      Expanded(
                        child: TabBarView(
                          children: activeMainTabs.map((tabKey) {
                            final rawApplicants = atsData[tabKey] ?? [];
                            final groupedSubData = _groupApplicantsBySubStatus(
                              rawApplicants,
                            );

                            return KeyedSubtree(
                              key: ValueKey(tabKey),
                              child: _buildSubStatusTabView(
                                tabKey,
                                groupedSubData,
                                colors,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  /// Builds Layer 2 Sub-Tabs and its content
  Widget _buildSubStatusTabView(
    String mainTabKey,
    Map<String, List<AtsApplicant>> groupedSubData,
    AppColors colors,
  ) {
    // Only include sub-categories with > 0 candidates, then apply the tab's fixed order
    final activeSubTabs = _orderedKeys(
      groupedSubData.keys.where((subKey) {
        final count = _calculateCount(groupedSubData[subKey]);
        return count > 0;
      }).toList(),
      _subTabPriorityFor(mainTabKey),
    );

    if (activeSubTabs.isEmpty) {
      return Center(
        child: customText(
          title: 'No candidates in this stage',
          color: colors.subTitleColor,
          fontSize: 14,
        ),
      );
    }

    return DefaultTabController(
      length: activeSubTabs.length,
      child: Column(
        children: [
          // Sub-Tabs Header (Red Underline)
          Container(
            padding: const EdgeInsets.only(bottom: 4),
            child: TabBar(
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              labelColor: colors.headingColor,
              unselectedLabelColor: colors.subTitleColor,
              indicatorColor: colors.orangeLine ?? Colors.red,
              indicatorWeight: 2.0,
              labelStyle: GoogleFonts.merriweather(
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: GoogleFonts.merriweather(
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
              tabs: activeSubTabs.map((subKey) {
                final count = _calculateCount(groupedSubData[subKey]);
                return Tab(text: '$subKey ($count)');
              }).toList(),
            ),
          ),
          // Sub-Tab Applicants List
          Expanded(
            child: TabBarView(
              children: activeSubTabs.map((subKey) {
                final applicants = groupedSubData[subKey] ?? [];
                final displayed = _isSearching && _searchQuery.trim().isNotEmpty
                    ? applicants.where(_matchesQuery).toList()
                    : applicants;

                return _buildApplicantListView(displayed, colors);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// Applicants List View
  Widget _buildApplicantListView(
    List<AtsApplicant> applicants,
    AppColors colors,
  ) {
    if (applicants.isEmpty) {
      return Center(
        child: customText(
          title: 'No applicants found',
          color: colors.subTitleColor,
          fontSize: 14,
        ),
      );
    }

    return RefreshIndicator(
      backgroundColor: colors.bgColor,
      color: Constants.darkBlue,
      onRefresh: () async {
        await context.read<AtsProvider>().loadAtsData();
      },
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: applicants.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 70),
        itemBuilder: (context, index) {
          final candidate = applicants[index];

          return Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              bottom: 4,
              top: 4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomListTile(
                  onTap: () {
                    NavigationService.push(
                      BusinessAtsDetailPage(applicant: candidate),
                    );
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFFC4C4C4),
                    backgroundImage:
                        candidate.candidateInfoDto?.profileIcon != null &&
                            candidate.candidateInfoDto!.profileIcon!
                                .trim()
                                .isNotEmpty
                        ? NetworkImage(
                            '${GlobalConstants.Image_url}${candidate.candidateInfoDto!.profileIcon}',
                          )
                        : candidate.gender == "Male"
                        ? const AssetImage(CustomAssetUrl.maleicon)
                              as ImageProvider
                        : const AssetImage(CustomAssetUrl.femalicon),
                  ),
                  title: customText(
                    title: candidate.fullName.isNotEmpty
                        ? candidate.fullName
                        : "Candidate Name",
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colors.headingColor,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: customText(
                      title:
                          'Applied for : ${candidate.roleForBusinessHiring ?? "Role"} || ${candidate.hiringFor ?? ''}',
                      fontSize: 12,
                      color: colors.subTitleColor,
                    ),
                  ),
                  trailing: candidate.statusId == 4
                      ? null
                      : IconButton(
                          onPressed: () {
                            CustomBottomShheetForAts.show(
                              context: context,
                              applicantData: candidate,
                            );
                          },
                          icon: Icon(
                            Icons.more_horiz_outlined,
                            color: colors.subTitleColor,
                          ),
                        ),
                ),
                if (candidate.statusId == 15 &&
                    candidate.call_back_date_time != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        customText(
                          title:
                              "Call Back on ${formatCallbackDate(candidate.call_back_date_time!)}",
                          color: colors.headingColor,
                        ),
                      ],
                    ),
                  ),
                if (candidate.remark != null &&
                    candidate.remark!.trim().isNotEmpty)
                  CustomRemarkConatiner(
                    subtitle: candidate.remark!,
                    valueColor: colors.subTitleColor!,
                    title: "Remark",
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  String formatCallbackDate(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) return '';
    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return rawDate;
    return DateFormat('d MMM yyyy').format(parsed);
  }
}
