// ignore_for_file: unused_result, avoid_print, unused_field, override_on_non_overriding_member, unused_local_variable, prefer_final_fields, use_full_hex_values_for_flutter_colors, non_constant_identifier_names, avoid_unnecessary_containers, use_build_context_synchronously
// ignore_for_file: todo
import 'dart:convert';

import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/customdialogue_for_call_whatsapp.dart';
import 'package:job_circle/constants/drop_down_class.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/application_status_model.dart';
import 'package:job_circle/models/changeStatusModel.dart';
import 'package:job_circle/models/drop_down_model.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/models/job_details_model.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/screens/Lead_details/lead_details.dart';
import 'package:job_circle/screens/jobs/interview_bay_executive.dart';
import 'package:job_circle/screens/jobs/pdf.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/service/data_get_api_service.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:job_circle/tracking/application.dart';
import 'package:job_circle/tracking/assign.dart';
import 'package:job_circle/tracking/line_up.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' hide RefreshIndicator;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:timelines/timelines.dart';
import 'package:url_launcher/url_launcher.dart';

final fetchAllTalentPoolProvider = FutureProvider<List<Applicant>>(
    (ref) => _TalentPoolExecutiveState.fetchAllApplicants());

class TalentPoolExecutive extends ConsumerStatefulWidget {
  const TalentPoolExecutive({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TalentPoolExecutiveState();
}

class _TalentPoolExecutiveState extends ConsumerState<TalentPoolExecutive> {
  @override
  void initState() {
    super.initState();
    initializeState();
  }

  Future<void> initializeState() async {
    await bindProfileSummary();
    fetchData();

    fetchTabData();
    // await fetchAllApplicants(profilemodel.id!.toInt());
    //  _applicantsFuture = fetchApplicantsByUserId(552);
  }

  Future<void> bindProfileSummary() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var id = await Utils.getPreferencesValue(
      prefs,
      ESharedPreferences.user_id.name,
    );
    var result =
        await UserDataService().getUserProfileSummary(int.tryParse(id)!);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      var dataResult = Utils.parseResponse(result).resultData;

      profilemodel = ProfileSummaryModel.fromJson(dataResult);
    } else {
      // Handle the case when the API call fails
      setState(() {
        profilemodel =
            ProfileSummaryModel(); // or set it to an appropriate default value
      });
    }
  }

