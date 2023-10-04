import 'dart:convert';

import 'package:awesome_calendar/awesome_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_circle/constants/customDialogue.dart';
import 'package:job_circle/constants/custom_dialogue_select.dart';
import 'package:job_circle/constants/custom_dialogue_update_crpf_in_new.dart';
import 'package:job_circle/constants/customdialogue_for_join.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/changeStatusModel.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/models/job_details_model.dart';
import 'package:job_circle/screens/jobs/pdf.dart';
import 'package:job_circle/screens/jobs/recruitz.dart';
import 'package:job_circle/service/data_get_api_service.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/utils.dart';
import '../../constants/customdialogue_for_call_whatsapp.dart';
import '../../constants/customtoggle.dart';
import '../../constants/drop_down_class.dart';
import '../../models/application_status_model.dart';
import '../../models/interview_rounds_model.dart';
import '../../models/profileSummary.dart';
import '../../service/UserDataService.dart';
import '../../themes/colors.dart';

//enum Issue { no, incorrect, recruiter, other }

final fetchAllApplicantProvider = FutureProvider.family<List<Applicant>, int>(
    (ref, id) => _InterViewBayState.fetchAllApplicants(id));

class InterViewBay extends ConsumerStatefulWidget {
  const InterViewBay({
    super.key,
  });

  @override
  ConsumerState<InterViewBay> createState() => _InterViewBayState();
}

