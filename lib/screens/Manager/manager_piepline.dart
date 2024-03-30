// ignore_for_file: unused_field, unused_result, unused_local_variable, avoid_print, unused_element, non_constant_identifier_names, use_full_hex_values_for_flutter_colors, avoid_unnecessary_containers, use_build_context_synchronously
// ignore_for_file: todo
import 'dart:convert';

import 'package:awesome_calendar/awesome_calendar.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/changeStatusModel.dart';
import 'package:job_circle/models/drop_down_model.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/screens/Lead_details/lead_details.dart';
import 'package:job_circle/screens/Manager/Lead_detail/manager_lead_form.dart';
import 'package:job_circle/screens/Manager/tracking/manager_application.dart';
import 'package:job_circle/screens/Manager/tracking/manager_assign.dart';
import 'package:job_circle/screens/Manager/tracking/manager_interviewbay.dart';
import 'package:job_circle/screens/Manager/tracking/manager_lineup.dart';
import 'package:job_circle/screens/Manager/tracking/manager_negativeStatus.dart';
import 'package:job_circle/screens/Manager/tracking/manager_select.dart';
import 'package:job_circle/screens/jobs/interview_bay_executive.dart';
import 'package:job_circle/screens/jobs/pdf.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

final fetchAllManagerProvider = FutureProvider<List<Applicant>>(
    (ref) => _ManagerPipeLineState.fetchAllApplicants());

class ManagerPipeLine extends ConsumerStatefulWidget {
  const ManagerPipeLine({super.key});

  @override
  ConsumerState<ManagerPipeLine> createState() => _ManagerPipeLineState();
}

class _ManagerPipeLineState extends ConsumerState<ManagerPipeLine>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final SearchController _searchController = SearchController();
  final ScrollController _scrollController = ScrollController();

  final FocusNode _searchFocusNode = FocusNode();
  int cutTab = 0;

  List<Applicant> allLeads = [];
  List<Applicant> searchResults = [];
  Applicant? lead;
  List<Applicant> filteredLeads = [];
  List<Applicant> allLeadsData = [];
  // int statusLength = status.length;

  static const int _pageSize = 1000;

  static Future<List<Applicant>> fetchAllApplicants() async {
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/leads/v1/getAllLeadsByManagerId?userId=$userid&pageNumber=1&pageSize=1000');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> contentList = jsonData['resultData']['content'];
        List<Applicant> applicants =
            contentList.map((json) => Applicant.fromJson(json)).toList();
        return applicants;
      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error while fetching data: $e');
      return [];
    }
  }

  static Future<List<dynamic>> _fetchLeadsData() async {
    while (true) {
      final response = await http.get(Uri.parse(
          'http://${GlobalConstants.API_Host_one}/leads/v1/grid?page=1&size=$_pageSize'));

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        // Update any other logic if needed
        return parsedResponse["resultData"]["content"];
      } else {
        throw Exception('Failed to load lead data from API');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initializeState();
  }

  String getFormattedName(String? firstName, String? lastName) {
    String capitalizeFirstLetter(String? text) {
      if (text == null || text.isEmpty) {
        return '';
      }
      return text[0].toUpperCase() + text.substring(1).toLowerCase();
    }

    if (firstName == null && lastName == null) {
      return '';
    } else if (firstName == null) {
      return capitalizeFirstLetter(lastName!);
    } else if (lastName == null) {
      return capitalizeFirstLetter(firstName);
    } else {
      List<String> firstNames = firstName.split(' ');
      List<String> lastNames = lastName.split(' ');

      // Capitalize the first letter of each word in the first and last names
      for (int i = 0; i < firstNames.length; i++) {
        firstNames[i] = capitalizeFirstLetter(firstNames[i]);
      }
      for (int i = 0; i < lastNames.length; i++) {
        lastNames[i] = capitalizeFirstLetter(lastNames[i]);
      }

      if (firstNames.isNotEmpty && lastNames.isNotEmpty) {
        return '${firstNames.join(' ')} ${lastNames.join(' ')}';
      } else if (firstNames.isNotEmpty) {
        return firstNames.first;
      } else if (lastNames.isNotEmpty) {
        return lastNames.first;
      } else {
        return '';
      }
    }
  }

  String getFormattedAge(int age) {
    return age > 0
        ? '($age)'
        : ''; // Returns empty string if age is 0 or not available
  }

  List<String> storedSelectedOptions = [];
  String storedSelectedCategory = '';
  List<String> storedSelectedColumn = [];

  void onFilterDialogClosed(List<String> selectedOptions,
      String selectedCategory, List<String> selectedColumn) {
    setState(() {
      storedSelectedOptions = selectedOptions;
      storedSelectedCategory = selectedCategory;
      storedSelectedColumn = selectedColumn;
    });
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));

    ref.refresh(fetchAllManagerProvider);
  }

  bool isSearchEnable = false;

  FocusNode searchNode = FocusNode();

  String? selectedItem = "All";
  String? selectedCompany = "All";
  String? selectedLineUp = "All";
  String? selectedSpoc = "All";

  String? selectedItemForSelect = "All";

  @override
  Widget build(BuildContext context) {
    final leadData = ref.watch(fetchAllManagerProvider);

    return leadData.when(
      data: (fetchdata) {
        List<String?> LineUpItem = fetchdata
            .where((element) =>
                element.hr_status_id == 20) //TODO:: list of company for line-up
            .map((element) => [
                  element.short_name != null && element.short_name != ""
                      ? element.short_name
                      : "All",
                ]) // Map both sourceName and refername
            .expand((element) => element) // Flatten the list of lists
            .toSet()
            .toList();

        List<String?> selectItem = fetchdata
            .where((element) =>
                element.hr_status_id == 13) //TODO:: List of company for select
            .map((element) => [
                  element.short_name != null && element.short_name != ""
                      ? element.short_name
                      : "All",
                ]) // Map both sourceName and refername
            .expand((element) => element) // Flatten the list of lists
            .toSet()
            .toList();

        List<String?> items = fetchdata
            .where((element) =>
                element.hr_status_id == 14 &&
                element.status_id ==
                    1) //TODO:: List of company for interview-bay.
            .map((element) => [
                  element.short_name != null && element.short_name != ""
                      ? element.short_name
                      : "All",
                ]) // Map both sourceName and refername
            .expand((element) => element) // Flatten the list of lists
            .toSet()
            .toList();

        List<String?> spocdata = fetchdata
            .where((element) =>
                element.hr_status_id == 15 ||
                element.hr_status_id == 16 ||
                element.hr_status_id == 17 ||
                element.hr_status_id == 18 ||
                element.hr_status_id ==
                    19) //TODO:: List of company for interview-bay.
            .map((element) => [
                  element.spoc_name != null && element.spoc_name != ""
                      ? element.spoc_name
                      : "All",
                ]) // Map both sourceName and refername
            .expand((element) => element) // Flatten the list of lists
            .toSet()
            .toList();

        final allStatuses = fetchdata
            .map((lead) => lead.hr_status?.toString())
            .where((status) => status != null)
            .toSet()
            .toList();

        final lengthStatuses = fetchdata
            .map((lead) => lead.hr_status?.toString())
            .where((status) => status != null)
            .toSet()
            .toList();

        final statuses = fetchdata
            .map((lead) => lead.hr_status?.toString())
            .where((status) => status != null)
            .toSet()
            .toList();

// Remove excluded statuses
        final excludedStatuses = [
          "Wrong Number",
          "Screening Reject",
          "Hiring Hold/Closed",
          "Reject",
          "Revoke"
        ];

        final bool containsExcludedStatusLength =
            lengthStatuses.any((status) => excludedStatuses.contains(status));

        if (containsExcludedStatusLength) {
          lengthStatuses.add("Not Selected/Not shortlist");
        }

        lengthStatuses
            .removeWhere((status) => excludedStatuses.contains(status));

        lengthStatuses.sort();

        final bool containsExcludedStatus =
            allStatuses.any((status) => excludedStatuses.contains(status));

        if (containsExcludedStatus) {
          statuses.add("Not Selected/Not shortlist");
        }
        statuses.sort();

        List<String> statusWithData = [];
        List<String> excludedStatusWithData = [];

        for (String? status in statuses) {
          bool hasDataForStatus =
              fetchdata.any((lead) => lead.hr_status == status);
          if (hasDataForStatus || status == "Not Selected/Not shortlist") {
            statusWithData.add(status!);
          }
        }

        for (String? status in lengthStatuses) {
          bool hasDataForStatusExcluded =
              fetchdata.any((lead) => lead.hr_status == status);
          if (hasDataForStatusExcluded ||
              status == "Not Selected/Not shortlist") {
            excludedStatusWithData.add(status!);
          }
        }
        List<bool> enabledTabs = List.filled(statusWithData.length, true);

        List<Tab> tabs = [];

// Filter out statuses with count > 0
        final filteredStatuses = statusWithData.where((status) {
          int itemCount;
          if (status == "Not Selected/Not shortlist") {
            itemCount = fetchdata
                .where((lead) =>
                    excludedStatuses.contains(lead.hr_status.toString()) &&
                    (lead.applicantName!
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()) ||
                        lead.companyName!
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()) ||
                        lead.contactNo
                            .toString()
                            .toString()
                            .contains(_searchController.text.toLowerCase()) ||
                        lead.process!
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase())))
                .length;
          } else {
            itemCount = fetchdata
                .where((applicant) =>
                    applicant.hr_status.toString() == status &&
                    !excludedStatuses.contains(applicant.hr_status.toString()))
                .where((element) =>
                    element.applicantName!
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()) ||
                    element.companyName!
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()) ||
                    element.contactNo
                        .toString()
                        .toString()
                        .contains(_searchController.text.toLowerCase()) ||
                    element.process!
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()))
                .length;
          }

          return itemCount > 0;
        }).toList();

