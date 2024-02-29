// ignore_for_file: override_on_non_overriding_member, unused_field, unused_local_variable, unused_result, file_names, avoid_print, unused_element, prefer_final_fields, non_constant_identifier_names, avoid_unnecessary_containers, use_build_context_synchronously, unnecessary_null_comparison, use_full_hex_values_for_flutter_colors
// ignore_for_file: todo
import 'dart:convert';

import 'package:awesome_calendar/awesome_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/customdialogue_for_call_whatsapp.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/changeStatusModel.dart';
import 'package:job_circle/models/drop_down_model.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/models/job_details_model.dart';
import 'package:job_circle/screens/jobs/pdf.dart';
import 'package:job_circle/service/data_get_api_service.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/tracking/application.dart';
import 'package:job_circle/tracking/assign.dart';
import 'package:job_circle/tracking/interview_bay.dart';
import 'package:job_circle/tracking/select_status.dart';
// import 'package:pdftron_flutter/pdftron_flutter.dart' as pdftron;
import 'package:pull_to_refresh/pull_to_refresh.dart';
//import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/utils.dart';
import '../../constants/drop_down_class.dart';
import '../../models/application_status_model.dart';
import '../../models/interview_rounds_model.dart';
import '../../models/profileSummary.dart';
import '../../service/UserDataService.dart';
import '../../themes/colors.dart';

//enum Issue { no, incorrect, recruiter, other }

final fetchAllApplicantProvider = FutureProvider<List<Applicant>>(
    (ref) => _InterViewBayState.fetchAllApplicants());

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

  Future<void> _onRefresh(int index) async {
    // Perform a global refresh (e.g., fetch new data for all tabs)
    await Future.delayed(const Duration(seconds: 2));

    ref.refresh(fetchAllApplicantProvider);
    // Update the UI with new data

    _refreshControllers[index]
        .refreshCompleted(); // Call this to end the refresh animation
  }
  /* RefreshController refreshController = RefreshController();

  Future<void> _onRefresh() async {
    // Perform a global refresh (e.g., fetch new data for all tabs)
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      ref.refresh(fetchAllApplicantProvider);
      refreshController.refreshCompleted();
      // Update the UI with new data
    });
    // Call this to end the refresh animation
  } */

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
        List<Applicant> applicants = contentList
       //.where((element) => element.is_join_submitted!=1)  //TODO:: to hide join submitted data....
            /*  .where((element) =>
                element.is_status_hide != 1 || element.is_status_hide!=null || element.s2_is_status_hide != 1 ||
                element.s2_is_status_hide != null) */
            .map((json) => Applicant.fromJson(json))
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