  static Future<List<Applicant>> fetchAllApplicants() async {
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/leads/v1/getAllLeadsBySourceId?sourceId=$userid&page=1&size=100');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> contentList = jsonData['resultData']['content'];

        // Convert the list of Map to a list of Applicant objects
        List<Applicant> applicants = contentList
            .map((json) => Applicant.fromJson(json))
            .where((applicant) =>
                (applicant.is_status_hide == 1 &&
                    isCurrentMonth(applicant.dol)) ||
                (applicant.is_status_hide == 0 &&
                    applicant.sub_status == "Join" &&
                    isCurrentMonth(applicant.dol)) ||
                (applicant.is_status_hide == null ||
                    applicant.is_status_hide == 0))
            .toList();
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

  static bool isCurrentMonth(DateTime? date) {
    if (date == null) return false;
    DateTime now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  JobDetailsModel jobDetailsModel = JobDetailsModel();
  ProfileSummaryModel profilemodel = ProfileSummaryModel();
  @override
  Future<List<Applicant>>? _applicantsFuture;
  List<DropDownItem>? applicationList = [];
  List<DropDownItem>? dropDownItemList = [];

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

  void fetchData() async {
    try {
      ApplicationAPI api = ApplicationAPI();
      // applicationList = await getApplicationStatusList();
      dropDownItemList = await getDropDownData();

      // Use the applicationList as needed
      // For example, you can print the groupName of each Application object:
      // for (var application in applicationList) {
      // print(applicationList.map((e) => e.value));
      // }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  final List<RefreshController> _refreshControllers = List.generate(
    10,
    (index) => RefreshController(initialRefresh: false),
  );

  Future<void> _onRefresh() async {
    // Perform a global refresh (e.g., fetch new data for all tabs)
    await Future.delayed(const Duration(seconds: 2));

    ref.refresh(fetchAllTalentPoolProvider);
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
        .map((e) => e.executive_status != null
            ? e.executive_status.toString()
            : e.s2ExecutiveStatus)
        // .where((element) => element == "Application" || element == "Assign")
        .where((status) => status != null)
        .map(
            (status) => status!) // Non-null assertion to handle non-null values
        .toSet()
        .toList()
      ..sort();
  }

  List<String> getNtiveStatus(List<Applicant> applicants) {
    return applicants
        .where(
            (e) => (e.is_status_hide != null ? e.is_status_hide == 1 : false))
        .where((element) =>
            element.hr_status_id != 14 && element.hr_status_id != 13)
        .map((e) => e.hr_status != null ? e.hr_status.toString() : e.s2HrStatus)
        .where((status) => status != null)
        .map(
            (status) => status!) // Non-null assertion to handle non-null values
        .toSet()
        .toList()
      ..sort();
  }

  List<String> getSubStatus(List<Applicant> applicants) {
    return applicants
        .map((e) => e.hr_sub_status != null
            ? e.hr_sub_status.toString()
            : e.s2HrSubStatus)
        // .where((element) => element == "Application" || element == "Assign")
        .where((status) => status != null)
        .map(
            (status) => status!) // Non-null assertion to handle non-null values
        .toSet()
        .toList()
      ..sort();
  }

  bool isSelect = false;
  bool isSearchVisible = false;
  final FocusNode _searchFocusNode = FocusNode();

  final bool _showRejectTextField = false;
  final bool _showremarkfordropandNotJoin = false;

  late AnimationController _animationController;

  Map<int, SelectedOption> selectedValueMap = {};

  Map<int, String> selectedRoundsMap = {};

  bool _isVi = false, isf2f = false;
  late TabController customTabController;
  TextEditingController searchController1 = TextEditingController();

  List<Applicant>? applicants; // Holds fetched data
  bool isLoading = true; // Indicates whether data is loading
  String? error; // Holds error message, if any

  Future<void> fetchTabData() async {
    try {
      List<Applicant> data = await fetchAllApplicants();
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

  bool isSearchEnable = false;

  FocusNode searchNode = FocusNode();

  final TextEditingController _searchController = TextEditingController();
  List<Applicant>? _filteredData;

  String? selectedItemForSelect = "All";
  String? selectedItemForBay = "All";

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var fetchApplicants =
        profilemodel.id != null ? ref.watch(fetchAllTalentPoolProvider) : null;

    // Build your widget's UI with the 'profilemodel' data
    // For example:
    return PageStorage(
        bucket: PageStorageBucket(),
        child: fetchApplicants != null
            ? fetchApplicants.when(
                data: (fetchdata) {
                  List<String?> itemforbay = fetchdata
                      .where((element) =>
                          element.hr_status_id == 14 &&
                          element.status_id ==
                              1) //TODO:: List of all source_name and freelancer_name
                      .map((element) => [
                            element.short_name != null &&
                                    element.short_name != ""
                                ? element.short_name
                                : "All",
                          ]) // Map both sourceName and refername
                      .expand((element) => element) // Flatten the list of lists
                      .toSet()
                      .toList();

                  List<String?> itemforSelect = fetchdata
                      .where((element) =>
                          element.hr_status_id ==
                          13) //TODO:: List of all source_name and freelancer_name
                      .map((element) => [
                            element.short_name != null &&
                                    element.short_name != ""
                                ? element.short_name
                                : "All",
                          ]) // Map both sourceName and refername
                      .expand((element) => element) // Flatten the list of lists
                      .toSet()
                      .toList();
                  /* fetchApplicants = ref

                  
              .refresh(fetchAllApplicantProvider(profilemodel.id!.toInt())); */ //TODO: to refresh data from api.
                  List<Applicant>? dataList = fetchdata;

                  // Define a flag to track if any item meets the condition
                  bool anyItemMeetsCondition = false;

                  for (Applicant item in dataList) {
                    if (item.executive_status != null ||
                        item.s2ExecutiveStatus != null) {
                      // If the condition is met for any item, set the flag to true and break the loop
                      anyItemMeetsCondition = true;
                      break;
                    }
                  }
                  if (anyItemMeetsCondition) {
                    final data = fetchdata;
                    final statuses = getStatuses(data);
                    final substatus = getSubStatus(data);
                    final negativeStatus = getNtiveStatus(data);

                    return DefaultTabController(
                      length: statuses.length,
                      child: Scaffold(
                        floatingActionButton: DraggableFab(
                          //  initPosition: const Offset(4, 3),
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
                        /*  floatingActionButtonLocation:
                            FloatingActionButtonLocation.miniCenterDocked,
                        floatingActionButton: FloatingActionButton(
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
                            }), */
                        backgroundColor: Colors.white,
                        appBar: PreferredSize(
                          preferredSize: Size(
                              double.maxFinite,
                              isSearchEnable
                                  ? kTextTabBarHeight * 1.8
                                  : kToolbarHeight / 1.1),
                          child: AppBar(
                            title: isSearchEnable
                                ? SizedBox(
                                    // margin: EdgeInsets.only(top: 10.h),
                                    height:
                                        MediaQuery.of(context).size.height / 26,
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
                                              top: 8,
                                              bottom: 8,
                                              left: 10,
                                              right: 10),
                                          counterText: '',
                                          // labelText: "Remark",
                                          labelStyle: const TextStyle(
                                            color: Constants.themeBgColor,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade400),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade400),
                                          ),
                                          focusColor: const Color(0xffff0eceb),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                          hintText: "Sameer",
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
                                                isSearchEnable =
                                                    !isSearchEnable;
                                              })
                                            : setState(() {});
                                      },
                                    ),
                                  )
                                : null,
                            elevation: 0,
                            backgroundColor: Constants.bgColorWhite,
                            bottom: TabBar(
                              unselectedLabelStyle: GoogleFonts.varela(
                                  fontWeight: FontWeight.normal),
                              labelStyle: GoogleFonts.varela(
                                  fontWeight: FontWeight.bold),
                              // physics: const (),
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
                                border:
                                    Border.all(color: Constants.borderColor),
                              ),
                              tabs: statuses
                                  .map(
                                    (status) => customTab(
                                        status,
                                        data
                                            .where((applicant) =>
                                                applicant.executive_status.toString() ==
                                                    status ||
                                                applicant.s2ExecutiveStatus
                                                        .toString() ==
                                                    status)
                                            .where((element) =>
                                                element.applicantName!
                                                    .toLowerCase()
                                                    .contains(_searchController
                                                        .text
                                                        .toLowerCase()) ||
                                                element.contactNo
                                                    .toString()
                                                    .toString()
                                                    .contains(_searchController
                                                        .text
                                                        .toLowerCase()) ||
                                                element.last_name!
                                                    .toLowerCase()
                                                    .contains(_searchController.text.toLowerCase()) ||
                                                element.companyName!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                                                element.process!.toLowerCase().contains(_searchController.text.toLowerCase()))
                                            .length // Show status in the top-level tab bar
                                        ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                        body: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: statuses.map((status) {
                            // Filter applicants based on the current status

                            final applicants = data
                                .where((element) =>
                                    element.applicantName!.toLowerCase().contains(
                                        _searchController.text.toLowerCase()) ||
                                    element.last_name!.toLowerCase().contains(
                                        _searchController.text
                                            .toLowerCase()) || //TODO:: For searrch.....
                                    element.companyName!.toLowerCase().contains(
                                        _searchController.text.toLowerCase()) ||
                                    element.contactNo
                                        .toString()
                                        .toString()
                                        .contains(_searchController.text
                                            .toLowerCase()) ||
                                    element.process!.toLowerCase().contains(
                                        _searchController.text.toLowerCase()))
                                .where((applicant) =>
                                    applicant.executive_status != null
                                        ? applicant.executive_status
                                                .toString() ==
                                            status
                                        : applicant.s2ExecutiveStatus == status)
                                .toList();

                            final subStatuses = data
                                .map((lead) =>
                                    lead.hr_sub_status?.toString() ??
                                    lead.s2HrSubStatus)
                                .where((spoc) => spoc != null)
                                .toSet()
                                .toList()
                              ..sort();

                            List<String> substatusWithData = [];
                            for (String? sub in subStatuses) {
                              // Check if there are leads associated with this referral source
                              bool hasDataForSpoc = data.any((lead) =>
                                  (lead.executive_status == status ||
                                      lead.s2ExecutiveStatus == status) &&
                                  (lead.hr_sub_status == sub ||
                                      lead.s2HrSubStatus == sub));
                              if (hasDataForSpoc) {
                                substatusWithData
                                    .add(sub!); // Add non-null referral sources
                              }
                            }

                            /* if (status == "Application") {
                              // No second tab bar needed if subStatuses is empty
                              return SmartRefresher(
                                controller: _refreshControllers[
                                    statuses.indexOf(status)],
                                onRefresh: () async {
                                  await _onRefresh(statuses.indexOf(status));
                                },
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: applicants.length,
                                  itemBuilder: (context, index) {
                                    final applicant = applicants[index];
                                    return listViewItem_new(
                                        profilemodel.report_to!.toInt(),
                                        context,
                                        applicant,
                                        true,
                                        statuses,
                                        profilemodel.id != null
                                            ? profilemodel.id!.toInt()
                                            : 467,
                                        "${profilemodel.first_name} ${profilemodel.last_name}",
                                        index,
                                        dropDownItemList!);
                                  },
                                ),
                              );
                            } */
                            if (status == "Application") {
                              // No second tab bar needed if subStatuses is empty
                              return RefreshIndicator(
                                triggerMode:
                                    RefreshIndicatorTriggerMode.anywhere,
                                displacement:
                                    100.0, // Adjust the distance to trigger the refresh
                                color: Colors.blue,
                                onRefresh: () async {
                                  await _onRefresh();
                                },
                                child: ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: applicants.length,
                                  itemBuilder: (context, index) {
                                    final applicant = applicants[index];
                                    return listViewItem_new(
                                      profilemodel.report_to!.toInt(),
                                      context,
                                      applicant,
                                      true,
                                      statuses,
                                      profilemodel.id != null
                                          ? profilemodel.id!.toInt()
                                          : 467,
                                      "${profilemodel.first_name} ${profilemodel.last_name}",
                                      index,
                                      dropDownItemList!,
                                    );
                                  },
                                ),
                              );
                            } else if (status == "Line-up") {
                              List<String?> uniqueCompanyNames = dataList
                                  .where(
                                      (element) => element.hr_status_id == 20)
                                  .map((applicant) =>
                                      applicant.short_name ??
                                      applicant.companyName)
                                  .toSet()
                                  .toList();

                              return DefaultTabController(
                                length: uniqueCompanyNames.length,
                                child: Scaffold(
                                  appBar: PreferredSize(
                                    preferredSize: const Size(
                                        double.maxFinite, kToolbarHeight / 1.3),
                                    child: AppBar(
                                      // title: const Text("Hello"),
                                      elevation: 0,
                                      backgroundColor: Constants.bgColorWhite,
                                      bottom: TabBar(
                                        unselectedLabelStyle:
                                            GoogleFonts.varela(
                                                fontWeight: FontWeight.normal),
                                        labelStyle: GoogleFonts.varela(
                                            fontWeight: FontWeight.bold),
                                        labelPadding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        labelColor: Colors.black,
                                        isScrollable: true,
                                        unselectedLabelColor: Colors.black,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        splashBorderRadius:
                                            BorderRadius.circular(8),
                                        indicatorWeight: 7.h,
                                        indicatorPadding: EdgeInsets.only(
                                            bottom: 8.h, left: 3.w, right: 3.w),
                                        indicator: BoxDecoration(
                                          color: Constants.borderColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Constants.borderColor),
                                        ),
                                        /*  onTap: (value) {
                                  setState(() {
                                    isSelect = !isSelect;
                                  });
                                }, */
                                        tabs: uniqueCompanyNames
                                            .map((subStatus) => customTab(
                                                subStatus.toString(),
                                                (data
                                                    .where((applicant) =>
                                                        applicant.companyName.toString() == subStatus ||
                                                        applicant.short_name.toString() ==
                                                            subStatus)
                                                    .where((element) =>
                                                        element.applicantName!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                                                        element.last_name!
                                                            .toLowerCase()
                                                            .contains(_searchController.text
                                                                .toLowerCase()) ||
                                                        element.contactNo
                                                            .toString()
                                                            .toString()
                                                            .contains(_searchController
                                                                .text
                                                                .toLowerCase()) ||
                                                        element.companyName!
                                                            .toLowerCase()
                                                            .contains(_searchController.text.toLowerCase()) ||
                                                        element.process!.toLowerCase().contains(_searchController.text.toLowerCase()))
                                                    .where((applicant) => (applicant.companyName.toString() == subStatus || applicant.short_name.toString() == subStatus) && (applicant.executive_status == status || applicant.s2ExecutiveStatus == status))
                                                    .length)))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  body: TabBarView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children:
                                        uniqueCompanyNames.map((subStatus) {
                                      // Filter applicants based on the current status and sub_status
                                      final filteredApplicants = applicants
                                          .where((applicant) =>
                                              (applicant.companyName
                                                          .toString() ==
                                                      subStatus ||
                                                  applicant.short_name
                                                          .toString() ==
                                                      subStatus) &&
                                              (applicant.executive_status ==
                                                      status ||
                                                  applicant.s2ExecutiveStatus ==
                                                      status))
                                          .toList();

                                      return RefreshIndicator(
                                        triggerMode: RefreshIndicatorTriggerMode
                                            .anywhere,
                                        displacement:
                                            100.0, // Adjust the distance to trigger the refresh
                                        color: Colors.blue,
                                        onRefresh: () async {
                                          await _onRefresh();
                                        },
                                        child: ListView.builder(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: filteredApplicants.length,
                                          itemBuilder: (context, index) {
                                            final applicant =
                                                filteredApplicants[index];

                                            return listViewItem_new(
                                                profilemodel.report_to!.toInt(),
                                                context,
                                                applicant,
                                                true,
                                                statuses,
                                                profilemodel.id != null
                                                    ? profilemodel.id!.toInt()
                                                    : 467,
                                                "${profilemodel.first_name} ${profilemodel.last_name}",
                                                index,
                                                dropDownItemList!);
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            } else if (status == "Not Selected/Not shortlist") {
                              return DefaultTabController(
                                length: negativeStatus.length,
                                child: Scaffold(
                                  appBar: PreferredSize(
                                    preferredSize: const Size(
                                        double.maxFinite, kToolbarHeight / 1.3),
                                    child: AppBar(
                                      // title: const Text("Hello"),
                                      elevation: 0,
                                      backgroundColor: Constants.bgColorWhite,
                                      bottom: TabBar(
                                        unselectedLabelStyle:
                                            GoogleFonts.varela(
                                                fontWeight: FontWeight.normal),
                                        labelStyle: GoogleFonts.varela(
                                            fontWeight: FontWeight.bold),
                                        labelPadding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        labelColor: Colors.black,
                                        isScrollable: true,
                                        unselectedLabelColor: Colors.black,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        splashBorderRadius:
                                            BorderRadius.circular(8),
                                        indicatorWeight: 7.h,
                                        indicatorPadding: EdgeInsets.only(
                                            bottom: 8.h, left: 3.w, right: 3.w),
                                        indicator: BoxDecoration(
                                          color: Constants.borderColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Constants.borderColor),
                                        ),
                                        /*  onTap: (value) {
                                  setState(() {
                                    isSelect = !isSelect;
                                  });
                                }, */
                                        tabs: negativeStatus
                                            .map((subStatus) => customTab(
                                                subStatus,
                                                (data
                                                    .where((applicant) =>
                                                        applicant.hr_status.toString() == subStatus ||
                                                        applicant.s2HrStatus.toString() ==
                                                            subStatus)
                                                    .where((element) =>
                                                        element.applicantName!
                                                            .toLowerCase()
                                                            .contains(_searchController.text
                                                                .toLowerCase()) ||
                                                        element.last_name!
                                                            .toLowerCase()
                                                            .contains(_searchController.text
                                                                .toLowerCase()) ||
                                                        element.contactNo
                                                            .toString()
                                                            .toString()
                                                            .contains(_searchController.text.toLowerCase()) ||
                                                        element.companyName!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                                                        element.process!.toLowerCase().contains(_searchController.text.toLowerCase()))
                                                    .where((applicant) => (applicant.hr_status.toString() == subStatus || applicant.s2HrStatus.toString() == subStatus) && (applicant.executive_status == status || applicant.s2ExecutiveStatus == status))
                                                    .length)))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  body: TabBarView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: negativeStatus.map((subStatus) {
                                      // Filter applicants based on the current status and sub_status
                                      final filteredApplicants = applicants
                                          .where((applicant) =>
                                              (applicant.hr_status.toString() ==
                                                      subStatus ||
                                                  applicant.s2HrStatus
                                                          .toString() ==
                                                      subStatus) &&
                                              (applicant.executive_status ==
                                                      status ||
                                                  applicant.s2ExecutiveStatus ==
                                                      status))
                                          .toList();

                                      return RefreshIndicator(
                                        triggerMode: RefreshIndicatorTriggerMode
                                            .anywhere,
                                        displacement:
                                            100.0, // Adjust the distance to trigger the refresh
                                        color: Colors.blue,
                                        onRefresh: () async {
                                          await _onRefresh();
                                        },
                                        child: ListView.builder(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: filteredApplicants.length,
                                          itemBuilder: (context, index) {
                                            final applicant =
                                                filteredApplicants[index];

                                            return listViewItem_new(
                                                profilemodel.report_to!.toInt(),
                                                context,
                                                applicant,
                                                true,
                                                statuses,
                                                profilemodel.id != null
                                                    ? profilemodel.id!.toInt()
                                                    : 467,
                                                "${profilemodel.first_name} ${profilemodel.last_name}",
                                                index,
                                                dropDownItemList!);
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            } else if (status == "Interview bay") {
                              // Second tab bar needed for subStatuses
                              return DefaultTabController(
                                length: substatusWithData.length,
                                child: Scaffold(
                                  appBar: PreferredSize(
                                    preferredSize: const Size(
                                        double.maxFinite, kToolbarHeight / 1.3),
                                    child: AppBar(
                                      // title: const Text("Hello"),
                                      elevation: 0,
                                      backgroundColor: Constants.bgColorWhite,
                                      bottom: TabBar(
                                        unselectedLabelStyle:
                                            GoogleFonts.varela(
                                                fontWeight: FontWeight.normal),
                                        labelStyle: GoogleFonts.varela(
                                            fontWeight: FontWeight.bold),
                                        labelPadding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        labelColor: Colors.black,
                                        isScrollable: true,
                                        unselectedLabelColor: Colors.black,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        splashBorderRadius:
                                            BorderRadius.circular(8),
                                        indicatorWeight: 7.h,
                                        indicatorPadding: EdgeInsets.only(
                                            bottom: 8.h, left: 3.w, right: 3.w),
                                        indicator: BoxDecoration(
                                          color: Constants.borderColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Constants.borderColor),
                                        ),
                                        /*  onTap: (value) {
                                  setState(() {
                                    isSelect = !isSelect;
                                  });
                                }, */
                                        tabs: substatusWithData
                                            .map((subStatus) => customTab(
                                                subStatus == "" &&
                                                        status ==
                                                            "Interview bay"
                                                    ? "In Process"
                                                    : subStatus == "" &&
                                                            status == "Select"
                                                        ? "Hired"
                                                        : subStatus,
                                                (data
                                                    .where((applicant) =>
                                                        applicant.executive_status
                                                                .toString() ==
                                                            status ||
                                                        applicant.s2ExecutiveStatus
                                                                .toString() ==
                                                            status)
                                                    .where((element) =>
                                                        selectedItemForBay == "All" ||
                                                        element.short_name ==
                                                            selectedItemForBay)
                                                    .where((element) =>
                                                        element.applicantName!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                                                        element.last_name!
                                                            .toLowerCase()
                                                            .contains(_searchController.text
                                                                .toLowerCase()) ||
                                                        element.contactNo
                                                            .toString()
                                                            .toString()
                                                            .contains(_searchController.text.toLowerCase()) ||
                                                        element.companyName!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                                                        element.process!.toLowerCase().contains(_searchController.text.toLowerCase()))
                                                    .where((applicant) => (applicant.hr_sub_status.toString() == subStatus || applicant.s2HrSubStatus.toString() == subStatus) && (applicant.executive_status == status || applicant.s2ExecutiveStatus == status))
                                                    .length)))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  body: TabBarView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children:
                                        substatusWithData.map((subStatus) {
                                      // Filter applicants based on the current status and sub_status
                                      final filteredApplicants = applicants
                                          .where((applicant) =>
                                              (applicant.hr_sub_status
                                                          .toString() ==
                                                      subStatus ||
                                                  applicant.s2HrSubStatus
                                                          .toString() ==
                                                      subStatus) &&
                                              (applicant.executive_status ==
                                                      status ||
                                                  applicant.s2ExecutiveStatus ==
                                                      status))
                                          .where((element) =>
                                              selectedItemForBay == "All" ||
                                              element.short_name ==
                                                  selectedItemForBay)
                                          .toList();

                                      return Column(
                                        children: [
                                          Expanded(
                                            child: RefreshIndicator(
                                              triggerMode:
                                                  RefreshIndicatorTriggerMode
                                                      .anywhere,
                                              displacement:
                                                  100.0, // Adjust the distance to trigger the refresh
                                              color: Colors.blue,
                                              onRefresh: () async {
                                                await _onRefresh();
                                              },
                                              child: ListView.builder(
                                                physics:
                                                    const AlwaysScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    filteredApplicants.length,
                                                itemBuilder: (context, index) {
                                                  final applicant =
                                                      filteredApplicants[index];

                                                  return listViewItem_new(
                                                      profilemodel.report_to!
                                                          .toInt(),
                                                      context,
                                                      applicant,
                                                      true,
                                                      statuses,
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
                                                  value: selectedItemForBay,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedItemForBay =
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
                                                    ...itemforbay.map<
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
                                    }).toList(),
                                  ),
                                ),
                              );
                            } else if (status == "Select") {
                              // Second tab bar needed for subStatuses
                              return DefaultTabController(
                                length: substatusWithData.length,
                                child: Scaffold(
                                  appBar: PreferredSize(
                                    preferredSize: const Size(
                                        double.maxFinite, kToolbarHeight / 1.3),
                                    child: AppBar(
                                      // title: const Text("Hello"),
                                      elevation: 0,
                                      backgroundColor: Constants.bgColorWhite,
                                      bottom: TabBar(
                                        unselectedLabelStyle:
                                            GoogleFonts.varela(
                                                fontWeight: FontWeight.normal),
                                        labelStyle: GoogleFonts.varela(
                                            fontWeight: FontWeight.bold),
                                        labelPadding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        labelColor: Colors.black,
                                        isScrollable: true,
                                        unselectedLabelColor: Colors.black,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        splashBorderRadius:
                                            BorderRadius.circular(8),
                                        indicatorWeight: 7.h,
                                        indicatorPadding: EdgeInsets.only(
                                            bottom: 8.h, left: 3.w, right: 3.w),
                                        indicator: BoxDecoration(
                                          color: Constants.borderColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Constants.borderColor),
                                        ),
                                        /*  onTap: (value) {
                                  setState(() {
                                    isSelect = !isSelect;
                                  });
                                }, */
                                        tabs: substatusWithData
                                            .map((subStatus) => customTab(
                                                subStatus,
                                                (data
                                                    .where((applicant) =>
                                                        applicant.executive_status.toString() == status ||
                                                        applicant.s2ExecutiveStatus.toString() ==
                                                            status)
                                                    .where((element) =>
                                                        selectedItemForSelect == "All" ||
                                                        element.short_name ==
                                                            selectedItemForSelect)
                                                    .where((element) =>
                                                        element.applicantName!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                                                        element.last_name!
                                                            .toLowerCase()
                                                            .contains(_searchController
                                                                .text
                                                                .toLowerCase()) ||
                                                        element.contactNo
                                                            .toString()
                                                            .toString()
                                                            .contains(_searchController.text.toLowerCase()) ||
                                                        element.companyName!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                                                        element.process!.toLowerCase().contains(_searchController.text.toLowerCase()))
                                                    .where((applicant) => (applicant.hr_sub_status.toString() == subStatus || applicant.s2HrSubStatus.toString() == subStatus) && (applicant.executive_status == status || applicant.s2ExecutiveStatus == status))
                                                    .length)))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  body: TabBarView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children:
                                        substatusWithData.map((subStatus) {
                                      // Filter applicants based on the current status and sub_status
                                      final filteredApplicants = applicants
                                          .where((applicant) =>
                                              (applicant.hr_sub_status
                                                          .toString() ==
                                                      subStatus ||
                                                  applicant.s2HrSubStatus
                                                          .toString() ==
                                                      subStatus) &&
                                              (applicant.executive_status ==
                                                      status ||
                                                  applicant.s2ExecutiveStatus ==
                                                      status))
                                          .where((element) =>
                                              selectedItemForSelect == "All" ||
                                              element.short_name ==
                                                  selectedItemForSelect)
                                          .toList();

                                      return Column(
                                        children: [
                                          Expanded(
                                            child: RefreshIndicator(
                                              triggerMode:
                                                  RefreshIndicatorTriggerMode
                                                      .anywhere,
                                              displacement:
                                                  100.0, // Adjust the distance to trigger the refresh
                                              color: Colors.blue,
                                              onRefresh: () async {
                                                await _onRefresh();
                                              },
                                              child: ListView.builder(
                                                physics:
                                                    const AlwaysScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    filteredApplicants.length,
                                                itemBuilder: (context, index) {
                                                  final applicant =
                                                      filteredApplicants[index];

                                                  return listViewItem_new(
                                                      profilemodel.report_to!
                                                          .toInt(),
                                                      context,
                                                      applicant,
                                                      true,
                                                      statuses,
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
                                                    ...itemforSelect.map<
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
                                    }).toList(),
                                  ),
                                ),
                              );
                            } else {
                              // Second tab bar needed for subStatuses
                              return DefaultTabController(
                                length: substatusWithData.length,
                                child: Scaffold(
                                  appBar: PreferredSize(
                                    preferredSize: const Size(
                                        double.maxFinite, kToolbarHeight / 1.4),
                                    child: AppBar(
                                      // title: const Text("Hello"),
                                      elevation: 0,
                                      backgroundColor: Constants.bgColorWhite,
                                      bottom: TabBar(
                                        unselectedLabelStyle:
                                            GoogleFonts.varela(
                                                fontWeight: FontWeight.normal),
                                        labelStyle: GoogleFonts.varela(
                                            fontWeight: FontWeight.bold),
                                        labelPadding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        labelColor: Colors.black,
                                        isScrollable: true,
                                        unselectedLabelColor: Colors.black,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        splashBorderRadius:
                                            BorderRadius.circular(8),
                                        indicatorWeight: 7.h,
                                        indicatorPadding: EdgeInsets.only(
                                            bottom: 8.h, left: 3.w, right: 3.w),
                                        indicator: BoxDecoration(
                                          color: Constants.borderColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Constants.borderColor),
                                        ),
                                        /*  onTap: (value) {
                                  setState(() {
                                    isSelect = !isSelect;
                                  });
                                }, */
                                        tabs: substatusWithData
                                            .map((subStatus) => customTab(
                                                subStatus == "" &&
                                                        status ==
                                                            "Interview bay"
                                                    ? "In Process"
                                                    : subStatus == "" &&
                                                            status == "Select"
                                                        ? "Hired"
                                                        : subStatus,
                                                (data
                                                    .where((applicant) =>
                                                        applicant.executive_status
                                                                .toString() ==
                                                            status ||
                                                        applicant.s2ExecutiveStatus
                                                                .toString() ==
                                                            status)
                                                    .where((element) =>
                                                        element.applicantName!
                                                            .toLowerCase()
                                                            .contains(_searchController.text
                                                                .toLowerCase()) ||
                                                        element.last_name!
                                                            .toLowerCase()
                                                            .contains(_searchController.text
                                                                .toLowerCase()) ||
                                                        element.contactNo
                                                            .toString()
                                                            .toString()
                                                            .contains(_searchController.text.toLowerCase()) ||
                                                        element.companyName!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                                                        element.process!.toLowerCase().contains(_searchController.text.toLowerCase()))
                                                    .where((applicant) => (applicant.hr_sub_status.toString() == subStatus || applicant.s2HrSubStatus.toString() == subStatus) && (applicant.executive_status == status || applicant.s2ExecutiveStatus == status))
                                                    .length)))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  body: TabBarView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children:
                                        substatusWithData.map((subStatus) {
                                      // Filter applicants based on the current status and sub_status
                                      final filteredApplicants = applicants
                                          .where((applicant) =>
                                              (applicant.hr_sub_status
                                                          .toString() ==
                                                      subStatus ||
                                                  applicant.s2HrSubStatus
                                                          .toString() ==
                                                      subStatus) &&
                                              (applicant.executive_status ==
                                                      status ||
                                                  applicant.s2ExecutiveStatus ==
                                                      status))
                                          .toList();

                                      return RefreshIndicator(
                                        triggerMode: RefreshIndicatorTriggerMode
                                            .anywhere,
                                        displacement:
                                            100.0, // Adjust the distance to trigger the refresh
                                        color: Colors.blue,
                                        onRefresh: () async {
                                          await _onRefresh();
                                        },
                                        child: ListView.builder(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: filteredApplicants.length,
                                          itemBuilder: (context, index) {
                                            final applicant =
                                                filteredApplicants[index];

                                            return listViewItem_new(
                                                profilemodel.report_to!.toInt(),
                                                context,
                                                applicant,
                                                true,
                                                statuses,
                                                profilemodel.id != null
                                                    ? profilemodel.id!.toInt()
                                                    : 467,
                                                "${profilemodel.first_name} ${profilemodel.last_name}",
                                                index,
                                                dropDownItemList!);
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            }
                          }).toList(),
                        ),
                        //),
                      ),
                    );
                    // Your code to display the data when at least one item meets the condition
                  } else {
                    // Display a "no data" message
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/nodata.png",
                          //height: 200,
                        ),
                        Text(
                          "No data to display",
                          style: GoogleFonts.varela(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        )
                      ],
                    );
                  }
                },
                error: (error, stackTrace) {
                  return const Center(
                    child: Text("Error while fetching the data"),
                  );
                },
                loading: () {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Constants.darkBlue,
                  ));
                },
              )
            : Center(
                child: Text(
                  "No data to display.",
                  style: GoogleFonts.varela(),
                ),
              ));
  }

  Widget listViewItem_new(
      int reportTo,
      BuildContext context,
      Applicant item,
      bool isTrue,
      List<String> status,
      int id,
      String sourceName,
      int index,
      List<DropDownItem> dropDownModel) {
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

    List<DropDownItem>? dropDownItemForLineUp =
        dropDownItemList!.where((element) => element.statusId == 20).toList();

    return item.hr_status_id != 0
        ? SwipeTo(
            iconOnRightSwipe: Icons.call,
            iconOnLeftSwipe: Icons.sms_outlined,
            onRightSwipe: item.alternateNo == 0 || item.alternateNo == null
                ? (details) async {
                    await FlutterPhoneDirectCaller.callNumber(
                        "+91${item.contactNo}");
                    {
                      if (item.hr_status_id == 11 ||
                          item.s2DdHrStatusId == 11) {
                        try {
                          NewChangeStatusModel changeStatusModel =
                              NewChangeStatusModel(
                                  statusId: 4,
                                  hrStatusId: 12,
                                  sourceId: id,
                                  spoc: reportTo,
                                  dol: DateTime.now(),
                                  sourceName: sourceName);
                          Map<String, dynamic> jsonData =
                              changeStatusModel.toJson();

                          await JobPostApiService.NewchangeStatus(
                              jsonData, item.id!.toInt());

                          // Assuming you have access to the ref and fetchAllApplicantProvider in your widget tree
                          ref.refresh(fetchAllTalentPoolProvider);
                          ref.refresh(fetchAllExecutiveProvide);
                        } catch (e) {
                          print('Error: $e');
                          // Handle error...
                        }
                      }
                    }
                  }
                : (details) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return item.alternateNo != null
                            ? CustomAlertDialog(
                                phoneNumber1: item.contactNo!.toInt(),
                                phoneNumber2: item.alternateNo!.toInt(),
                                isCall: true,
                                firstName: item.applicantName.toString(),
                                lastName: item.last_name.toString(),
                                item: item,
                                leadID: item.id!.toInt(),
                                id: id,
                                sourcename: sourceName,
                                reportTo: reportTo,
                              )
                            : const SizedBox();
                      },
                    );
                  },
            onLeftSwipe: item.alternateNo == 0 || item.alternateNo == null
                ? (details) async {
                    Uri url =
                        Uri.parse("whatsapp://send?phone=91${item.contactNo}");
                    await canLaunchUrl(url)
                        ? await launchUrl(url)
                        : throw "could not launch $url";

                    if (item.hr_status_id == 11 || item.s2DdHrStatusId == 11) {
                      try {
                        NewChangeStatusModel changeStatusModel =
                            NewChangeStatusModel(
                                statusId: 4,
                                hrStatusId: 12,
                                sourceId: id,
                                spoc: reportTo,
                                dol: DateTime.now(),
                                sourceName: sourceName);
                        Map<String, dynamic> jsonData =
                            changeStatusModel.toJson();

                        await JobPostApiService.NewchangeStatus(
                            jsonData, item.id!.toInt());

                        // Assuming you have access to the ref and fetchAllApplicantProvider in your widget tree
                        ref.refresh(fetchAllTalentPoolProvider);
                        ref.refresh(fetchAllExecutiveProvide);
                      } catch (e) {
                        print('Error: $e');
                        // Handle error...
                      }
                    }
                  }
                : (details) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                          phoneNumber1: int.parse(item.contactNo.toString()),
                          phoneNumber2: int.parse(item.alternateNo.toString()),
                          isCall: false,
                          firstName: item.applicantName.toString(),
                          lastName: item.last_name.toString(),
                          leadID: item.id!.toInt(),
                          item: item,
                          id: id,
                          sourcename: sourceName,
                          reportTo: reportTo,
                        );
                      },
                    );
                  },
            child: Container(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
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
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 10),
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return Column(
                            children: [
                              Visibility(
                                  visible: item.hr_status_id == 11 ||
                                      item.s2DdHrStatusId ==
                                          11, //TODO:: Application
                                  child: ApplicantContainerWidget(
                                    item: item,
                                    dropDownItemList: dropDownItemList!,
                                    id: id,
                                    report_to: reportTo,
                                    sourcename: sourceName,
                                  )),
                              Visibility(
                                  visible: item.hr_status_id == 12 ||
                                      item.s2DdHrStatusId == 12, //TODO:: Assign
                                  child: InkWell(
                                    onDoubleTap: () async {
                                      SharedPreferences pref =
                                          await Utils.getSharedPreferences();
                                      var userType =
                                          await Utils.getPreferencesValue(
                                              pref,
                                              ESharedPreferences
                                                  .user_type.name);
                                      var userrole =
                                          await Utils.getPreferencesValue(pref,
                                              ESharedPreferences.role.name);
                                      var id = await Utils.getPreferencesValue(
                                          pref,
                                          ESharedPreferences.user_id.name);
                                      int? userid = int.tryParse(id);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LeadDetailPage(
                                                    source_name: sourceName,
                                                    //TODO:: Send to lead Details page
                                                    userid: userid!,
                                                    id: item.jobId,
                                                    userrole:
                                                        userrole.toString(),
                                                    userType: userType,
                                                    item: item,
                                                    report_to: reportTo,
                                                  )));
                                    },
                                    child: AssignData(
                                        myLineUp:
                                            item.sourceId == profilemodel.id
                                                ? true
                                                : false,
                                        item: item,
                                        dropDownItemList: dropDownItemList!),
                                  )),
                              Visibility(
                                  visible: item.hr_status_id == 20 ||
                                      item.s2DdHrStatusId == 12, //TODO:: LineUp
                                  child: InkWell(
                                    onDoubleTap: () async {
                                      SharedPreferences pref =
                                          await Utils.getSharedPreferences();
                                      var userType =
                                          await Utils.getPreferencesValue(
                                              pref,
                                              ESharedPreferences
                                                  .user_type.name);
                                      var userrole =
                                          await Utils.getPreferencesValue(pref,
                                              ESharedPreferences.role.name);
                                      var id = await Utils.getPreferencesValue(
                                          pref,
                                          ESharedPreferences.user_id.name);
                                      int? userid = int.tryParse(id);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LeadDetailPage(
                                                    source_name: sourceName,
                                                    //TODO:: Send to lead Details page
                                                    userid: userid!,
                                                    id: item.jobId,
                                                    report_to: reportTo,
                                                    userrole:
                                                        userrole.toString(),
                                                    userType: userType,
                                                    item: item,
                                                  )));
                                    },
                                    child: LineUp(
                                        mylineup:
                                            item.sourceId == profilemodel.id
                                                ? true
                                                : false,
                                        item: item,
                                        dropDownItemList:
                                            dropDownItemForLineUp),
                                  )),
                              Visibility(
                                visible: item.hr_status_id != 11 &&
                                    item.hr_status_id != 12 &&
                                    item.hr_status_id != 20,
                                child: InkWell(
                                  onDoubleTap: () async {
                                    SharedPreferences pref =
                                        await Utils.getSharedPreferences();
                                    var userType =
                                        await Utils.getPreferencesValue(pref,
                                            ESharedPreferences.user_type.name);
                                    var userrole =
                                        await Utils.getPreferencesValue(
                                            pref, ESharedPreferences.role.name);
                                    var id = await Utils.getPreferencesValue(
                                        pref, ESharedPreferences.user_id.name);
                                    int? userid = int.tryParse(id);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LeadDetailPage(
                                                  source_name: sourceName,
                                                  //TODO:: Send to lead Details page
                                                  userid: userid!,
                                                  id: item.jobId,
                                                  report_to: reportTo,
                                                  userrole: userrole.toString(),
                                                  userType: userType,
                                                  item: item,
                                                )));
                                  },
                                  child: customTalentPoolCard(item, context,
                                      finalinterviewRounds, selectedRoundIndex),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  if (item.resume != null)
                    Positioned(
                      right: 0,
                      child: IconButton(
                          onPressed: item.hr_status_id != 11
                              ? () {
                                  item.resume != null
                                      ? item.resume!.contains(".docx")
                                          ? const SizedBox() /* FutureBuilder<void>(    //TODO: Docs view for cv.
                                              future: pdftron.PdftronFlutter
                                                  .openDocument(
                                                "https://s3.ap-south-1.amazonaws.com/job-circle-2/${item.resume}",
                                                config:
                                                    pdftron.Config.fromJson({
                                                  'readOnly':
                                                      true, // Set to read-only mode
                                                  // Add other configuration options as needed to remove watermark or customize viewer
                                                }),
                                              ),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                } else if (snapshot.hasError) {
                                                  return Center(
                                                      child: Text(
                                                          'Error: ${snapshot.error}'));
                                                } else {
                                                  // PDF document has been opened successfully
                                                  return Container(); // Placeholder widget
                                                }
                                              },
                                            ) */
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PDFViewerScreen(
                                                  isCC: false,
                                                  isCvDownloaded:
                                                      item.hr_status_id == 14
                                                          ? item.isCvDownload !=
                                                                  null
                                                              ? item
                                                                  .isCvDownload!
                                                                  .toInt()
                                                              : 0
                                                          : 1,
                                                  /*  isCvDownloaded:
                                                      item.isCvDownload != null
                                                          ? item.isCvDownload!
                                                              .toInt()
                                                          : 0, */
                                                  pdfAssetPath:
                                                      item.resume.toString(),
                                                  phoneNumber1:
                                                      item.contactNo!.toInt(),
                                                  isref: false,
                                                  id: item.id,
                                                  phoneNumber2:
                                                      item.alternateNo != null
                                                          ? item.alternateNo!
                                                              .toInt()
                                                          : 0,
                                                  name:
                                                      "${item.applicantName} ${item.last_name}",

                                                  // Replace with the actual asset path of your PDF file
                                                ),
                                              ),
                                            )
                                      : const SizedBox();
                                }
                              : () async {
                                  if (item.hr_status_id == 11 ||
                                      item.s2DdHrStatusId == 11) {
                                    try {
                                      // Find the first matching item

                                      NewChangeStatusModel changeStatusModel =
                                          NewChangeStatusModel(
                                              statusId: 4,
                                              hrStatusId: 12,
                                              dol: DateTime.now(),
                                              sourceId: id,
                                              spoc: reportTo,
                                              sourceName: sourceName);
                                      Map<String, dynamic> jsonData =
                                          changeStatusModel.toJson();

                                      await JobPostApiService.NewchangeStatus(
                                          jsonData, item.id!.toInt());

                                      ref.refresh(fetchAllTalentPoolProvider);
                                      ref.refresh(fetchAllExecutiveProvide);
                                    } catch (e) {
                                      print('Error: $e');
                                      // Handle error...
                                    }
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PDFViewerScreen(
                                        isCvDownloaded: item.status_id == 14
                                            ? item.isCvDownload != null
                                                ? item.isCvDownload!.toInt()
                                                : 0
                                            : 1,
                                        id: item.id,
                                        pdfAssetPath: item.resume.toString(),
                                        phoneNumber1: item.contactNo!.toInt(),
                                        isref: false,
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
                    ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }

  Column customTalentPoolCard(Applicant item, BuildContext context,
      List<String>? finalinterviewRounds, int selectedRoundIndex) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r), topRight: Radius.circular(8.r)),
          ),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (item.gender != null)
                item.profilePic != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://s3.ap-south-1.amazonaws.com/job-circle-2/${item.profilePic}"),
                        radius: 22,
                      )
                    : CircleAvatar(
                        backgroundColor: Constants.bgColorWhite,
                        backgroundImage: AssetImage(item.gender == "Male"
                            ? "assets/images/leadmale.png"
                            : "assets/images/leadfemal.png"),
                        radius: 22,
                      ),
              if (item.gender == null)
                item.profilePic != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://s3.ap-south-1.amazonaws.com/job-circle-2/${item.profilePic}"),
                        radius: 22,
                      )
                    : CircleAvatar(
                        backgroundColor: Constants.borderColor,
                        radius: 22,
                        child: Text(
                          item.applicantName!.isNotEmpty
                              ? item.applicantName![0].toUpperCase()
                              : 'N',
                          style: const TextStyle(
                            color: Constants.themeBgColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
              const SizedBox(
                width: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${item.applicantName.toString()} ${item.last_name.toString()}",
                    // maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                  if (item.hr_status_id == 13 ||
                      item.hr_status_id ==
                          14) //TODO:: view only for select and interview bay
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/process.png",
                          height: 12.h,
                          //  color: Constants.subtitleclr,
                        ),
                        SizedBox(
                          width: 4.sp,
                        ),
                        Text(
                          item.process.toString(),
                          style: GoogleFonts.varela(
                            color: Colors.black54,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          " | ",
                          style: GoogleFonts.varela(
                            color: Colors.black54,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        Image.asset(
                          "assets/images/designation.png",
                          height: 12.h,
                          //  color: Constants.subtitleclr,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          item.role_code != null
                              ? item.role_code.toString()
                              : item.lead_level.toString(),
                          style: GoogleFonts.varela(
                            color: Colors.black54,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  if (item.hr_status_id != 13 &&
                      item.hr_status_id !=
                          14) //TODO:: not view for select and interview bay
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        item.qualification == null
                            ? Row(
                                children: [
                                  Image.asset(
                                    "assets/images/bag.png",
                                    height: 13.h,
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
                                    "assets/images/education_d.png",
                                    height: 14.h,
                                    //  color: Constants.subtitleclr,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    " ${item.qualification.toString()}  |  ",
                                    style: GoogleFonts.varela(
                                      color: Colors.black54,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Image.asset(
                                    "assets/images/bag.png",
                                    height: 13.h,
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
                ],
              ),
            ],
          ),
        ),
        if (item.hr_status_id == 13 ||
            item.hr_status_id == 14) //TODO:: view only for select
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/cmpny.png",
                        height: 12.5.h,
                      ),
                      SizedBox(
                        width: 6.w,
                      ),
                      Text(
                        item.short_name != null
                            ? item.short_name.toString()
                            : item.companyName.toString(),
                        style: GoogleFonts.varela(
                            // color: Colors.black54,
                            color: Constants.subtitleclr,
                            fontWeight: FontWeight.normal,
                            fontSize: 13.sp),
                      ),
                    ],
                  ),
                  if (item.hr_status_id != 14)
                    SizedBox(
                      height: 4.h,
                    ),
                  if (item.hr_status_id != 14)
                    Row(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/documentStatus.png",
                              height: 15.sp,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              item.document_status.toString(),
                              style: GoogleFonts.varela(
                                  // color: Colors.black54,
                                  color: Constants.subtitleclr,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13.sp),
                            ),
                          ],
                        ),
                      ],
                    ),
                  if (item.hr_status_id != 14)
                    SizedBox(
                      height: 4.h,
                    ),
                  if (item.hr_status_id != 14)
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              size: 15.sp,
                              color: Constants.blue,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              item.doj != null
                                  ? DateFormat('dd MMM yyyy').format(item.doj!)
                                  : "Pending",
                              style: GoogleFonts.varela(
                                  // color: Colors.black54,
                                  color: Constants.subtitleclr,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13.sp),
                            ),
                          ],
                        ),
                      ],
                    )
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/loc.png",
                          height: 12.5.sp,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Expanded(
                          child: Text(
                            item.workLocation.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: GoogleFonts.varela(
                              fontSize: 13.sp,
                              color: Constants.subtitleclr,
                            ),
                          ),
                        )
                      ],
                    ),
                    if (item.hr_status_id != 14)
                      SizedBox(
                        height: 4.h,
                      ),
                    if (item.hr_status_id != 14)
                      Icon(
                        Icons.track_changes,
                        size: 13.sp,
                        color: Colors.transparent,
                      ),
                    if (item.hr_status_id != 14)
                      SizedBox(
                        height: 4.h,
                      ),
                    if (item.hr_status_id != 14)
                      Row(
                        children: [
                          Icon(
                            Icons.currency_rupee_outlined,
                            size: 15.sp,
                            color: Constants.blue,
                          ),
                          Text(
                            item.salary != null ? "${item.salary}" : "Pending",
                            style: GoogleFonts.varela(
                              fontSize: 13.sp,
                              color: Constants.subtitleclr,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start, // Ad
            children: [
              if (item.companyName != null &&
                  item.hr_status_id != 13 &&
                  item.hr_status_id != 14)
                Padding(
                  padding: EdgeInsets.only(top: 4.h, left: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/cmpny.png",
                        height: 12.5.h,
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      Text(
                        item.short_name != null
                            ? item.short_name.toString()
                            : item.companyName.toString(),
                        style: GoogleFonts.varela(
                            // color: Colors.black54,
                            color: Constants.subtitleclr,
                            fontWeight: FontWeight.normal,
                            fontSize: 13.sp),
                      )
                    ],
                  ),
                ),
              if (item.process != null &&
                  item.hr_status_id != 13 &&
                  item.hr_status_id != 14)
                Padding(
                  padding: EdgeInsets.only(left: 4.w, top: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/des.png",
                        height: 12.5.h,
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      Text(
                        item.role_code != null
                            ? "${item.process.toString()} || ${item.role_code.toString()}"
                            : "${item.process.toString()} || ${item.lead_level.toString()}",
                        style: GoogleFonts.varela(
                            // color: Colors.black54,
                            color: Constants.subtitleclr,
                            fontWeight: FontWeight.normal,
                            fontSize: 13.sp),
                      )
                    ],
                  ),
                ),
              if (item.totalSalary != null &&
                  item.hr_status_id != 13 &&
                  item.hr_status_id != 14)
                Padding(
                  padding: EdgeInsets.only(left: 4.w, top: 2.h),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/wallet.png",
                        height: 12.5.h,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        convertSalaryFormat(item.totalSalary.toString()),
                        style: GoogleFonts.varela(
                            // color: Colors.black54,
                            color: Constants.subtitleclr,
                            fontWeight: FontWeight.normal,
                            fontSize: 13.sp),
                      ),
                    ],
                  ),
                ),
              if (item.workLocation != null &&
                  item.hr_status_id != 13 &&
                  item.hr_status_id != 14)
                Padding(
                  padding: EdgeInsets.only(left: 4.w, top: 2.h),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/loc.png",
                        height: 12.5.sp,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Expanded(
                        child: Text(
                          item.workLocation.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.varela(
                            fontSize: 13.sp,
                            color: Constants.subtitleclr,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              //TODO:: Interview Rounds......{
              //
              //
              //
              //
              //
              //
              //
              //
              if (item.status_id == 1)
                Container(
                  margin: EdgeInsets.only(top: 4.h),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Constants.borderColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Constants.borderColor)),
                  //  padding: const EdgeInsets.only(bottom: 5),
                  height: MediaQuery.of(context).size.height / 15,
                  child: Timeline.tileBuilder(
                    //  scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(bottom: 10),

                    shrinkWrap: true,
                    // padding: const EdgeInsets.only(top: 0),
                    theme: TimelineThemeData(
                      direction: Axis.horizontal,
                      connectorTheme: const ConnectorThemeData(
                        space: 8.0,
                        thickness: 2.0,
                      ),
                    ),
                    builder: TimelineTileBuilder.connected(
                      contentsAlign: ContentsAlign.basic,
                      connectionDirection: ConnectionDirection.before,
                      itemCount: finalinterviewRounds != null
                          ? finalinterviewRounds.length
                          : 0,
                      itemExtentBuilder: (_, __) {
                        return (MediaQuery.of(context).size.width - 50) /
                            finalinterviewRounds!.length.toDouble();
                      },
                      oppositeContentsBuilder: (context, index) {
                        return Container();
                      },
                      contentsBuilder: (context, index) {
                        return finalinterviewRounds != null
                            ? Text(finalinterviewRounds[index])
                            : const Text("");
                      },
                      indicatorBuilder: (_, index) {
                        if (index == selectedRoundIndex) {
                          // Customize the selected round indicator
                          return const OutlinedDotIndicator(
                            borderWidth: 4.0,
                            color: Colors.green,
                          );
                        } else if (index > selectedRoundIndex) {
                          // Customize indicators for other rounds
                          return OutlinedDotIndicator(
                            borderWidth: 4.0,
                            color: Colors.grey.shade400,
                          );
                        } else {
                          return CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 8.r,
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 13.h,
                            ),
                          ); /* const DotIndicator(
                                                              //   borderWidth: 4.0,
                                                              color: Colors.green,
                                                            ); */
                        }
                      },
                      connectorBuilder: (_, index, type) {
                        if (index == selectedRoundIndex) {
                          // Customize the selected round connector
                          return const DashedLineConnector(
                            color: Colors.green,
                          );
                        } else if (index > selectedRoundIndex) {
                          // Customize connectors for other rounds
                          return DashedLineConnector(
                            color: Colors.grey.shade400,
                          );
                        } else {
                          return const DashedLineConnector(
                            color: Colors.green,
                          );
                        }
                      },
                    ),
                  ),
                ),

              //
              //
              //
              //
              //
              //
              //
              //
              // TODO:: Interview rounds end ........}
              //
              //
              //
              //
              // TODO:: Interview rounds for drop out and on hold
              if (item.hr_sub_status == "Drop-out" ||
                  item.hr_sub_status == "On-Hold" ||
                  item.hr_status == "Reject" ||
                  item.s2HrStatus == "Reject")
                Container(
                  margin: EdgeInsets.only(top: 4.h),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Constants.borderColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Constants.borderColor)),
                  //  padding: const EdgeInsets.only(bottom: 5),
                  height: MediaQuery.of(context).size.height / 15,
                  child: Timeline.tileBuilder(
                    //  scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(bottom: 10),

                    shrinkWrap: true,
                    // padding: const EdgeInsets.only(top: 0),
                    theme: TimelineThemeData(
                      direction: Axis.horizontal,
                      connectorTheme: const ConnectorThemeData(
                        space: 8.0,
                        thickness: 2.0,
                      ),
                    ),
                    builder: TimelineTileBuilder.connected(
                      contentsAlign: ContentsAlign.basic,
                      connectionDirection: ConnectionDirection.before,
                      itemCount: finalinterviewRounds != null
                          ? finalinterviewRounds.length
                          : 0,
                      itemExtentBuilder: (_, __) {
                        return (MediaQuery.of(context).size.width - 50) /
                            finalinterviewRounds!.length.toDouble();
                      },
                      oppositeContentsBuilder: (context, index) {
                        return Container();
                      },
                      contentsBuilder: (context, index) {
                        return finalinterviewRounds != null
                            ? Text(finalinterviewRounds[index])
                            : const Text("");
                      },
                      indicatorBuilder: (_, index) {
                        if (index == selectedRoundIndex) {
                          // Customize the selected round indicator
                          return const OutlinedDotIndicator(
                            borderWidth: 4.0,
                            color: Colors.red,
                          );
                        } else if (index > selectedRoundIndex) {
                          // Customize indicators for other rounds
                          return OutlinedDotIndicator(
                            borderWidth: 4.0,
                            color: Colors.grey.shade400,
                          );
                        } else {
                          return CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 8.r,
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 13.h,
                            ),
                          ); /* const DotIndicator(
                                                              //   borderWidth: 4.0,
                                                              color: Colors.green,
                                                            ); */
                        }
                      },
                      connectorBuilder: (_, index, type) {
                        if (index == selectedRoundIndex) {
                          // Customize the selected round connector
                          return const DashedLineConnector(
                            color: Colors.green,
                          );
                        } else if (index > selectedRoundIndex) {
                          // Customize connectors for other rounds
                          return DashedLineConnector(
                            color: Colors.grey.shade400,
                          );
                        } else {
                          return const DashedLineConnector(
                            color: Colors.green,
                          );
                        }
                      },
                    ),
                  ),
                ),

              if (item.hr_sub_status == "Drop-out" ||
                  item.hr_sub_status == "On-Hold" ||
                  item.hr_sub_status == "Offer Decline" ||
                  item.hr_sub_status == "Not Join" ||
                  item.s2HrSubStatus == "Not Join" ||
                  item.hr_status == "Reject" ||
                  item.s2HrStatus == "Reject")
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.r),
                    // border: Border.all(color: Colors.grey.shade400)
                  ),
                  margin: EdgeInsets.only(top: 4.h),
                  padding: EdgeInsets.only(
                      left: 4.w, right: 4.w, top: 6.h, bottom: 6.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        item.remark ?? "",
                        style: GoogleFonts.varela(
                          fontStyle: FontStyle.italic,
                          // color: Constants.subtitleclr,
                        ),
                      ),
                    ],
                  ),
                ),

              if (item.hr_sub_status != "Drop-out" &&
                  item.hr_sub_status != "On-Hold" &&
                  item.hr_sub_status != "Offer Decline" &&
                  (item.hr_status_id != 16) &&
                  item.hr_status_id != 13 &&
                  item.status_id != 1)
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  padding: const EdgeInsets.only(
                      top: 6, bottom: 6, right: 10, left: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      // border: Border.all(color: Colors.amber),
                      //color: Colors.amberAccent.shade100,
                      borderRadius: BorderRadius.circular(08)),
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      /* Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if ((item.executive_icon != null &&
                                  item.executive_icon != "null") ||
                              item.s2ExecutiveIcon != null)
                            CircleAvatar(
                                backgroundColor: Colors.white,
                                child: CustomImage(
                                    imageUrl:
                                        "https://s3.ap-south-1.amazonaws.com/job-circle-2/${item.executive_icon ?? item.s2ExecutiveIcon}",
                                    height: 24.h,
                                    defaultImageUrl:
                                        "assets/images/error.png") /* Image.network(
                                "https://s3.ap-south-1.amazonaws.com/job-circle-2/${item.referral_icon ?? item.s2ReferralIcon}",
                                fit: BoxFit.fill,
                                height: 24.h,
                              ), */
                                )
                        ],
                      ), */
                      if (item.hr_status_id != 15 &&
                          item.hr_status_id != 16 &&
                          item.hr_status_id != 17 &&
                          item.hr_status_id != 18 &&
                          item.hr_status_id != 19)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // const Text("Other"),
                                Row(
                                  children: [
                                    if (item.executive_feedback1 != null ||
                                        item.s2ExecutiveFeedback1 != null ||
                                        item.executive_feedback1 != "")
                                      Flexible(
                                        child: Text(
                                          item.executive_feedback1 != null
                                              ? item.executive_feedback1
                                                  .toString()
                                              : item.s2ExecutiveFeedback1
                                                  .toString(),
                                          style: GoogleFonts.varela(
                                              color: Constants.blue,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14.sp),
                                          softWrap: true,
                                          // maxLines: 3,
                                        ),
                                      ),
                                  ],
                                ),
                                if (item.executive_feedback2 != null ||
                                    item.s2ExecutiveFeedback2 != null)
                                  Text(
                                    item.executive_feedback2 != null
                                        ? item.executive_feedback2.toString()
                                        : item.s2ExecutiveFeedback2 != null
                                            ? item.s2ExecutiveFeedback2
                                                .toString()
                                            : "",
                                    softWrap: true,
                                    // maxLines: 3,
                                    style: GoogleFonts.varela(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp),
                                  )
                              ],
                            ),
                          ),
                        ),
                      if (item.hr_status_id == 15 ||
                          item.hr_status_id == 16 ||
                          item.hr_status_id == 17 ||
                          item.hr_status_id == 18 ||
                          item.hr_status_id == 19)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              item.remark ?? "",
                              style: GoogleFonts.varela(
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        //   if (item.hr_status_id == 13) //TODO: Only for Select.....
      ],
    );
  }

  Widget customTab(String title, int count) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Constants.borderColor, width: 1)),
        child: Row(
          children: [
            Text(title, style: GoogleFonts.varela()),
            SizedBox(
              width: 4.w,
            ),
            Text("(${count.toString()})", style: GoogleFonts.varela())
          ],
        ));
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
          String formattedStartValue =
              '${shortStartValue.toStringAsFixed(shortStartValue.truncateToDouble() == shortStartValue ? 0 : 1)}k';
          String formattedEndValue = endValue > 0
              ? '${shortEndValue.toStringAsFixed(shortEndValue.truncateToDouble() == shortEndValue ? 0 : 1)}k'
              : '';
          return '$formattedStartValue${formattedEndValue.isNotEmpty ? ' - $formattedEndValue' : ''} Per Month';
        } else {
          return '$startValue${endValue > 0 ? ' - $endValue' : ''} Per Month';
        }
      } else if (input.contains("Lac's P.A")) {
        if (startValue >= 100000) {
          double shortStartValue = startValue / 10000000.0;
          double shortEndValue = endValue / 10000000.0;
          String formattedStartValue =
              '${shortStartValue.toStringAsFixed(shortStartValue.truncateToDouble() == shortStartValue ? 0 : 2)} Lac\'s';
          String formattedEndValue = endValue > 0
              ? '${shortEndValue.toStringAsFixed(shortEndValue.truncateToDouble() == shortEndValue ? 0 : 2)} Lac\'s'
              : '';
          return '$formattedStartValue${formattedEndValue.isNotEmpty ? ' - $formattedEndValue' : ''} P.A';
        } else {
          return '$startValue${endValue > 0 ? ' - $endValue' : ''} Per Year';
        }
      }
    }

    // Handle other cases, or return the input as it is if it doesn't match any pattern
    return input;
  }
}

