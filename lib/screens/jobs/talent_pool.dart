import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
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
import 'package:job_circle/screens/jobs/my_pipe_line.dart';
import 'package:job_circle/screens/jobs/pdf.dart';
import 'package:job_circle/service/data_get_api_service.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/utils.dart';
import '../../constants/customdialogue_for_call_whatsapp.dart';
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
      DateTime dob = DateTime.parse(dateOfBirth + "T00:00:00.000Z");

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
        .where((e) => e.status_code!.contains('TP'))
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
  final RefreshController _refreshController =
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

  bool isSelect = false;

  Map<int, SelectedOption> selectedValueMap = {};
  final GlobalKey<_TalentPoolState> _talentPollKey =
      GlobalKey<_TalentPoolState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    var fetchApplicants = ref.watch(fetchAllTalentPool);

    return PageStorage(
        bucket: PageStorageBucket(),
        key: const PageStorageKey<String>("futureKey"),
        child: fetchApplicants != null
            ? fetchApplicants.when(
                data: (fetchdata) {
                  List<Applicant>? dataList = fetchdata;

                  // Define a flag to track if any item meets the condition
                  bool anyItemMeetsCondition = false;

                  for (Applicant item in dataList) {
                    if (item.status_code!.contains("TP")) {
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
                          preferredSize:
                              Size(double.maxFinite, kTextTabBarHeight / 1.2.h),
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
                          child: NestedScrollView(
                            headerSliverBuilder: (BuildContext context,
                                bool innerBoxIsScrolled) {
                              return <Widget>[];
                            },
                            body: TabBarView(
                              children: statuses.map((status) {
                                // Filter applicants based on the current status
                                final applicants = data
                                    .where((applicant) =>
                                        applicant.status.toString() == status)
                                    .toList();

                                // Check if sub_status is null or not
                                final subStatuses = applicants
                                    .map((applicant) =>
                                        applicant.sub_status?.toString())
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
                                                  applicant.sub_status
                                                      .toString() ==
                                                  subStatus)
                                              .toList();

                                          return ListView.builder(
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
            if (item.status != "Application") {
              /*  Navigator.push(
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
            onRightSwipe: item.alternateNo == 0
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
                    if (item.status != "Application")
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
                                        ref.refresh(fetchAllMyPipeLineJobs);
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
                        if (item.status != "Application") {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFViewerScreen(
                                isref: false,
                                pdfAssetPath: item.resume.toString(),
                                phoneNumber1: item.contactNo!.toInt(),
                                phoneNumber2: item.alternateNo!.toInt(),
                                // Replace with the actual asset path of your PDF file
                              ),
                            ),
                          );
                        } else {
                          ChangeStatusModel changeStatusModel =
                              ChangeStatusModel(
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
                                isref: false,
                                pdfAssetPath: item.resume.toString(),
                                phoneNumber1: item.contactNo!.toInt(),
                                phoneNumber2: item.alternateNo!.toInt(),
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