// Create tabs for filtered statuses
        filteredStatuses.asMap().entries.forEach((entry) {
          final index = entry.key;
          final status = entry.value;

          // Count the number of leads for the status
          int itemCount;
          if (status == "Not Selected/Not shortlist") {
            itemCount = fetchdata
                .where((lead) =>
                    excludedStatuses.contains(lead.hr_status.toString()) &&
                    (lead.applicantName!
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()) ||
                        lead.companyName!
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()) ||
                        lead.contactNo
                            .toString()
                            .toString()
                            .contains(_searchController.text.toLowerCase()) ||
                        lead.process!
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase())))
                .length;
          } else {
            itemCount = fetchdata
                .where((applicant) =>
                    applicant.hr_status.toString() == status &&
                    !excludedStatuses.contains(applicant.hr_status.toString()))
                .where((element) =>
                    element.applicantName!
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()) ||
                    element.companyName!
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()) ||
                    element.contactNo
                        .toString()
                        .toString()
                        .contains(_searchController.text.toLowerCase()) ||
                    element.process!
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()))
                .length;
          }

          // Create the Tab widget and add it to the tabs list
          tabs.add(
            Tab(
              height: MediaQuery.of(context).size.height / 30,
              text: "$status ($itemCount)",
            ),
          );
        });

        List<String> finalStatus = _searchController.text.isNotEmpty
            ? filteredStatuses.toList()
            : excludedStatusWithData.toList();

        _tabController = TabController(
            length: _searchController.text.isNotEmpty
                ? filteredStatuses.isNotEmpty
                    ? filteredStatuses.length
                    : 0
                : lengthStatuses.length,
            vsync: this,
            initialIndex: 0);
        return Stack(
          children: [
            DefaultTabController(
                length: _searchController.text.isNotEmpty
                    ? filteredStatuses.isNotEmpty
                        ? filteredStatuses.length
                        : 0
                    : lengthStatuses.length,
                initialIndex: 0,
                child: Scaffold(
                  floatingActionButton: DraggableFab(
                    child: FloatingActionButton(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        child: Icon(
                          Icons.search,
                          size: 30.sp,
                          color: Constants.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            isSearchEnable = !isSearchEnable;
                            _searchController.clear();
                          });
                          if (isSearchEnable) {
                            searchNode.requestFocus();
                          }
                        }),
                  ),
                  backgroundColor: Colors.white,
                  appBar: PreferredSize(
                    preferredSize: Size(
                        double.maxFinite,
                        isSearchEnable
                            ? kTextTabBarHeight * 1.60.sp
                            : kToolbarHeight / 1.4.sp),
                    child: AppBar(
                      automaticallyImplyLeading: false,
                      elevation: 0,
                      iconTheme: const IconThemeData(color: Colors.black),
                      backgroundColor: Colors.white,
                      title: isSearchEnable
                          ? SizedBox(
                              // margin: EdgeInsets.only(top: 10.h),
                              height: MediaQuery.of(context).size.height / 26.h,
                              child: TextField(
                                focusNode: searchNode,
                                keyboardType: TextInputType.name,
                                //textInputAction: TextInputAction.s, // Set TextInputAction to sentences
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: _searchController,
                                style: GoogleFonts.varela(
                                    color: Constants.subtitleclr,
                                    fontSize: 14.sp),
                                cursorColor: Colors.grey.shade600,
                                decoration: InputDecoration(
                                    filled: false,
                                    fillColor: Constants.borderColor,
                                    prefixIcon: const Icon(Icons.search),
                                    prefixIconColor: Colors.grey.shade400,
                                    contentPadding: const EdgeInsets.only(
                                        top: 8, bottom: 8, left: 10, right: 10),
                                    counterText: '',
                                    // labelText: "Remark",
                                    labelStyle: const TextStyle(
                                      color: Constants.themeBgColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade400),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade400),
                                    ),
                                    focusColor: const Color(0xffff0eceb),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                    hintText: "Search",
                                    hintStyle: GoogleFonts.sourceSansPro(
                                        color: Constants.hintColor,
                                        fontSize: 15.sp)),
                                onSubmitted: (value) {
                                  setState(() {
                                    isSearchEnable = !isSearchEnable;
                                  });
                                },
                                onChanged: (value) {
                                  // setState(() {});
                                  _searchController.text.isEmpty
                                      ? setState(() {
                                          isSearchEnable = !isSearchEnable;
                                        })
                                      : setState(() {});
                                },
                              ),
                            )
                          : null,
                      bottom: TabBar(
                          // physics: const NeverScrollableScrollPhysics(),
                          // controller: _tabController,
                          // Indicator color
                          indicatorColor: Colors.transparent,
                          isScrollable: true,
                          labelColor: Colors.black,
                          unselectedLabelStyle: GoogleFonts.varela(
                              fontSize: 14.sp, fontWeight: FontWeight.normal),
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: Constants.borderColor,
                              border: Border.all(
                                  color: Constants.borderColor, width: 1)),
                          // unselectedLabelColor: Colors.black,
                          labelStyle: GoogleFonts.varela(
                              fontSize: 14.sp, fontWeight: FontWeight.bold),
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: tabs),
                    ),
                  ),
                  body: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    //  controller: _tabController,
                    children: finalStatus.map((status) {
                      final spocData = fetchdata
                          .map((lead) => lead.spoc_name?.toString())
                          .where((spoc) => spoc != null)
                          .toSet()
                          .toList()
                        ..sort();

                      List<String> spocWithData = [];

                      bool hasInProcess = fetchdata.any((lead) =>
                          lead.hr_status == status &&
                          lead.hr_sub_status == null);

                      if (hasInProcess) {
                        spocWithData.add("Applied");
                      }

                      for (String? spoc in spocData) {
                        bool hasDataForSpoc = fetchdata.any((lead) =>
                            lead.hr_status == status && lead.spoc_name == spoc);
                        if (hasDataForSpoc) {
                          spocWithData
                              .add(spoc!); // Add non-null referral sources
                        }
                      }
                      List<Applicant> filteredApp = fetchdata
                          .where((lead) => (lead.hr_status == status ||
                              lead.s2HrStatus == status))
                          .where((element) =>
                              element.applicantName!.toLowerCase().contains(
                                  _searchController.text.toLowerCase()) ||
                              element.companyName!.toLowerCase().contains(
                                  _searchController.text.toLowerCase()) ||
                              element.contactNo.toString().toString().contains(
                                  _searchController.text.toLowerCase()) ||
                              element.process!.toLowerCase().contains(
                                  _searchController.text.toLowerCase()))
                          .toList();
                      if (status == 'Application') {
                        return RefreshIndicator(
                          triggerMode: RefreshIndicatorTriggerMode.anywhere,
                          displacement: 100.0,
                          color: Colors.blue,
                          onRefresh: () async {
                            await _onRefresh();
                          },
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: filteredApp.length,
                            itemBuilder: (context, index) {
                              // Build UI for each lead
                              return statusView(
                                  profilemodel.report_to!.toInt(),
                                  context,
                                  filteredApp[index],
                                  true,
                                  profilemodel.id != null
                                      ? profilemodel.id!.toInt()
                                      : 467,
                                  "${profilemodel.first_name} ${profilemodel.last_name}",
                                  index,
                                  dropDownItemList!);
                            },
                          ),
                        );
                      }
                      if (status == 'Assign') {
                        // Create tabs for each spocName
                        List<bool> enabledTabs =
                            List.filled(spocWithData.length, true);

                        return DefaultTabController(
                          length: spocWithData.length,
                          initialIndex: 0,
                          child: Scaffold(
                            backgroundColor: Colors.white,
                            appBar: PreferredSize(
                              preferredSize: Size(double.maxFinite, 36.h),
                              child: AppBar(
                                automaticallyImplyLeading: false,
                                elevation: 0,
                                iconTheme:
                                    const IconThemeData(color: Colors.black),
                                backgroundColor: Colors.white,
                                bottom: TabBar(
                                  // controller: _tabController,
                                  // Indicator color
                                  indicatorColor: Colors.transparent,
                                  isScrollable: true,
                                  labelColor: Colors.black,
                                  unselectedLabelStyle: GoogleFonts.varela(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.normal),
                                  indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color: Constants.borderColor,
                                      border: Border.all(
                                          color: Constants.borderColor,
                                          width: 1)),
                                  labelStyle: GoogleFonts.varela(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  tabs:
                                      spocWithData.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final spoc = entry.value;
                                    final filteredCount = fetchdata
                                        .where((lead) =>
                                            lead.hr_status == status &&
                                            (lead.spoc_name == spoc ||
                                                (spoc == "Applied" &&
                                                    lead.spoc_name == null)))
                                        .where((element) =>
                                            element.applicantName!
                                                .toLowerCase()
                                                .contains(
                                                  _searchController.text
                                                      .toLowerCase(),
                                                ) ||
                                            element.contactNo
                                                .toString()
                                                .toString()
                                                .contains(_searchController.text
                                                    .toLowerCase()) ||
                                            element.companyName!
                                                .toLowerCase()
                                                .contains(
                                                  _searchController.text
                                                      .toLowerCase(),
                                                ) ||
                                            element.process!
                                                .toLowerCase()
                                                .contains(
                                                  _searchController.text
                                                      .toLowerCase(),
                                                ))
                                        .length;

                                    if (filteredCount == 0) {
                                      enabledTabs[index] = false;
                                    }
                                    String tabText = spoc.isEmpty
                                        ? "Applied"
                                        : "${spoc.split(" ").first} ${spoc.split(" ")[1].substring(0, 1)}";

                                    return enabledTabs[index]
                                        ? Tab(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                30.h,
                                            text: "$tabText ($filteredCount)",
                                          )
                                        : const SizedBox(); // Return an empty SizedBox for disabled tabs
                                  }).toList(),
                                ),
                              ),
                            ),
                            body: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: spocWithData.map((spoc) {
                                List<Applicant> filteredSpoc = fetchdata
                                    .where((lead) =>
                                        (lead.hr_status == status &&
                                            lead.spoc_name.toString() ==
                                                spoc) ||
                                        (lead.hr_status == status &&
                                            lead.spoc_name == null &&
                                            spoc == "Applied"))
                                    .where((element) =>
                                        element.applicantName!
                                            .toLowerCase()
                                            .contains(_searchController.text
                                                .toLowerCase()) ||
                                        element.contactNo
                                            .toString()
                                            .toString()
                                            .contains(_searchController.text
                                                .toLowerCase()) ||
                                        element.companyName!.toLowerCase().contains(
                                            _searchController.text.toLowerCase()) ||
                                        element.process!.toLowerCase().contains(_searchController.text.toLowerCase()))
                                    .where((applicant) => applicant.hr_status.toString() == status)
                                    .toList();

                                return Column(
                                  children: [
                                    Visibility(
                                      visible: filteredSpoc.isEmpty,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              "./assets/images/nodata.gif",
                                              height: 300.0.h,
                                              width: 400.0.w,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Text(
                                                "Oops! We couldn't find any results.",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.varela(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: RefreshIndicator(
                                        triggerMode: RefreshIndicatorTriggerMode
                                            .anywhere,
                                        displacement: 100.0,
                                        color: Colors.blue,
                                        onRefresh: () async {
                                          await _onRefresh();
                                        },
                                        child: ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: filteredSpoc.length,
                                          itemBuilder: (context, index) {
                                            // Build UI for each lead
                                            return statusView(
                                                profilemodel.report_to!.toInt(),
                                                context,
                                                filteredSpoc[index],
                                                true,
                                                profilemodel.id != null
                                                    ? profilemodel.id!.toInt()
                                                    : 467,
                                                "${profilemodel.first_name} ${profilemodel.last_name}",
                                                index,
                                                dropDownItemList!);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      } else if (status == 'Line-up') {
                        final sourceData = fetchdata
                            .map((lead) => lead.spoc_name?.toString())
                            .where((company) => company != null)
                            .toSet()
                            .toList()
                          ..sort();

                        List<String> sourceWithData = [];
                        for (String? source in sourceData) {
                          // Check if there are leads associated with this  source
                          bool hasDataForReferral = fetchdata.any((lead) =>
                              lead.hr_status == status &&
                              lead.spoc_name == source);
                          if (hasDataForReferral) {
                            sourceWithData
                                .add(source!); // Add non-null referral sources
                          }
                        }
                        List<bool> enabledTabs =
                            List.filled(sourceWithData.length, true);

                        return DefaultTabController(
                          length: sourceWithData.length,
                          initialIndex: 0,
                          child: Scaffold(
                            backgroundColor: Colors.white,
                            appBar: PreferredSize(
                              preferredSize: Size(double.maxFinite, 36.h),
                              child: AppBar(
                                automaticallyImplyLeading: false,
                                elevation: 0,
                                iconTheme:
                                    const IconThemeData(color: Colors.black),
                                backgroundColor: Colors.white,
                                bottom: TabBar(
                                  indicatorColor: Colors.transparent,
                                  isScrollable: true,
                                  labelColor: Colors.black,
                                  unselectedLabelStyle: GoogleFonts.varela(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.normal),
                                  indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color: Constants.borderColor,
                                      border: Border.all(
                                          color: Constants.borderColor,
                                          width: 1)),
                                  // unselectedLabelColor: Colors.black,
                                  labelStyle: GoogleFonts.varela(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  tabs: sourceWithData
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final index = entry.key;
                                    final company = entry.value;
                                    final filteredCount = fetchdata
                                        .where((applicant) =>
                                            applicant.hr_status
                                                    .toString() ==
                                                status &&
                                            applicant
                                                    .spoc_name
                                                    .toString() ==
                                                company)
                                        .where(
                                            (element) =>
                                                selectedLineUp ==
                                                    "All" ||
                                                element
                                                        .short_name ==
                                                    selectedLineUp)
                                        .where((element) =>
                                            element
                                                .applicantName!
                                                .toLowerCase()
                                                .contains(
                                                  _searchController.text
                                                      .toLowerCase(),
                                                ) ||
                                            element
                                                .contactNo
                                                .toString()
                                                .toString()
                                                .contains(
                                                    _searchController
                                                        .text
                                                        .toLowerCase()) ||
                                            element.short_name!
                                                .toLowerCase()
                                                .contains(
                                                  _searchController.text
                                                      .toLowerCase(),
                                                ) ||
                                            element.process!
                                                .toLowerCase()
                                                .contains(
                                                  _searchController.text
                                                      .toLowerCase(),
                                                ))
                                        .length;

                                    if (filteredCount == 0) {
                                      enabledTabs[index] = false;
                                    }

                                    return enabledTabs[index]
                                        ? Tab(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                30.h,
                                            text:
                                                "${company.split(" ").first} ${company.split(" ")[1].substring(0, 1)} ($filteredCount)",
                                          )
                                        : const SizedBox(); // Return an empty SizedBox for disabled tabs
                                  }).toList(),
                                ),
                              ),
                            ),
                            body: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: sourceWithData
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                    final index = entry.key;
                                    final company = entry.value;

                                    // Check if the tab is enabled
                                    if (enabledTabs[index]) {
                                      List<Applicant> filteredReferral = fetchdata
                                          .where((lead) =>
                                              lead.hr_status == status &&
                                              lead.spoc_name.toString() ==
                                                  company)
                                          .where((element) =>
                                              selectedLineUp == "All" ||
                                              element.short_name ==
                                                  selectedLineUp)
                                          .where((element) =>
                                              element.applicantName!
                                                  .toLowerCase()
                                                  .contains(_searchController
                                                      .text
                                                      .toLowerCase()) ||
                                              element.companyName!
                                                  .toLowerCase()
                                                  .contains(_searchController
                                                      .text
                                                      .toLowerCase()) ||
                                              element.contactNo
                                                  .toString()
                                                  .toString()
                                                  .contains(
                                                      _searchController.text.toLowerCase()) ||
                                              element.process!.toLowerCase().contains(_searchController.text.toLowerCase()))
                                          .where((applicant) => applicant.hr_status.toString() == status)
                                          .toList();

                                      // Check if filteredReferral is empty
                                      if (filteredReferral.isEmpty) {
                                        return Column(
                                          children: [
                                            Image.asset(
                                              "assets/images/nodata.png",
                                              height: 300.0.h,
                                              width: 400.0.w,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Text(
                                                "Oops! We couldn't find any results.",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.varela(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      }
                                      return Column(
                                        children: [
                                          Expanded(
                                            child: RefreshIndicator(
                                              triggerMode:
                                                  RefreshIndicatorTriggerMode
                                                      .anywhere,
                                              displacement: 100.0,
                                              color: Colors.blue,
                                              onRefresh: () async {
                                                await _onRefresh();
                                              },
                                              child: ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemCount:
                                                    filteredReferral.length,
                                                itemBuilder: (context, index) {
                                                  // Build UI for each lead
                                                  return statusView(
                                                      profilemodel.report_to!
                                                          .toInt(),
                                                      context,
                                                      filteredReferral[index],
                                                      true,
                                                      profilemodel.id != null
                                                          ? profilemodel.id!
                                                              .toInt()
                                                          : 467,
                                                      "${profilemodel.first_name} ${profilemodel.last_name}",
                                                      index,
                                                      dropDownItemList!);
                                                },
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10, bottom: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                ),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    25.sp,
                                                width: 100,
                                                child: DropdownButton<String>(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  padding: EdgeInsets.zero,
                                                  underline: const SizedBox(),
                                                  // Your DropdownButton code here
                                                  style: GoogleFonts.varela(
                                                      color: Colors.black),
                                                  elevation: 0,
                                                  // isDense: false,
                                                  value: selectedLineUp,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedLineUp = newValue;
                                                    });
                                                  },
                                                  items: [
                                                    // Default item to display when nothing is selected
                                                    DropdownMenuItem<String>(
                                                      value: "All",
                                                      child: Text(
                                                        'All',
                                                        style:
                                                            GoogleFonts.varela(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ),
                                                    // Other items
                                                    ...LineUpItem.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String? value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value ?? value!,
                                                          style: GoogleFonts
                                                              .varela(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                        ),
                                                      );
                                                    }),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    } else {
                                      // Return a disabled tab
                                      return const SizedBox();
                                    }
                                  })
                                  .whereType<Widget>()
                                  .toList(),
                            ),
                          ),
                        );
                      } else if (status == 'Interview bay') {
                        // Return a default widget or null if status doesn't match 'Application' or 'Assign'
                        List<String> intervieWithData = [];
                        List<String?> interviewData = fetchdata
                            .map((lead) => lead.hr_sub_status?.toString())
                            .where((subStatus) => subStatus != null)
                            .toSet()
                            .toList()
                          ..sort();

                        // Check if there are leads with hrStatus equal to status and hrSubStatus null
                        bool hasInProcess = fetchdata.any((lead) =>
                            lead.hr_status == status &&
                            lead.hr_sub_status == null);

                        // Add "In-Process" if there are such leads
                        if (hasInProcess) {
                          intervieWithData.add("In-Process");
                        }

                        // Iterate over the interviewData to add other subStatus
                        for (String? subStatus in interviewData) {
                          // Check if there are leads associated with this subStatus
                          bool hasDataForInterview = fetchdata.any((lead) =>
                              lead.hr_status == status &&
                              lead.hr_sub_status == subStatus);
                          if (hasDataForInterview) {
                            intervieWithData.add(
                                subStatus!); // Add non-null referral sources
                          }
                        }
                        List<bool> enabledTabs =
                            List.filled(intervieWithData.length, true);

                        return DefaultTabController(
                          length: intervieWithData.length,
                          initialIndex: 0,
                          child: Scaffold(
                            backgroundColor: Colors.white,
                            appBar: PreferredSize(
                              preferredSize: Size(
                                double.maxFinite,
                                36.h,
                              ),
                              child: AppBar(
                                automaticallyImplyLeading: false,
                                elevation: 0,
                                iconTheme:
                                    const IconThemeData(color: Colors.black),
                                backgroundColor: Colors.white,
                                bottom: TabBar(
                                  indicatorColor: Colors.transparent,
                                  isScrollable: true,
                                  labelColor: Colors.black,
                                  unselectedLabelStyle: GoogleFonts.varela(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.normal),
                                  indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color: Constants.borderColor,
                                      border: Border.all(
                                          color: Constants.borderColor,
                                          width: 1)),
                                  // unselectedLabelColor: Colors.black,
                                  labelStyle: GoogleFonts.varela(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  tabs: intervieWithData
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final index = entry.key;
                                    final subStatus = entry.value;
                                    final filteredCount = fetchdata
                                        .where((lead) =>
                                            lead.hr_status == status &&
                                            (lead.hr_sub_status == subStatus ||
                                                (subStatus == "In-Process" &&
                                                    lead.hr_sub_status ==
                                                        null)))
                                        .where((element) =>
                                            selectedItem == "All" ||
                                            element.short_name == selectedItem)
                                        .where((element) =>
                                            element.applicantName!
                                                .toLowerCase()
                                                .contains(
                                                  _searchController.text
                                                      .toLowerCase(),
                                                ) ||
                                            element.companyName!
                                                .toLowerCase()
                                                .contains(
                                                  _searchController.text
                                                      .toLowerCase(),
                                                ) ||
                                            element.contactNo
                                                .toString()
                                                .toString()
                                                .contains(_searchController.text
                                                    .toLowerCase()) ||
                                            element.process!
                                                .toLowerCase()
                                                .contains(
                                                  _searchController.text
                                                      .toLowerCase(),
                                                ))
                                        .length;

                                    if (filteredCount == 0) {
                                      enabledTabs[index] = false;
                                    }
                                    String tabText = subStatus.isEmpty
                                        ? "In-Process "
                                        : "$subStatus ";

                                    return enabledTabs[index]
                                        ? Tab(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                30.h,
                                            text: "$tabText ($filteredCount)",
                                          )
                                        : const SizedBox(); // Return an empty SizedBox for disabled tabs
                                  }).toList(),
                                ),
                              ),
                            ),
                            body: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: intervieWithData
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                    final index = entry.key;
                                    final subStatus = entry.value;

                                    // Check if the tab is enabled
                                    if (enabledTabs[index]) {
                                      List<Applicant> filteredInterview = fetchdata
                                          .where((lead) =>
                                              (lead.hr_status == status &&
                                                  lead.hr_sub_status.toString() ==
                                                      subStatus) ||
                                              (lead.hr_status == status &&
                                                  lead.hr_sub_status == null &&
                                                  subStatus == "In-Process"))
                                          .where((element) =>
                                              selectedItem == "All" ||
                                              element.short_name ==
                                                  selectedItem)
                                          .where((element) =>
                                              (element.applicantName != null &&
                                                  element.applicantName!
                                                      .toLowerCase()
                                                      .contains(_searchController
                                                          .text
                                                          .toLowerCase())) ||
                                              (element.companyName!
                                                  .toLowerCase()
                                                  .contains(_searchController.text.toLowerCase())) ||
                                              element.contactNo.toString().toString().contains(_searchController.text.toLowerCase()) ||
                                              (element.process!.toLowerCase().contains(_searchController.text.toLowerCase())))
                                          .where((applicant) => applicant.hr_status.toString() == status)
                                          .toList();

                                      if (filteredInterview.isEmpty) {
                                        return Column(
                                          children: [
                                            Image.asset(
                                              "assets/images/nodata.png",
                                              height: 300.0.h,
                                              width: 400.0.w,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Text(
                                                "Oops! We couldn't find any results.",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.varela(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      }

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: RefreshIndicator(
                                              triggerMode:
                                                  RefreshIndicatorTriggerMode
                                                      .anywhere,
                                              displacement: 100.0,
                                              color: Colors.blue,
                                              onRefresh: () async {
                                                await _onRefresh();
                                              },
                                              child: ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemCount:
                                                    filteredInterview.length,
                                                itemBuilder: (context, index) {
                                                  // Build UI for each lead
                                                  return statusView(
                                                      profilemodel.report_to!
                                                          .toInt(),
                                                      context,
                                                      filteredInterview[index],
                                                      true,
                                                      profilemodel.id != null
                                                          ? profilemodel.id!
                                                              .toInt()
                                                          : 467,
                                                      "${profilemodel.first_name} ${profilemodel.last_name}",
                                                      index,
                                                      dropDownItemList!);
                                                },
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 10, bottom: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                25.sp,
                                            width: 100,
                                            child: DropdownButton<String>(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              padding: EdgeInsets.zero,
                                              underline: const SizedBox(),
                                              // Your DropdownButton code here
                                              style: GoogleFonts.varela(
                                                  color: Colors.black),
                                              elevation: 0,
                                              // isDense: false,
                                              value: selectedItem,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedItem = newValue;
                                                });
                                              },
                                              items: [
                                                // Default item to display when nothing is selected
                                                DropdownMenuItem<String>(
                                                  value: "All",
                                                  child: Text(
                                                    'All',
                                                    style: GoogleFonts.varela(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                // Other items
                                                ...items.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String? value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(
                                                      value ?? value!,
                                                      style: GoogleFonts.varela(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  );
                                                }),
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  })
                                  .whereType<Widget>()
                                  .toList(), // Filter out null values from the list
                            ),
                          ),
                        );
                      } else if (status == 'Not Selected/Not shortlist') {
                        final negativeStatuses = [
                          "Wrong Number",
                          "Screening Reject",
                          "Hiring Hold/Closed",
                          "Reject",
                          "Revoke"
                        ];

                        final negativeStatusesWithData =
                            negativeStatuses.where((negativeStatus) {
                          return fetchdata.any((lead) =>
                              lead.hr_status?.toString() == negativeStatus);
                        }).toList();
                        List<bool> enabledTabs =
                            List.filled(negativeStatusesWithData.length, true);
                        // Create tabs for each sourceName
                        return DefaultTabController(
                          length: negativeStatusesWithData.length,
                          initialIndex: 0,
                          child: Scaffold(
                            backgroundColor: Colors.white,
                            appBar: PreferredSize(
                              preferredSize: Size(double.maxFinite, 36.h),
                              child: AppBar(
                                automaticallyImplyLeading: false,
                                elevation: 0,
                                iconTheme:
                                    const IconThemeData(color: Colors.black),
                                backgroundColor: Colors.white,
                                bottom: TabBar(
                                  indicatorColor: Colors.transparent,
                                  isScrollable: true,
                                  labelColor: Colors.black,
                                  unselectedLabelStyle: GoogleFonts.varela(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.normal),
                                  indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color: Constants.borderColor,
                                      border: Border.all(
                                          color: Constants.borderColor,
                                          width: 1)),
                                  labelStyle: GoogleFonts.varela(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  tabs: negativeStatusesWithData
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final index = entry.key;
                                    final negativeStatus = entry.value;
                                    final filteredCount = fetchdata
                                        .where((applicant) =>
                                            applicant.hr_status.toString() ==
                                            negativeStatus)
                                        .where((element) =>
                                            selectedSpoc == "All" ||
                                            element.spoc_name == selectedSpoc)
                                        .where((element) =>
                                            element.applicantName!
                                                .toLowerCase()
                                                .contains(
                                                  _searchController.text
                                                      .toLowerCase(),
                                                ) ||
                                            element.contactNo
                                                .toString()
                                                .toString()
                                                .contains(_searchController.text
                                                    .toLowerCase()) ||
                                            element.companyName!
                                                .toLowerCase()
                                                .contains(
                                                  _searchController.text
                                                      .toLowerCase(),
                                                ) ||
                                            element.process!
                                                .toLowerCase()
                                                .contains(
                                                  _searchController.text
                                                      .toLowerCase(),
                                                ))
                                        .length;

                                    if (filteredCount == 0) {
                                      enabledTabs[index] = false;
                                    }

                                    return enabledTabs[index]
                                        ? Tab(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                30.h,
                                            text:
                                                "$negativeStatus ($filteredCount)",
                                          )
                                        : const SizedBox(); // Return an empty SizedBox for disabled tabs
                                  }).toList(),
                                ),
                              ),
                            ),
                            body: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: negativeStatusesWithData
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                    final index = entry.key;
                                    final negativeStatus = entry.value;
                                    if (enabledTabs[index]) {
                                      List<Applicant> filteredNegativeStatus = fetchdata
                                          .where((lead) =>
                                              lead.hr_status.toString() ==
                                              negativeStatus)
                                          .where((element) =>
                                              selectedSpoc == "All" ||
                                              element.spoc_name == selectedSpoc)
                                          .where((element) =>
                                              element.applicantName!
                                                  .toLowerCase()
                                                  .contains(_searchController.text
                                                      .toLowerCase()) ||
                                              element.contactNo
                                                  .toString()
                                                  .toString()
                                                  .contains(_searchController.text
                                                      .toLowerCase()) ||
                                              element.companyName!
                                                  .toLowerCase()
                                                  .contains(_searchController
                                                      .text
                                                      .toLowerCase()) ||
                                              element.process!.toLowerCase().contains(_searchController.text.toLowerCase()))
                                          .toList();

                                      if (filteredNegativeStatus.isEmpty) {
                                        return Column(
                                          children: [
                                            Image.asset(
                                              "./assets/images/nodata.gif",
                                              height: 300.0.h,
                                              width: 400.0.w,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Text(
                                                "Oops! We couldn't find any results.",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.varela(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      }

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: RefreshIndicator(
                                              triggerMode:
                                                  RefreshIndicatorTriggerMode
                                                      .anywhere,
                                              displacement: 100.0,
                                              color: Colors.blue,
                                              onRefresh: () async {
                                                await _onRefresh();
                                              },
                                              child: ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                controller: _scrollController,
                                                itemCount:
                                                    filteredNegativeStatus
                                                        .length,
                                                itemBuilder: (context, index) {
                                                  // Build UI for each lead
                                                  return statusView(
                                                      profilemodel.report_to!
                                                          .toInt(),
                                                      context,
                                                      filteredNegativeStatus[
                                                          index],
                                                      true,
                                                      profilemodel.id != null
                                                          ? profilemodel.id!
                                                              .toInt()
                                                          : 467,
                                                      "${profilemodel.first_name} ${profilemodel.last_name}",
                                                      index,
                                                      dropDownItemList!);
                                                },
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 10, bottom: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                25.sp,
                                            //width: 100,
                                            child: DropdownButton<String>(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              padding: EdgeInsets.zero,
                                              underline: const SizedBox(),
                                              // Your DropdownButton code here
                                              style: GoogleFonts.varela(
                                                  color: Colors.black),
                                              elevation: 0,
                                              // isDense: false,
                                              value: selectedSpoc,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedSpoc = newValue;
                                                });
                                              },
                                              items: [
                                                // Default item to display when nothing is selected
                                                DropdownMenuItem<String>(
                                                  value: "All",
                                                  child: Text(
                                                    'All',
                                                    style: GoogleFonts.varela(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                // Other items
                                                ...spocdata.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String? value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(
                                                      value ?? value!,
                                                      style: GoogleFonts.varela(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  );
                                                }),
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  })
                                  .whereType<Widget>()
                                  .toList(),
                            ),
                          ),
                        );
                      } else if (status == 'Select') {
                        // Return a default widget or null if status doesn't match 'Application' or 'Assign'
                        List<String> selectWithData = [];
                        List<String?> interviewData = fetchdata
                            .map((lead) => lead.hr_sub_status?.toString())
                            .where((subStatus) => subStatus != null)
                            .toSet()
                            .toList()
                          ..sort();

                        // Check if there are leads with hrStatus equal to status and hrSubStatus null
                        bool hasInSelected = fetchdata.any((lead) =>
                            lead.hr_status == status &&
                            lead.hr_sub_status == null);

                        // Add "In-Process" if there are such leads
                        if (hasInSelected) {
                          selectWithData.add("Selected");
                        }

                        // Iterate over the interviewData to add other subStatus
                        for (String? subStatus in interviewData) {
                          // Check if there are leads associated with this subStatus
                          bool hasDataForSelect = fetchdata.any((lead) =>
                              lead.hr_status == status &&
                              lead.hr_sub_status == subStatus);
                          if (hasDataForSelect) {
                            selectWithData.add(
                                subStatus!); // Add non-null referral sources
                          }
                        }

                        List<bool> enabledTabs =
                            List.filled(selectWithData.length, true);

                        return DefaultTabController(
                          length: selectWithData.length,
                          initialIndex: 1,
                          child: Scaffold(
                            backgroundColor: Colors.white,
                            appBar: PreferredSize(
                              preferredSize: Size(double.maxFinite, 36.h),
                              child: AppBar(
                                automaticallyImplyLeading: false,
                                elevation: 0,
                                iconTheme:
                                    const IconThemeData(color: Colors.black),
                                backgroundColor: Colors.white,
                                bottom: TabBar(
                                  // controller: _tabController,
                                  // Indicator color
                                  indicatorColor: Colors.transparent,
                                  isScrollable: true,
                                  labelColor: Colors.black,
                                  unselectedLabelStyle: GoogleFonts.varela(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.normal),
                                  indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color: Constants.borderColor,
                                      border: Border.all(
                                          color: Constants.borderColor,
                                          width: 1)),
                                  // unselectedLabelColor: Colors.black,
                                  labelStyle: GoogleFonts.varela(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  tabs: selectWithData
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final index = entry.key;
                                    final subStatus = entry.value;
                                    final filteredCount = fetchdata
                                        .where((lead) =>
                                            lead.hr_status == status &&
                                            (lead.hr_sub_status == subStatus ||
                                                (subStatus == "Selected" &&
                                                    lead.hr_sub_status ==
                                                        null)))
                                        .where((element) =>
                                            selectedItemForSelect == "All" ||
                                            element.short_name ==
                                                selectedItemForSelect)
                                        .where((element) =>
                                            element.applicantName!
                                                .toLowerCase()
                                                .contains(
                                                  _searchController.text
                                                      .toLowerCase(),
                                                ) ||
                                            element.companyName!
                                                .toLowerCase()
                                                .contains(
                                                  _searchController.text
                                                      .toLowerCase(),
                                                ) ||
                                            element.contactNo
                                                .toString()
                                                .toString()
                                                .contains(_searchController.text
                                                    .toLowerCase()) ||
                                            element.process!
                                                .toLowerCase()
                                                .contains(
                                                  _searchController.text
                                                      .toLowerCase(),
                                                ))
                                        .length;

                                    if (filteredCount == 0) {
                                      enabledTabs[index] = false;
                                    }
                                    String tabText =
                                        subStatus.isEmpty || subStatus == ""
                                            ? "Selected"
                                            : subStatus;

                                    return enabledTabs[index]
                                        ? Tab(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                30.h,
                                            text: "$tabText ($filteredCount)",
                                          )
                                        : const SizedBox(); // Return an empty SizedBox for disabled tabs
                                  }).toList(),
                                ),
                              ),
                            ),
                            body: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: selectWithData
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                    final index = entry.key;
                                    final subStatus = entry.value;

                                    // Check if the tab is enabled
                                    if (enabledTabs[index]) {
                                      List<Applicant> filteredSelect = fetchdata
                                          .where((lead) =>
                                              (lead.hr_status == status &&
                                                  lead.hr_sub_status.toString() ==
                                                      subStatus) ||
                                              (lead.hr_status == status &&
                                                  lead.hr_sub_status == null &&
                                                  subStatus == "Selected"))
                                          .where((element) =>
                                              selectedItemForSelect == "All" ||
                                              element.short_name ==
                                                  selectedItemForSelect)
                                          .where((element) =>
                                              (element.applicantName != null && element.applicantName!.toLowerCase().contains(_searchController.text.toLowerCase())) ||
                                              element.contactNo
                                                  .toString()
                                                  .toString()
                                                  .contains(_searchController.text
                                                      .toLowerCase()) ||
                                              (element.companyName!
                                                  .toLowerCase()
                                                  .contains(_searchController.text.toLowerCase())) ||
                                              (element.process!.toLowerCase().contains(_searchController.text.toLowerCase())))
                                          .where((applicant) => applicant.hr_status.toString() == status)
                                          .toList();

                                      if (filteredSelect.isEmpty) {
                                        return Column(
                                          children: [
                                            Image.asset(
                                              "assets/images/nodata.png",
                                              height: 300.0.h,
                                              width: 400.0.w,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Text(
                                                "Oops! We couldn't find any results.",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.varela(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      }

                                      return Column(
                                        children: [
                                          Expanded(
                                            child: RefreshIndicator(
                                              triggerMode:
                                                  RefreshIndicatorTriggerMode
                                                      .anywhere,
                                              displacement: 100.0,
                                              color: Colors.blue,
                                              onRefresh: () async {
                                                await _onRefresh();
                                              },
                                              child: ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemCount:
                                                    filteredSelect.length,
                                                itemBuilder: (context, index) {
                                                  // Build UI for each lead
                                                  return statusView(
                                                      profilemodel.report_to!
                                                          .toInt(),
                                                      context,
                                                      filteredSelect[index],
                                                      true,
                                                      profilemodel.id != null
                                                          ? profilemodel.id!
                                                              .toInt()
                                                          : 467,
                                                      "${profilemodel.first_name} ${profilemodel.last_name}",
                                                      index,
                                                      dropDownItemList!);
                                                },
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10, bottom: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                ),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    25.sp,
                                                // width: 100,
                                                child: DropdownButton<String>(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  padding: EdgeInsets.zero,
                                                  underline: const SizedBox(),
                                                  // Your DropdownButton code here
                                                  style: GoogleFonts.varela(
                                                      color: Colors.black),
                                                  elevation: 0,
                                                  // isDense: false,
                                                  value: selectedItemForSelect,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedItemForSelect =
                                                          newValue;
                                                    });
                                                  },
                                                  items: [
                                                    // Default item to display when nothing is selected
                                                    DropdownMenuItem<String>(
                                                      value: "All",
                                                      child: Text(
                                                        'All',
                                                        style:
                                                            GoogleFonts.varela(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ),
                                                    // Other items
                                                    ...selectItem.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String? value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value ?? value!,
                                                          style: GoogleFonts
                                                              .varela(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                        ),
                                                      );
                                                    }),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    } else {
                                      // Return a disabled tab
                                      return const SizedBox();
                                    }
                                  })
                                  .whereType<Widget>()
                                  .toList(),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }).toList(),
                  ),
                )),
          ],
        );
      },
      loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (error, stackTrace) {
        return const Scaffold(
          body: Center(
            child: Text("Failed to get Lead Data"),
          ),
        );
      },
    );
  }

  List<DropDownItem>? dropDownItemList = [];

  void fetchData() async {
    try {
      // applicationList = await getApplicationStatusList();
      dropDownItemList = await getDropDownData();
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<List<DropDownItem>> getDropDownData() async {
    try {
      final response = await http.get(Uri.parse(
          "http://${GlobalConstants.API_Host}/status_dd/v1?page=1&size=100"));

      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        final Map<String, dynamic> responseData = json.decode(response.body);

        final List<dynamic> content = responseData['resultData']['content'];

        // Map each item in the 'content' list to a DropDownItem
        final List<DropDownItem> dropDownModelList =
            content.map((item) => DropDownItem.fromJson(item)).toList();

        return dropDownModelList;
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load dropdown data');
      }
    } catch (e) {
      // Handle any exceptions that occur during the process
      print('Error: $e');
      throw Exception('Exception while fetching dropdown data');
    }
  }

  ProfileSummaryModel profilemodel = ProfileSummaryModel();
  Future<void> bindProfileSummary() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var result = await UserDataService().getUserProfileSummary(
      await Utils.getPreferencesValue(
        prefs,
        ESharedPreferences.user_id.name,
      ),
    );
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      var dataResult = Utils.parseResponse(result).resultData;
      setState(() {
        profilemodel = ProfileSummaryModel.fromJson(dataResult);
      });
    } else {
      // Handle the case when the API call fails
      setState(() {
        profilemodel =
            ProfileSummaryModel(); // or set it to an appropriate default value
      });
    }
  }

  Future<void> initializeState() async {
    await bindProfileSummary();
    fetchData();
  }

  int calculateAge(String dateOfBirth) {
    DateTime now = DateTime.now();
    DateTime dob = DateTime.parse(dateOfBirth);

    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }

    return age;
  }

//
//
//
//
//
//
//
//
//
//
//
  Widget statusView(
      int reportTo,
      BuildContext context,
      Applicant item,
      bool isTrue,
      int id,
      String sourceName,
      int index,
      List<DropDownItem> dropDownMode) {
    List<String>? finalinterviewRounds = item.inteviewrounds
        ?.map((round) => round
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll('"', '')
            .trim())
        .expand((formattedRound) => formattedRound.split(','))
        .toSet()
        .map((round) => round.trim())
        .where((round) => round.isNotEmpty)
        .toList();
    int selectedRoundIndex = item.interview_rounds != null
        ? finalinterviewRounds!.indexOf(item.interview_rounds.toString())
        : 0;

    List<DropDownItem>? finalDropDownItem = dropDownItemList!
        .where((element) =>
            element.statusId == item.dd_hr_status_id ||
            element.statusId == item.hr_status_id)
        .toList();

    List<DropDownItem>? finalDropDownItemforReadyOffer = dropDownItemList!
        .where(
            (element) => element.priStatusId == 15 || element.priStatusId == 17)
        .where((element) => element.statusId == item.hr_status_id)
        .toList();
    List<DropDownItem>? finalDropDownItemforJoinNot = dropDownItemList!
        .where(
            (element) => element.priStatusId == 18 || element.priStatusId == 16)
        .where((element) =>
            element.statusId == item.hr_status_id || element.statusId == 13)
        .toList();

    List<DropDownItem>? dropDownItemForLineUp =
        dropDownItemList!.where((element) => element.statusId == 20).toList();

    List<DropDownItem>? finalDropDownItemforTrainingDrop =
        dropDownItemList! //TODO: List where we have

            .where((element) => element.priStatusId == 19)
            .toList();

    List<dynamic> finalInterviewRounds = item.inteviewrounds
            ?.map((round) => round
                .replaceAll('[', '')
                .replaceAll(']', '')
                .replaceAll('"', ''))
            .expand((formattedRound) => formattedRound.split(', '))
            .where((formattedRound) => formattedRound.isNotEmpty)
            .toSet() // Convert to set to remove duplicates
            .toList() ??
        []; // Convert back to list
    /* List<String> finalinterviewRounds = item.inteviewrounds
            ?.map((round) => round
                .replaceAll('[', '')
                .replaceAll(']', '')
                .replaceAll('"', ''))
            .expand((formattedRound) => formattedRound.split(', '))
            .toSet()
            .toList() ??
        []; */

    DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
    DateTime today = DateTime.now();
    DateTime? doj;
    if (item.doj != null) {
      doj = DateTime(item.doj!.year, item.doj!.month, item.doj!.day);
    }
    DateTime today1 = DateTime(today.year, today.month, today.day);

    bool isToday = doj != null && doj.isAtSameMomentAs(today1);

    DateTime yesterday = today1.subtract(const Duration(days: 1));
    bool isYesterday = doj != null && doj.isAtSameMomentAs(yesterday);

    DateTime initialDate = DateTime.now();
    DateTime lastAllowedDate = DateTime.now().add(const Duration(days: 4 * 31));
    DateTime? singleSelect;

    // Replace with your stored date
    const Duration threshold = Duration(days: 6); // 6 days threshold

    bool isWithinThreshold(DateTime currentDate) {
      return doj != null
          ? currentDate.isAfter(doj.subtract(threshold)) &&
              currentDate.isBefore(doj)
          : false;
    }

    bool isDateWithinThreshold = isWithinThreshold(today1);

    Future<void> singleSelectPicker() async {
      final DateTime? picked = await showDialog<DateTime>(
        context: context,
        builder: (BuildContext context) {
          return AwesomeCalendarDialog(
            initialDate: initialDate,
            startDate: initialDate,
            endDate: lastAllowedDate,
            selectionMode: SelectionMode.single,
            cancelBtnText: "",
            confirmBtnText: "Submit",
          );
        },
      );
      if (picked != null) {
        setState(() {
          singleSelect = picked;
        });
        print(picked);
        NewChangeStatusModel changeStatusModel =
            NewChangeStatusModel(doj: picked);
        Map<String, dynamic> jsonData = changeStatusModel.toJson();
        try {
          await JobPostApiService.NewchangeStatus(jsonData, item.id!.toInt());
          ref.refresh(fetchAllManagerProvider);
          ref.refresh(fetchAllExecutiveProvide);
          setState(() {});
          // First pop to close the dialog
        } catch (e) {
          print('Error: $e');
          // Handle error...
        }
      }
    }

    return item.hr_status_id != 0
        ? Container(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: item.is_ref == 1
                          ? Constants.themeBgColorLight
                          : Colors.white,
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0.5, 2),
                            blurRadius: 2,
                            spreadRadius: 2,
                            color: Colors.grey.shade200)
                      ],
                      borderRadius: BorderRadius.circular(8.r)),
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          children: [
                            Visibility(
                                visible: item.hr_status_id == 11 ||
                                    item.s2DdHrStatusId ==
                                        11, //TODO:: Application
                                child: ManagerApplication(
                                  item: item,
                                  report_to: reportTo,
                                  dropDownItemList: dropDownItemList!,
                                  id: id,
                                  sourcename: sourceName,
                                )),
                            Visibility(
                                visible: item.hr_status_id == 12 ||
                                    item.s2DdHrStatusId == 12, //TODO:: Assign
                                child: GestureDetector(
                                  onDoubleTap: () async {
                                    SharedPreferences pref =
                                        await Utils.getSharedPreferences();
                                    var userType =
                                        await Utils.getPreferencesValue(pref,
                                            ESharedPreferences.user_type.name);
                                    var userrole =
                                        await Utils.getPreferencesValue(
                                            pref, ESharedPreferences.role.name);
                                    var userid =
                                        await Utils.getPreferencesValue(pref,
                                            ESharedPreferences.user_id.name);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LeadDetailPage(
                                                  report_to: reportTo,
                                                  source_name: sourceName,
                                                  //TODO:: Send to lead Details page
                                                  userid: userid,
                                                  id: item.jobId,
                                                  userrole: userrole,
                                                  userType: userType,
                                                  item: item,
                                                )));
                                  },
                                  child: ManagerAssign(
                                      myLineUp: item.sourceId == profilemodel.id
                                          ? true
                                          : false,
                                      item: item,
                                      dropDownItemList: dropDownItemList!),
                                )),
                            Visibility(
                                visible: item.hr_status_id == 14 ||
                                    item.s2DdHrStatusId ==
                                        14, //TODO:: InterViewBay
                                child: GestureDetector(
                                  onDoubleTap: () async {
                                    SharedPreferences pref =
                                        await Utils.getSharedPreferences();
                                    var userType =
                                        await Utils.getPreferencesValue(pref,
                                            ESharedPreferences.user_type.name);
                                    var userrole =
                                        await Utils.getPreferencesValue(
                                            pref, ESharedPreferences.role.name);
                                    var userid =
                                        await Utils.getPreferencesValue(pref,
                                            ESharedPreferences.user_id.name);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LeadDetailPage(
                                                  report_to: reportTo,
                                                  source_name: sourceName,
                                                  //TODO:: Send to lead Details page
                                                  userid: userid,
                                                  id: item.jobId,
                                                  userrole: userrole,
                                                  userType: userType,
                                                  item: item,
                                                )));
                                  },
                                  child: ManagerInterViewBayStatus(
                                    item: item,
                                    dropDownItemList: dropDownItemList!,
                                    finalDropDownItem: finalDropDownItem,
                                    finalinterviewRounds: finalinterviewRounds,
                                    selectedRoundIndex: selectedRoundIndex,
                                  ),
                                )),
                            Visibility(
                                visible: item.hr_status_id == 20 ||
                                    item.s2DdHrStatusId == 20, //TODO:: Line-up

                                child: GestureDetector(
                                  onDoubleTap: () async {
                                    SharedPreferences pref =
                                        await Utils.getSharedPreferences();
                                    var userType =
                                        await Utils.getPreferencesValue(pref,
                                            ESharedPreferences.user_type.name);
                                    var userrole =
                                        await Utils.getPreferencesValue(
                                            pref, ESharedPreferences.role.name);
                                    var userid =
                                        await Utils.getPreferencesValue(pref,
                                            ESharedPreferences.user_id.name);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LeadDetailPage(
                                                  report_to: reportTo,
                                                  source_name: sourceName,
                                                  //TODO:: Send to lead Details page
                                                  userid: userid,
                                                  id: item.jobId,
                                                  userrole: userrole,
                                                  userType: userType,
                                                  item: item,
                                                )));
                                  },
                                  child: ManagerLineUp(
                                      mylineup: item.sourceId == profilemodel.id
                                          ? true
                                          : false,
                                      item: item,
                                      dropDownItemList: dropDownItemForLineUp),
                                )),
                            Visibility(
                                visible: item.dd_hr_status_id == 13 ||
                                    item.s2DdHrStatusId == 13, //TODO:: Select
                                child: GestureDetector(
                                  onDoubleTap: () async {
                                    SharedPreferences pref =
                                        await Utils.getSharedPreferences();
                                    var userType =
                                        await Utils.getPreferencesValue(pref,
                                            ESharedPreferences.user_type.name);
                                    var userrole =
                                        await Utils.getPreferencesValue(
                                            pref, ESharedPreferences.role.name);
                                    var userid =
                                        await Utils.getPreferencesValue(pref,
                                            ESharedPreferences.user_id.name);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LeadDetailPage(
                                                  report_to: reportTo,
                                                  source_name: sourceName,
                                                  //TODO:: Send to lead Details page
                                                  userid: userid,
                                                  id: item.jobId,
                                                  userrole: userrole,
                                                  userType: userType,
                                                  item: item,
                                                )));
                                  },
                                  child: ManagerSelect(
                                      item: item,
                                      finalDropDownItemforJoinNot:
                                          finalDropDownItemforJoinNot,
                                      finalDropDownItemforReadyOffer:
                                          finalDropDownItemforReadyOffer,
                                      finalDropDownItemForTrainingDrop:
                                          finalDropDownItemforTrainingDrop),
                                )),
                            Visibility(
                                visible: item.hr_status_id == 15 ||
                                    item.hr_status_id == 16 ||
                                    item.hr_status_id == 17 ||
                                    item.hr_status_id == 18 ||
                                    item.hr_status_id == 19,
                                //TODO:: Hiring Hold/Closed
                                child: GestureDetector(
                                  onDoubleTap: () async {
                                    SharedPreferences pref =
                                        await Utils.getSharedPreferences();
                                    var userType =
                                        await Utils.getPreferencesValue(pref,
                                            ESharedPreferences.user_type.name);
                                    var userrole =
                                        await Utils.getPreferencesValue(
                                            pref, ESharedPreferences.role.name);
                                    var userid =
                                        await Utils.getPreferencesValue(pref,
                                            ESharedPreferences.user_id.name);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LeadDetailPage(
                                                  report_to: reportTo,
                                                  source_name: sourceName,
                                                  //TODO:: Send to lead Details page
                                                  userid: userid,
                                                  id: item.jobId,
                                                  userrole: userrole,
                                                  userType: userType,
                                                  item: item,
                                                )));
                                  },
                                  child: ManagerNegative(
                                    item: item,
                                    finalinterviewRounds: finalinterviewRounds,
                                    selectedRoundIndex: selectedRoundIndex,
                                  ),
                                ))
                          ],
                        );
                      },
                    ),
                  ),
                ),
                if (item.resume != null)
                  Positioned(
                    right: 0,
                    child: Column(
                      children: [
                        if (item.hr_status_id != 11)
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ManagerLeadForm(
                                              leads: item,
                                            )));
                              },
                              icon: Image.asset(
                                "assets/images/pencil.png",
                                height: 15.sp,
                              )),
                        if (item.hr_status_id == 11)
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PDFViewerScreen(
                                      isCC: false,
                                      isCvDownloaded: item.hr_status_id == 14
                                          ? item.isCvDownload != null
                                              ? item.isCvDownload!.toInt()
                                              : 0
                                          : 1,

                                      pdfAssetPath: item.resume.toString(),
                                      phoneNumber1: item.contactNo!.toInt(),
                                      isref: false,
                                      id: item.id,
                                      phoneNumber2: item.alternateNo != null
                                          ? item.alternateNo!.toInt()
                                          : 0,
                                      name:
                                          "${item.applicantName} ${item.last_name}",

                                      // Replace with the actual asset path of your PDF file
                                    ),
                                  ),
                                );
                              },
                              icon: Image.asset(
                                "assets/images/cv.png",
                                height: 15.h,
                              )),
                      ],
                    ),
                  ),
              ],
            ),
          )
        : const SizedBox();
  }
}