//TODO:: Old code of talentPool.. before 02/03/2024

/* // ignore_for_file: override_on_non_overriding_member, unused_field, unused_result, unused_local_variable, unnecessary_null_comparison, avoid_print, unused_element, non_constant_identifier_names, use_build_context_synchronously
// ignore_for_file: todo
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/changeStatusModel.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/models/job_details_model.dart';
import 'package:job_circle/screens/jobs/Interview_bay_cc.dart';
import 'package:job_circle/screens/jobs/interview_bay_executive.dart';
import 'package:job_circle/screens/jobs/pdf.dart';
import 'package:job_circle/service/data_get_api_service.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../common/utils.dart';
import '../../constants/drop_down_class.dart';
import '../../models/application_status_model.dart';
import '../../models/profileSummary.dart';
import '../../service/UserDataService.dart';
import '../../themes/colors.dart';

//enum Issue { no, incorrect, recruiter, other }
final fetchAllTalentPool = FutureProvider<List<Applicant>>(
    (ref) => _TalentPoolState.fetchAllApplicants());

class TalentPool extends ConsumerStatefulWidget {
  const TalentPool({
    super.key,
  });

  @override
  ConsumerState<TalentPool> createState() => _TalentPoolState();
}

class _TalentPoolState extends ConsumerState<TalentPool>
    with SingleTickerProviderStateMixin {
  JobDetailsModel jobDetailsModel = JobDetailsModel();
  ProfileSummaryModel profilemodel = ProfileSummaryModel();
  @override
  Future<List<Applicant>>? _applicantsFuture;
  List<Application>? applicationList = [];
  void fetchData() async {
    try {
      ApplicationAPI api = ApplicationAPI();
      applicationList = await api.getApplicationStatusList();

      // Use the applicationList as needed
      // For example, you can print the groupName of each Application object:
      // for (var application in applicationList) {
      // print(applicationList.map((e) => e.value));
      // }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    bindProfileSummary();
    fetchData();

    //  _applicantsFuture = fetchApplicantsByUserId(552);
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

  static Future<List<Applicant>> fetchAllApplicants() async {
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/leads/v1/getAllAppliedJobs?userId1=$userid&userId2=$userid&page=1&size=1000');
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
    try {
      DateTime now = DateTime.now();
      DateTime dob = DateTime.parse("${dateOfBirth}T00:00:00.000Z");

      int age = now.year - dob.year;
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day)) {
        age--;
      }

      return age;
    } catch (e) {
      print("Error parsing date: $e");
      // You might want to handle the error or return a default value here
      return 0; // or throw an exception, depending on your use case
    }
  }

  String? selectedStatusValue;

  List<String> getStatuses(List<Applicant> applicants) {
    return applicants
        .where((e) => e.hr_status != null)
        .map((e) => e.hr_status.toString())
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

  /*  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final RefreshController _refreshController1 =
      RefreshController(initialRefresh: false);

  Future<void> _onRefresh() async {
    // Perform a global refresh (e.g., fetch new data for all tabs)
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      ref.refresh(fetchAllTalentPool);
      // Update the UI with new data
    });
    _refreshController
        .refreshCompleted(); // Call this to end the refresh animation
  }

  Future<void> _onRefresh1() async {
    // Perform a global refresh (e.g., fetch new data for all tabs)
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      ref.refresh(fetchAllTalentPool);
      // Update the UI with new data
    });
    _refreshController1
        .refreshCompleted(); // Call this to end the refresh animation
  } */

  /*  Future<void> _onRefresh() async {
    // Perform a global refresh (e.g., fetch new data for all tabs)
    await Future.delayed(const Duration(seconds: 2));

    ref.refresh(fetchAllTalentPool);
    // Update the UI with new data

    // Call this to end the refresh animation
  } */

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      ref.refresh(fetchAllTalentPool);
    });

    return null;
  }

  bool isSelect = false;

  Map<int, SelectedOption> selectedValueMap = {};

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    var fetchApplicants = ref.watch(fetchAllTalentPool);

    return PageStorage(
        bucket: PageStorageBucket(),
        // key: const PageStorageKey<String>("futureKey"),
        child: fetchApplicants != null
            ? fetchApplicants.when(
                data: (fetchdata) {
                  List<Applicant>? dataList = fetchdata;

                  // Define a flag to track if any item meets the condition
                  bool anyItemMeetsCondition = false;

                  for (Applicant item in dataList) {
                    if (item.hr_status != null) {
                      // If the condition is met for any item, set the flag to true and break the loop
                      anyItemMeetsCondition = true;
                      break;
                    }
                  }
                  if (anyItemMeetsCondition) {
                    final data = fetchdata;
                    final statuses = getStatuses(data);
                    return DefaultTabController(
                      length: statuses.length,
                      child: Scaffold(
                        backgroundColor: Constants.bgColorWhite,
                        appBar: PreferredSize(
                          preferredSize:
                              Size(double.maxFinite, kTextTabBarHeight / 1.2.h),
                          child: AppBar(
                            elevation: 0,
                            backgroundColor: Constants.bgColorWhite,
                            bottom: TabBar(
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
                                border:
                                    Border.all(color: Constants.borderColor),
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
                        body: TabBarView(
                          children: statuses.map((status) {
                            // Filter applicants based on the current status
                            final applicants = data
                                .where((applicant) =>
                                    applicant.hr_status.toString() == status)
                                .toList();

                            // Check if sub_status is null or not
                            final subStatuses = applicants
                                .map((applicant) =>
                                    applicant.hr_sub_status?.toString())
                                .where((subStatus) =>
                                    subStatus != null && subStatus != "")
                                .toSet()
                                .toList()
                              ..sort();

                            if (subStatuses.isEmpty) {
                              // No second tab bar needed if subStatuses is empty
                              return RefreshIndicator(
                                triggerMode:
                                    RefreshIndicatorTriggerMode.anywhere,
                                onRefresh: refreshList,
                                key: refreshKey,
                                child: ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
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
                                ),
                              );
                            } else {
                              // Second tab bar needed for subStatuses
                              return DefaultTabController(
                                length: subStatuses.length,
                                child: Scaffold(
                                  appBar: PreferredSize(
                                    preferredSize: const Size(
                                        double.maxFinite, kTextTabBarHeight),
                                    child: AppBar(
                                      //elevation: 0,
                                      backgroundColor: Constants.bgColorWhite,
                                      bottom: TabBar(
                                        isScrollable: true,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        //indicatorWeight: 2.0,
                                        unselectedLabelStyle:
                                            GoogleFonts.varela(),
                                        labelStyle: GoogleFonts.varela(
                                            fontWeight: FontWeight.w600),
                                        unselectedLabelColor: Colors.black,
                                        labelColor: Constants.subtitleclr,
                                        indicatorPadding: EdgeInsets.only(
                                            bottom: 8.h, left: 3.w, right: 3.w),
                                        indicator: isSelect
                                            ? BoxDecoration(
                                                color: Constants.borderColor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: Constants
                                                        .borderColor) // Creates border
                                                )
                                            : null,
                                        indicatorColor: Constants.borderColor,
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
                                    children: subStatuses.map((subStatus) {
                                      // Filter applicants based on the current status and sub_status
                                      final filteredApplicants = applicants
                                          .where((applicant) =>
                                              applicant.hr_sub_status
                                                  .toString() ==
                                              subStatus)
                                          .toList();

                                      return RefreshIndicator(
                                        triggerMode: RefreshIndicatorTriggerMode
                                            .anywhere,
                                        onRefresh: refreshList,
                                        key: refreshKey,
                                        child: ListView.builder(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: filteredApplicants.length,
                                          itemBuilder: (context, index) {
                                            final applicant =
                                                filteredApplicants[index];

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
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            }
                          }).toList(),
                        ),
                        //),
                      ),
                    );
                    // Your code to display the data when at least one item meets the condition
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
                  return const Center(child: CircularProgressIndicator());
                },
              )
            : const SizedBox());
    // Build your widget's UI with the 'profilemodel' data
    // For example:
    /*  return FutureBuilder<List<Applicant>>(
        future: profilemodel.id != null
            ? fetchAllApplicants()
            : Future.error("Profile model is null"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            List<Applicant>? dataList = snapshot.data;

            // Define a flag to track if any item meets the condition
            bool anyItemMeetsCondition = false;

            for (Applicant item in dataList!) {
              if (item.status_code!.contains("TP")) {
                // If the condition is met for any item, set the flag to true and break the loop
                anyItemMeetsCondition = true;
                break;
              }
            }

            if (anyItemMeetsCondition) {
              final data = snapshot.data!;
              final statuses = getStatuses(data);
              return DefaultTabController(
                length: statuses.length,
                child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize:
                        Size(double.maxFinite, kTextTabBarHeight / 1.2.h),
                    child: AppBar(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      bottom: TabBar(
                        labelPadding: const EdgeInsets.only(left: 5, right: 5),
                        labelColor: Colors.black,
                        isScrollable: true,
                        unselectedLabelColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.tab,
                        splashBorderRadius: BorderRadius.circular(8),
                        indicatorWeight: 7.h,
                        indicatorPadding:
                            EdgeInsets.only(bottom: 8.h, left: 3.w, right: 3.w),
                        indicator: BoxDecoration(
                          color: Constants.borderColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Constants.borderColor),
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
                  body: RefreshIndicator(
                    onRefresh: () async {
                      setState(
                          () {}); // This will trigger the rebuild of the widget tree
                    },
                    child: TabBarView(
                      children: statuses.map((status) {
                        // Filter applicants based on the current status
                        final applicants = data
                            .where((applicant) =>
                                applicant.status.toString() == status)
                            .toList();

                        // Check if sub_status is null or not
                        final subStatuses = applicants
                            .map(
                                (applicant) => applicant.sub_status?.toString())
                            .where((subStatus) => subStatus != null)
                            .toSet()
                            .toList()
                          ..sort();

                        if (subStatuses.isEmpty) {
                          // No second tab bar needed if subStatuses is empty
                          return ListView.builder(
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
                        } else {
                          // Second tab bar needed for subStatuses
                          return DefaultTabController(
                            length: subStatuses.length,
                            child: Scaffold(
                              appBar: PreferredSize(
                                preferredSize: const Size(
                                    double.maxFinite, kTextTabBarHeight),
                                child: AppBar(
                                  //elevation: 0,
                                  backgroundColor: Colors.white,
                                  bottom: TabBar(
                                    isScrollable: true,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    //indicatorWeight: 2.0,
                                    unselectedLabelStyle: GoogleFonts.varela(),
                                    labelStyle: GoogleFonts.varela(
                                        fontWeight: FontWeight.w600),
                                    unselectedLabelColor: Colors.black,
                                    labelColor: Constants.subtitleclr,
                                    indicatorPadding: EdgeInsets.only(
                                        bottom: 8.h, left: 3.w, right: 3.w),
                                    indicator: isSelect
                                        ? BoxDecoration(
                                            color: Constants.borderColor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Constants
                                                    .borderColor) // Creates border
                                            )
                                        : null,
                                    indicatorColor: Constants.borderColor,
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
                                children: subStatuses.map((subStatus) {
                                  // Filter applicants based on the current status and sub_status
                                  final filteredApplicants = applicants
                                      .where((applicant) =>
                                          applicant.sub_status.toString() ==
                                          subStatus)
                                      .toList();

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: filteredApplicants.length,
                                    itemBuilder: (context, index) {
                                      final applicant =
                                          filteredApplicants[index];

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
                                }).toList(),
                              ),
                            ),
                          );
                        }
                      }).toList(),
                    ),
                  ),
                ),
              );
              // Your code to display the data when at least one item meets the condition
            } else {
              // Display a "no data" message
              return const Center(
                child: Text("No data to display."),
              );
            }

            // Get the statuses here
          }
          return const Center(child: Text("No Data to display."));
        },
      ); */

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

  Widget listViewItem_new(BuildContext context, Applicant item, bool isTrue,
      List<String> status, int id, int index) {
    // List<String>? myStrings;
    //  bool stopIteration = false;

    return Stack(
      children: [
        InkWell(
          onTap: () async {
            if (item.status_id != 10) {
              /*  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TalentPoolDetail(
                            applicant: item,
                            Status: status,
                          ))); */
            } else {
              ChangeStatusModel changeStatusModel = ChangeStatusModel(
                  dol: DateTime.now(),
                  // status: "TP2",  //TODO: before status modification....
                  // subStatus: "View"
                  sourceId: id,
                  status_id: 18);
              Map<String, dynamic> jsonData = changeStatusModel.toJson();
              try {
                await JobPostApiService.changeStatus(
                    jsonData, item.id!.toInt());
                ref.refresh(fetchAllTalentPool);
                /*  Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Recruitz()));
                setState(() {}); */
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
            /* onRightSwipe: item.alternateNo == 0   //TODO siwpe to call
                ? () async {
                    if (item.status != "Application") {
                      FlutterPhoneDirectCaller.callNumber(
                          "+91${item.contactNo}");
                    } else {
                      ChangeStatusModel changeStatusModel = ChangeStatusModel(
                          status: "TP2", sourceId: id, subStatus: "View");
                      Map<String, dynamic> jsonData =
                          changeStatusModel.toJson();
                      try {
                        await JobPostApiService.changeStatus(
                            jsonData, item.id!.toInt());
                        ref.refresh(fetchAllTalentPool);
                      } catch (e) {
                        print('Error: $e');
                      }

                      FlutterPhoneDirectCaller.callNumber(
                          "+91${item.contactNo}");
                    }
                  }
                : () async {
                    if (item.status != "Application") {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomAlertDialog(
                            phoneNumber1: item.contactNo!.toInt(),
                            phoneNumber2: item.alternateNo!.toInt(),
                            isCall: true,
                          );
                        },
                      );
                    } else {
                      ChangeStatusModel changeStatusModel = ChangeStatusModel(
                          status: "TP2", sourceId: id, subStatus: "View");
                      Map<String, dynamic> jsonData =
                          changeStatusModel.toJson();
                      try {
                        await JobPostApiService.changeStatus(
                            jsonData, item.id!.toInt());
                        ref.refresh(fetchAllTalentPool);
                      } catch (e) {
                        print('Error: $e');
                      }
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomAlertDialog(
                            phoneNumber1: item.contactNo!.toInt(),
                            phoneNumber2: item.alternateNo!.toInt(),
                            isCall: true,
                          );
                        },
                      );
                    }
                  },
            onLeftSwipe: item.alternateNo == 0
                ? () async {
                    if (item.status != "Application") {
                      Uri url = Uri.parse(
                          "whatsapp://send?phone=91${item.contactNo}");
                      await canLaunchUrl(url)
                          ? await launchUrl(url)
                          : throw "could not launch $url";
                    } else {
                      ChangeStatusModel changeStatusModel = ChangeStatusModel(
                          status: "TP2", sourceId: id, subStatus: "View");
                      Map<String, dynamic> jsonData =
                          changeStatusModel.toJson();
                      try {
                        await JobPostApiService.changeStatus(
                            jsonData, item.id!.toInt());
                        ref.refresh(fetchAllTalentPool);
                      } catch (e) {
                        print('Error: $e');
                      }
                      Uri url = Uri.parse(
                          "whatsapp://send?phone=91${item.contactNo}");
                      await canLaunchUrl(url)
                          ? await launchUrl(url)
                          : throw "could not launch $url";
                    }
                  }
                : () async {
                    if (item.status != "Application") {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return CustomAlertDialog(
                            phoneNumber1: item.contactNo!.toInt(),
                            phoneNumber2: item.alternateNo!.toInt(),
                            isCall: false,
                          );
                        },
                      );
                    } else {
                      ChangeStatusModel changeStatusModel = ChangeStatusModel(
                          status: "TP2", sourceId: id, subStatus: "View");
                      Map<String, dynamic> jsonData =
                          changeStatusModel.toJson();
                      try {
                        await JobPostApiService.changeStatus(
                            jsonData, item.id!.toInt());
                        ref.refresh(fetchAllTalentPool);
                      } catch (e) {
                        print('Error: $e');
                      }
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return CustomAlertDialog(
                            phoneNumber1: item.contactNo!.toInt(),
                            phoneNumber2: item.alternateNo!.toInt(),
                            isCall: false,
                          );
                        },
                      );
                    }
                  }, */
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
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
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (item.gender != null)
                          item.profilePic != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://s3.ap-south-1.amazonaws.com/job-circle-2/${item.profilePic}"),
                                  // child: Text(item.applicantName[0].toUpperCase()),
                                  radius: 22,
                                )
                              : CircleAvatar(
                                  backgroundColor: Constants.bgColorWhite,
                                  backgroundImage: AssetImage(
                                      item.gender == "Male"
                                          ? "assets/images/leadmale.png"
                                          : "assets/images/leadfemal.png"),
                                  // child: Text(item.applicantName[0].toUpperCase()),
                                  radius: 22,
                                ),
                        if (item.gender == null)
                          item.profilePic != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://s3.ap-south-1.amazonaws.com/job-circle-2/${item.profilePic}"),
                                  // child: Text(item.applicantName[0].toUpperCase()),
                                  radius: 22,
                                )
                              : CircleAvatar(
                                  backgroundColor: Constants.borderColor,
                                  // child: Text(item.applicantName[0].toUpperCase()),
                                  radius: 22,
                                  child: Text(
                                    item.applicantName!.isNotEmpty
                                        ? item.applicantName![0].toUpperCase()
                                        : 'N', // Default to 'N' if the name is empty
                                    style: const TextStyle(
                                      color: Constants.themeBgColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
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
                                if (item.dateOfBirth != null)
                                  Text(
                                    " (${calculateAge(item.dateOfBirth.toString())} yr's)",
                                    style: GoogleFonts.varela(
                                        color: Colors.black54, fontSize: 12.sp),
                                  )
                              ],
                            ),
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
                                            "assets/images/education_d.png",
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
                          ],
                        ),
                      ],
                    ),
                    if (item.status_id != 10)
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
                                Container(
                                  margin: const EdgeInsets.only(bottom: 2),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: Constants.borderColor,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    item.companyName.toString(),
                                    style: GoogleFonts.varela(
                                      color: Colors.black54,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: Constants.borderColor,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        item.role_code != null &&
                                                item.role_code != ""
                                            ? "${item.process} - ${item.role_code}"
                                            : "${item.process} - ${item.lead_level}",
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
                              children: [
                                // Declare selectedStatus as a class-level variable

// ...

                                PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    setState(() async {
                                      String subValue = "0";
                                      for (var app in applicationList!) {
                                        if (app.value.toString() == value &&
                                            app.sub_value != null) {
                                          subValue = app.sub_value.toString();
                                          break;
                                        }
                                      }

                                      selectedValueMap[item.id!] =
                                          SelectedOption(
                                              value, subValue.toString());

                                      // Now you can use both value and subValue for further operations
                                      ChangeStatusModel changeStatusModel =
                                          ChangeStatusModel(
                                              status: subValue.toString(),
                                              sourceId: item.sourceId,
                                              subStatus: value);
                                      Map<String, dynamic> jsonData =
                                          changeStatusModel.toJson();
                                      try {
                                        await JobPostApiService.changeStatus(
                                            jsonData, item.id!.toInt());
                                        ref.refresh(fetchAllTalentPool);
                                        ref.refresh(fetchAllApplicantProvider);
                                        ref.refresh(fetchAllExecutiveProvide);
                                      } catch (e) {
                                        print('Error: $e');
                                        // Handle error...
                                      }
                                      /*   Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) => Recruitz(
                                                    key: _talentPollKey,
                                                  )))); */
                                    });
                                    // setState(() {});
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return applicationList!.map((option) {
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
                                  offset: const Offset(0, 32),
                                  elevation: 16,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
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
                                )
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
                            )
                          ],
                        ),
                      )
                  ],
                ),

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
                      onPressed: () async {
                        if (item.status_id != 10) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFViewerScreen(
                                  isCvDownloaded: item.isCvDownload != null
                                    ? item.isCvDownload!.toInt()
                                    : 0,
                                isref: false,
                                pdfAssetPath: item.resume.toString(),
                                phoneNumber1: item.contactNo!.toInt(),
                                phoneNumber2: item.alternateNo == null
                                    ? 0
                                    : item.alternateNo!.toInt(),
                                      name: "${item.applicantName} ${item.last_name}",
                                // Replace with the actual asset path of your PDF file
                              ),
                            ),
                          );
                        } else {
                          ChangeStatusModel changeStatusModel =
                              ChangeStatusModel(
                                  dol: DateTime.now(),
                                  status: "TP2",
                                  sourceId: id,
                                  subStatus: "View");
                          Map<String, dynamic> jsonData =
                              changeStatusModel.toJson();
                          try {
                            await JobPostApiService.changeStatus(
                                jsonData, item.id!.toInt());
                            ref.refresh(fetchAllTalentPool);
                          } catch (e) {
                            print('Error: $e');
                          }
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFViewerScreen(
                                  isCvDownloaded: item.isCvDownload != null
                                    ? item.isCvDownload!.toInt()
                                    : 0,
                                isref: false,
                                pdfAssetPath: item.resume.toString(),
                                phoneNumber1: item.contactNo!.toInt(),
                                phoneNumber2: item.alternateNo!.toInt(),
                                  name: "${item.applicantName} ${item.last_name}",
                                // Replace with the actual asset path of your PDF file
                              ),
                            ),
                          );
                        }
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
 */
