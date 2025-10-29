// screens/Billing/ui/generate_invoice.dart
// ignore_for_file: curly_braces_in_flow_control_structures, deprecated_member_use

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/model/referal_program/joiners_model.dart';
import 'package:job_circle/src/provider/referal_program/joiners_provider.dart';
import 'package:job_circle/src/screen/referal_program/invoice.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/salary_round_off.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/referal_program/custom_joiners_card.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class JoinersHomePage extends StatefulWidget {
  const JoinersHomePage({super.key});

  @override
  State<JoinersHomePage> createState() => _JoinersHomePageState();
}

class _JoinersHomePageState extends State<JoinersHomePage>
    with TickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<GenerateInvoiceProvider>(
        context,
        listen: false,
      );
      provider.fetchJoinersData();
    });
  }

  void _updateTabController(List<String> statusCategories) {
    if (_tabController != null) {
      _tabController!.dispose();
    }
    _tabController = TabController(
      length: statusCategories.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GenerateInvoiceProvider>(
      builder: (context, provider, child) {
        final state = provider.state;

        if (state.isLoading) {
          return const Scaffold(
            backgroundColor: Constants.white,
            body: Center(
              child: CircularProgressIndicator(color: Constants.darkBlue),
            ),
          );
        }

        if (state.error != null) {
          return Scaffold(
            backgroundColor: Constants.white,
            body: Center(child: Text('Error: ${state.error}')),
          );
        }

        if (state.joinersResponse != null &&
            state.joinersResponse!.resultData != null &&
            state.joinersResponse!.resultData!.payable == null &&
            state.joinersResponse!.resultData!.notPayable == null &&
            state.joinersResponse!.resultData!.pending == null &&
            state.joinersResponse!.resultData!.joiners == null) {
          return const Scaffold(
            backgroundColor: Constants.white,
            body: Center(
              child: customText(
                title: "No data available",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Constants.darkBlue,
              ),
            ),
          );
        }

        if (_tabController != null &&
            _tabController!.length != state.statusCategories.length) {
          _updateTabController(state.statusCategories);
        } else if (_tabController == null &&
            state.statusCategories.isNotEmpty) {
          _updateTabController(state.statusCategories);
        }

        return Scaffold(
          backgroundColor: Constants.white,
          appBar: AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: Constants.black),
            backgroundColor: Constants.borderColor,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CustomTextFieldforAll(
                isSearch: true,
                controller: searchController,
                isGmail: true,
                hint: "Search Candidate",
                onChanged: (query) {
                  provider.filterJoiners(query);
                },
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton(
                  onPressed: () {
                    _showDateFilterBottomSheet(context, state);
                  },
                  child: customText(
                    title:
                        state.selectedMonth != null &&
                            state.selectedYear != null
                        ? "${DateFormat('MMM').format(DateFormat('MM').parse(state.selectedMonth!))} ${state.selectedYear}"
                        : "Month",
                    fontWeight: FontWeight.bold,
                    color: Constants.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          body: state.statusCategories.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        customText(
                          title: "Oops!",
                          fontSize: 18,
                          color: Constants.darkBlue,
                        ),
                        customText(
                          textAlign: TextAlign.center,
                          title:
                              "We couldn't find any candidate matching your search",
                          fontSize: 16,
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      child: TabBar(
                        controller: _tabController,
                        tabs: state.statusCategories.map((status) {
                          return Tab(
                            text:
                                "$status (${state.getJoinersByStatus(status)!.length})",
                          );
                        }).toList(),
                        overlayColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                        tabAlignment: TabAlignment.start,
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: Constants.black,
                        unselectedLabelColor: Constants.subtitleclr,
                        indicatorColor: Constants.orange,
                        labelStyle: GoogleFonts.merriweather(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        unselectedLabelStyle: GoogleFonts.merriweather(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        dragStartBehavior: DragStartBehavior.start,
                        controller: _tabController,
                        children: state.statusCategories
                            .map(
                              (status) => _buildJoinerList(
                                context,
                                state.getJoinersByStatus(status),
                                state,
                                status,
                                provider,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  num _calculateFilteredPayableTotal(GenerateInvoiceState state) {
    final allPayableJoiners =
        state.joinersResponse?.resultData?.payable?.values
            .expand((list) => list)
            .toList() ??
        [];

    return allPayableJoiners
        .where((joiner) {
          if (joiner.attrStatus?.toLowerCase() != "payable" &&
              joiner.attrStatus2?.toLowerCase() != "payable")
            return false;
          if (joiner.dateOfJoining == null) return false;
          try {
            final date = DateFormat('dd MMM yyyy').parse(joiner.dateOfJoining!);
            final month = DateFormat('MM').format(date);
            final year = DateFormat('yyyy').format(date);
            return month == state.selectedMonth && year == state.selectedYear;
          } catch (_) {
            return false;
          }
        })
        .fold<num>(0, (sum, joiner) => sum + (joiner.partnerPayout ?? 0));
  }

  void _showDateFilterBottomSheet(
    BuildContext context,
    GenerateInvoiceState state,
  ) {
    final allJoiners = [
      ...(state.joinersResponse?.resultData?.joiners?.values
              .expand((list) => list)
              .toList() ??
          []),
      ...(state.joinersResponse?.resultData?.pending?.values
              .expand((list) => list)
              .toList() ??
          []),
      ...(state.joinersResponse?.resultData?.payable?.values
              .expand((list) => list)
              .toList() ??
          []),
      ...(state.joinersResponse?.resultData?.notPayable?.values
              .expand((list) => list)
              .toList() ??
          []),
    ];

    final availableDates = <String>{};

    for (var joiner in allJoiners) {
      if (joiner.dateOfJoining != null) {
        try {
          final date = DateFormat('dd MMM yyyy').parse(joiner.dateOfJoining!);
          availableDates.add(DateFormat('MMM yyyy').format(date));
        } catch (e) {
          // skip invalid date
        }
      }
    }

    final sortedDates = List<String>.from(availableDates)
      ..sort((a, b) {
        final dateA = DateFormat('MMM yyyy').parse(a);
        final dateB = DateFormat('MMM yyyy').parse(b);
        return dateB.compareTo(dateA); // Descending: latest first
      });

    showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.3),
      backgroundColor: Colors.transparent,
      elevation: 1,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer<GenerateInvoiceProvider>(
          builder: (context, provider, child) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const customText(
                        title: "Month",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue,
                      ),
                      InkWell(
                        onTap: () {
                          provider.resetFilters();
                          NavigationService.pop();
                        },
                        child: const customText(
                          title: "Reset",
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: sortedDates.length,
                      itemBuilder: (context, index) {
                        final date = sortedDates[index];
                        return InkWell(
                          onTap: () {
                            final parts = date.split(' ');
                            final month = DateFormat(
                              'MM',
                            ).format(DateFormat('MMM').parse(parts[0]));
                            final year = parts[1];

                            provider.filterByDate(month, year);
                            NavigationService.pop();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: index % 2 == 0
                                  ? Constants.lightdull
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.only(
                              left: 20,
                              bottom: 10,
                              top: 10,
                              right: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                customText(
                                  title: date,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                if (state.selectedMonth != null &&
                                    state.selectedYear != null &&
                                    date ==
                                        "${DateFormat('MMM').format(DateFormat('MM').parse(state.selectedMonth!))} ${state.selectedYear}")
                                  const CustomNetworkImage(
                                    color: Constants.darkBlue,
                                    imageUrl: CustomIconUrl.locicon,
                                    defaultIcon: Icons.check,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildJoinerList(
    BuildContext context,
    List<JoinerData>? joiners,
    GenerateInvoiceState state,
    String status,
    GenerateInvoiceProvider provider,
  ) {
    if (joiners == null || joiners.isEmpty) {
      return const Center(child: customText(title: "No data available"));
    }

    final Map<String, List<JoinerData>> groupedJoiners = {};
    for (var joiner in joiners) {
      groupedJoiners
          .putIfAbsent(joiner.organizationName ?? 'Unknown', () => [])
          .add(joiner);
    }
    final sortedEntries = groupedJoiners.entries.toList()
      ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));

    final dateFormat = DateFormat('dd MMM yyyy');

    return Stack(
      children: [
        RefreshIndicator(
          color: Constants.darkBlue,
          onRefresh: () async {
            await provider.fetchJoinersData();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: sortedEntries.map((entry) {
              final companyName = entry.key;
              final companyJoiners = List.from(entry.value)
                ..sort((a, b) {
                  final dateA = dateFormat.parse(a.dateOfJoining.trim());
                  final dateB = dateFormat.parse(b.dateOfJoining.trim());
                  return dateA.compareTo(dateB);
                });

              return SliverStickyHeader(
                header: Container(
                  color: Constants.lightdull,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 6,
                  ),
                  alignment: Alignment.centerLeft,
                  child: customText(
                    title: "$companyName (${companyJoiners.length})",
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Constants.darkBlue,
                  ),
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final joiner = companyJoiners[index];
                    final isLast = index == companyJoiners.length - 1;
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            // NavigationService.push(JoinersDetail(applicant: joiner));
                          },
                          child: CustomJoinerCard(
                            joiner: joiner,
                            context: context,
                          ),
                        ),
                        if (!isLast)
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Divider(thickness: 1, endIndent: 10),
                          ),
                      ],
                    );
                  }, childCount: companyJoiners.length),
                ),
              );
            }).toList(),
          ),
        ),
        if (status.toLowerCase() == 'payable' &&
            state.selectedMonth != null &&
            state.selectedYear != null &&
            joiners.isNotEmpty)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: kToolbarHeight,
              child: Container(
                color: Constants.borderColor,
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const customText(
                          title: "Total Rs. ",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Constants.darkBlue,
                        ),
                        customText(
                          title: SalaryRoundOff.customRoundOff(
                            _calculateFilteredPayableTotal(state).toString(),
                          ),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Constants.darkBlue,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 200,
                      child: CustomButtonForSave(
                        title: "Create Invoice",
                        onTap: () {
                          final bankdetail = state
                              .joinersResponse!
                              .resultData!
                              .payable!
                              .entries
                              .first
                              .value
                              .first
                              .accountNumber;
                          if (bankdetail == null ||
                              bankdetail.isEmpty ||
                              bankdetail == "null") {
                            CustomSnackbar.show(
                              "Add banking detail to generate invoice",
                              true,
                            );
                          } else {
                            NavigationService.push(
                              InvoiceScreen(
                                joinersdata: state
                                    .joinersResponse!
                                    .resultData!
                                    .payable!
                                    .entries
                                    .expand((e) => e.value)
                                    .where((joiner) {
                                      if (joiner.dateOfJoining == null) {
                                        return false;
                                      }
                                      try {
                                        final date = DateFormat(
                                          'dd MMM yyyy',
                                        ).parse(joiner.dateOfJoining!);
                                        final month = DateFormat(
                                          'MM',
                                        ).format(date);
                                        final year = DateFormat(
                                          'yyyy',
                                        ).format(date);

                                        return month == state.selectedMonth &&
                                            year == state.selectedYear;
                                      } catch (e) {
                                        return false;
                                      }
                                    })
                                    .toList(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