class _InterViewBayState extends ConsumerState<InterViewBay>
    with TickerProviderStateMixin {
  JobDetailsModel jobDetailsModel = JobDetailsModel();
  ProfileSummaryModel profilemodel = ProfileSummaryModel();
  @override
  Future<List<Applicant>>? _applicantsFuture;
  List<Application>? applicationList = [];

  Future<List<Application>> getApplicationStatusList() async {
    final url = Uri.parse(
        "http://${GlobalConstants.API_Host}/master/v1/getByGroups?groupName=appl_status&pageNumber=1&pageSize=100");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final applicationModel = ApplicationStatusModel.fromJson(jsonBody);

      if (applicationModel.resultData?.content != null) {
        // Filter the list based on the condition for application status text
        final filteredList = applicationModel.resultData!.content!
            .where((element) =>
                element.code!.contains(":") || element.code!.contains(";"))
            .toList();
        return filteredList;
      } else {
        // If the content is null, return an empty list
        return [];
      }
    } else {
      // If the request fails, throw an exception or handle the error as needed
      throw Exception('Failed to load data');
    }
  }

  void fetchData() async {
    try {
      ApplicationAPI api = ApplicationAPI();
      applicationList = await getApplicationStatusList();

      // Use the applicationList as needed
      // For example, you can print the groupName of each Application object:
      // for (var application in applicationList) {
      // print(applicationList.map((e) => e.value));
      // }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> _onRefresh() async {
    // Perform a global refresh (e.g., fetch new data for all tabs)
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      ref.refresh(fetchAllApplicantProvider(profilemodel.id!.toInt()));
      // Update the UI with new data
    });
    _refreshController
        .refreshCompleted(); // Call this to end the refresh animation
  }

  @override
  void initState() {
    super.initState();
    initializeState();
  }

  Future<void> initializeState() async {
    await bindProfileSummary();
    fetchData();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    fetchTabData();
    // await fetchAllApplicants(profilemodel.id!.toInt());
    //  _applicantsFuture = fetchApplicantsByUserId(552);
  }

  @override
  void dispose() {
    // Don't forget to dispose of the animation controller
    _animationController.dispose();
    super.dispose();
  }

  Map<int, String> selectedStatusMap = {};

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

  static Future<List<Applicant>> fetchAllApplicants(int userId) async {
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/leads/v1/getAllAppliedJobs?userId1=$userId&userId2=$userId&page=1&size=1000');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> contentList = jsonData['resultData']['content'];

        // Convert the list of Map to a list of Applicant objects
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

  String convertSalaryFormat(String input) {
    // Extract numeric values from the input string
    List<int> salaryValues = [
      for (var value in input.split('-'))
        if (int.tryParse(value.trim().replaceAll(RegExp(r'[^\d]'), '')) != null)
          int.parse(value.trim().replaceAll(RegExp(r'[^\d]'), ''))
    ];

    if (salaryValues.length == 2) {
      int startValue = salaryValues[0];
      int endValue = salaryValues[1];

      if (input.contains('Per Month')) {
        if (startValue >= 1000) {
          double shortStartValue = startValue / 100000.0;
          double shortEndValue = endValue / 100000.0;
          return '${shortStartValue.toStringAsFixed(shortStartValue.truncateToDouble() == shortStartValue ? 0 : 1)}k - ${shortEndValue.toStringAsFixed(shortEndValue.truncateToDouble() == shortEndValue ? 0 : 1)}k Per Month';
        } else {
          return '$startValue - $endValue Per Month';
        }
      } else if (input.contains("Lac's P.A")) {
        if (startValue >= 100000) {
          double shortStartValue = startValue / 1000000.0;
          double shortEndValue = endValue / 10000000.0;
          return "${shortStartValue.toStringAsFixed(shortStartValue.truncateToDouble() == shortStartValue ? 0 : 1)} Lac's - ${shortEndValue.toStringAsFixed(shortEndValue.truncateToDouble() == shortEndValue ? 0 : 1)} Lac's P.A";
        } else {
          return '$startValue - $endValue Per Year';
        }
      }
    }

    // Handle other cases, or return the input as it is if it doesn't match any pattern
    return input;
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

  String? selectedStatusValue;

  List<String> getStatuses(List<Applicant> applicants) {
    return applicants
        .where((e) => e.status_code!.contains('IB'))
        .where((element) =>
            element.status_code !=
            "IB8") //TODO: to remove disqualify and reject from tab bar
        .where((element) => element.status_code != "IB6")
        .map((e) => e.status.toString())
        .toSet()
        .toList()
      ..sort();
  }

/*   List<String> getStatuses(List<Applicant> applicants) {
    return applicants
        .map((e) => e.status.toString())
        .toSet()
        .toList()
        .where((status) =>
            status == 'Application' ||
            status == 'Assign' ||
            status == 'Screening Reject' ||
            status == 'S-Reject')
        .toList()
      ..sort();
  } */

  bool isSelect = false;
  bool isSearchVisible = false;
  final FocusNode _searchFocusNode = FocusNode();

  bool _showRejectTextField = false;
  bool _showremarkfordropandNotJoin = false;

  void toggleSearchVisibility() {
    setState(() {
      isSearchVisible = !isSearchVisible;
    });
  }

  late AnimationController _animationController;

  Map<int, SelectedOption> selectedValueMap = {};
  final GlobalKey<_InterViewBayState> _talentPollKey =
      GlobalKey<_InterViewBayState>();

  Map<int, String> selectedRoundsMap = {};

  void updateSelectedRoundForJob(int jobId, String selectedRound) {
    setState(() {
      selectedRoundsMap[jobId] = selectedRound;
    });
  }

  bool _isVi = false, isf2f = false;
  late TabController customTabController;

  List<Applicant>? applicants; // Holds fetched data
  bool isLoading = true; // Indicates whether data is loading
  String? error; // Holds error message, if any

  Future<void> fetchTabData() async {
    try {
      List<Applicant> data = await fetchAllApplicants(profilemodel.id!.toInt());
      setState(() {
        applicants = data;
        isLoading = false;
        error = null;
      });
    } catch (e) {
      setState(() {
        applicants = null;
        isLoading = false;
        error = "An error occurred: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (profilemodel == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      var fetchApplicants = profilemodel.id != null
          ? ref.watch(fetchAllApplicantProvider(profilemodel.id!.toInt()))
          : null;

      // Build your widget's UI with the 'profilemodel' data
      // For example:
      return PageStorage(
          bucket: PageStorageBucket(),
          key: const PageStorageKey<String>("futureKey"),
          child: fetchApplicants != null
              ? fetchApplicants.when(
                  data: (fetchdata) {
                    /* fetchApplicants = ref
                .refresh(fetchAllApplicantProvider(profilemodel.id!.toInt())); */ //TODO: to refresh data from api.
                    List<Applicant>? dataList = fetchdata;

                    // Define a flag to track if any item meets the condition
                    bool anyItemMeetsCondition = false;

                    for (Applicant item in dataList) {
                      if (item.status_code!.contains("IB")) {
                        // If the condition is met for any item, set the flag to true and break the loop
                        anyItemMeetsCondition = true;
                        break;
                      }
                    }

                    if (anyItemMeetsCondition) {
                      final data = fetchdata;
                      final statuses =
                          getStatuses(data); // Get the statuses here

                      return DefaultTabController(
                          length: statuses.length,
                          child: Scaffold(
                            appBar: PreferredSize(
                              preferredSize: Size(
                                  double.maxFinite, kTextTabBarHeight / 1.2.h),
                              child: AppBar(
                                elevation: 0,
                                backgroundColor: Colors.white,
                                bottom: TabBar(
                                  key: const ValueKey("ccTab2"),
                                  labelPadding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  labelColor: Colors.black,
                                  isScrollable: true,
                                  unselectedLabelColor: Colors.black,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  splashBorderRadius: BorderRadius.circular(8),
                                  indicatorWeight: 7.h,
                                  indicatorPadding: EdgeInsets.only(
                                      bottom: 8.h, left: 3.w, right: 3.w),
                                  indicator: BoxDecoration(
                                    color: Constants.borderColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Constants.borderColor),
                                  ),
                                  tabs: statuses
                                      .map(
                                        (status) => customTab(
                                          status, // Show status in the top-level tab bar
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                            body: SmartRefresher(
                              enablePullDown: true,
                              controller: _refreshController,
                              onRefresh: _onRefresh,
                              child: NestedScrollView(
                                headerSliverBuilder: (BuildContext context,
                                    bool innerBoxIsScrolled) {
                                  return <Widget>[];
                                },
                                body: TabBarView(
                                  key: const ValueKey("ccTabView2"),
                                  children:
                                      statuses.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final status = entry.value;
                                    // Filter applicants based on the current status
                                    final applicants = data
                                        .where((applicant) =>
                                            applicant.status.toString() ==
                                            status)
                                        .toList();

                                    // Check if sub_status is null or not
                                    if (status == "Reject") {
                                      // Display applicants directly without sub_status tabs
                                      return ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: applicants.length,
                                        itemBuilder: (context, index) {
                                          final applicant = applicants[index];
                                          return listViewItem_new(
                                            context,
                                            applicant,
                                            true,
                                            statuses,
                                            profilemodel.id != null
                                                ? profilemodel.id!.toInt()
                                                : 467,
                                            index,
                                          );
                                        },
                                      );
                                    } else if (status == "In-Process") {
                                      List<String> companyTab = applicants
                                          .where((applicant) =>
                                              applicant.status_code == "IB5")
                                          .map((applicant) =>
                                              applicant.short_name.toString())
                                          .toSet()
                                          .toList()
                                        ..sort();
                                      customTabController = TabController(
                                          length: companyTab.length,
                                          vsync: this);
                                      //TODO: Add custom tab controller
                                      return DefaultTabController(
                                        length: companyTab.length,
                                        child: Scaffold(
                                          appBar: PreferredSize(
                                            preferredSize: const Size(
                                                double.maxFinite,
                                                kTextTabBarHeight),
                                            child: AppBar(
                                              backgroundColor: Colors.white,
                                              bottom: TabBar(
                                                controller: customTabController,
                                                key: const ValueKey("ccTab3"),
                                                isScrollable: true,
                                                indicatorSize:
                                                    TabBarIndicatorSize.tab,
                                                unselectedLabelStyle:
                                                    GoogleFonts.varela(),
                                                labelStyle: GoogleFonts.varela(
                                                    fontWeight:
                                                        FontWeight.w600),
                                                unselectedLabelColor:
                                                    Colors.black,
                                                labelColor:
                                                    Constants.subtitleclr,
                                                indicatorPadding:
                                                    EdgeInsets.only(
                                                        bottom: 8.h,
                                                        left: 3.w,
                                                        right: 3.w),
                                                indicator: isSelect
                                                    ? BoxDecoration(
                                                        color: Constants
                                                            .borderColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        border: Border.all(
                                                            color: Constants
                                                                .borderColor))
                                                    : null,
                                                indicatorColor:
                                                    Constants.borderColor,
                                                tabs: companyTab
                                                    .map((companyName) =>
                                                        Tab(text: companyName))
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                          body: TabBarView(
                                            controller: customTabController,
                                            key: const ValueKey("ccTabView3"),
                                            children: companyTab
                                                .asMap()
                                                .entries
                                                .map((e) {
                                              final index = e.key;
                                              final status = e.value;
                                              // Filter applicants based on the current company name and status
                                              final filteredApplicants =
                                                  applicants
                                                      .where((applicant) =>
                                                          applicant
                                                                  .status_code ==
                                                              "IB5" &&
                                                          applicant.short_name
                                                                  .toString() ==
                                                              e.value)
                                                      .toList();

                                              return SingleChildScrollView(
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      filteredApplicants.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final applicant =
                                                        filteredApplicants[
                                                            index];

                                                    return listViewItem_new(
                                                      context,
                                                      applicant,
                                                      true,
                                                      statuses,
                                                      profilemodel.id != null
                                                          ? profilemodel.id!
                                                              .toInt()
                                                          : 467,
                                                      index,
                                                    );
                                                  },
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    }

                                    //TODO: Substatus as per company in select tab

                                    else if (status == "New") {
                                      List<String> companyTab = applicants
                                          .map((applicant) =>
                                              applicant.short_name.toString())
                                          .toSet()
                                          .toList()
                                        ..sort();
                                      customTabController = TabController(
                                          length: companyTab.length,
                                          vsync: this);
                                      //TODO: Add custom tab controller
                                      return DefaultTabController(
                                        length: companyTab.length,
                                        child: Scaffold(
                                          appBar: PreferredSize(
                                            preferredSize: const Size(
                                                double.maxFinite,
                                                kTextTabBarHeight),
                                            child: AppBar(
                                              backgroundColor: Colors.white,
                                              bottom: TabBar(
                                                controller: customTabController,
                                                key: const ValueKey("ccTab3"),
                                                isScrollable: true,
                                                indicatorSize:
                                                    TabBarIndicatorSize.tab,
                                                unselectedLabelStyle:
                                                    GoogleFonts.varela(),
                                                labelStyle: GoogleFonts.varela(
                                                    fontWeight:
                                                        FontWeight.w600),
                                                unselectedLabelColor:
                                                    Colors.black,
                                                labelColor:
                                                    Constants.subtitleclr,
                                                indicatorPadding:
                                                    EdgeInsets.only(
                                                        bottom: 8.h,
                                                        left: 3.w,
                                                        right: 3.w),
                                                indicator: isSelect
                                                    ? BoxDecoration(
                                                        color: Constants
                                                            .borderColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        border: Border.all(
                                                            color: Constants
                                                                .borderColor))
                                                    : null,
                                                indicatorColor:
                                                    Constants.borderColor,
                                                tabs: companyTab
                                                    .map((companyName) =>
                                                        Tab(text: companyName))
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                          body: PageStorage(
                                            bucket: PageStorageBucket(),
                                            key: PageStorageKey<String>(status),
                                            child: TabBarView(
                                              controller: customTabController,
                                              key: const ValueKey("ccTabView3"),
                                              children: companyTab
                                                  .asMap()
                                                  .entries
                                                  .map((e) {
                                                final index = e.key;
                                                final status = e.value;
                                                // Filter applicants based on the current company name and status
                                                final filteredApplicants =
                                                    applicants
                                                        .where((applicant) =>
                                                                applicant
                                                                    .short_name
                                                                    .toString() ==
                                                                e.value /* &&   //Before 02-09-2023 if want previous then 
                                                applicant.sub_code == "IB7-5"  */
                                                            )
                                                        .toList();

                                                return Column(
                                                  children: [
                                                    PageStorage(
                                                      bucket:
                                                          PageStorageBucket(), // Add this line
                                                      key: const PageStorageKey<
                                                          String>("sskk"),
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            filteredApplicants
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final applicant =
                                                              filteredApplicants[
                                                                  index];

                                                          return InkWell(
                                                            onTap: () {
                                                              // Handle tap on the parent widget (outside the Row)
                                                              FocusManager
                                                                  .instance
                                                                  .primaryFocus
                                                                  ?.unfocus(); // Unfocus the keyboard
                                                              if (isSearchVisible) {
                                                                setState(() {
                                                                  isSearchVisible =
                                                                      false;
                                                                  _animationController
                                                                      .reverse(); // Reverse the animation
                                                                  _searchFocusNode
                                                                      .unfocus(); // Clear focus when it becomes invisible
                                                                });
                                                              }
                                                            },
                                                            child:
                                                                SingleChildScrollView(
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  listViewItem_new(
                                                                    context,
                                                                    applicant,
                                                                    true,
                                                                    statuses,
                                                                    profilemodel.id !=
                                                                            null
                                                                        ? profilemodel
                                                                            .id!
                                                                            .toInt()
                                                                        : 467,
                                                                    index,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    //TODO: filter button at the bottom
                                                    /*  const Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  right: 15.w, bottom: 10),
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        isf2f = !isf2f;
                                                        _isVi = false;
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: isf2f
                                                              ? Constants
                                                                  .borderColor
                                                              : Colors.white,
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          8),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          8)),
                                                          border: Border.all(
                                                              color: Constants
                                                                  .themeBgColor)),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 6,
                                                          horizontal: 12),
                                                      child: const Text("F2F"),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        isf2f = false;
                                                        _isVi = !_isVi;
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: _isVi
                                                              ? Constants
                                                                  .borderColor
                                                              : Colors.white,
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          8),
                                                                  bottomRight:
                                                                      Radius
                                                                          .circular(
                                                                              8)),
                                                          border: Border.all(
                                                              color: Constants
                                                                  .themeBgColor)),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 6,
                                                          horizontal: 12),
                                                      child:
                                                          const Text("Virtual"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ) */
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      // Proceed with sub_status tabs for other statuses
                                      final subStatuses = applicants
                                          .where((element) =>
                                              element.sub_code !=
                                              "IB7-3") //TODO: to remove offerDrop and notJoin from tab bar viee
                                          .where((element) =>
                                              element.sub_code != "IB7-2")
                                          .map((applicant) =>
                                              applicant.sub_status?.toString())
                                          .where(
                                              (subStatus) => subStatus != null)
                                          .toSet()
                                          .toList()
                                        ..sort();

                                      // Second tab bar needed for subStatuses

                                      return DefaultTabController(
                                        length: subStatuses.length,
                                        child: Scaffold(
                                          appBar: PreferredSize(
                                            preferredSize: const Size(
                                                double.maxFinite,
                                                kTextTabBarHeight),
                                            child: AppBar(
                                              //elevation: 0,
                                              backgroundColor: Colors.white,
                                              bottom: TabBar(
                                                key: const ValueKey("ccTab3"),
                                                isScrollable: true,
                                                indicatorSize:
                                                    TabBarIndicatorSize.tab,
                                                //indicatorWeight: 2.0,
                                                unselectedLabelStyle:
                                                    GoogleFonts.varela(),
                                                labelStyle: GoogleFonts.varela(
                                                    fontWeight:
                                                        FontWeight.w600),
                                                unselectedLabelColor:
                                                    Colors.black,
                                                labelColor:
                                                    Constants.subtitleclr,
                                                indicatorPadding:
                                                    EdgeInsets.only(
                                                        bottom: 8.h,
                                                        left: 3.w,
                                                        right: 3.w),
                                                indicator: isSelect
                                                    ? BoxDecoration(
                                                        color: Constants
                                                            .borderColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        border: Border.all(
                                                            color: Constants
                                                                .borderColor) // Creates border
                                                        )
                                                    : null,
                                                indicatorColor:
                                                    Constants.borderColor,
                                                /*  onTap: (value) {
                                    setState(() {
                                      isSelect = !isSelect;
                                    });
                                  }, */
                                                tabs: subStatuses
                                                    .map((subStatus) =>
                                                        Tab(text: subStatus!))
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                          body: TabBarView(
                                            key: const ValueKey("ccTabView3"),
                                            children: subStatuses
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                              final index = entry.key;
                                              final status = entry.value;
                                              // Filter applicants based on the current status and sub_status
                                              final filteredApplicants =
                                                  applicants
                                                      .where((applicant) =>
                                                          applicant.sub_status
                                                              .toString() ==
                                                          entry.value)
                                                      .toList();

                                              return ListView.builder(
                                                // scrollDirection: Axis.vertical,
                                                scrollDirection: Axis.vertical,
                                                // Use appropriate scroll physics as needed (e.g., BouncingScrollPhysics())
                                                physics:
                                                    BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    filteredApplicants.length,
                                                itemBuilder: (context, index) {
                                                  final applicant =
                                                      filteredApplicants[index];

                                                  return listViewItem_new(
                                                    context,
                                                    applicant,
                                                    true,
                                                    statuses,
                                                    profilemodel.id != null
                                                        ? profilemodel.id!
                                                            .toInt()
                                                        : 467,
                                                    index,
                                                  );

                                                  /*  GestureDetector(
                                                onTap: () {
                                                  // Handle tap on the parent widget (outside the Row)
                                                  if (isSearchVisible) {
                                                  setState(() {
                                                      isSearchVisible = false;
                                                      _animationController
                                                          .reverse(); // Reverse the animation
                                                      _searchFocusNode
                                                          .unfocus(); // Clear focus when it becomes invisible
                                                  });
                                                  }
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                  Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          // Handle tap inside the search container (Expanded)
                                                          _searchFocusNode
                                                              .requestFocus();
                                                          /*  if (!isSearchVisible) {
                                                            setState(() {
                                                              isSearchVisible =
                                                                  true;
                                                              _animationController
                                                                  .forward(); // Start the animation
                                                              _searchFocusNode
                                                                  .requestFocus(); // Request focus on the search field when it becomes visible
                                                            });
                                                          } */
                                                        },
                                                        child: AnimatedOpacity(
                                                          duration: const Duration(
                                                              milliseconds: 500),
                                                          opacity: isSearchVisible
                                                              ? 1.0
                                                              : 0.0, // Fade in/out the search container
                                                          child: SlideTransition(
                                                            position: Tween<Offset>(
                                                              begin: const Offset(
                                                                  -1,
                                                                  0), // Start from the left side of the screen
                                                              end: const Offset(0,
                                                                  0), // Slide to the center of the screen
                                                            ).animate(
                                                                CurvedAnimation(
                                                              parent:
                                                                  _animationController, // Use the same animation controller from your code
                                                              curve: Curves
                                                                  .easeInOut, // Set the desired animation curve
                                                            )),
                                                            child: Container(
                                                              height: 50.h,
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 8,
                                                                      right: 12,
                                                                      top: 10),
                                                              child: TextField(
                                                                focusNode:
                                                                    _searchFocusNode,
                                                                style: GoogleFonts
                                                                    .varela(
                                                                  color:
                                                                      Colors.black,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                                decoration:
                                                                    InputDecoration(
                                                                  fillColor:
                                                                      Colors.white,
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        const BorderSide(),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                10),
                                                                  ),
                                                                  filled: true,
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    bottom: 10,
                                                                    left: 5,
                                                                    top: 10,
                                                                  ),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                10),
                                                                  ),
                                                                  hintText: "Rahul",
                                                                  suffixIcon:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      // Handle tap on the search icon inside the search container
                                                                      setState(() {
                                                                        isSearchVisible =
                                                                            false;
                                                                        _animationController
                                                                            .reverse(); // Reverse the animation
                                                                        _searchFocusNode
                                                                            .requestFocus(); // Clear focus on the search field when it becomes invisible
                                                                      });
                                                                    },
                                                                    child:
                                                                        const Icon(
                                                                      Icons.search,
                                                                      size: 24,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        // Handle tap on the search icon outside the search container
                                                        if (!isSearchVisible) {
                                                          setState(() {
                                                            isSearchVisible = true;
                                                            _animationController
                                                                .forward(); // Start the animation
                                                            _searchFocusNode
                                                                .requestFocus(); // Request focus on the search field when it becomes visible
                                                          });
                                                        }
                                                      },
                                                      child: Visibility(
                                                        visible: !isSearchVisible,
                                                        child: const Padding(
                                                          padding: EdgeInsets.only(
                                                              right: 20, top: 10),
                                                          child: Icon(
                                                            Icons.search,
                                                            size: 24,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                  ),
                                                  ],
                                                ),
                                              ) */
                                                },
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    }
                                  }).toList(),
                                ),
                              ),
                            ),
                          ));
                    } else {
                      // Display a "no data" message
                      return const Center(
                        child: Text("No data to display."),
                      );
                    }
                  },
                  error: (error, stackTrace) {
                    return const Center(
                      child: Text("Error while fetching the data"),
                    );
                  },
                  loading: () {
                    return const CircularProgressIndicator();
                  },
                )
              : const SizedBox());

      /* FutureBuilder<List<Applicant>>(
        future: fetchAllApplicants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            final data = snapshot.data!;
            final statuses = data
                .map((e) => e.status.toString())
                .toSet()
                .toList()
                .where((status) =>
                    status == 'Application' ||
                    status == 'Assign' ||
                    status == 'Screening Reject' ||
                    status == 'Reject')
                .toList();
            statuses.sort();

            return DefaultTabController(
              length: statuses.length,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize:
                      const Size(double.maxFinite, kTextTabBarHeight),
                  child: AppBar(
                    backgroundColor: Colors.white,
                    bottom: TabBar(
                      labelPadding: const EdgeInsets.only(left: 5, right: 5),
                      labelColor: Colors.black,
                      isScrollable: true,
                      unselectedLabelColor: Colors.black,
                      indicatorSize: TabBarIndicatorSize.tab,
                      splashBorderRadius: BorderRadius.circular(8),
                      indicatorWeight: 1.h,
                      indicatorPadding: EdgeInsets.only(
                          top: 8.h, bottom: 8.h, left: 3.w, right: 3.w),
                      indicator: BoxDecoration(
                        color: Constants.borderColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Constants.borderColor),
                      ),
                      tabs: statuses
                          .map(
                            (e) => Tab(
                              child: customTab(e),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    setState(
                        () {}); // This will trigger the rebuild of the widget tree
                  },
                  child: TabBarView(
                    children: statuses
                        .map(
                          (e) => ListView.builder(
                            shrinkWrap: true,
                            itemCount: data
                                .where((applicant) =>
                                    applicant.status.toString() == e)
                                .length,
                            itemBuilder: (context, index) {
                              final applicant = data
                                  .where((applicant) =>
                                      applicant.status.toString() == e)
                                  .toList()[index];
                              return listViewItem_new(
                                context,
                                applicant,
                                true,
                                statuses,
                                profilemodel.id!.toInt(),
                                index, // Pass the dynamic index here
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),

                  /* TabBarView(
                    children: statuses
                        .map(
                          (e) => ListView(
                            shrinkWrap: true,
                            children: data
                                .where(
                                  (applicant) =>
                                      applicant.status.toString() == e,
                                )
                                .map(
                                  (e) => listViewItem_new(context, e, true,
                                      statuses, profilemodel.id!.toInt(),1),
                                )
                                .toList(),
                          ),
                        )
                        .toList(),
                  ), */
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ); */
    }
  }

  TextEditingController showrejectTextFileld = TextEditingController();
  TextEditingController remarkfordropandNotJoin = TextEditingController();

  Map<int, bool> selectedJobs = {};
  Map<int, bool> selectedDropOut = {};
  Map<int, bool> selectedWalkOut = {};
  Map<int, bool> selectedoption = {};

  Future<InterviewResult>? interviewResultFuture;
  // Initialize as an empty list

  Future<InterviewResult> fetchDataAndUpdateDropdown(
      int jobId, int leadId) async {
    ApplicationAPI app = ApplicationAPI();

    return interviewResultFuture = app.fetchInterviewResult(jobId, leadId);
  }

  String selectedInterviewRound = 'Select';

  bool switchValue = false;

  Map<int, bool> jobToggleStates = {};

  List<JobItem> jobs = [];

  bool submited = false,
      under = false,
      notSubmited = false,
      shedule = false,
      pending = false,
      done = false;

  bool Drop = false, notJoin = false;

  Widget listViewItem_new(BuildContext context, Applicant item, bool isTrue,
      List<String> status, int id, int index) {
    bool isRejected = false,
        isOfferDrop = false,
        isWalkOut = false,
        isDropOut = false,
        isNotJoin = false;

    // spocController.text =
    // "${userRole.runtimeType} ${userModel.lastName} -  ${userModel.role}";

    List<String> finalinterviewRounds = item.inteviewrounds
            ?.map((round) => round
                .replaceAll('[', '')
                .replaceAll(']', '')
                .replaceAll('"', ''))
            .expand((formattedRound) => formattedRound.split(', '))
            .toList() ??
        [];

    /* String? getInitialValue() {
      if (selectedRoundsMap[item.id] != null &&
          selectedRoundsMap[item.id]!.isNotEmpty &&
          finalinterviewRounds.contains(selectedRoundsMap[item.id]!)) {
        return selectedRoundsMap[item.id]!;
      } else if (finalinterviewRounds.isNotEmpty) {
        return finalinterviewRounds[0];
      } else {
        return null;
      }
    } */

    //final isDropOut = selectedoption[item.id] ?? false;

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
        ChangeStatusModel changeStatusModel = ChangeStatusModel(
          status: "IB7",
          subStatus: "Confirmation Pending",
          doj: picked,
          id: item.id,
          sourceId: item.sourceId,
        );
        Map<String, dynamic> jsonData = changeStatusModel.toJson();
        try {
          await JobPostApiService.changeStatus(jsonData, item.id!.toInt());
          ref.refresh(fetchAllApplicantProvider(profilemodel.id!.toInt()));
          setState(() {});
          // First pop to close the dialog
        } catch (e) {
          print('Error: $e');
          // Handle error...
        }
      }
    }

    // List<String>? myStrings;
    //  bool stopIteration = false;
    /*  int jobId =
        item.id!.toInt(); // Replace with the actual ID or unique identifier
    if (!jobToggleStates.containsKey(jobId)) {
      jobToggleStates[jobId] = true; // Initialize the toggle state for this job
    } */
    return Stack(
      children: [
        InkWell(
          onTap: () {
            if (item.status != "Application") {
              /* Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TalentPoolDetail(
                            applicant: item,
                            Status: status,
                          ))); */
            } else {
              ChangeStatusModel changeStatusModel = ChangeStatusModel(
                  status: "TP2", sourceId: id, subStatus: "View");
              Map<String, dynamic> jsonData = changeStatusModel.toJson();
              try {
                JobPostApiService.changeStatus(jsonData, item.id!.toInt());
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Recruitz()));
                setState(() {});
                /* showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return CustomDialog(
                      fetchDataFromApi: () {},
                      isFisrt: false,
                      onClose: () {
                        Navigator.pop(context);
                      },
                      title: "Success",
                      subtitle: "Submitted successfully!",
                    );
                  },
                ); */
              } catch (e) {
                print('Error: $e');
              }
            }
            setState(() {});
            setState(() {});
            /*  item.status == "Application"
                ? null
                : Navigator.pushNamed(
                    context,
                    ERoute.jobsdetail.name,
                    arguments: {
                      'id': item.jobId,
                    },
                  ); */
          },
          child: SwipeTo(
            iconOnRightSwipe: Icons.call,
            iconOnLeftSwipe: Icons.sms_outlined,
            onRightSwipe: item.alternateNo == 0 || item.alternateNo == null
                ? () async {
                    FlutterPhoneDirectCaller.callNumber("+91${item.contactNo}");
                  }
                : () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return item.alternateNo != null
                            ? CustomAlertDialog(
                                phoneNumber1: item.contactNo!.toInt(),
                                phoneNumber2: item.alternateNo!.toInt(),
                                isCall: true,
                              )
                            : const SizedBox();
                      },
                    );
                  },
            onLeftSwipe: item.alternateNo == 0 || item.alternateNo == null
                ? () async {
                    Uri url =
                        Uri.parse("whatsapp://send?phone=91${item.contactNo}");
                    await canLaunchUrl(url)
                        ? await launchUrl(url)
                        : throw "could not launch $url";
                  }
                : () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                          phoneNumber1: int.parse(item.contactNo.toString()),
                          phoneNumber2: int.parse(item.alternateNo.toString()),
                          isCall: false,
                        );
                      },
                    );
                  },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
                //set border radius more than 50% of height and width to make circle
              ),
              // shadowColor: Constants.themeBgColor,
              elevation: 4,

              margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                child: StatefulBuilder(builder: (context, setState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://media.istockphoto.com/id/503040171/photo/middle-eastern-businessman-portrait.jpg?s=612x612&w=0&k=20&c=7t6c_HQHfUZNgrVtR-G1rQpJAMaCbFsuxppDRKBnXDw="),
                            // child: Text(item.applicantName[0].toUpperCase()),
                            radius: 22,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${item.applicantName.toString()} ${item.last_name.toString()}",
                                    style: GoogleFonts.varela(
                                      // color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (item.status_code != "IB7" &&
                                      item.dateOfBirth != null)
                                    Text(
                                      " (${calculateAge(item.dateOfBirth.toString())} yr's)",
                                      style: GoogleFonts.varela(
                                          color: Colors.black54,
                                          fontSize: 12.sp),
                                    )
                                ],
                              ),
                              if (item.status_code != "IB7" &&
                                  item.status_code != "IB5" &&
                                  item.status_code != "IB4")
                                Row(
                                  children: [
                                    item.qualification == null
                                        ? Row(
                                            children: [
                                              Image.asset(
                                                "assets/images/bag.png",
                                                height: 12.h,
                                                //  color: Constants.subtitleclr,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                item.isExperienced.toString(),
                                                style: GoogleFonts.varela(
                                                  color: Colors.black54,
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Image.asset(
                                                "assets/images/graduate.png",
                                                height: 15.h,
                                                //  color: Constants.subtitleclr,
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                "${item.qualification.toString()}  |  ",
                                                style: GoogleFonts.varela(
                                                  color: Colors.black54,
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Image.asset(
                                                "assets/images/bag.png",
                                                height: 12.h,
                                                //  color: Constants.subtitleclr,
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                " ${item.isExperienced}",
                                                style: GoogleFonts.varela(
                                                  color: Colors.black54,
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          )
                                  ],
                                ),
                              if (item.status_code == "IB7" ||
                                  item.status_code == "IB5" ||
                                  item.status_code == "IB4")
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                      // color: Constants.borderColor,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        item.role_code != null &&
                                                item.role_code != ""
                                            ? "${item.process} - ${item.role_code}"
                                            : "${item.process} - ${item.leadLevel}",
                                        style: GoogleFonts.varela(
                                          color: Colors.black54,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      if ((item.status_code != "IB7" &&
                              item.status_code != "IB8" &&
                              item.status_code != "IB5") &&
                          !isDropOut)
                        Wrap(
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.end,
                              children: List.generate(
                                applicationList!
                                    .where((option) =>
                                        option.code!.contains('IB8:3'))
                                    .length,
                                (index) {
                                  final option = applicationList!
                                      .where((option) =>
                                          option.code!.contains('IB8:3'))
                                      .toList()[index];
                                  return InkWell(
                                    onTap: option.code != "IB8:3"
                                        ? () {
                                            /*  ChangeStatusModel changeStatusModel =
                                                  ChangeStatusModel(
                                                      status:
                                                          option.sub_value.toString(),
                                                      sourceId: item.sourceId,
                                                      subStatus: option.value,
                                                      interview_rounds:
                                                          item.inteviewrounds!.first);
                                              Map<String, dynamic> jsonData =
                                                  changeStatusModel.toJson();
                                              try {
                                                JobPostApiService.changeStatus(
                                                    jsonData, item.id!.toInt());
                                                setState(() {});
                                              } catch (e) {
                                                print('Error: $e');
                                                // Handle error...
                                              } */
                                          }
                                        : () {
                                            setState(() {
                                              isDropOut = !isDropOut;
                                            });
                                          },
                                    child: Wrap(
                                      children: [
                                        //  if (option.code != "IB8:1")
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 6, right: 6),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            color: Colors.grey.shade100,
                                            border: Border.all(
                                                color: Constants.borderColor),
                                          ),
                                          child: Text(
                                            option.code != "IB5:2"
                                                ? option.value.toString()
                                                : "F2F Interview",
                                            style: GoogleFonts.varela(
                                                color: Colors.blue),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return CustomDialogueForNew(
                                      title: 'Register ',
                                      title2: "for an Interview.",
                                      company_name: item.companyName.toString(),
                                      nature_of_work:
                                          item.natureOfWork.toString(),
                                      process: item.process.toString(),
                                      role: item.leadLevel.toString(),
                                      companyId: item.short_list_for!.toInt(),
                                      item: item,
                                      refreshCallback: () {
                                        ref.refresh(fetchAllApplicantProvider(
                                            profilemodel.id!.toInt()));
                                      },
                                    );
                                  },
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 6, right: 6),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: Colors.grey.shade100,
                                  border:
                                      Border.all(color: Constants.borderColor),
                                ),
                                child: Text(
                                  "Schedule Interview",
                                  style: GoogleFonts.varela(color: Colors.blue),
                                ),
                              ),
                            ),
                          ],
                        ),

                      //TODO: Old DropDown code of dropout,virtual and onsite interview in New.
                      /*  (item.status_code != "IB7" &&
                                    item.status_code != "IB8" &&
                                    item.status_code != "IB5") &&
                                !isDropOut
                            ? Padding(
                                padding: EdgeInsets.only(top: 6.h),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        value == "Drop-out"
                                            ? setState(() {
                                                selectedoption[item.id!.toInt()] =
                                                    !isSelected;
                                              })
                                            : setState(() {
                                                String subValue = "0";
                                                for (var app in applicationList!) {
                                                  if (app.value.toString() ==
                                                          value &&
                                                      app.sub_value != null) {
                                                    subValue =
                                                        app.sub_value.toString();
                                                    break;
                                                  }
                                                }

                                                selectedValueMap[item.id!] =
                                                    SelectedOption(
                                                        value, subValue.toString());
                                                if (item.sub_code == "IB5:2" ||
                                                    item.sub_code == "IB5:1") {
                                                  updateSelectedRoundForJob(
                                                      item.id!.toInt(),
                                                      item.inteviewrounds!.first
                                                          .toString());
                                                }

                                                // Now you can use both value and subValue for further operations
                                                ChangeStatusModel
                                                    changeStatusModel =
                                                    ChangeStatusModel(
                                                        interview_rounds:
                                                            item.sub_code ==
                                                                        "IB5:2" ||
                                                                    item.sub_code ==
                                                                        "IB5:1"
                                                                ? item
                                                                    .inteviewrounds!
                                                                    .first
                                                                : null,
                                                        status: subValue.toString(),
                                                        sourceId: item.sourceId,
                                                        subStatus: value);
                                                Map<String, dynamic> jsonData =
                                                    changeStatusModel.toJson();
                                                try {
                                                  JobPostApiService.changeStatus(
                                                      jsonData, item.id!.toInt());
                                                  setState(() {});
                                                } catch (e) {
                                                  print('Error: $e');
                                                  // Handle error...
                                                }
                                                /*  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: ((context) => CC(
                                                              key: _talentPollKey,
                                                            )))); */
                                              });
                                        // setState(() {});
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return applicationList!
                                            .where((element) =>
                                                element.code!.contains(":"))
                                            .map((option) {
                                          bool isOdd =
                                              applicationList!.indexOf(option) %
                                                      2 ==
                                                  1;
                                          // Retrieve the corresponding sub_value from the option
                                          String subValue = option.sub_value
                                              .toString(); // Replace with the actual property name
                                          // setState(() {});
                                          return customMenuItem(option, isOdd);
                                        }).toList();
                                      },
                                      child: Container(
                                        // height: 32,
                                        /*   margin: const EdgeInsets.only(
                                                  bottom: 10, top: 10), */
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            // color: Constants.subtitleclr,
                                            border: Border.all(
                                                color: Constants.borderColor)),
                                        padding: const EdgeInsets.all(12),
                                        child: Row(
                                          children: [
                                            Text(
                                              selectedValueMap[item.id!]
                                                      ?.selectedValue ??
                                                  item.sub_status.toString(),
                                              style: GoogleFonts.varela(
                                                color: Colors.black,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const Icon(
                                              Icons.arrow_drop_down,
                                              size: 13,
                                              color: Colors.black,
                                            )
                                          ],
                                        ),
                                      ),
                                      offset: const Offset(0, 32),
                                      elevation: 16,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(), */

                      if ((item.status != "Application" &&
                              item.status_code != "IB7") &&
                          item.status_code != "IB5" &&
                          item.status_code != "IB4")
                        Container(
                          decoration: BoxDecoration(
                              color: Constants.borderColor,
                              /* border: Border.all(color: Constants.borderColor
                      ), */
                              // color: Constants.borderColor,
                              borderRadius: BorderRadius.circular(8)),
                          margin: EdgeInsets.only(bottom: 2, top: 6.h),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          // padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!item.status_code!.contains("IB5") &&
                                      !item.status_code!.contains("IB7"))
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 2),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      decoration: BoxDecoration(
                                          color: Constants.borderColor,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(
                                        item.status_code!.contains("IB5")
                                            ? item.short_name.toString()
                                            : item.companyName.toString(),
                                        style: GoogleFonts.varela(
                                          color: Colors.black54,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  if (item.status_code != "IB7")
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1, horizontal: 4),
                                      decoration: BoxDecoration(
                                          color: Constants.borderColor,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            item.role_code != null &&
                                                    item.role_code != ""
                                                ? "${item.process} - ${item.role_code}"
                                                : "${item.process} - ${item.leadLevel}",
                                            style: GoogleFonts.varela(
                                              color: Colors.black54,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                children: const [
                                  /* item.sub_code == "IB5:1"
                                                    ? */
                                  /* GestureDetector(
                                              onTap: () {
                                                item.sub_code == "IB5:1"
                                                    ? setState(() {
                                                        {
                                                          CustomToggleButton(
                                                            isToggleOn: switchValue,
                                                            onToggleChanged:
                                                                (value) {
                                                              setState(() {
                                                                switchValue = value;
                                                              });
                                                            },
                                                          );
                                                          ChangeStatusModel
                                                              changeStatusModel =
                                                              ChangeStatusModel(
                                                                  status: item
                                                                      .status_code,
                                                                  sourceId: id,
                                                                  subStatus:
                                                                      "Virtual Interview");
                                                          Map<String, dynamic>
                                                              jsonData =
                                                              changeStatusModel
                                                                  .toJson();
                                                          try {
                                                            JobPostApiService
                                                                .changeStatus(
                                                                    jsonData,
                                                                    item.id!
                                                                        .toInt());
                                                            setState(() {});
                                                          } catch (e) {
                                                            print('Error: $e');
                                                            // Handle error...
                                                          }
                                                        }
                                                      })
                                                    : setState(() {
                                                        CustomToggleButton(
                                                          isToggleOn: switchValue,
                                                          onToggleChanged: (value) {
                                                            setState(() {
                                                              switchValue = value;
                                                            });
                                                          },
                                                        );
                                                        ChangeStatusModel
                                                            changeStatusModel =
                                                            ChangeStatusModel(
                                                                status: item
                                                                    .status_code,
                                                                sourceId: id,
                                                                subStatus:
                                                                    "On-Site Interview");
                                                        Map<String, dynamic>
                                                            jsonData =
                                                            changeStatusModel
                                                                .toJson();
                                                        try {
                                                          JobPostApiService
                                                              .changeStatus(
                                                                  jsonData,
                                                                  item.id!.toInt());
                                                          setState(() {});
                                                        } catch (e) {
                                                          print('Error: $e');
                                                          // Handle error...
                                                        }
                                                      });
                                              }, */

                                  /* : GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            switchValue =
                                                                !switchValue;
                                                          });
                                                        },
                                                        child: Container(
                                                          width: 30.0,
                                                          height: 15.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16.0),
                                                            color: switchValue
                                                                ? Colors.green
                                                                : Colors.grey,
                                                          ),
                                                          child: Stack(
                                                            alignment: switchValue
                                                                ? Alignment
                                                                    .centerRight
                                                                : Alignment
                                                                    .centerLeft,
                                                            children: [
                                                              Container(
                                                                width: 15.0,
                                                                height: 15.0,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ), */
                                  /*  Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 6,
                                                          ),
                                                          Text(
                                                            "On-Site",
                                                            style: GoogleFonts
                                                                .varela(
                                                                    color: Colors
                                                                        .blue),
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        children: [
                                                          Text(
                                                            "Virtual",
                                                            style: GoogleFonts
                                                                .varela(
                                                                    color: Colors
                                                                        .blue),
                                                          ),
                                                          const SizedBox(
                                                            width: 6,
                                                          ),
                                                        ],
                                                      ), */
                                  /* Text(
                                                  "Move to",
                                                  style: GoogleFonts.varela(
                                                      fontSize: 8.sp,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ) */

                                  /* PopupMenuButton<String>(
                                            onSelected: (value) {
                                              setState(() {
                                                String subValue = "0";
                                                for (var app in applicationList!) {
                                                  if (app.value.toString() ==
                                                          value &&
                                                      app.sub_value != null) {
                                                    subValue =
                                                        app.sub_value.toString();
                                                    break;
                                                  }
                                                }

                                                selectedValueMap[item.id!] =
                                                    SelectedOption(
                                                        value, subValue.toString());

                                                // Now you can use both value and subValue for further operations
                                                ChangeStatusModel
                                                    changeStatusModel =
                                                    ChangeStatusModel(
                                                        status: subValue.toString(),
                                                        sourceId: id,
                                                        subStatus: value);
                                                Map<String, dynamic> jsonData =
                                                    changeStatusModel.toJson();
                                                try {
                                                  JobPostApiService.changeStatus(
                                                      jsonData, item.id!.toInt());
                                                  setState(() {});
                                                } catch (e) {
                                                  print('Error: $e');
                                                  // Handle error...
                                                }
                                                /*  Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) => CC(
                                                        key: _talentPollKey,
                                                      )))); */
                                              });
                                              // setState(() {});
                                            },
                                            itemBuilder: (BuildContext context) {
                                              return applicationList!
                                                  .where((element) =>
                                                      element.code!.contains(";"))
                                                  .map((option) {
                                                bool isOdd = applicationList!
                                                            .indexOf(option) %
                                                        2 ==
                                                    1;
                                                // Retrieve the corresponding sub_value from the option
                                                String subValue = option.sub_value
                                                    .toString(); // Replace with the actual property name
                                                // setState(() {});
                                                return customMenuItem(
                                                    option, isOdd);
                                              }).toList();
                                            },
                                            child: Container(
                                              // height: 32,
                                              /*   margin: const EdgeInsets.only(
                                            bottom: 10, top: 10), */
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  // color: Constants.subtitleclr,
                                                  border: Border.all(
                                                      color:
                                                          Constants.borderColor)),
                                              padding: const EdgeInsets.all(12),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    selectedValueMap[item.id!]
                                                            ?.selectedValue ??
                                                        item.sub_status.toString(),
                                                    style: GoogleFonts.varela(
                                                      color: Colors.black,
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.arrow_drop_down,
                                                    size: 13,
                                                    color: Colors.black,
                                                  )
                                                ],
                                              ),
                                            ),
                                            offset: const Offset(0, 32),
                                            elevation: 16,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ) */

                                  /* PopupMenuButton<String>(
                                      onSelected: (value) {
                                        setState(() {
                                          int index = status.indexOf(value);
                                          selectedStatusMap[index] = value;
                                        });
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return applicationList.map((option) {
                                          bool isOdd =
                                              applicationList.indexOf(option) % 2 ==
                                                  1;
                                          return customMenuItem(option, isOdd);
                                        }).toList();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Constants.subtitleclr,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        child: Row(
                                          children: [
                                            Text(
                                              selectedStatus ?? 'Please Select',
                                              style: GoogleFonts.varela(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const Icon(
                                              Icons.arrow_drop_down,
                                              size: 13,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      ),
                                      offset: const Offset(0, 32),
                                      elevation: 16,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8)),
                                    ), */
                                ],
                              ),
                            ],
                          ),
                        ),
                      //TODO: to add document status as per document mode.

                      if (item.status_code == "IB7" && item.mode_document == 1)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Documentation Status :"),
                            SizedBox(
                              height: 4.h,
                            ),
                            Wrap(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (item.document_status !=
                                            "Under Review" &&
                                        item.document_status != "Submitted" &&
                                        item.document_status !=
                                            "Not Submitted") {
                                      ChangeStatusModel changeStatusModel =
                                          ChangeStatusModel(
                                        status: "IB7",
                                        subStatus: item.sub_code == "IB7-4"
                                            ? "Ready to Join"
                                            : "Confirmation Pending",
                                        doj: item.doj,
                                        id: item.id,
                                        sourceId: item.sourceId,
                                        document_status: "Not Submitted",
                                      );
                                      Map<String, dynamic> jsonData =
                                          changeStatusModel.toJson();
                                      try {
                                        await JobPostApiService.changeStatus(
                                            jsonData, item.id!.toInt());
                                        ref.refresh(fetchAllApplicantProvider(
                                            profilemodel.id!.toInt()));
                                        setState(() {});

                                        // First pop to close the dialog
                                      } catch (e) {
                                        print('Error: $e');
                                        // Handle error...
                                      }
                                    }
                                  },
                                  child: item.document_status !=
                                              "Under Review" &&
                                          item.document_status != "Submitted"
                                      ? Container(
                                          margin: EdgeInsets.only(right: 6.w),
                                          decoration: BoxDecoration(
                                              color: item.document_status ==
                                                      "Not Submitted"
                                                  ? Colors.red
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              border: Border.all(
                                                  color:
                                                      Constants.borderColor)),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 10),
                                          child: Text("Not Submitted",
                                              style: GoogleFonts.varela(
                                                  color: item.document_status ==
                                                          "Not Submitted"
                                                      ? Colors.white
                                                      : Colors.black)),
                                        )
                                      : disableContainer("Not Submitted"),
                                ),
                                InkWell(
                                    onTap: () async {
                                      if (item.document_status != "Submitted" &&
                                          item.document_status !=
                                              "Under Review") {
                                        ChangeStatusModel changeStatusModel =
                                            ChangeStatusModel(
                                                status: "IB7",
                                                subStatus: item.sub_code ==
                                                        "IB7-4"
                                                    ? "Ready to Join"
                                                    : "Confirmation Pending",
                                                doj: item.doj,
                                                id: item.id,
                                                sourceId: item.sourceId,
                                                document_status:
                                                    "Under Review");
                                        Map<String, dynamic> jsonData =
                                            changeStatusModel.toJson();
                                        try {
                                          await JobPostApiService.changeStatus(
                                              jsonData, item.id!.toInt());

                                          ref.refresh(fetchAllApplicantProvider(
                                              profilemodel.id!.toInt()));
                                          setState(() {});
                                          // First pop to close the dialog
                                        } catch (e) {
                                          print('Error: $e');
                                          // Handle error...
                                        }
                                      }
                                    },
                                    child: item.document_status != "Submitted"
                                        ? Container(
                                            margin: EdgeInsets.only(right: 6.w),
                                            decoration: BoxDecoration(
                                                color: item.document_status ==
                                                        "Under Review"
                                                    ? Colors.orangeAccent
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                border: Border.all(
                                                    color:
                                                        Constants.borderColor)),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 10),
                                            child: Text("Under Review",
                                                style: GoogleFonts.varela(
                                                    color:
                                                        item.document_status ==
                                                                "Under Review"
                                                            ? Colors.white
                                                            : Colors.black)),
                                          )
                                        : disableContainer("Under Review")),
                                InkWell(
                                  onTap: () async {
                                    if (item.document_status ==
                                            "Under Review" ||
                                        item.document_status ==
                                                "Not Submitted" &&
                                            item.mode_document == 1) {
                                      setState(() {
                                        notSubmited = false;
                                        submited = true;
                                        under = false;
                                      });
                                      ChangeStatusModel changeStatusModel =
                                          ChangeStatusModel(
                                              status: "IB7",
                                              subStatus:
                                                  item.sub_code == "IB7-4"
                                                      ? "Ready to Join"
                                                      : "Confirmation Pending",
                                              doj: item.doj,
                                              id: item.id,
                                              sourceId: item.sourceId,
                                              document_status: "Submitted");
                                      Map<String, dynamic> jsonData =
                                          changeStatusModel.toJson();
                                      try {
                                        await JobPostApiService.changeStatus(
                                            jsonData, item.id!.toInt());

                                        ref.refresh(fetchAllApplicantProvider(
                                            profilemodel.id!.toInt()));
                                        setState(() {});
                                        // First pop to close the dialog
                                      } catch (e) {
                                        print('Error: $e');
                                        // Handle error...
                                      }
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 6.w),
                                    decoration: BoxDecoration(
                                        color: item.document_status ==
                                                    "Submitted" &&
                                                item.mode_document == 1
                                            ? Colors.green
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        border: Border.all(
                                            color: Constants.borderColor)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    child: Text("Submitted",
                                        style: GoogleFonts.varela(
                                            color: item.document_status ==
                                                        "Submitted" &&
                                                    item.mode_document == 1
                                                ? Colors.white
                                                : Colors.black)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4.h,
                            )
                          ],
                        ),

                      if (item.status_code == "IB7" && item.mode_document == 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Documentation Status :"),
                            SizedBox(
                              height: 4.h,
                            ),
                            Wrap(
                              children: [
                                InkWell(
                                    onTap: () async {
                                      if (item.document_status != "Pending" &&
                                          item.document_status != "Submitted" &&
                                          item.document_status !=
                                              "Schedule F2F" &&
                                          item.mode_document == 0) {
                                        ChangeStatusModel changeStatusModel =
                                            ChangeStatusModel(
                                                status: "IB7",
                                                subStatus: item.sub_code ==
                                                        "IB7-4"
                                                    ? "Ready to Join"
                                                    : "Confirmation Pending",
                                                doj: item.doj,
                                                id: item.id,
                                                sourceId: item.sourceId,
                                                document_status:
                                                    "Schedule F2F");
                                        Map<String, dynamic> jsonData =
                                            changeStatusModel.toJson();
                                        try {
                                          await JobPostApiService.changeStatus(
                                              jsonData, item.id!.toInt());

                                          ref.refresh(fetchAllApplicantProvider(
                                              profilemodel.id!.toInt()));
                                          setState(() {});
                                          // First pop to close the dialog
                                        } catch (e) {
                                          print('Error: $e');
                                          // Handle error...
                                        }
                                      }
                                    },
                                    child: item.document_status != "Pending" &&
                                            item.document_status !=
                                                "Submitted" &&
                                            item.mode_document == 0
                                        ? Container(
                                            margin: EdgeInsets.only(right: 6.w),
                                            decoration: BoxDecoration(
                                                color: item.document_status ==
                                                        "Schedule F2F"
                                                    ? Colors.amber
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                border: Border.all(
                                                    color:
                                                        Constants.borderColor)),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 10),
                                            child: Text("Schedule F2F",
                                                style: GoogleFonts.varela(
                                                    color:
                                                        item.document_status ==
                                                                "Schedule F2F"
                                                            ? Colors.white
                                                            : Colors.black)),
                                          )
                                        : disableContainer("Schedule F2F")),
                                InkWell(
                                    onTap: () async {
                                      if (item.document_status != "Submitted" &&
                                          item.document_status != "Pending" &&
                                          item.mode_document == 0) {
                                        ChangeStatusModel changeStatusModel =
                                            ChangeStatusModel(
                                                status: "IB7",
                                                subStatus: item.sub_code ==
                                                        "IB7-4"
                                                    ? "Ready to Join"
                                                    : "Confirmation Pending",
                                                doj: item.doj,
                                                id: item.id,
                                                sourceId: item.sourceId,
                                                document_status: "Pending");
                                        Map<String, dynamic> jsonData =
                                            changeStatusModel.toJson();
                                        try {
                                          await JobPostApiService.changeStatus(
                                              jsonData, item.id!.toInt());

                                          ref.refresh(fetchAllApplicantProvider(
                                              profilemodel.id!.toInt()));
                                          setState(() {});
                                          // First pop to close the dialog
                                        } catch (e) {
                                          print('Error: $e');
                                          // Handle error...
                                        }
                                      }
                                    },
                                    child: item.document_status !=
                                                "Submitted" &&
                                            item.mode_document == 0
                                        ? Container(
                                            margin: EdgeInsets.only(right: 6.w),
                                            decoration: BoxDecoration(
                                                color: item.document_status ==
                                                        "Pending"
                                                    ? Colors.orangeAccent
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                border: Border.all(
                                                    color:
                                                        Constants.borderColor)),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 10),
                                            child: Text("Pending",
                                                style: GoogleFonts.varela(
                                                    color:
                                                        item.document_status ==
                                                                "Pending"
                                                            ? Colors.white
                                                            : Colors.black)),
                                          )
                                        : disableContainer("Pending")),
                                InkWell(
                                  onTap: () async {
                                    if (item.document_status == "Pending" ||
                                        item.document_status ==
                                                "Schedule F2F" &&
                                            item.mode_document == 0) {
                                      ChangeStatusModel changeStatusModel =
                                          ChangeStatusModel(
                                              status: "IB7",
                                              subStatus:
                                                  item.sub_code == "IB7-4"
                                                      ? "Ready to Join"
                                                      : "Confirmation Pending",
                                              doj: item.doj,
                                              id: item.id,
                                              sourceId: item.sourceId,
                                              document_status: "Submitted");
                                      Map<String, dynamic> jsonData =
                                          changeStatusModel.toJson();
                                      try {
                                        await JobPostApiService.changeStatus(
                                            jsonData, item.id!.toInt());
                                        ref.refresh(fetchAllApplicantProvider(
                                            profilemodel.id!.toInt()));
                                        setState(() {});
                                        // First pop to close the dialog
                                      } catch (e) {
                                        print('Error: $e');
                                        // Handle error...
                                      }
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 6.w),
                                    decoration: BoxDecoration(
                                        color: item.document_status ==
                                                    "Submitted" &&
                                                item.mode_document == 0
                                            ? Colors.green
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        border: Border.all(
                                            color: Constants.borderColor)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    child: Text("Submitted",
                                        style: GoogleFonts.varela(
                                            color: item.document_status ==
                                                        "Submitted" &&
                                                    item.mode_document == 0
                                                ? Colors.white
                                                : Colors.black)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4.h,
                            )
                          ],
                        ),
                      //todo to show DOJ and select or update DOJ only for select tab.
                      if (item.status_code == "IB7" &&
                          (item.sub_code == "IB7-5" ||
                              item.sub_code == "IB7-4" ||
                              item.sub_code == "IB7-1"))
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                isToday ||
                                        isYesterday ||
                                        item.sub_code == "IB7-4"
                                    ? null
                                    : singleSelectPicker();
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: doj == yesterday
                                          ? Constants.themeBgColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                          color: item.doj != null
                                              ? item.doj?.day == tomorrow.day &&
                                                      item.doj!.month ==
                                                          tomorrow.month &&
                                                      item.doj!.year ==
                                                          tomorrow.year
                                                  ? Colors.blue
                                                  : item.doj!.day ==
                                                              DateTime.now()
                                                                  .day &&
                                                          item.doj!.month ==
                                                              DateTime.now()
                                                                  .month &&
                                                          item.doj!.year ==
                                                              DateTime.now()
                                                                  .year
                                                      ? Colors.green
                                                      : doj == yesterday
                                                          ? Colors.white
                                                          : Colors.brown
                                              : Constants.themeBgColor)),
                                  padding: const EdgeInsets.only(
                                      left: 5, top: 4, bottom: 4, right: 5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.calendar_month_outlined,
                                          size: 15.h,
                                          color: item.doj != null
                                              ? item.doj?.day == tomorrow.day &&
                                                      item.doj!.month ==
                                                          tomorrow.month &&
                                                      item.doj!.year ==
                                                          tomorrow.year
                                                  ? Colors.blue
                                                  : item.doj!.day ==
                                                              DateTime.now()
                                                                  .day &&
                                                          item.doj!.month ==
                                                              DateTime.now()
                                                                  .month &&
                                                          item.doj!.year ==
                                                              DateTime.now()
                                                                  .year
                                                      ? Colors.green
                                                      : doj == yesterday
                                                          ? Colors.white
                                                          : Colors.brown
                                              : Constants.themeBgColor),
                                      SizedBox(
                                        width: 4.w,
                                      ),
                                      item.doj != null
                                          ? item.doj!.day == DateTime.now().day &&
                                                  item.doj!.month ==
                                                      DateTime.now().month &&
                                                  item.doj!.year ==
                                                      DateTime.now().year
                                              ? Text("Today",
                                                  style: GoogleFonts.varela(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.w600))
                                              : item.doj!.day == tomorrow.day &&
                                                      item.doj!.month ==
                                                          tomorrow.month &&
                                                      item.doj!.year ==
                                                          tomorrow.year
                                                  ? Text("Tomorrow",
                                                      style: GoogleFonts.varela(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.w600))
                                                  : doj == yesterday
                                                      ? Text("Yesterday",
                                                          style: GoogleFonts.varela(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600))
                                                      : Text(DateFormat('dd MMM yyyy').format(item.doj!),
                                                          style: GoogleFonts.varela(
                                                              color:
                                                                  Colors.brown,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600))
                                          : Text("Select DOJ",
                                              style: GoogleFonts.varela(color: Constants.themeBgColor, fontWeight: FontWeight.w600)),
                                    ],
                                  )),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            if (item.doj != null &&
                                !isToday &&
                                item.sub_code != "IB7-4")
                              InkWell(
                                onTap: () {
                                  ChangeStatusModel changeStatusModel =
                                      ChangeStatusModel(
                                    status: "IB7",
                                    subStatus: "Confirmation Pending",
                                    doj: null,
                                    id: item.id,
                                    sourceId: item.sourceId,
                                  );
                                  Map<String, dynamic> jsonData =
                                      changeStatusModel.toJson();
                                  try {
                                    JobPostApiService.changeStatus(
                                        jsonData, item.id!.toInt());
                                    setState(() {});
                                    // First pop to close the dialog
                                  } catch (e) {
                                    print('Error: $e');
                                    // Handle error...
                                  }
                                },
                                child: Image.asset(
                                  "assets/images/close (1).png",
                                  height: 16.h,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            const Spacer(),
                            if (item.sub_code == "IB7-4")
                              Container(
                                margin:
                                    EdgeInsets.only(bottom: 10.h, right: 10.w),
                                child: Image.asset(
                                  "assets/images/readytojoin.png",
                                  height: 40.h,
                                ),
                              ),
                          ],
                        ),
                      if (item.status_code == "IB5" && !isWalkOut)
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Wrap(
                              children: List.generate(
                                applicationList!
                                    .where(
                                        (option) => option.code!.contains(';'))
                                    .length,
                                (index) {
                                  final option = applicationList!
                                      .where((option) =>
                                          option.code!.contains(';'))
                                      .toList()[index];
                                  return InkWell(
                                    onTap: option.code != "IB8;2"
                                        ? () {
                                            ChangeStatusModel
                                                changeStatusModel =
                                                ChangeStatusModel(
                                              status:
                                                  option.sub_value.toString(),
                                              sourceId: item.sourceId,
                                              subStatus: option.value,
                                            );
                                            Map<String, dynamic> jsonData =
                                                changeStatusModel.toJson();
                                            try {
                                              JobPostApiService.changeStatus(
                                                  jsonData, item.id!.toInt());
                                              setState(() {});
                                            } catch (e) {
                                              print('Error: $e');
                                              // Handle error...
                                            }
                                          }
                                        : () {
                                            setState(() {
                                              isWalkOut = !isWalkOut;
                                            });
                                          },
                                    child: Wrap(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 6, right: 6),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 2),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            color: Colors.grey.shade100,
                                            border: Border.all(
                                                color: Constants.borderColor),
                                          ),
                                          child: Text(
                                            option.value.toString(),
                                            style: GoogleFonts.varela(
                                                color: Colors.blue),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                            /*  ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: applicationList!
                                    .where((option) => option.code!.contains(';'))
                                    .length,
                                itemBuilder: (context, index) {
                                  final option = applicationList!
                                      .where((option) => option.code!.contains(';'))
                                      .toList()[index];
                                  return InkWell(
                                    onTap: option.code != "IB8;2"
                                        ? () {
                                            ChangeStatusModel changeStatusModel =
                                                ChangeStatusModel(
                                                    status:
                                                        option.sub_value.toString(),
                                                    sourceId: item.sourceId,
                                                    subStatus: option.value);
                                            Map<String, dynamic> jsonData =
                                                changeStatusModel.toJson();
                                            try {
                                              JobPostApiService.changeStatus(
                                                  jsonData, item.id!.toInt());
                                              setState(() {});
                                            } catch (e) {
                                              print('Error: $e');
                                              // Handle error...
                                            }
                                          }
                                        : () {
                                            setState(() {
                                              selectedWalkOut[item.id!.toInt()] =
                                                  !isWalk;
                                            });
                                          },
                                    child: Wrap(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 6, bottom: 6, right: 6),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 2),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              color: Colors.grey.shade100,
                                              border: Border.all(
                                                  color: Constants.borderColor)),
                                          child: Text(option.value.toString(),
                                              style: GoogleFonts.varela(
                                                  color: Colors.blue)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ), */
                            const Spacer(),
                            // const (),
                            //if (item.status_code!.contains("IB5"))
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 2),
                                child: Stack(
                                  children: [
                                    // item.sub_code=="IB5:1"?
                                    ToggleButton(
                                      initialValue: item.sub_code == "IB5:1"
                                          ? true
                                          : false,
                                      item: item,
                                      id: item.id!.toInt(),
                                      refreshCallback: () {
                                        ref.refresh(fetchAllApplicantProvider(
                                            profilemodel.id!.toInt()));
                                      },
                                    ),
                                  ],
                                )),
                          ],
                        ),

                      if (item.status_code == "IB5" &&
                          !isRejected &&
                          !isWalkOut)
                        Row(children: [
                          InkWell(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomDialogueForSelect(
                                    item: item,
                                    refreshCallback: () {
                                      ref.refresh(fetchAllApplicantProvider(
                                          profilemodel.id!.toInt()));
                                    },
                                  );
                                },
                              );
                              ref.refresh(fetchAllApplicantProvider(
                                  profilemodel.id!.toInt()));
                              /*    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => CC(
                                                key: _talentPollKey,
                                              )))); */
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 3, top: 3.h),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.green[900],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Constants.borderColor, width: 2)),
                              child: Text("Select",
                                  style: GoogleFonts.varela(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                          if (!isRejected && !isWalkOut)
                            InkWell(
                              onTap: () {
                                //  selectedJobs[item.id!.toInt()] = !isSelected;

                                setState(() {
                                  isRejected = !isRejected;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 3, bottom: 3, left: 10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Constants.themeBgColor,
                                        width: 2)),
                                child: Text("Reject",
                                    style: GoogleFonts.varela(
                                        color: Constants.themeBgColor,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          const Spacer(),
                          if (item.status_code != "IB7" &&
                              item.status_code == "IB5")
                            Container(
                              height: 30.h,
                              padding: const EdgeInsets.only(left: 8),
                              // Adjust the padding as needed
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.r),
                                border:
                                    Border.all(color: Colors.blue, width: 1.5),
                              ),
                              child: DropdownButton<String>(
                                // menuMaxHeight: 0.1,
                                borderRadius: BorderRadius.circular(8.r),
                                elevation: 4,
                                value: item.interview_rounds,
                                onChanged: (newValue) async {
                                  if (newValue != null) {
                                    updateSelectedRoundForJob(
                                        item.id!.toInt(), newValue);
                                  }
                                  ChangeStatusModel changeStatusModel =
                                      ChangeStatusModel(
                                    status: "IB5",
                                    sourceId: item.sourceId,
                                    interview_rounds: newValue,
                                    subStatus: item.sub_status,
                                  );
                                  Map<String, dynamic> jsonData =
                                      changeStatusModel.toJson();
                                  try {
                                    await JobPostApiService.changeStatus(
                                        jsonData, item.id!.toInt());
                                    ref.refresh(fetchAllApplicantProvider(
                                        profilemodel.id!.toInt()));
                                    setState(() {});
                                  } catch (e) {
                                    print('Error: $e');
                                    // Handle error...
                                  }
                                },
                                items: [
                                  if (item.interview_rounds != null &&
                                      !finalinterviewRounds
                                          .contains(item.interview_rounds))
                                    DropdownMenuItem<String>(
                                      value: item
                                          .interview_rounds, // Use the initial value from the JSON string
                                      child: Text(
                                        item.interview_rounds.toString(),
                                        style: GoogleFonts.varela(
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ...finalinterviewRounds.map((round) {
                                    return DropdownMenuItem<String>(
                                      value: round,
                                      child: Text(
                                        round,
                                        style: GoogleFonts.varela(
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                                underline:
                                    Container(), // This removes the underline
                                hint: Text(
                                  'Select',
                                  style: GoogleFonts.varela(
                                    fontSize: 12.sp,
                                  ),
                                ), // Display "Select" when item.interview_rounds is empty
                              ),
                            )
                        ]),

                      /* FutureBuilder<InterviewResult>(
                                  future: fetchDataAndUpdateDropdown(
                                      item.jobId!.toInt(), item.id!.toInt()),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child: Text('Error: ${snapshot.error}'));
                                    } else if (snapshot.hasData) {
                                      InterviewResult interviewResult =
                                          snapshot.data!;
                                      interviewRounds = interviewResult
                                          .resultData.interviewRounds;

                                      return Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            height: 30,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                border:
                                                    Border.all(color: Colors.blue)),
                                            child: DropdownButton<String>(
                                              elevation: 4,
                                              value: selectedRoundsMap[item.id],
                                              onChanged: (newValue) {
                                                if (newValue != null) {
                                                  updateSelectedRoundForJob(
                                                      item.id!.toInt(), newValue);
                                                }
                                                ChangeStatusModel
                                                    changeStatusModel =
                                                    ChangeStatusModel(
                                                        status: "IB5".toString(),
                                                        sourceId: item.sourceId,
                                                        interview_rounds: newValue,
                                                        subStatus: item.sub_status);
                                                Map<String, dynamic> jsonData =
                                                    changeStatusModel.toJson();
                                                try {
                                                  JobPostApiService.changeStatus(
                                                      jsonData, item.id!.toInt());
                                                  setState(() {});
                                                } catch (e) {
                                                  print('Error: $e');
                                                  // Handle error...
                                                }
                                              },
                                              items: [
                                                DropdownMenuItem<String>(
                                                    value: item.interview_rounds,
                                                    child: item.interview_rounds ==
                                                            null
                                                        ? Text(
                                                            'InterView rounds',
                                                            style:
                                                                GoogleFonts.varela(
                                                                    fontSize:
                                                                        14.sp),
                                                          )
                                                        : Text(
                                                            item.interview_rounds
                                                                .toString(),
                                                            style:
                                                                GoogleFonts.varela(
                                                                    fontSize:
                                                                        14.sp),
                                                          )),
                                                for (String round
                                                    in interviewRounds)
                                                  DropdownMenuItem<String>(
                                                    value: round,
                                                    child: Text(
                                                      round,
                                                      style: GoogleFonts.varela(
                                                          fontSize: 12.sp),
                                                    ),
                                                  ),
                                              ],
                                              underline:
                                                  Container(), // This removes the underline
                                            ),
                                          ),

                                          // Rest of your UI...
                                        ],
                                      );
                                    } else {
                                      return const Center(
                                          child: Text('No data available'));
                                    }
                                  },
                                ) */

                      if (item.status_code == "IB7" &&
                              item.sub_code == "IB7-5" ||
                          item.sub_code == "IB7-4" && !isDropOut)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (item.doj != null && isToday ||
                                item.doj != null && isYesterday)
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isDropOut = !isDropOut;
                                    notJoin = true;
                                    Drop = false;
                                  });
                                },
                                /* ChangeStatusModel changeStatusModel =
                                        ChangeStatusModel(
                                      status: "IB7",
                                      subStatus: "Not Join",
                                      doj: item.doj,
                                      id: item.id,
                                      sourceId: item.sourceId,
                                    );
                                    Map<String, dynamic> jsonData =
                                        changeStatusModel.toJson();
                                    try {
                                      JobPostApiService.changeStatus(
                                          jsonData, item.id!.toInt());
                                      setState(() {});
                                      // First pop to close the dialog
                                    } catch (e) {
                                      print('Error: $e');
                                      // Handle error...
                                    } */

                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 5, bottom: 3, right: 6),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Constants.themeBgColor,
                                          width: 2)),
                                  child: Text("Not Join",
                                      style: GoogleFonts.varela(
                                          color: Constants.themeBgColor,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            if (item.doj != null && isToday ||
                                item.doj != null && isYesterday)
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomDialogueForJoin(
                                        item: item,
                                      );
                                    },
                                  );
                                  /*  ChangeStatusModel changeStatusModel =
                                        ChangeStatusModel(
                                      status: "IB7",
                                      subStatus: "Join",
                                      doj: item.doj,
                                      id: item.id,
                                      sourceId: item.sourceId,
                                    );
                                    Map<String, dynamic> jsonData =
                                        changeStatusModel.toJson();
                                    try {
                                      JobPostApiService.changeStatus(
                                          jsonData, item.id!.toInt());
                                      setState(() {});
                                      // First pop to close the dialog
                                    } catch (e) {
                                      print('Error: $e');
                                      // Handle error...
                                    } */
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 5, bottom: 3, right: 6),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.green, width: 2)),
                                  child: Text("Join",
                                      style: GoogleFonts.varela(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            if (((item.doj == null || !isToday) &&
                                    !isYesterday) &&
                                item.sub_code != "IB7-4")
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isDropOut = !isDropOut;
                                    Drop = true;
                                    notJoin = false;
                                  });
                                  /*  ChangeStatusModel changeStatusModel =
                                        ChangeStatusModel(
                                      status: "IB7",
                                      subStatus: "Offer Drop",
                                      doj: item.doj,
                                      id: item.id,
                                      sourceId: item.sourceId,
                                    );
                                    Map<String, dynamic> jsonData =
                                        changeStatusModel.toJson();
                                    try {
                                      JobPostApiService.changeStatus(
                                          jsonData, item.id!.toInt());
                                      setState(() {});
                                      // First pop to close the dialog
                                    } catch (e) {
                                      print('Error: $e');
                                      // Handle error...
                                    } */
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 5, bottom: 3, right: 6),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Constants.themeBgColor,
                                          width: 2)),
                                  child: Text("Offer Drop",
                                      style: GoogleFonts.varela(
                                          color: Constants.themeBgColor,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            if (!isToday &&
                                item.doj != null &&
                                !isYesterday &&
                                item.sub_code != "IB7-4")
                              InkWell(
                                onTap: () async {
                                  ChangeStatusModel changeStatusModel =
                                      ChangeStatusModel(
                                    status: "IB7",
                                    subStatus: "Ready to Join",
                                    doj: item.doj,
                                    id: item.id,
                                    sourceId: item.sourceId,
                                  );
                                  Map<String, dynamic> jsonData =
                                      changeStatusModel.toJson();
                                  try {
                                    await JobPostApiService.changeStatus(
                                        jsonData, item.id!.toInt());
                                    ref.refresh(fetchAllApplicantProvider(
                                        profilemodel.id!.toInt()));
                                    setState(() {});
                                    // First pop to close the dialog
                                  } catch (e) {
                                    print('Error: $e');
                                    // Handle error...
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    top: 5,
                                    bottom: 3,
                                    right: 6,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.green, width: 2)),
                                  child: Text("Ready to Join",
                                      style: GoogleFonts.varela(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                          ],
                        ),

                      //TODO: Reason remark for offer Drop and not join

                      if (item.status_code == "IB7" && isDropOut)
                        Container(
                          margin: EdgeInsets.only(top: 10.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r)),
                          height: MediaQuery.of(context).size.height / 26,
                          child: TextField(
                            controller: remarkfordropandNotJoin,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(top: 10.h, left: 6.w),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Constants.borderColor),
                                  borderRadius: BorderRadius.circular(8)),
                              labelText: notJoin
                                  ? "Reason of Not Join"
                                  : Drop
                                      ? "Reason of Offer Drop"
                                      : "",
                              hintStyle: GoogleFonts.varela(
                                  color: Colors.grey.shade400),
                              hintText: notJoin
                                  ? "Reason of not join"
                                  : Drop
                                      ? "Reason of Offer Drop"
                                      : "",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Constants.borderColor),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Constants.borderColor),
                              ),
                            ),
                          ),
                        ),

                      if (item.status_code == "IB7" && isDropOut) //isOfferDrop
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isDropOut = !isDropOut;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 10),
                                child: Text("Cancel",
                                    style: GoogleFonts.varela(
                                        color: Constants.themeBgColor,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            /*  ElevatedButton(
                                onPressed: () {selectedoption
                                  /*  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => CC(
                                                key: _talentPollKey,
                                              )))); */
                                  // Perform actions on submission
                                  // For example, save the reason and update status
                                  // ...

                                  // Reset _showRejectTextField to hide the text field
                                  setState(() {
                                    _showRejectTextField = true;
                                  });
                                },
                                child: const Text("Cancel"),
                              ), */
                            //    if (showrejectTextFileld.text.isNotEmpty)
                            // if (showrejectTextFileld.text.isNotEmpty)
                            InkWell(
                              onTap: () async {
                                if (remarkfordropandNotJoin.text.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomDialog(
                                          fetchDataFromApi: () {},
                                          onClose: () {
                                            Navigator.pop(context);
                                          },
                                          isFisrt: false,
                                          title: "Feedback",
                                          subtitle: notJoin
                                              ? "Please give the reason of Not Join"
                                              : Drop
                                                  ? "Please give the reason of Offer Drop"
                                                  : "");
                                    },
                                  );
                                } else {
                                  ChangeStatusModel changeStatusModel =
                                      ChangeStatusModel(
                                          status: "IB7",
                                          subStatus: notJoin
                                              ? "Not Join"
                                              : "Offer Drop",
                                          doj: item.doj,
                                          id: item.id,
                                          sourceId: item.sourceId,
                                          remark: remarkfordropandNotJoin.text);
                                  Map<String, dynamic> jsonData =
                                      changeStatusModel.toJson();
                                  try {
                                    await JobPostApiService.changeStatus(
                                        jsonData, item.id!.toInt());
                                    ref.refresh(fetchAllApplicantProvider(
                                        profilemodel.id!.toInt()));
                                    setState(() {});
                                  } catch (e) {
                                    print('Error: $e');
                                    // Handle error...
                                  }
                                  /*  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => CC(
                                                key: _talentPollKey,
                                              )))); */
                                  // Perform actions on submission
                                  // For example, save the reason and update status
                                  // ...

                                  // Reset _showRejectTextField to hide the text field
                                  setState(() {
                                    _showremarkfordropandNotJoin = false;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 10),
                                child: Text("Submit",
                                    style: GoogleFonts.varela(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      if (item.status_code == "IB8" && item.remark != null)
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: const Offset(0.5, 2),
                                    blurRadius: 2,
                                    spreadRadius: 2)
                              ],
                              borderRadius: BorderRadius.circular(8.r)),
                          margin: EdgeInsets.only(top: 4.h),
                          padding: EdgeInsets.symmetric(
                              vertical: 4.h, horizontal: 8.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Feedback",
                                style: GoogleFonts.varela(
                                    // color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp),
                              ),
                              if (item.remark != null)
                                Text(
                                  "${item.remark}",
                                  style: GoogleFonts.varela(
                                    color: Colors.black54,
                                    fontSize: 12.sp,
                                  ),
                                  overflow: TextOverflow.clip,
                                  softWrap: true,
                                ),
                            ],
                          ),
                        ),

                      //TODO: Remark End for not join and offer drop......

                      if (item.status_code == "IB5" && isRejected || isWalkOut)
                        Container(
                          margin: EdgeInsets.only(top: 10.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r)),
                          height: MediaQuery.of(context).size.height / 26,
                          child: TextField(
                            controller: showrejectTextFileld,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(top: 10.h, left: 6.w),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Constants.borderColor),
                                  borderRadius: BorderRadius.circular(8)),
                              labelText: isRejected
                                  ? "Reason of Rejection"
                                  : isDropOut
                                      ? "Reason of Drop-Out"
                                      : "Reason of Walk Out",
                              hintStyle: GoogleFonts.varela(
                                  color: Colors.grey.shade400),
                              hintText: isRejected
                                  ? "Reason of Rejection"
                                  : isDropOut
                                      ? "Reason of Drop-Out"
                                      : "Reason of Walk Out",
                              //labelStyle: GoogleFonts.varela(color: Colors.grey.shade400),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Constants.borderColor),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Constants.borderColor),
                              ),
                            ),
                          ),
                        ),
                      if (item.status_code == "IB5" && isRejected || isWalkOut)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isRejected
                                      ? isRejected = !isRejected
                                      : isDropOut == true
                                          ? isDropOut = !isDropOut
                                          : isWalkOut = !isWalkOut;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 10),
                                child: Text("Cancel",
                                    style: GoogleFonts.varela(
                                        color: Constants.themeBgColor,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            /*  ElevatedButton(
                                onPressed: () {
                                  /*  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => CC(
                                                key: _talentPollKey,
                                              )))); */
                                  // Perform actions on submission
                                  // For example, save the reason and update status
                                  // ...

                                  // Reset _showRejectTextField to hide the text field
                                  setState(() {
                                    _showRejectTextField = true;
                                  });
                                },
                                child: const Text("Cancel"),
                              ), */
                            //    if (showrejectTextFileld.text.isNotEmpty)
                            // if (showrejectTextFileld.text.isNotEmpty)
                            InkWell(
                              onTap: () async {
                                if (showrejectTextFileld.text.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomDialog(
                                          fetchDataFromApi: () {},
                                          onClose: () {
                                            Navigator.pop(context);
                                          },
                                          isFisrt: false,
                                          title: "Feedback",
                                          subtitle: isRejected
                                              ? "Please give the reason of Rejection"
                                              : isDropOut
                                                  ? "Provide Reason to drop out first"
                                                  : "Provide Reason to walk out first");
                                    },
                                  );
                                } else {
                                  ChangeStatusModel changeStatusModel =
                                      ChangeStatusModel(
                                          status: isRejected
                                              ? "IB6"
                                              : isDropOut
                                                  ? "IB8"
                                                  : "IB8",
                                          sourceId: item.sourceId,
                                          remark: showrejectTextFileld.text);
                                  Map<String, dynamic> jsonData =
                                      changeStatusModel.toJson();
                                  try {
                                    await JobPostApiService.changeStatus(
                                        jsonData, item.id!.toInt());
                                    ref.refresh(fetchAllApplicantProvider(
                                        profilemodel.id!.toInt()));
                                    setState(() {});
                                  } catch (e) {
                                    print('Error: $e');
                                    // Handle error...
                                  }
                                  /*  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => CC(
                                                key: _talentPollKey,
                                              )))); */
                                  // Perform actions on submission
                                  // For example, save the reason and update status
                                  // ...

                                  // Reset _showRejectTextField to hide the text field
                                  setState(() {
                                    _showRejectTextField = false;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 10),
                                child: Text("Submit",
                                    style: GoogleFonts.varela(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                    ],
                  );
                }),

                // initialPadding: EdgeInsets.zero,
                // contentPadding: EdgeInsets.only(left: 7.w),
                //key: cardB,
                // trailing: const Icon(null),

                /* children: <Widget>[
                    const Divider(
                      thickness: 1.0,
                      height: 1.0,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 10),
                      // padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [Text("${item.process} - ${item.level}")],
                          ),
                          Text(item.companyName)
                        ],
                      ),
                    )
                  ] */
              ),
            ),
          ),
        ),
        if (item.resume != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: [
                  /*  if (item.status != "Application")
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFViewerScreen(
                                pdfAssetPath: 'assets/images/cv.pdf',
                                phoneNumber1: item.contactNo!.toInt(),
                                phoneNumber2: item.alternateNo!.toInt(),
                                // Replace with the actual asset path of your PDF file
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.edit,
                          size: 15.h,
                          color: Constants.themeBgColor,
                        )), */
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PDFViewerScreen(
                              pdfAssetPath: item.resume.toString(),
                              phoneNumber1: item.contactNo!.toInt(),
                              phoneNumber2: item.alternateNo != null
                                  ? item.alternateNo!.toInt()
                                  : 0,

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
          )
      ],
    );
  }

  Container disableContainer(String title) {
    return Container(
      margin: EdgeInsets.only(right: 6.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child:
          Text(title, style: GoogleFonts.varela(color: Colors.grey.shade500)),
    );
  }

  Widget customTab(
    String title,
  ) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Constants.borderColor, width: 1)),
        child: Row(
          children: [
            Text(title),
            SizedBox(
              width: 5.w,
            ),
          ],
        ));
  }

  PopupMenuItem<String> customMenuItem(Application option, bool isOdd) {
    return PopupMenuItem<String>(
      value: option
          .value, // Replace 'someValue' with the actual property you want to use as the value
      child: Text(
        option.value
            .toString(), // Replace 'applicantName' with the actual property you want to use as the label
        style: const TextStyle(
            color: Colors.black // Example: custom styling based on isOdd
            ),
      ),
    );
  }
}