/*   String convertSalaryFormat(String input) {
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
  } */

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

        /*  .where((element) => element.s2DdStatusId != 22)//TODO: all id for the tab which we dont want to display..
        .where((element) => element.s2DdStatusId != 19)
        .where((element) => element.s2DdStatusId != 21)
        .where((element) => element.s2DdStatusId != 14)
        .where((element) => element.s2DdStatusId != 20)
        .where((element) => element.status_id != 22)
        .where((element) => element.status_id != 19)
        .where((element) => element.status_id != 21)
        .where((element) => element.status_id != 14)
        .where((element) => element.status_id != 20) */

        /*  .where((element) => element.status_id != 16)*/

        .map((e) => e.hr_status != null ? e.hr_status.toString() : e.s2HrStatus)
        .where((status) => status != null)
        .map(
            (status) => status!) // Non-null assertion to handle non-null values
        .toSet()
        .toList()
      ..sort();
  }

  /*  List<String> getStatuses(List<Applicant> applicants) {  //TODO: old code to get status before status modification..
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
  } */

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

  Map<int, String> selectedRoundsMap = {};

  void updateSelectedRoundForJob(int jobId, String selectedRound) {
    setState(() {
      selectedRoundsMap[jobId] = selectedRound;
    });
  }

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

  /* var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      ref.refresh(fetchAllApplicantProvider);
    });

    return null;
  } */

  TextEditingController _searchController = TextEditingController();
  List<Applicant>? _filteredData;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var fetchApplicants =
        profilemodel.id != null ? ref.watch(fetchAllApplicantProvider) : null;

    // Build your widget's UI with the 'profilemodel' data
    // For example:
    return PageStorage(
        bucket: PageStorageBucket(),
        child: fetchApplicants != null
            ? fetchApplicants.when(
                data: (fetchdata) {
                  /* fetchApplicants = ref
              .refresh(fetchAllApplicantProvider(profilemodel.id!.toInt())); */ //TODO: to refresh data from api.
                  List<Applicant>? dataList = fetchdata;

                  // Define a flag to track if any item meets the condition
                  bool anyItemMeetsCondition = false;

                  for (Applicant item in dataList) {
                    if (item.hr_status != null || item.s2HrStatus != null) {
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
                        /*  floatingActionButton: FloatingActionButton(  //TODO: Refresh button.....
                          backgroundColor: Constants.maintheme_light_color,
                          onPressed: () {
                            ref.refresh(fetchAllApplicantProvider);
                          },
                          child: const Icon(Icons.refresh),
                        ),
                        floatingActionButtonLocation:
                            FloatingActionButtonLocation.centerDocked, */
                        backgroundColor: Constants.bgColorWhite,
                        appBar: PreferredSize(
                          preferredSize: const Size(
                              double.maxFinite, kTextTabBarHeight * 2),
                          child: AppBar(
                            title: Container(
                              margin: EdgeInsets.only(top: 10.h),
                              height: MediaQuery.of(context).size.height / 24.h,
                              child: TextField(
                                keyboardType: TextInputType.name,
                                //textInputAction: TextInputAction.s, // Set TextInputAction to sentences
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: _searchController,
                                style: GoogleFonts.varela(
                                    color: Constants.subtitleclr,
                                    fontSize: 14.sp),
                                decoration: InputDecoration(
                                    filled: false,
                                    fillColor: Constants.borderColor,
                                    prefixIcon: const Icon(Icons.search),
                                    prefixIconColor: Constants.themeBgColor,
                                    contentPadding: const EdgeInsets.only(
                                        top: 8, bottom: 8, left: 10, right: 10),
                                    counterText: '',
                                    // labelText: "Remark",
                                    labelStyle: const TextStyle(
                                      color: Constants.themeBgColor,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: const BorderSide(
                                          color: Constants.themeBgColor),
                                    ),
                                    focusColor: const Color(0xffff0eceb),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: const BorderSide(
                                        color: Constants.themeBgColor,
                                      ),
                                    ),
                                    hintText: "Search",
                                    hintStyle: GoogleFonts.sourceSansPro(
                                        color: Constants.hintColor,
                                        fontSize: 15.sp)),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                            elevation: 0,
                            backgroundColor: Constants.bgColorWhite,
                            bottom: TabBar(
                              physics: const NeverScrollableScrollPhysics(),
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
                                                applicant.hr_status.toString() ==
                                                    status ||
                                                applicant.s2HrStatus.toString() ==
                                                    status)
                                            .where((element) =>
                                                element.applicantName!
                                                    .toLowerCase()
                                                    .contains(_searchController
                                                        .text
                                                        .toLowerCase()) ||
                                                element.last_name!
                                                    .toLowerCase()
                                                    .contains(_searchController
                                                        .text
                                                        .toLowerCase()) ||
                                                element.companyName!
                                                    .toLowerCase()
                                                    .contains(
                                                        _searchController.text.toLowerCase()) ||
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
                                    element.applicantName!
                                        .toLowerCase()
                                        .contains(_searchController.text
                                            .toLowerCase()) ||
                                    element.last_name!.toLowerCase().contains(
                                        _searchController.text
                                            .toLowerCase()) || //TODO:: For searrch.....
                                    element.companyName!.toLowerCase().contains(
                                        _searchController.text.toLowerCase()) ||
                                    element.process!.toLowerCase().contains(
                                        _searchController.text.toLowerCase()))
                                .where((applicant) => applicant.hr_status !=
                                        null
                                    ? applicant.hr_status.toString() == status
                                    : applicant.s2HrStatus == status)
                                .toList();
                            // final index = status.id;
                            /*  final applicants = data  //TODO:: befor modification...
                                .where((applicant) =>
                                    applicant.hr_status.toString() == status)
                                .toList(); */

                            // Check if sub_status is null or not
                            final subStatuses =
                                []; /* applicants
                                .map((applicant) =>
                                    applicant.hr_sub_status?.toString())
                                .where((subStatus) =>
                                    subStatus != null && subStatus != "")
                                .toSet()
                                .toList()
                              ..sort(); */

                            if (subStatuses.isEmpty) {
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
                            } else {
                              // Second tab bar needed for subStatuses
                              return DefaultTabController(
                                length: subStatuses.length,
                                child: Scaffold(
                                  appBar: PreferredSize(
                                    preferredSize: const Size(
                                        double.maxFinite, kTextTabBarHeight),
                                    child: AppBar(
                                      title: const Text("Hello"),
                                      //elevation: 0,
                                      backgroundColor: Constants.bgColorWhite,
                                      bottom: TabBar(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
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

                                      return ListView.builder(
                                        physics: const BouncingScrollPhysics(),
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
                                              "${profilemodel.first_name} ${profilemodel.last_name}",
                                              index,
                                              dropDownItemList!);
                                        },
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
  }

  //TODO:: New InterviewBay For CC.....{

  Widget listViewItem_new(
      BuildContext context,
      Applicant item,
      bool isTrue,
      List<String> status,
      int id,
      String sourceName,
      int index,
      List<DropDownItem> dropDownModel) {
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
            .where((formattedRound) =>
                formattedRound != null && formattedRound.isNotEmpty)
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
          ref.refresh(fetchAllApplicantProvider);
          setState(() {});
          // First pop to close the dialog
        } catch (e) {
          print('Error: $e');
          // Handle error...
        }
      }
    }

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
                                  dol: DateTime.now(),
                                  sourceName: sourceName);
                          Map<String, dynamic> jsonData =
                              changeStatusModel.toJson();

                          await JobPostApiService.NewchangeStatus(
                              jsonData, item.id!.toInt());

                          // Assuming you have access to the ref and fetchAllApplicantProvider in your widget tree
                          ref.refresh(fetchAllApplicantProvider);

                          setState(() {});
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
                                dol: DateTime.now(),
                                sourceName: sourceName);
                        Map<String, dynamic> jsonData =
                            changeStatusModel.toJson();

                        await JobPostApiService.NewchangeStatus(
                            jsonData, item.id!.toInt());

                        // Assuming you have access to the ref and fetchAllApplicantProvider in your widget tree
                        ref.refresh(fetchAllApplicantProvider);

                        setState(() {});
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
                                    sourcename: sourceName,
                                  )),
                              Visibility(
                                  visible: item.hr_status_id == 12 ||
                                      item.s2DdHrStatusId == 12, //TODO:: Assign
                                  child: AssignData(
                                      item: item,
                                      dropDownItemList: dropDownItemList!)),
                              Visibility(
                                  visible: item.hr_status_id == 14 ||
                                      item.s2DdHrStatusId ==
                                          14, //TODO:: InterViewBay
                                  child: InterViewBayStatus(
                                    item: item,
                                    dropDownItemList: dropDownItemList!,
                                    finalDropDownItem: finalDropDownItem,
                                    finalInterviewRounds: finalInterviewRounds,
                                  )),
                              Visibility(
                                  visible: item.dd_hr_status_id == 13 ||
                                      item.s2DdHrStatusId == 13, //TODO:: Select
                                  child: SelectStatus(
                                      item: item,
                                      finalDropDownItemforJoinNot:
                                          finalDropDownItemforJoinNot,
                                      finalDropDownItemforReadyOffer:
                                          finalDropDownItemforReadyOffer,
                                      finalDropDownItemForTrainingDrop:
                                          finalDropDownItemforTrainingDrop))
                              /*  Visibility(
                                visible: item.hr_status_id ==
                                    10, //TODO:: Application
                                child: GestureDetector(
                                  onTap: () async {
                                    if (dropDownItemList != null) {
                                      try {
                                        // Find the first matching item
                                
                                        NewChangeStatusModel changeStatusModel =
                                            NewChangeStatusModel(
                                                statusId: 6, hrStatusId: 18);
                                        Map<String, dynamic> jsonData =
                                            changeStatusModel.toJson();
                                
                                        await JobPostApiService.NewchangeStatus(
                                            jsonData, item.id!.toInt());
                                        ref.refresh(fetchAllApplicantProvider);
                                        setState(() {});
                                      } catch (e) {
                                        print('Error: $e');
                                        // Handle error...
                                      }
                                    }
                                  },
                                  child: Container(
                                    child: Row(
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
                                                  backgroundColor:
                                                      Constants.bgColorWhite,
                                                  backgroundImage: AssetImage(item
                                                              .gender ==
                                                          "Male"
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
                                                  backgroundColor:
                                                      Constants.borderColor,
                                                  // child: Text(item.applicantName[0].toUpperCase()),
                                                  radius: 22,
                                                  child: Text(
                                                    item.applicantName!
                                                            .isNotEmpty
                                                        ? item.applicantName![0]
                                                            .toUpperCase()
                                                        : 'N', // Default to 'N' if the name is empty
                                                    style: const TextStyle(
                                                      color: Constants
                                                          .themeBgColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "${item.applicantName.toString().toTitleCase()} ${item.last_name.toString().toTitleCase()}",
                                                  style: GoogleFonts.varela(
                                                    fontStyle: FontStyle.normal,
                                                    // color: Colors.black54,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                if (item.dateOfBirth != null)
                                                  Text(
                                                    " (${calculateAge(item.dateOfBirth.toString())} yr's)",
                                                    style: GoogleFonts.varela(
                                                        color: Colors.black54,
                                                        fontSize: 12.sp),
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
                                                            item.isExperienced
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .varela(
                                                              color: Colors
                                                                  .black54,
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
                                                            style: GoogleFonts
                                                                .varela(
                                                              color: Colors
                                                                  .black54,
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
                                                            style: GoogleFonts
                                                                .varela(
                                                              color: Colors
                                                                  .black54,
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
                                ),
                             
                              ),
                               */
                              /* Visibility(
                                visible:
                                    item.hr_status_id == 18, //TODO:: Assign
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                                    backgroundColor:
                                                        Constants.bgColorWhite,
                                                    backgroundImage: AssetImage(item
                                                                .gender ==
                                                            "Male"
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
                                                    backgroundColor:
                                                        Constants.borderColor,
                                                    // child: Text(item.applicantName[0].toUpperCase()),
                                                    radius: 22,
                                                    child: Text(
                                                      item.applicantName!
                                                              .isNotEmpty
                                                          ? item
                                                              .applicantName![0]
                                                              .toUpperCase()
                                                          : 'N', // Default to 'N' if the name is empty
                                                      style: const TextStyle(
                                                        color: Constants
                                                            .themeBgColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20.0,
                                                      ),
                                                    ),
                                                  ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "${item.applicantName.toString().toTitleCase()} ${item.last_name.toString().toTitleCase()}",
                                                    style: GoogleFonts.varela(
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      // color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  if (item.dateOfBirth != null)
                                                    Text(
                                                      " (${calculateAge(item.dateOfBirth.toString())} yr's)",
                                                      style: GoogleFonts.varela(
                                                          color: Colors.black54,
                                                          fontSize: 12.sp),
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
                                                              item.isExperienced
                                                                  .toString(),
                                                              style: GoogleFonts
                                                                  .varela(
                                                                color: Colors
                                                                    .black54,
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
                                                              style: GoogleFonts
                                                                  .varela(
                                                                color: Colors
                                                                    .black54,
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
                                                              style: GoogleFonts
                                                                  .varela(
                                                                color: Colors
                                                                    .black54,
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
                                      Container(
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                            color: Constants.borderColor,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.companyName.toString(),
                                                  style: GoogleFonts.varela(
                                                    color: Colors.black54,
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      item.role_code != null &&
                                                              item.role_code !=
                                                                  ""
                                                          ? "${item.process} - ${item.role_code}"
                                                          : "${item.process} - ${item.lead_level}",
                                                      style: GoogleFonts.varela(
                                                        color: Colors.black54,
                                                        // fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            PopupMenuButton<String>(
                                              onSelected: (value) async {
                                                setState(() async {
                                                  int subValue = 0;
                                                  int getstatusId = 0;
                                                  for (var app
                                                      in dropDownItemList!) {
                                                    if (app.statusDd
                                                                .toString() ==
                                                            value &&
                                                        app.statusDdId !=
                                                            null) {
                                                      subValue = app.statusDdId!
                                                          .toInt();
                                                      getstatusId =
                                                          app.statusId!.toInt();
                                                      break;
                                                    }
                                                  }
                                
                                                  // Now you can use both value and subValue for further operations
                                                  NewChangeStatusModel
                                                      changeStatusModel =
                                                      NewChangeStatusModel(
                                                          statusId: subValue,
                                                          hrStatusId: 0,
                                                          interviewRounds: item
                                                              .inteviewrounds!
                                                              .first
                                                              .replaceAll(
                                                                  '[', '')
                                                              .replaceAll(
                                                                  ']', '')
                                                              .replaceAll(
                                                                  '"', ''));
                                                  Map<String, dynamic>
                                                      jsonData =
                                                      changeStatusModel
                                                          .toJson();
                                                  try {
                                                    await JobPostApiService
                                                        .NewchangeStatus(
                                                            jsonData,
                                                            item.id!.toInt());
                                                    ref.refresh(
                                                        fetchAllApplicantProvider);
                                                    ref.refresh(
                                                        fetchAllReferalProvider);
                                                    ref.refresh(
                                                        fetchAllApplyProvider);
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
                                              itemBuilder:
                                                  (BuildContext context) {
                                                return dropDownItemList!
                                                    .where((element) =>
                                                        element.statusId ==
                                                        item.hr_status_id)
                                                    .map((option) {
                                                  return customMenuItem(
                                                      option, true);
                                                }).toList();
                                              },
                                              offset: const Offset(0, 32),
                                              elevation: 16,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Container(
                                                // height: 32,
                                                /*   margin: const EdgeInsets.only(
                                        bottom: 10, top: 10), */
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    // color: Constants.subtitleclr,
                                                    border: Border.all(
                                                        color: Constants
                                                            .borderColor)),
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Select",
                                                      /*   selectedValueMap[item.id!]
                                                        ?.selectedValue ??
                                                    item.sub_status.toString(), */
                                                      style: GoogleFonts.varela(
                                                        color: Colors.black,
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ), */
                              /*  Visibility(
                                  visible: item.status_id ==
                                      24, //TODO:: InterviewBay
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                      backgroundColor: Constants
                                                          .bgColorWhite,
                                                      backgroundImage: AssetImage(item
                                                                  .gender ==
                                                              "Male"
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
                                                      backgroundColor:
                                                          Constants.borderColor,
                                                      // child: Text(item.applicantName[0].toUpperCase()),
                                                      radius: 22,
                                                      child: Text(
                                                        item.applicantName!
                                                                .isNotEmpty
                                                            ? item
                                                                .applicantName![
                                                                    0]
                                                                .toUpperCase()
                                                            : 'N', // Default to 'N' if the name is empty
                                                        style: const TextStyle(
                                                          color: Constants
                                                              .themeBgColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20.0,
                                                        ),
                                                      ),
                                                    ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${item.applicantName.toString().toTitleCase()} ${item.last_name.toString().toTitleCase()}",
                                                      style: GoogleFonts.varela(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        // color: Colors.black54,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    if (item.dateOfBirth !=
                                                        null)
                                                      Text(
                                                        " (${calculateAge(item.dateOfBirth.toString())} yr's)",
                                                        style:
                                                            GoogleFonts.varela(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize:
                                                                    12.sp),
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
                                                                item.isExperienced
                                                                    .toString(),
                                                                style:
                                                                    GoogleFonts
                                                                        .varela(
                                                                  color: Colors
                                                                      .black54,
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
                                                                style:
                                                                    GoogleFonts
                                                                        .varela(
                                                                  color: Colors
                                                                      .black54,
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
                                                                style:
                                                                    GoogleFonts
                                                                        .varela(
                                                                  color: Colors
                                                                      .black54,
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
                                        Container(
                                          width: double.maxFinite,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 8,
                                          ),
                                          decoration: BoxDecoration(
                                              color: Constants.borderColor,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.companyName.toString(),
                                                style: GoogleFonts.varela(
                                                  color: Colors.black54,
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Row(
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
                                            ],
                                          ),
                                        ),
                                        Wrap(
                                          children: List.generate(
                                              finalInterviewRounds.length,
                                              (index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: index != 0
                                                    ? () async {
                                                        NewChangeStatusModel
                                                            changeStatusModel =
                                                            NewChangeStatusModel(
                                                                statusId: item
                                                                    .status_id,
                                                                interviewRounds:
                                                                    finalInterviewRounds[
                                                                        index]);
                                                        Map<String, dynamic>
                                                            jsonData =
                                                            changeStatusModel
                                                                .toJson();
                                                        try {
                                                          await JobPostApiService
                                                              .NewchangeStatus(
                                                                  jsonData,
                                                                  item.id!
                                                                      .toInt());
                                                          ref.refresh(
                                                              fetchAllApplicantProvider);
                                                          ref.refresh(
                                                              fetchAllReferalProvider);
                                                          ref.refresh(
                                                              fetchAllApplyProvider);
                                                        } catch (e) {
                                                          print('Error: $e');
                                                          // Handle error...
                                                        }
                                                      }
                                                    : () {},
                                                child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 4,
                                                        horizontal: 8),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Constants
                                                                .themeBgColor),
                                                        color: index == 0 ||
                                                                item.interview_rounds ==
                                                                    finalInterviewRounds[
                                                                        index]
                                                            ? Constants
                                                                .borderColor
                                                            : Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.r)),
                                                    child: Text(
                                                      finalInterviewRounds[
                                                          index],
                                                      style: GoogleFonts.varela(
                                                          color: Colors.grey),
                                                    )),
                                              ),
                                            );
                                          }),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Wrap(
                                              children: List.generate(
                                                finalDropDownItem.length,
                                                (index) => GestureDetector(
                                                  onTap: () async {
                                                    NewChangeStatusModel
                                                        changeStatusModel =
                                                        NewChangeStatusModel(
                                                      interviewRounds: item
                                                          .interview_rounds
                                                          .toString(),
                                                      /*  hrStatusId:
                                                    finalDropDownItem[index]
                                                        .statusId, */
                                                      statusId:
                                                          finalDropDownItem[
                                                                  index]
                                                              .secStatusId,
                                                    );
                                                    Map<String, dynamic>
                                                        jsonData =
                                                        changeStatusModel
                                                            .toJson();
                                                    try {
                                                      await JobPostApiService
                                                          .NewchangeStatus(
                                                              jsonData,
                                                              item.id!.toInt());
                                                      ref.refresh(
                                                          fetchAllApplicantProvider);
                                                      ref.refresh(
                                                          fetchAllReferalProvider);
                                                      ref.refresh(
                                                          fetchAllApplyProvider);
                                                    } catch (e) {
                                                      print('Error: $e');
                                                      // Handle error...
                                                    }
                                                  },
                                                  child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 4,
                                                          horizontal: 8),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.r),
                                                      ),
                                                      child: finalDropDownItem[
                                                                      index]
                                                                  .statusId ==
                                                              item.dd_hr_status_id
                                                          ? Text(
                                                              finalDropDownItem[
                                                                      index]
                                                                  .secStatus
                                                                  .toString(),
                                                              style: GoogleFonts
                                                                  .varela(
                                                                      color: Colors
                                                                          .blue),
                                                            )
                                                          : null),
                                                ),
                                              ),
                                            ),
                                            Wrap(
                                              children: List.generate(
                                                finalDropDownItem.length,
                                                (index) => GestureDetector(
                                                  onTap: finalDropDownItem[
                                                                  index]
                                                              .priStatusId !=
                                                          17
                                                      ? () async {
                                                          NewChangeStatusModel
                                                              changeStatusModel =
                                                              NewChangeStatusModel(
                                                                  interviewRounds: item
                                                                      .interview_rounds
                                                                      .toString(),
                                                                  /*  hrStatusId:
                                                          finalDropDownItem[
                                                                  index]
                                                              .statusId, */
                                                                  statusId: finalDropDownItem[
                                                                          index]
                                                                      .priStatusId);
                                                          Map<String, dynamic>
                                                              jsonData =
                                                              changeStatusModel
                                                                  .toJson();
                                                          try {
                                                            await JobPostApiService
                                                                .NewchangeStatus(
                                                                    jsonData,
                                                                    item.id!
                                                                        .toInt());
                                                            ref.refresh(
                                                                fetchAllApplicantProvider);
                                                            ref.refresh(
                                                                fetchAllReferalProvider);
                                                            ref.refresh(
                                                                fetchAllApplyProvider);
                                                          } catch (e) {
                                                            print('Error: $e');
                                                            // Handle error...
                                                          }
                                                        }
                                                      : () async {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return CustomDialogueForSelect(
                                                                item: item,
                                                                refreshCallback:
                                                                    () {
                                                                  ref.refresh(
                                                                      fetchAllApplicantProvider);
                                                                  ref.refresh(
                                                                      fetchAllReferalProvider);
                                                                  ref.refresh(
                                                                      fetchAllApplyProvider);
                                                                },
                                                                finalDropDown:
                                                                    finalDropDownItem[
                                                                        index],
                                                              );
                                                            },
                                                          );
                                                          ref.refresh(
                                                              fetchAllApplicantProvider);
                                                          ref.refresh(
                                                              fetchAllReferalProvider);
                                                          ref.refresh(
                                                              fetchAllApplyProvider);
                                                          /*    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => CC(
                                                key: _talentPollKey,
                                              )))); */
                                                        },
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4.h,
                                                              horizontal: 8.w),
                                                      decoration: BoxDecoration(
                                                          color: finalDropDownItem[
                                                                          index]
                                                                      .priStatusId ==
                                                                  5
                                                              ? Constants
                                                                  .themeBgColor
                                                              : Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.r)),
                                                      child: Text(
                                                        finalDropDownItem[index]
                                                            .primaryStatus
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.varela(
                                                                color: Colors
                                                                    .white),
                                                      )),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )),
                              */ /*  Visibility(
                            visible: item.status_id == 12, //TODO: Reject
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                                backgroundColor:
                                                    Constants.bgColorWhite,
                                                backgroundImage: AssetImage(item
                                                            .gender ==
                                                        "Male"
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
                                                backgroundColor:
                                                    Constants.borderColor,
                                                // child: Text(item.applicantName[0].toUpperCase()),
                                                radius: 22,
                                                child: Text(
                                                  item.applicantName!.isNotEmpty
                                                      ? item.applicantName![0]
                                                          .toUpperCase()
                                                      : 'N', // Default to 'N' if the name is empty
                                                  style: const TextStyle(
                                                    color:
                                                        Constants.themeBgColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                  ),
                                                ),
                                              ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "${item.applicantName.toString().toTitleCase()} ${item.last_name.toString().toTitleCase()}",
                                                style: GoogleFonts.varela(
                                                  fontStyle: FontStyle.normal,
                                                  // color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               if (item.dateOfBirth != null)
                                              Text(
                                                " (${calculateAge(item.dateOfBirth.toString())} yr's)",
                                                style: GoogleFonts.varela(
                                                    color: Colors.black54,
                                                    fontSize: 12.sp),
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
                                                          item.isExperienced
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .varela(
                                                            color:
                                                                Colors.black54,
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
                                                          style: GoogleFonts
                                                              .varela(
                                                            color:
                                                                Colors.black54,
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
                                                          style: GoogleFonts
                                                              .varela(
                                                            color:
                                                                Colors.black54,
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
                                  Container(
                                    width: double.maxFinite,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Constants.borderColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.companyName.toString(),
                                          style: GoogleFonts.varela(
                                            color: Colors.black54,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
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
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        */
                              /*  Visibility(
                                  visible:
                                      item.hr_status_id == 17, //TODO:: Select
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                      backgroundColor: Constants
                                                          .bgColorWhite,
                                                      backgroundImage: AssetImage(item
                                                                  .gender ==
                                                              "Male"
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
                                                      backgroundColor:
                                                          Constants.borderColor,
                                                      // child: Text(item.applicantName[0].toUpperCase()),
                                                      radius: 22,
                                                      child: Text(
                                                        item.applicantName!
                                                                .isNotEmpty
                                                            ? item
                                                                .applicantName![
                                                                    0]
                                                                .toUpperCase()
                                                            : 'N', // Default to 'N' if the name is empty
                                                        style: const TextStyle(
                                                          color: Constants
                                                              .themeBgColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20.0,
                                                        ),
                                                      ),
                                                    ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${item.applicantName.toString().toTitleCase()} ${item.last_name.toString().toTitleCase()}",
                                                      style: GoogleFonts.varela(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        // color: Colors.black54,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    if (item.dateOfBirth !=
                                                        null)
                                                      Text(
                                                        " (${calculateAge(item.dateOfBirth.toString())} yr's)",
                                                        style:
                                                            GoogleFonts.varela(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize:
                                                                    12.sp),
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
                                                                item.isExperienced
                                                                    .toString(),
                                                                style:
                                                                    GoogleFonts
                                                                        .varela(
                                                                  color: Colors
                                                                      .black54,
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
                                                                style:
                                                                    GoogleFonts
                                                                        .varela(
                                                                  color: Colors
                                                                      .black54,
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
                                                                style:
                                                                    GoogleFonts
                                                                        .varela(
                                                                  color: Colors
                                                                      .black54,
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
                                        Container(
                                          width: double.maxFinite,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 8,
                                          ),
                                          decoration: BoxDecoration(
                                              color: Constants.borderColor,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.companyName.toString(),
                                                style: GoogleFonts.varela(
                                                  color: Colors.black54,
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Row(
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
                                            ],
                                          ),
                                        ),
                                        item.doj != null &&
                                                item.doj!.day == today.day
                                            ? Wrap(
                                                children: List.generate(
                                                  finalDropDownItemforJoinNot
                                                      .length,
                                                  (index) => GestureDetector(
                                                    onTap: item.status_id != 18
                                                        ? () async {
                                                            NewChangeStatusModel
                                                                changeStatusModel =
                                                                NewChangeStatusModel(
                                                                    doj: item
                                                                        .doj,
                                                                    hrStatusId: finalDropDownItemforJoinNot[index].secStatusId ==
                                                                            16
                                                                        ? 0
                                                                        : finalDropDownItemforJoinNot[index]
                                                                            .statusId,
                                                                    statusId: finalDropDownItemforJoinNot[
                                                                            index]
                                                                        .secStatusId);
                                                            Map<String, dynamic>
                                                                jsonData =
                                                                changeStatusModel
                                                                    .toJson();
                                                            try {
                                                              await JobPostApiService
                                                                  .NewchangeStatus(
                                                                      jsonData,
                                                                      item.id!
                                                                          .toInt());
                                                              ref.refresh(
                                                                  fetchAllApplicantProvider);
                                                              ref.refresh(
                                                                  fetchAllReferalProvider);
                                                              ref.refresh(
                                                                  fetchAllApplyProvider);
                                                            } catch (e) {
                                                              print(
                                                                  'Error: $e');
                                                              // Handle error...
                                                            }
                                                          }
                                                        : () {},
                                                    child: item.status_id != 18
                                                        ? Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 6,
                                                                    horizontal:
                                                                        4),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        4.h,
                                                                    horizontal:
                                                                        8.w),
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    Colors.red,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.r)),
                                                            child: Text(
                                                              finalDropDownItemforJoinNot[
                                                                      index]
                                                                  .secStatus
                                                                  .toString(),
                                                              style: GoogleFonts
                                                                  .varela(
                                                                      color: Colors
                                                                          .white),
                                                            ))
                                                        : const SizedBox(),
                                                  ),
                                                ),
                                              )
                                            : Wrap(
                                                children: List.generate(
                                                  finalDropDownItemforReadyOffer
                                                      .length,
                                                  (index) => GestureDetector(
                                                    onTap: item.status_id != 15
                                                        ? () async {
                                                            //TODO: To hide ready to join
                                                            NewChangeStatusModel
                                                                changeStatusModel =
                                                                NewChangeStatusModel(
                                                                    doj: item
                                                                        .doj,
                                                                    hrStatusId: finalDropDownItemforReadyOffer[index].secStatusId ==
                                                                            17
                                                                        ? 0
                                                                        : finalDropDownItemforReadyOffer[index]
                                                                            .statusId,
                                                                    statusId: finalDropDownItemforReadyOffer[
                                                                            index]
                                                                        .secStatusId);
                                                            Map<String, dynamic>
                                                                jsonData =
                                                                changeStatusModel
                                                                    .toJson();
                                                            try {
                                                              await JobPostApiService
                                                                  .NewchangeStatus(
                                                                      jsonData,
                                                                      item.id!
                                                                          .toInt());
                                                              ref.refresh(
                                                                  fetchAllApplicantProvider);
                                                              ref.refresh(
                                                                  fetchAllReferalProvider);
                                                              ref.refresh(
                                                                  fetchAllApplyProvider);
                                                            } catch (e) {
                                                              print(
                                                                  'Error: $e');
                                                              // Handle error...
                                                            }
                                                          }
                                                        : () {},
                                                    child: item.status_id != 15
                                                        ? Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 6,
                                                                    horizontal:
                                                                        4),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        4.h,
                                                                    horizontal:
                                                                        8.w),
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    Colors.red,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.r)),
                                                            child: Text(
                                                              finalDropDownItemforReadyOffer[
                                                                      index]
                                                                  .secStatus
                                                                  .toString(),
                                                              style: GoogleFonts
                                                                  .varela(
                                                                      color: Colors
                                                                          .white),
                                                            ))
                                                        : const SizedBox(),
                                                  ),
                                                ),
                                              ),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                isToday ||
                                                        isYesterday ||
                                                        item.status_id ==
                                                            1 //TODO :: Ready to join
                                                    ? null
                                                    : singleSelectPicker();
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: doj ==
                                                              yesterday
                                                          ? Constants
                                                              .themeBgColor
                                                          : Colors.white,
                                                      borderRadius: BorderRadius
                                                          .circular(8.r),
                                                      border: Border.all(
                                                          color: item
                                                                      .doj !=
                                                                  null
                                                              ? item.doj?.day ==
                                                                          tomorrow
                                                                              .day &&
                                                                      item.doj!
                                                                              .month ==
                                                                          tomorrow
                                                                              .month &&
                                                                      item.doj!
                                                                              .year ==
                                                                          tomorrow
                                                                              .year
                                                                  ? Colors.blue
                                                                  : item.doj!.day == DateTime.now().day &&
                                                                          item.doj!.month ==
                                                                              DateTime.now().month &&
                                                                          item.doj!.year == DateTime.now().year
                                                                      ? Colors.green
                                                                      : doj == yesterday
                                                                          ? Colors.white
                                                                          : Colors.brown
                                                              : Constants.themeBgColor)),
                                                  padding: const EdgeInsets.only(left: 5, top: 4, bottom: 4, right: 5),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                          Icons
                                                              .calendar_month_outlined,
                                                          size: 15.h,
                                                          color: item
                                                                      .doj !=
                                                                  null
                                                              ? item.doj
                                                                              ?.day ==
                                                                          tomorrow
                                                                              .day &&
                                                                      item.doj!
                                                                              .month ==
                                                                          tomorrow
                                                                              .month &&
                                                                      item.doj!
                                                                              .year ==
                                                                          tomorrow
                                                                              .year
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
                                                                      ? Colors
                                                                          .green
                                                                      : doj ==
                                                                              yesterday
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .brown
                                                              : Constants
                                                                  .themeBgColor),
                                                      SizedBox(
                                                        width: 4.w,
                                                      ),
                                                      item.doj != null
                                                          ? item.doj!.day == DateTime.now().day &&
                                                                  item.doj!.month ==
                                                                      DateTime.now()
                                                                          .month &&
                                                                  item.doj!.year ==
                                                                      DateTime.now()
                                                                          .year
                                                              ? Text("Today",
                                                                  style: GoogleFonts.varela(
                                                                      color: Colors
                                                                          .green,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600))
                                                              : item.doj!.day == tomorrow.day &&
                                                                      item.doj!.month ==
                                                                          tomorrow
                                                                              .month &&
                                                                      item.doj!.year ==
                                                                          tomorrow
                                                                              .year
                                                                  ? Text(
                                                                      "Tomorrow",
                                                                      style: GoogleFonts.varela(
                                                                          color: Colors.blue,
                                                                          fontWeight: FontWeight.w600))
                                                                  : doj == yesterday
                                                                      ? Text("Yesterday", style: GoogleFonts.varela(color: Colors.white, fontWeight: FontWeight.w600))
                                                                      : Text(DateFormat('dd MMM yyyy').format(item.doj!), style: GoogleFonts.varela(color: Colors.brown, fontWeight: FontWeight.w600))
                                                          : Text("Select DOJ", style: GoogleFonts.varela(color: Constants.themeBgColor, fontWeight: FontWeight.w600)),
                                                    ],
                                                  )),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            if (item.doj != null &&
                                                !isToday) //TODO:: Ready to join.
                                              InkWell(
                                                onTap: () async {
                                                  NewChangeStatusModel
                                                      changeStatusModel =
                                                      NewChangeStatusModel(
                                                          // statusId: item.status_id,
                                                          doj: null);
                                                  Map<String, dynamic>
                                                      jsonData =
                                                      changeStatusModel
                                                          .toJson();
                                                  try {
                                                    await JobPostApiService
                                                        .NewchangeStatus(
                                                            jsonData,
                                                            item.id!.toInt());
                                                    setState(() {});
                                                    // First pop to close the dialog
                                                  } catch (e) {
                                                    print('Error: $e');
                                                    // Handle error...
                                                  }
                                                  setState(() {
                                                    item.doj == null;
                                                  });
                                                  ref.refresh(
                                                      fetchAllApplicantProvider);
                                                },
                                                child: Image.asset(
                                                  "assets/images/close (1).png",
                                                  height: 16.h,
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                            const Spacer(),
                                            if (item.status_id ==
                                                15) //TODO:: Ready to join.
                                              Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 10.h, right: 10.w),
                                                child: Image.asset(
                                                  "assets/images/readytojoin.png",
                                                  height: 40.h,
                                                ),
                                              ),
                                            if (item.status_id == 18)
                                              Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 10.h, right: 10.w),
                                                child: Image.asset(
                                                  "assets/images/selected.jpg",
                                                  height: 30.h,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            */
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
                                          ? SizedBox()/* FutureBuilder<void>(    //TODO: Docs view for cv.
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
                                              sourceName: sourceName);
                                      Map<String, dynamic> jsonData =
                                          changeStatusModel.toJson();

                                      await JobPostApiService.NewchangeStatus(
                                          jsonData, item.id!.toInt());

                                      ref.refresh(fetchAllApplicantProvider);
                                      setState(() {});
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

//TODO:: New InterviewBay For CC.....}

  Container CustomSearch(double height) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      //margin: const EdgeInsets.only(right: 20),
      height: height / 26.h,
      // width: width / 1.10.w,
      child: TextField(
          controller: searchController1,
          style: GoogleFonts.varela(color: Constants.subtitleclr),
          decoration: InputDecoration(
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(),
                borderRadius: BorderRadius.circular(8.r)),
            filled: true,
            prefixIcon: const Icon(Icons.search),
            contentPadding: const EdgeInsets.only(left: 5, top: 10),
            border: OutlineInputBorder(
                /* borderSide:
                const BorderSide(color: Constants.borderColor), */
                borderRadius: BorderRadius.circular(8.r)),
            hintText: "Search",
          )),
    );
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

  /*  Widget listViewItem_new1(
      BuildContext context,
      Applicant item,
      bool isTrue,
      List<String> status,
      int id,
      int index,
      List<DropDownItem> dropDownModel) {
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
          ref.refresh(fetchAllApplicantProvider);
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
            if (item.status_id != 10) {
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
            /* onRightSwipe: item.alternateNo == 0 || item.alternateNo == null   //TODO siwpe to call
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
                : (details) {
                    // handle left swipe with DragUpdateDetails
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
              /*   shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
                //set border radius more than 50% of height and width to make circle
              ),
              // shadowColor: Constants.themeBgColor,
              elevation: 4, */

              margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                child: StatefulBuilder(builder: (context, setState) {
                  return Column(
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
                          /* const CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://media.istockphoto.com/id/503040171/photo/middle-eastern-businessman-portrait.jpg?s=612x612&w=0&k=20&c=7t6c_HQHfUZNgrVtR-G1rQpJAMaCbFsuxppDRKBnXDw="),
                            // child: Text(item.applicantName[0].toUpperCase()),
                            radius: 22,
                          ), */
                          const SizedBox(
                            width: 6,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${item.applicantName.toString().toTitleCase()} ${item.last_name.toString().toTitleCase()}",
                                    style: GoogleFonts.varela(
                                      fontStyle: FontStyle.normal,
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
                              if (item.status_id != 17 &&
                                  item.status_id != 24 &&
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
                        ],
                      ),
                      if ((item.status_id != 17 &&
                              item.status_code != "IB8" &&
                              item.status_id != 24) &&
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
                                      role: item.lead_level.toString(),
                                      companyId: item.short_list_for!.toInt(),
                                      item: item,
                                      refreshCallback: () {
                                        ref.refresh(fetchAllApplicantProvider);
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

                      if ((item.status_id != 10 && item.status_id != 17) &&
                          item.status_id != 24 &&
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
                                  if (item.status_id !=
                                          24 && //TODO: id of intterviewBay..
                                      item.status_id !=
                                          17) //TODO: if of select..
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 2),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      decoration: BoxDecoration(
                                          color: Constants.borderColor,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(
                                        item.status_id ==
                                                24 //TODO: id of intterviewBay..
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
                              const Column(
                                children: [
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

                      if (item.status_id == 17 && item.mode_document == 1)
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
                                        /* status: "IB7",
                                        subStatus: item.sub_code == "IB7-4"
                                            ? "Ready to Join"
                                            : "Confirmation Pending", */
                                        status: item.status_code,
                                        subStatus: item.sub_status,
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
                                        ref.refresh(fetchAllApplicantProvider);
                                        ref.refresh(fetchAllReferalProvider);
                                        ref.refresh(fetchAllApplyProvider);
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
                                                /* status: "IB7",
                                                subStatus: item.sub_code ==
                                                        "IB7-4"
                                                    ? "Ready to Join"
                                                    : "Confirmation Pending", */
                                                status: item.status_code,
                                                subStatus: item.sub_status,
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

                                          ref.refresh(
                                              fetchAllApplicantProvider);
                                          ref.refresh(fetchAllReferalProvider);
                                          ref.refresh(fetchAllApplyProvider);
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
                                              /* status: "IB7",
                                              subStatus:
                                                  item.sub_code == "IB7-4"
                                                      ? "Ready to Join"
                                                      : "Confirmation Pending", */
                                              status: item.status_code,
                                              subStatus: item.sub_status,
                                              doj: item.doj,
                                              id: item.id,
                                              sourceId: item.sourceId,
                                              document_status: "Submitted");
                                      Map<String, dynamic> jsonData =
                                          changeStatusModel.toJson();
                                      try {
                                        await JobPostApiService.changeStatus(
                                            jsonData, item.id!.toInt());

                                        ref.refresh(fetchAllApplicantProvider);
                                        ref.refresh(fetchAllReferalProvider);
                                        ref.refresh(fetchAllApplyProvider);
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
                                                /*   status: "IB7",
                                                subStatus: item.sub_code ==
                                                        "IB7-4"
                                                    ? "Ready to Join"
                                                    : "Confirmation Pending", */
                                                status: item.status_code,
                                                subStatus: item.sub_status,
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

                                          ref.refresh(
                                              fetchAllApplicantProvider);
                                          ref.refresh(fetchAllReferalProvider);
                                          ref.refresh(fetchAllApplyProvider);
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
                                                /* status: "IB7",
                                                subStatus: item.sub_code ==
                                                        "IB7-4"
                                                    ? "Ready to Join"
                                                    : "Confirmation Pending", */
                                                status: item.status_code,
                                                subStatus: item.sub_status,
                                                doj: item.doj,
                                                id: item.id,
                                                sourceId: item.sourceId,
                                                document_status: "Pending");
                                        Map<String, dynamic> jsonData =
                                            changeStatusModel.toJson();
                                        try {
                                          await JobPostApiService.changeStatus(
                                              jsonData, item.id!.toInt());

                                          ref.refresh(
                                              fetchAllApplicantProvider);
                                          ref.refresh(fetchAllReferalProvider);
                                          ref.refresh(fetchAllApplyProvider);
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
                                              /*  status: "IB7",
                                              subStatus:
                                                  item.sub_code == "IB7-4"
                                                      ? "Ready to Join"
                                                      : "Confirmation Pending", */
                                              status: item.status_code,
                                              subStatus: item.sub_status,
                                              doj: item.doj,
                                              id: item.id,
                                              sourceId: item.sourceId,
                                              document_status: "Submitted");
                                      Map<String, dynamic> jsonData =
                                          changeStatusModel.toJson();
                                      try {
                                        await JobPostApiService.changeStatus(
                                            jsonData, item.id!.toInt());
                                        ref.refresh(fetchAllApplicantProvider);
                                        ref.refresh(fetchAllReferalProvider);
                                        ref.refresh(fetchAllApplyProvider);
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
                                onTap: () async {
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
                                    await JobPostApiService.changeStatus(
                                        jsonData, item.id!.toInt());
                                    setState(() {});
                                    // First pop to close the dialog
                                  } catch (e) {
                                    print('Error: $e');
                                    // Handle error...
                                  }
                                  setState(() {
                                    item.doj == null;
                                  });
                                  ref.refresh(fetchAllApplicantProvider);
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
                      if (item.status_code == "IB5" &&
                          !isWalkOut &&
                          !isRejected)
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
                                        ref.refresh(fetchAllApplicantProvider);
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
                                      ref.refresh(fetchAllApplicantProvider);
                                      ref.refresh(fetchAllReferalProvider);
                                      ref.refresh(fetchAllApplyProvider);
                                    },
                                  );
                                },
                              );
                              ref.refresh(fetchAllApplicantProvider);
                              ref.refresh(fetchAllReferalProvider);
                              ref.refresh(fetchAllApplyProvider);
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
                                value: item.interview_rounds ??
                                    finalinterviewRounds.first,
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
                                    ref.refresh(fetchAllApplicantProvider);
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
                                  ...finalinterviewRounds.toSet().map((round) {
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
                                    isNotJoin = !isNotJoin;
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
                                    isOfferDrop = !isOfferDrop;
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
                                    ref.refresh(fetchAllApplicantProvider);
                                    ref.refresh(fetchAllReferalProvider);
                                    ref.refresh(fetchAllApplyProvider);
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

                      if (item.status_code == "IB7" && isDropOut ||
                          isOfferDrop ||
                          isNotJoin)
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

                      if (item.status_code == "IB7" && isDropOut ||
                          isOfferDrop ||
                          isNotJoin) //isOfferDrop
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (isOfferDrop) {
                                    isOfferDrop = !isOfferDrop;
                                  } else if (isDropOut) {
                                    isDropOut = !isDropOut;
                                  } else {
                                    isNotJoin = !isNotJoin;
                                  }

                                  remarkfordropandNotJoin.clear();
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
                                    ref.refresh(fetchAllApplicantProvider);
                                    ref.refresh(fetchAllReferalProvider);
                                    ref.refresh(fetchAllApplyProvider);
                                    remarkfordropandNotJoin.clear();
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

                      if (item.status_code == "IB5" && isRejected ||
                          isWalkOut ||
                          isDropOut)
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
                              labelStyle:
                                  GoogleFonts.varela(color: Colors.grey),
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
                      if (item.status_code == "IB5" && isRejected ||
                          isWalkOut ||
                          isDropOut)
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
                                  showrejectTextFileld.clear();
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
                                          subStatus: isRejected
                                              ? null
                                              : isDropOut
                                                  ? "DropOut"
                                                  : "WalkOut",
                                          sourceId: item.sourceId,
                                          remark: showrejectTextFileld.text);
                                  Map<String, dynamic> jsonData =
                                      changeStatusModel.toJson();
                                  try {
                                    await JobPostApiService.changeStatus(
                                        jsonData, item.id!.toInt());
                                    ref.refresh(fetchAllApplicantProvider);
                                    ref.refresh(fetchAllApplyProvider);
                                    ref.refresh(fetchAllReferalProvider);
                                    showrejectTextFileld.clear();
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
                              isref: false,
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
 */
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

  PopupMenuItem<String> customMenuItem(DropDownItem option, bool isOdd) {
    return PopupMenuItem<String>(
      value: option
          .statusDd, // Replace 'someValue' with the actual property you want to use as the value
      child: Text(
        option.statusDd
            .toString(), // Replace 'applicantName' with the actual property you want to use as the label
        style: const TextStyle(
            color: Colors.black // Example: custom styling based on isOdd
            ),
      ),
    );
  }
}
