import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/components/customTextFieldForAll.dart';
import 'package:job_circle/constants/job_detail/custom_netwrok_image.dart';
import 'package:job_circle/models/view_and_generate_model.dart';
import 'package:job_circle/screens/Billing/ui/Invoice.dart';
import 'package:job_circle/screens/Billing/widget/custom_joiners_card.dart';
import 'package:job_circle/screens/Billing/provider/view_and_generate_provider.dart';
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
  final PageController _pageController = PageController();
  int _currentPage = 0;
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
    _tabController!.addListener(() {
      if (_tabController!.index != _currentPage) {
        setState(() {
          _currentPage = _tabController!.index;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _pageController.dispose();
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

            return Scaffold(
              backgroundColor: Constants.bgColorWhite,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButtonAnimator:
                  FloatingActionButtonAnimator.scaling,
              /*   floatingActionButton: _currentPage ==
                      state.statusCategories.indexWhere((e) => e == 'Payable') */
              floatingActionButton: _currentPage ==
                          state.statusCategories
                              .indexWhere((e) => e == 'Payable') &&
                      state.filteredResponse!.resultData!.payable!.entries.first
                          .value.isNotEmpty &&
                      state.selectedMonth != null &&
                      state.selectedYear != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customTextForWeather(
                          title:
                              "Total: Rs${state.getTotalPayable().toStringAsFixed(2)}",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Constants.darkBlue,
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 200,
                          child: CustomButtonForSave(
                            title: "Create Invoice",
                            onTap: () {
                              if (state
                                      .joinersResponse!
                                      .resultData!
                                      .payable!
                                      .entries
                                      .first
                                      .value
                                      .first
                                      .isBankDetailsAdded !=
                                  1) {
                                CustomSnackbar.show(
                                    "Add banking detail to generate invoice",
                                    true);
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Invoice(
                                              joinersdata: state
                                                  .joinersResponse!
                                                  .resultData!
                                                  .payable!
                                                  .entries
                                                  .expand((e) => e.value)
                                                  .toList(),
                                            )));
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  : null,
              appBar: AppBar(
                iconTheme: const IconThemeData(color: Constants.black),
                backgroundColor: Constants.borderColor,
                titleSpacing: 0,
                title: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CustomTextFieldforAll(
                    isSearch: true,
                    controller: searchController,
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
                      child: customText(
                        title: state.selectedMonth != null &&
                                state.selectedYear != null
                            ? "${DateFormat('MMM').format(DateFormat('MM').parse(state.selectedMonth!))} ${state.selectedYear}"
                            : "Select Date",
                        fontWeight: FontWeight.bold,
                        color: Constants.black,
                      ),
                    ),
                  ),
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      onTap: (index) {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear,
                        );
                      },
                      tabs: state.statusCategories
                          .map((status) => Tab(text: status))
                          .toList(),
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
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
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                          _tabController?.animateTo(index);
                        });
                      },
                      children: state.statusCategories
                          .map((status) => _buildJoinerList(
                              context, state.getJoinersByStatus(status)))
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
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

    final sortedDates = availableDates.toList()..sort();

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
                    title: "Date Of Joining",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                  ),
                  InkWell(
                    onTap: () {
                      ref
                          .read(generateInvoiceProvider.notifier)
                          .filterByDate(null, null);
                      Navigator.pop(context);
                    },
                    child: const customTextForWeather(
                      title: "Clear All",
                      fontSize: 14,
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

  Widget _buildJoinerList(BuildContext context, List<JoinerData>? joiners) {
    if (joiners == null || joiners.isEmpty) {
      return const Center(
        child: customText(title: "No data available"),
      );
    }

    final Map<String, List<JoinerData>> groupedJoiners = {};
    for (var joiner in joiners) {
      groupedJoiners
          .putIfAbsent(joiner.companyName ?? 'Unknown', () => [])
          .add(joiner);
    }

    return ListView(
      children: groupedJoiners.entries.map((entry) {
        final companyName = entry.key;
        final companyJoiners = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Constants.lightdull,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
              alignment: Alignment.centerLeft,
              child: customText(
                title: companyName,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Constants.darkBlue,
              ),
            ),
            ...companyJoiners.asMap().entries.map((mapEntry) {
              final index = mapEntry.key;
              final joiner = mapEntry.value;
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
            }),
          ],
        );
      }).toList(),
    );
  }
}
