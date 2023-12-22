import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/screens/jobs/pdf.dart';
import 'package:job_circle/service/data_get_api_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:timelines/timelines.dart';

import '../../common/utils.dart';
import '../../constants/drop_down_class.dart';
import '../../enums/enums.dart';
import '../../models/application_status_model.dart';
import '../../models/profileSummary.dart';
import '../../service/UserDataService.dart';
import '../../themes/colors.dart';

//enum Issue { no, incorrect, recruiter, other }

final fetchAllMyPipeLineJobs = FutureProvider<List<Applicant>>(
    (ref) => _MyPipeLineState.fetchAllApplicants());

class MyPipeLine extends ConsumerStatefulWidget {
  const MyPipeLine({
    super.key,
  });

  @override
  ConsumerState<MyPipeLine> createState() => _MyPipeLineState();
}

class _MyPipeLineState extends ConsumerState<MyPipeLine>
    with SingleTickerProviderStateMixin {
  @override
  Future<List<Applicant>>? _applicantsFuture;
  List<Application>? applicationList = [];
  void fetchData() async {
    try {
      ApplicationAPI api = ApplicationAPI();
      applicationList = await api.getApplicationStatusList();
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // bindProfileSummary();
    fetchData();
    bindProfileSummary();

    //  _applicantsFuture = fetchApplicantsByUserId(552);
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
        'http://${GlobalConstants.API_Host_one}/leads/v1/getAllLeadsBySourceid?userId1=$userid&page=1&size=1000');
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
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<String> getStatuses(List<Applicant> applicants) {
    return applicants
        .where((e) => e.status_code!.contains('IB'))
        .map((e) => e.status.toString())
        .toSet()
        .toList()
      ..sort();
  }

  Future<void> _onRefresh() async {
    // Perform a global refresh (e.g., fetch new data for all tabs)
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      ref.refresh(fetchAllMyPipeLineJobs);
      // Update the UI with new data
    });
    _refreshController
        .refreshCompleted(); // Call this to end the refresh animation
  }

  bool isSelect = false;

  Map<int, SelectedOption> selectedValueMap = {};
 

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var fetchApplicants = ref.watch(fetchAllMyPipeLineJobs);

    return PageStorage(
        bucket: PageStorageBucket(),
      //  key : const PageStorageKey<String>("futureKey"),
        child: fetchApplicants != null
            ? fetchApplicants.when(
                data: (fetchdata) {
                  List<Applicant>? dataList = fetchdata;
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
                    final statuses = getStatuses(data);
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
                        body: SmartRefresher(
                          enablePullDown: true,
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          child: TabBarView(
                            children: statuses.map((status) {
                              // Filter applicants based on the current status
                              final applicants = data
                                  .where((applicant) =>
                                      applicant.status.toString() == status)
                                  .toList();

                              if (status == 'New') {
                                // Display applicants directly without sub_status tabs
                                return ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  controller: ScrollController(),
                                  shrinkWrap: true,
                                  itemCount: applicants.length,
                                  itemBuilder: (context, index) {
                                    final applicant = applicants[index];
                                    return listViewItem_new(
                                      context,
                                      applicant,
                                      true,
                                      statuses,
                                      index,
                                    );
                                  },
                                );
                              } else if (status == "Select" ||
                                  status == "Disqualify") {
                                final subStatuses = applicants
                                    .map((applicant) =>
                                        applicant.sub_status?.toString())
                                    .where((subStatus) => subStatus != null)
                                    .toSet()
                                    .toList()
                                  ..sort();
                                /* customTabController = TabController(
                          length: companyTab.length, vsync: this); */
                                //TODO: Add custom tab controller
                                return DefaultTabController(
                                  length: subStatuses.length,
                                  child: Scaffold(
                                    appBar: PreferredSize(
                                      preferredSize: const Size(
                                          double.maxFinite,
                                          kTextTabBarHeight),
                                      child: AppBar(
                                        elevation: 0,
                                        backgroundColor: Colors.white,
                                        bottom: TabBar(
                                          //  controller: customTabController,
                                          // key: const ValueKey("ccTab3"),
                                          isScrollable: true,
                                          indicatorSize:
                                              TabBarIndicatorSize.tab,
                                          unselectedLabelStyle:
                                              GoogleFonts.varela(),
                                          labelStyle: GoogleFonts.varela(
                                              fontWeight: FontWeight.w600),
                                          unselectedLabelColor: Colors.black,
                                          labelColor: Constants.subtitleclr,
                                          indicatorPadding: EdgeInsets.only(
                                              bottom: 8.h,
                                              left: 3.w,
                                              right: 3.w),
                                          indicator: isSelect
                                              ? BoxDecoration(
                                                  color:
                                                      Constants.borderColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20),
                                                  border: Border.all(
                                                      color: Constants
                                                          .borderColor))
                                              : null,
                                          indicatorColor:
                                              Constants.borderColor,
                                          tabs: subStatuses
                                              .map((subStatus) =>
                                                  Tab(text: subStatus!))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                    body: PageStorage(
                                      bucket: PageStorageBucket(),
                                      // key: PageStorageKey<String>(status),
                                      child: TabBarView(
                                        // controller: customTabController,
                                        // key: const ValueKey("ccTabView3"),
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

                                          return Column(
                                            children: [
                                              PageStorage(
                                                bucket:
                                                    PageStorageBucket(), // Add this line
                                                // key: const PageStorageKey<
                                                //     String>("sskk"),
                                                child: ListView.builder(
                                                  physics:
                                                      const ClampingScrollPhysics(),
                                                  controller:
                                                      ScrollController(),
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      filteredApplicants
                                                          .length,
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
                                    .map((applicant) =>
                                        applicant.short_name?.toString())
                                    .where((subStatus) => subStatus != null)
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
                                          isScrollable: true,
                                          indicatorSize:
                                              TabBarIndicatorSize.tab,
                                          //indicatorWeight: 2.0,
                                          unselectedLabelStyle:
                                              GoogleFonts.varela(),
                                          labelStyle: GoogleFonts.varela(
                                              fontWeight: FontWeight.w600),
                                          unselectedLabelColor: Colors.black,
                                          labelColor: Constants.subtitleclr,
                                          indicatorPadding: EdgeInsets.only(
                                              bottom: 8.h,
                                              left: 3.w,
                                              right: 3.w),
                                          indicator: isSelect
                                              ? BoxDecoration(
                                                  color:
                                                      Constants.borderColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20),
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
                                      children: subStatuses.map((subStatus) {
                                        // Filter applicants based on the current status and sub_status
                                        final filteredApplicants = applicants
                                            .where((applicant) =>
                                                applicant.short_name
                                                    .toString() ==
                                                subStatus)
                                            .toList();

                                        return ListView.builder(
                                          physics:
                                              const ClampingScrollPhysics(),
                                          controller: ScrollController(),
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
                  } else {
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

  Widget listViewItem_new(BuildContext context, Applicant item, bool isTrue,
      List<String> status, int index) {
    // int selectedRoundIndex = 0;
    List<String> _processes = [];

    String jsonString = '["Screening", "Versant", "Manager(Ops)", "Client"]';

    List<String> finalinterviewRounds = json.decode(jsonString).cast<String>();
    // Replace with your selected interview round string

    int selectedRoundIndex = item.interview_rounds != null
        ? finalinterviewRounds.indexOf(item.interview_rounds.toString())
        : 0;

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

    return Stack(
      children: [
        InkWell(
          onTap: () {},
          child: SwipeTo(
            iconOnRightSwipe: Icons.call,
            iconOnLeftSwipe: Icons.sms_outlined,
/*             onRightSwipe: item.alternateNo == 0  //TODO siwpe to call
                ? () async {
                    FlutterPhoneDirectCaller.callNumber("+91${item.contactNo}");
                  }
                : () {
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
                  },
            onLeftSwipe: item.alternateNo == 0
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
                          phoneNumber1: item.contactNo!.toInt(),
                          phoneNumber2: item.alternateNo!.toInt(),
                          isCall: false,
                        );
                      },
                    );
                  }, */
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
                child: Column(
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
                                  item.applicantName.toString(),
                                  style: GoogleFonts.varela(
                                    // color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  item.dateOfBirth != null
                                      ? " (${calculateAge(item.dateOfBirth.toString())} yr's)"
                                      : "",
                                  style: GoogleFonts.varela(
                                      color: Colors.black54, fontSize: 12.sp),
                                )
                              ],
                            ),
                            item.status_code != "IB4"
                                ? Row(
                                    children: [
                                      Text(
                                        "${item.process} - ${item.lead_level}",
                                        style: GoogleFonts.varela(
                                          color: Colors.black54,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
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
                          ],
                        ),
                      ],
                    ),
                    /* Container(
                      decoration: BoxDecoration(
                          color: Constants.borderColor,
                         
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
                                      "${item.process} - ${item.leadLevel}",
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
                             
                              item.status == "Selected"
                                  ? Image.asset(
                                      "assets/images/selected.jpg",
                                      height: 40.h,
                                    )
                                  : item.status == "Reject"
                                      ? Image.asset(
                                          "assets/images/reject.jpg",
                                          height: 25.h,
                                        )
                                      : Container(
                                          margin: EdgeInsets.only(right: 10.w),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              border: Border.all(
                                                  color:
                                                      Constants.borderColor)),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 6),
                                          child: Text(
                                            item.sub_status.toString(),
                                            style: GoogleFonts.varela(
                                                fontWeight: FontWeight.w600),
                                          ))
                            ],
                          )
                        ],
                      ),
                    ) */

                    if (item.status_code == "IB7" &&
                        item.sub_code != "IB7-3" &&
                        item.sub_code != "IB7-2")
                      Container(
                        margin: EdgeInsets.only(
                          top: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Constants.borderColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 2.h, horizontal: 2.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Document Status"),
                                if (item.mode_document == 0)
                                  Wrap(
                                    children: [
                                      customContainerforDocumentStatus(
                                          Containercolor:
                                              item.document_status ==
                                                      "Schedule F2F"
                                                  ? Colors.amber
                                                  : Colors.white,
                                          fontColor: item.document_status ==
                                                  "Schedule F2F"
                                              ? Colors.white
                                              : Colors.grey.shade400,
                                          title: "Schedule F2F"),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      customContainerforDocumentStatus(
                                          Containercolor:
                                              item.document_status == "Pending"
                                                  ? Colors.amber
                                                  : Colors.white,
                                          fontColor:
                                              item.document_status == "Pending"
                                                  ? Colors.white
                                                  : Colors.grey.shade400,
                                          title: "Pending"),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      customContainerforDocumentStatus(
                                          Containercolor:
                                              item.document_status ==
                                                      "Submitted"
                                                  ? Colors.amber
                                                  : Colors.white,
                                          fontColor: item.document_status ==
                                                  "Submitted"
                                              ? Colors.white
                                              : Colors.grey.shade400,
                                          title: "Submitted"),
                                    ],
                                  ),
                                if (item.mode_document == 1)
                                  Wrap(
                                    children: [
                                      customContainerforDocumentStatus(
                                          Containercolor:
                                              item.document_status ==
                                                      "Not Submitted"
                                                  ? Colors.amber
                                                  : Colors.white,
                                          fontColor: item.document_status ==
                                                  "Not Submitted"
                                              ? Colors.white
                                              : Colors.grey.shade400,
                                          title: "Not Submitted"),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      customContainerforDocumentStatus(
                                          Containercolor:
                                              item.document_status ==
                                                      "Under Review"
                                                  ? Colors.amber
                                                  : Colors.white,
                                          fontColor: item.document_status ==
                                                  "Under Review"
                                              ? Colors.white
                                              : Colors.grey.shade400,
                                          title: "Under Review"),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      customContainerforDocumentStatus(
                                          Containercolor:
                                              item.document_status ==
                                                      "Submitted"
                                                  ? Colors.amber
                                                  : Colors.white,
                                          fontColor: item.document_status ==
                                                  "Submitted"
                                              ? Colors.white
                                              : Colors.grey.shade400,
                                          title: "Submitted"),
                                    ],
                                  )
                              ],
                            ),
                          ],
                        ),
                      ),
                    if (item.status_code == "IB7" && item.doj != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: 6.h),
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
                                                          DateTime.now().day &&
                                                      item.doj!.month ==
                                                          DateTime.now()
                                                              .month &&
                                                      item.doj!.year ==
                                                          DateTime.now().year
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
                                                          DateTime.now().day &&
                                                      item.doj!.month ==
                                                          DateTime.now()
                                                              .month &&
                                                      item.doj!.year ==
                                                          DateTime.now().year
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
                                                  fontWeight: FontWeight.w600))
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
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600))
                                                  : Text(
                                                      DateFormat('dd MMM yyyy')
                                                          .format(item.doj!),
                                                      style: GoogleFonts.varela(
                                                          color: Colors.brown,
                                                          fontWeight:
                                                              FontWeight.w600))
                                      : Text("Select DOJ",
                                          style: GoogleFonts.varela(
                                              color: Constants.themeBgColor,
                                              fontWeight: FontWeight.w600)),
                                ],
                              )),
                          if (item.emp_id != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 6.w),
                              decoration: BoxDecoration(
                                  color: Constants.borderColor,
                                  borderRadius: BorderRadius.circular(8.r)),
                              child: Row(
                                children: [
                                  Text(
                                    "Emp ID : ",
                                    style: GoogleFonts.varela(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(item.emp_id.toString()),
                                ],
                              ),
                            )
                        ],
                      ),
                    if (item.status_code != "IB4" &&
                        item.status_code != "IB5" &&
                        item.status_code != "IB6" &&
                        item.status_code != "IB7")
                      Container(
                        margin: const EdgeInsets.only(
                          top: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Constants.borderColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 2),
                        child: Row(
                          children: [
                            /*  SizedBox(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.asset(
                                  "assets/images/heart.png",
                                  fit: BoxFit.cover,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              // child: Text(item.applicantName[0].toUpperCase()),
                              height: 40.h,
                              width: 40.w,
                            ),
                            const SizedBox(
                              width: 6,
                            ), */
                            Expanded(
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
                          ],
                        ),
                      ),
                    if (item.sub_code == "IB7-2" || item.sub_code == "IB7-3")
                      Container(
                        margin: const EdgeInsets.only(
                          top: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Constants.borderColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 2),
                        child: Row(
                          children: [
                            /*  SizedBox(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.asset(
                                  "assets/images/heart.png",
                                  fit: BoxFit.cover,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              // child: Text(item.applicantName[0].toUpperCase()),
                              height: 40.h,
                              width: 40.w,
                            ),
                            const SizedBox(
                              width: 6,
                            ), */
                            Expanded(
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
                          ],
                        ),
                      ),
                    if (item.status_code == "IB4")
                      Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            color: Constants.borderColor,
                            borderRadius: BorderRadius.circular(8)),
                        margin: EdgeInsets.only(top: 6.h),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 2),
                        // padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 2),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                  color: Constants.borderColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                item.companyName.toString(),
                                style: GoogleFonts.varela(
                                    color: Colors.black54, fontSize: 13.sp
                                    // fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                  color: Constants.borderColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${item.process} - ${item.lead_level}",
                                    style: GoogleFonts.varela(
                                        color: Colors.black54, fontSize: 13.sp
                                        // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (item.status_code == "IB5" || item.status_code == "IB6")
                      Column(
                        children: [
                          SizedBox(
                            height: 4.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                item.sub_status == "On-Site Interview"
                                    ? "Face2Face Interview"
                                    : "Virtual Interview",
                                style: GoogleFonts.varela(
                                    // color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                    color: Colors.grey.shade400,
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ],
                      ),
                    if (item.status_code == "IB5")
                      Container(
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
                                  finalinterviewRounds.length.toDouble();
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
                                return const SolidLineConnector(
                                  color: Colors.green,
                                );
                              } else if (index > selectedRoundIndex) {
                                // Customize connectors for other rounds
                                return SolidLineConnector(
                                  color: Colors.grey.shade400,
                                );
                              } else {
                                return const SolidLineConnector(
                                  color: Colors.green,
                                );
                              }
                            },
                          ),
                        ),
                      ),

                    /*  Container(
                      height: 120,
                      alignment: Alignment.topCenter,
                      child: Timeline.tileBuilder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        theme: TimelineThemeData(
                          direction: Axis.horizontal,
                          connectorTheme: const ConnectorThemeData(
                            space: 8.0,
                            thickness: 2.0,
                          ),
                        ),
                        builder: TimelineTileBuilder.connected(
                          connectionDirection: ConnectionDirection.before,
                          itemCount: finalinterviewRounds != null
                              ? finalinterviewRounds.length
                              : 0,
                          itemExtentBuilder: (_, __) {
                            return (MediaQuery.of(context).size.width - 120) /
                                finalinterviewRounds.length.toDouble();
                          },
                          oppositeContentsBuilder: (context, index) {
                            return Container();
                          },
                          contentsBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: finalinterviewRounds != null
                                  ? Text(finalinterviewRounds[index])
                                  : const Text(""),
                            );
                          },
                          indicatorBuilder: (_, index) {
                            if (index == selectedRoundIndex) {
                              return const DotIndicator(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.green, width: 2),
                                    top: BorderSide(
                                        color: Colors.green, width: 2),
                                    left: BorderSide(
                                        color: Colors.green, width: 2),
                                    right: BorderSide(
                                        color: Colors.green, width: 2)),
                                size: 20.0,
                                color: Colors.white,
                              );
                            } else {
                              return OutlinedDotIndicator(
                                borderWidth: 4.0,
                                color: Colors.grey.shade400,
                              );
                            }
                          },
                          connectorBuilder: (_, index, type) {
                            if (index > 0) {
                              return SolidLineConnector(
                                color: Colors.grey.shade400,
                              );
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ), */
                    if (item.status_code == "IB6")
                      Container(
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
                                  finalinterviewRounds.length.toDouble();
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
                                return CircleAvatar(
                                  radius: 8.r,
                                  child: Image.asset(
                                    "assets/images/rejectcross.png",
                                    height: 8.h,
                                    color: Colors.white,
                                  ),
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
                                return const SolidLineConnector(
                                  color: Colors.green,
                                );
                              } else if (index > selectedRoundIndex) {
                                // Customize connectors for other rounds
                                return SolidLineConnector(
                                  color: Colors.grey.shade400,
                                );
                              } else {
                                return const SolidLineConnector(
                                  color: Colors.green,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    if (item.status_code == "IB6")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Feedback",
                            style: GoogleFonts.varela(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
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
                    /* Column(
                        children: [
                          SizedBox(
                            height: 4.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (item.remark != null)
                                Text(
                                  item.remark.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: GoogleFonts.varela(
                                    // color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                    color: Colors.grey.shade400,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ), */
                  ],
                ),
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
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PDFViewerScreen(
                              pdfAssetPath: item.resume.toString(),
                              isref: false,
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

  Container customContainerforDocumentStatus(
      {required Color Containercolor,
      required String title,
      required Color fontColor}) {
    return Container(
      margin: EdgeInsets.only(top: 4.h, bottom: 4.h),
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r), color: Containercolor),
      child: Text(
        title,
        style: GoogleFonts.varela(color: fontColor),
      ),
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
}
