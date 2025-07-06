import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/components/customTextFieldForAll.dart';
import 'package:job_circle/constants/job_detail/custom_netwrok_image.dart';
import 'package:job_circle/models/view_and_generate_model.dart';
import 'package:job_circle/screens/Billing/provider/view_and_generate_provider.dart';
import 'package:job_circle/screens/Billing/ui/Invoice.dart';
import 'package:job_circle/screens/Billing/widget/custom_joiners_card.dart';
import 'package:job_circle/screens/Manager/constant/custom_button_for_save.dart';
import 'package:job_circle/screens/Manager/constant/custom_snackbar.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

class GenerateInvoice extends ConsumerStatefulWidget {
  const GenerateInvoice({super.key});

  @override
  ConsumerState<GenerateInvoice> createState() => _GenerateInvoiceState();
}

class _GenerateInvoiceState extends ConsumerState<GenerateInvoice>
    with TickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(generateInvoiceProvider.notifier).fetchJoinersData();
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
    return ref.watch(generateInvoiceProvider).when(
          loading: () => const Scaffold(
            backgroundColor: Constants.bgColorWhite,
            body: Center(
              child: CircularProgressIndicator(
                color: Constants.darkBlue,
              ),
            ),
          ),
          error: (error, stack) => Scaffold(
            backgroundColor: Constants.bgColorWhite,
            body: Center(
              child: Text('Error: $error'),
            ),
          ),
          data: (state) {
            if (_tabController != null &&
                _tabController!.length != state.statusCategories.length) {
              _updateTabController(state.statusCategories);
            } else if (_tabController == null) {
              _updateTabController(state.statusCategories);
            }
            if (state.joinersResponse != null &&
                state.joinersResponse!.resultData != null &&
                state.joinersResponse!.resultData!.payable == null &&
                state.joinersResponse!.resultData!.notPayable == null &&
                state.joinersResponse!.resultData!.pending == null &&
                state.joinersResponse!.resultData!.joiners == null) {
              return const Scaffold(
                backgroundColor: Constants.bgColorWhite,
                body: Center(
                  child: customTextForWeather(
                    title: "No data available",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Constants.darkBlue,
                  ),
                ),
              );
            } else {
              return Scaffold(
                backgroundColor: Constants.bgColorWhite,
                /* bottomNavigationBar: state
                                .statusCategories[_tabController!.index] ==
                            'Payable' &&

                        // Check if date is selected
                        state.selectedMonth != null &&
                        state.selectedYear != null

                    /* _tabController!.index ==
                            state.statusCategories
                                .indexWhere((e) => e == 'Payable') &&
                        state.filteredResponse!.resultData!.payable!.entries
                            .first.value.isNotEmpty &&
                        state.selectedMonth != null &&
                        state.selectedYear != null */
                    ? Container(
                        padding: const EdgeInsets.only(left: 10),
                        color: Constants.borderColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customTextForWeather(
                              title:
                                  "Total Rs. ${_calculateFilteredPayableTotal(state).toString().replaceAll('.0', '')}",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Constants.darkBlue,
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
                                        true);
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Invoice(
                                          joinersdata: state.joinersResponse!
                                              .resultData!.payable!.entries
                                              .expand((e) => e.value)
                                              .where((joiner) {
                                            if (joiner.dateOfJoining == null) {
                                              return false;
                                            }

                                            try {
                                              final date = DateFormat(
                                                      'dd MMM yyyy')
                                                  .parse(joiner.dateOfJoining!);
                                              final month =
                                                  DateFormat('MM').format(date);
                                              final year = DateFormat('yyyy')
                                                  .format(date);

                                              return month ==
                                                      state.selectedMonth &&
                                                  year == state.selectedYear;
                                            } catch (e) {
                                              return false;
                                            }
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : null, */
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
                        ref
                            .read(generateInvoiceProvider.notifier)
                            .filterJoiners(query);
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
                        child: customTextForWeather(
                          title: state.selectedMonth != null &&
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
                              customTextForWeather(
                                title: "Oops!",
                                fontSize: 18,
                                color: Constants.darkBlue,
                              ),
                              customTextForWeather(
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
                              /*  onTap: (index) {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear,
                        );
                      }, */
                              tabs: state.statusCategories.map((status) {
                                return Tab(
                                  text:
                                      "$status (${state.getJoinersByStatus(status)!.length})",
                                );
                              }).toList(),
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              tabAlignment: TabAlignment.start,
                              isScrollable: true,
                              indicatorSize: TabBarIndicatorSize.label,
                              labelColor: Constants.black,
                              unselectedLabelColor: Constants.subtitleclr,
                              indicatorColor: Constants.orange,
                              labelStyle: GoogleFonts.merriweather(
                                  fontSize: 12, fontWeight: FontWeight.w700),
                              unselectedLabelStyle: GoogleFonts.merriweather(
                                  fontSize: 12, fontWeight: FontWeight.normal),
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              dragStartBehavior: DragStartBehavior.start,
                              controller: _tabController,
                              /*   onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                          _tabController?.animateTo(index);
                        });
                      }, */
                              children: state.statusCategories
                                  .map((status) => _buildJoinerList(
                                      context,
                                      state.getJoinersByStatus(status),
                                      state,
                                      status))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
              );
            }
          },
        );
  }

  num _calculateFilteredPayableTotal(GenerateInvoiceState state) {
    final allPayableJoiners = state.joinersResponse?.resultData?.payable?.values
            .expand((list) => list)
            .toList() ??
        [];

    return allPayableJoiners.where((joiner) {
      // Check attrStatus and date of joining
      if (joiner.attrStatus?.toLowerCase() != "payable" &&
          joiner.attrStatus2?.toLowerCase() != "payable") return false;
      if (joiner.dateOfJoining == null) return false;
      try {
        final date = DateFormat('dd MMM yyyy').parse(joiner.dateOfJoining!);
        final month = DateFormat('MM').format(date);
        final year = DateFormat('yyyy').format(date);
        return month == state.selectedMonth && year == state.selectedYear;
      } catch (_) {
        return false;
      }
    }).fold<num>(0, (sum, joiner) => sum + (joiner.partnerPayout ?? 0));
  }

  void _showDateFilterBottomSheet(
      BuildContext context, GenerateInvoiceState state) {
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
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
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
                      ref.read(generateInvoiceProvider.notifier).resetFilters();
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: const customTextForWeather(
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
                        final month = DateFormat('MM')
                            .format(DateFormat('MMM').parse(parts[0]));
                        final year = parts[1];

                        ref
                            .read(generateInvoiceProvider.notifier)
                            .filterByDate(month, year);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? Constants.lightdull
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.only(
                            left: 20, bottom: 10, top: 10, right: 10),
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
                                  imageUrl:
                                      "https://cdn-icons-png.flaticon.com/128/7794/7794658.png",
                                  defaultIcon: Icons.check),
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
  }

  Widget _buildJoinerList(BuildContext context, List<JoinerData>? joiners,
      GenerateInvoiceState state, String status) {
    if (joiners == null || joiners.isEmpty) {
      return const Center(
        child: customText(title: "No data available"),
      );
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
            await ref.read(generateInvoiceProvider.notifier).fetchJoinersData();
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
                  alignment: Alignment.centerLeft,
                  child: customText(
                    title: "$companyName (${companyJoiners.length})",
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Constants.darkBlue,
                  ),
                ),
                sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) {
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
                            child: Divider(
                              thickness: 1,
                              endIndent: 10,
                            ),
                          ),
                      ],
                    );
                  },
                  childCount: companyJoiners.length,
                )),
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
                padding: const EdgeInsets.only(
                  left: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextForWeather(
                      title:
                          "Total Rs. ${_calculateFilteredPayableTotal(state).toString().replaceAll('.0', '')}",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Constants.darkBlue,
                    ),
                    SizedBox(
                      width: 200,
                      child: CustomButtonForSave(
                        title: "Create Invoice",
                        onTap: () {
                          final bankdetail = state.joinersResponse!.resultData!
                              .payable!.entries.first.value.first.accountNumber;
                          if (bankdetail == null ||
                              bankdetail.isEmpty ||
                              bankdetail == "null") {
                            CustomSnackbar.show(
                                "Add banking detail to generate invoice", true);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Invoice(
                                  joinersdata: state.joinersResponse!
                                      .resultData!.payable!.entries
                                      .expand((e) => e.value)
                                      .where((joiner) {
                                    if (joiner.dateOfJoining == null) {
                                      return false;
                                    }

                                    try {
                                      final date = DateFormat('dd MMM yyyy')
                                          .parse(joiner.dateOfJoining!);
                                      final month =
                                          DateFormat('MM').format(date);
                                      final year =
                                          DateFormat('yyyy').format(date);

                                      return month == state.selectedMonth &&
                                          year == state.selectedYear;
                                    } catch (e) {
                                      return false;
                                    }
                                  }).toList(),
                                ),
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
          )
      ],
    );
  }
}
