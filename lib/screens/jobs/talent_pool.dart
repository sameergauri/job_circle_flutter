// ignore_for_file: unused_result, avoid_print, unused_field, override_on_non_overriding_member, unused_local_variable

import 'dart:convert';

import 'package:awesome_calendar/awesome_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/customdialogue_for_call_whatsapp.dart';
import 'package:job_circle/constants/drop_down_class.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/application_status_model.dart';
import 'package:job_circle/models/changeStatusModel.dart';
import 'package:job_circle/models/drop_down_model.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/models/interview_rounds_model.dart';
import 'package:job_circle/models/job_details_model.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/screens/jobs/interview_bay_executive.dart';
import 'package:job_circle/screens/jobs/pdf.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/service/data_get_api_service.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:job_circle/tracking/application.dart';
import 'package:job_circle/tracking/assign.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_to/swipe_to.dart';
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
        'http://${GlobalConstants.API_Host_one}/leads/v1/getAllLeadsBySourceId?sourceId=$userid&page=1&size=100');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> contentList = jsonData['resultData']['content'];

        // Convert the list of Map to a list of Applicant objects
        List<Applicant> applicants = contentList
            .map((json) => Applicant.fromJson(json))
            .where(
                (element) => element.status_id == 3 || element.status_id == 4)
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

    ref.refresh(fetchAllTalentPoolProvider);
    // Update the UI with new data

    _refreshControllers[index]
        .refreshCompleted(); // Call this to end the refresh animation
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
        .map((e) => e.hr_status != null ? e.hr_status.toString() : e.s2HrStatus)
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

  final TextEditingController _searchController = TextEditingController();
  List<Applicant>? _filteredData;

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
                        backgroundColor: Colors.white,
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
                    return Center(
                      child: Image.asset("assets/images/nodata.gif"),
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
            : const Center(
                child: Text("No data to display."),
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
          ref.refresh(fetchAllTalentPoolProvider);

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
                                    report_to: reportTo,
                                    sourcename: sourceName,
                                  )),
                              Visibility(
                                  visible: item.hr_status_id == 12 ||
                                      item.s2DdHrStatusId == 12, //TODO:: Assign
                                  child: AssignData(
                                      item: item,
                                      dropDownItemList: dropDownItemList!)),
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