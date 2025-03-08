// ignore_for_file: override_on_non_overriding_member, unused_field, unused_result, unused_local_variable, non_constant_identifier_names, avoid_unnecessary_containers, avoid_print, use_full_hex_values_for_flutter_colors, use_build_context_synchronously
// ignore_for_file: todo
import 'dart:convert';

import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/custom_network_image.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/models/job_details_model.dart';
import 'package:job_circle/screens/home.dart';
import 'package:job_circle/screens/jobs/curve_painter.dart';
import 'package:job_circle/screens/jobs/job_details.dart';
import 'package:job_circle/screens/jobs/job_details_for_candidate.dart';
import 'package:job_circle/screens/jobs/pdf.dart';
// import 'package:pdftron_flutter/pdftron_flutter.dart' as pdftron;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelines/timelines.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/utils.dart';
import '../../models/profileSummary.dart';
import '../../service/UserDataService.dart';
import '../../themes/colors.dart';

final fetchAllReferalProvider = FutureProvider<List<Applicant>>((
  ref,
) {
  Future.delayed(const Duration(seconds: 2));
  return _AllReferStatusState.fetchApplicantsByUserId();
});
//enum Issue { no, incorrect, recruiter, other }

class AllReferStatus extends ConsumerStatefulWidget {
  const AllReferStatus({
    super.key,
  });

  @override
  ConsumerState<AllReferStatus> createState() => _AllReferStatusState();
}

/* List<String?> getStatuses(List<Applicant> applicants) {
  return applicants
      .map((e) =>
          e.referral_status != null ? e.referral_status.toString() : e.s2ReferralStatus)
      .toSet()
      .toList()
    ..sort();
} */
List<String?> getStatuses(List<Applicant> applicants) {
  return applicants
      .map((e) => e.referral_status != null
          ? e.referral_status.toString()
          : e.s2ReferralStatus)
      .toSet()
      .toList()
    ..sort();
}

class _AllReferStatusState extends ConsumerState<AllReferStatus>
    with SingleTickerProviderStateMixin {
  JobDetailsModel jobDetailsModel = JobDetailsModel();
  ProfileSummaryModel profilemodel = ProfileSummaryModel();
  @override
  Future<List<Applicant>>? _applicantsFuture;
  @override
  void initState() {
    super.initState();
    bindProfileSummary();
    //  _applicantsFuture = fetchApplicantsByUserId(552);
  }

  Future<void> bindProfileSummary() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var type = await Utils.getPreferencesValue(
      prefs,
      ESharedPreferences.user_id.name,
    );
    int? usertype = int.tryParse(type.toString());
    var result = await UserDataService().getUserProfileSummary(usertype!);
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

  static Future<List<Applicant>> fetchApplicantsByUserId() async {
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/leads/v1/getReferralJobsByUser?userId=$userid&pageNumber=1&pageSize=1000');
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

  /*  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> _onRefresh() async {
    // Perform a global refresh (e.g., fetch new data for all tabs)
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      ref.refresh(fetchAllReferalProvider);
      // Update the UI with new data
    });
    _refreshController
        .refreshCompleted(); // Call this to end the refresh animation
  } */

  final List<RefreshController> _refreshControllers = List.generate(
    10,
    (index) => RefreshController(initialRefresh: false),
  );

  Future<void> _onRefresh(int index) async {
    // Perform a global refresh (e.g., fetch new data for all tabs)
    await Future.delayed(const Duration(seconds: 2));

    ref.refresh(fetchAllReferalProvider);
    // Update the UI with new data

    _refreshControllers[index]
        .refreshCompleted(); // Call this to end the refresh animation
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

  /*  String convertSalaryFormat(String input) {
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
          double shortStartValue = startValue / 10000000.0;
          double shortEndValue = endValue / 10000000.0;
          return "${shortStartValue.toStringAsFixed(shortStartValue.truncateToDouble() == shortStartValue ? 0 : 2)} Lac's - ${shortEndValue.toStringAsFixed(shortEndValue.truncateToDouble() == shortEndValue ? 0 : 2)} Lac's P.A";
        } else {
          return '$startValue - $endValue Per Year';
        }
      }
    }

    // Handle other cases, or return the input as it is if it doesn't match any pattern
    return input;
  } */

//TODO: old salry formater code which is not working properly.
  /*  String convertSalaryFormat(String input) {
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

  bool isSearchEnable = false;

  FocusNode searchNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var fetchApplicants =
        profilemodel.id != null ? ref.watch(fetchAllReferalProvider) : null;
    // Build your widget's UI with the 'profilemodel' data
    // For example:
    return PageStorage(
        bucket: PageStorageBucket(),
        // key: const PageStorageKey<String>("futureKey"),
        child: fetchApplicants != null
            ? fetchApplicants.when(data: (fetchData) {
                List<Applicant>? dataList = fetchData;
                bool anyItemMeetsCondition = false;
                for (Applicant item in dataList) {
                  // If the condition is met for any item, set the flag to true and break the loop
                  anyItemMeetsCondition = true;
                  break;
                }
                if (anyItemMeetsCondition) {
                  final data = fetchData;
                  final statuses = getStatuses(data);
                  return DefaultTabController(
                    length: statuses.length,
                    child: Scaffold(
                      floatingActionButton: DraggableFab(
                        child: FloatingActionButton(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            child: Icon(
                              Icons.search,
                              size: 30.sp,
                              color: Constants.darkBlue,
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
                      appBar: PreferredSize(
                        preferredSize: Size(
                            double.maxFinite,
                            isSearchEnable
                                ? kTextTabBarHeight * 1.90.sp
                                : kToolbarHeight),
                        child: AppBar(
                          title: isSearchEnable
                              ? SizedBox(
                                  // margin: EdgeInsets.only(top: 10.h),
                                  height:
                                      MediaQuery.of(context).size.height / 26.h,
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
                                          color: Constants.darkBlue,
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
                          backgroundColor: Colors.white,
                          bottom: TabBar(
                            unselectedLabelStyle: GoogleFonts.varela(
                                fontWeight: FontWeight.normal),
                            labelStyle:
                                GoogleFonts.varela(fontWeight: FontWeight.bold),
                            labelPadding:
                                const EdgeInsets.only(left: 5, right: 5),
                            labelColor: Colors.black,
                            isScrollable: true,
                            unselectedLabelColor: Colors.black,
                            indicatorSize: TabBarIndicatorSize.tab,
                            splashBorderRadius: BorderRadius.circular(8),
                            //indicatorSize: TabBarIndicatorSize.label,
                            indicatorWeight: 1.h,
                            indicatorPadding: EdgeInsets.only(
                                top: 8.h, bottom: 8.h, left: 3.w, right: 3.w),
                            //indicatorSize: TabBarIndicatorSize.label,
                            // indicatorWeight: 0,
                            indicator: BoxDecoration(
                                color: Constants.borderColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color:
                                        Constants.borderColor) // Creates border
                                ),
                            tabs: statuses
                                .map(
                                  (e) => Tab(
                                    child: customTab(
                                        e!,
                                        data
                                            .where((element) =>
                                                element.referral_status == e ||
                                                element.s2ReferralStatus == e)
                                            .where((element) =>
                                                element.applicantName!
                                                    .toLowerCase()
                                                    .contains(_searchController.text
                                                        .toLowerCase()) ||
                                                element.last_name!
                                                    .toLowerCase()
                                                    .contains(_searchController
                                                        .text
                                                        .toLowerCase()) ||
                                                element.companyName!
                                                    .toLowerCase()
                                                    .contains(_searchController
                                                        .text
                                                        .toLowerCase()) ||
                                                element.process!
                                                    .toLowerCase()
                                                    .contains(_searchController.text.toLowerCase()))
                                            .length),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      body: NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[];
                        },
                        body: TabBarView(
                          children: statuses.asMap().entries.map((entry) {
                            final index = entry.key;
                            final status = entry.value;
                            final applicants = data
                                .where((applicant) => applicant
                                            .referral_status !=
                                        null
                                    ? applicant.referral_status.toString() ==
                                        status
                                    : applicant.s2ReferralStatus.toString() ==
                                        status)
                                .where((element) =>
                                    element.applicantName!.toLowerCase().contains(
                                        _searchController.text.toLowerCase()) ||
                                    element.last_name!.toLowerCase().contains(
                                        _searchController.text.toLowerCase()) ||
                                    element.companyName!.toLowerCase().contains(
                                        _searchController.text.toLowerCase()) ||
                                    element.process!.toLowerCase().contains(
                                        _searchController.text.toLowerCase()))
                                .toList();

                            // Create widgets based on the applicants list

                            // Return the list of widgets for this status
                            return SmartRefresher(
                              enablePullDown: true,
                              controller: _refreshControllers[index],
                              onRefresh: () async {
                                await _onRefresh(index);
                              },
                              child: ListView.builder(
                                shrinkWrap: true,
                                // physics: const BouncingScrollPhysics(),
                                itemCount: applicants.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return listViewItem_new(
                                      context, applicants[index], true);
                                },
                              ),
                            );
                          }).toList(),

                          /* children: [
                            ListView.builder(
                              itemCount: statuses.length,
                              itemBuilder: (BuildContext context, int index) {
                                final filteredData = data
                                    .where((applicant) =>
                                        applicant.status.toString() ==
                                        statuses[index])
                                    .toList();
                      
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: filteredData.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return listViewItem_new(
                                        context, filteredData[index], true);
                                  },
                                );
                              },
                            ),
                          ], */
                        ),
                      ),
                      /* SmartRefresher(
                        enablePullDown: true,
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        child: NestedScrollView(
                          headerSliverBuilder: (BuildContext context,
                              bool innerBoxIsScrolled) {
                            return <Widget>[];
                          },
                          body: TabBarView(
                            children: statuses
                                .map(
                                  (e) => ListView(
                                    shrinkWrap: true,
                                    children: data
                                        .where(
                                          (applicant) =>
                                              applicant.status.toString() ==
                                              e,
                                        )
                                        .map(
                                          (e) => listViewItem_new(
                                              context, e, true),
                                        )
                                        .toList(),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ), */
                    ),
                  );
                } else {
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/noref.gif"),
                          Text(
                            textAlign: TextAlign.center,
                            "Your expertise can shape careers and earn rewards.",
                            style: GoogleFonts.varela(
                                fontSize: 18.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Join us in connecting talent with opportunities. Refer now and let's build success together!",
                                  style: GoogleFonts.varela(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          /*   InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                  color: Constants.themeBgColor,
                                  borderRadius: BorderRadius.circular(8.r)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Text(
                                "View Jobs",
                                style: GoogleFonts.varela(color: Colors.white),
                              ),
                            ),
                          ) */
                          const Spacer(),
                        ],
                      ),
                    ),
                  );
                }
              }, error: (error, stackTrace) {
                return const Center(
                  child: Text("Error while fetching the data"),
                );
              }, loading: () {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Constants.darkBlue,
                ));
              })
            : const Center(
                child: CircularProgressIndicator(
                  color: Constants.darkBlue,
                ),
              ));
  }

  Widget listViewItem_new(BuildContext context, Applicant item, bool isTrue) {
    // List<String>? myStrings;
    //  bool stopIteration = false;

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

    return InkWell(
      onTap: () async {
        SharedPreferences pref = await Utils.getSharedPreferences();
        var userType = await Utils.getPreferencesValue(
            pref, ESharedPreferences.user_type.name);
        var userrole =
            await Utils.getPreferencesValue(pref, ESharedPreferences.role.name);
        var id = await Utils.getPreferencesValue(
            pref, ESharedPreferences.user_id.name);
        int? userid = int.tryParse(id);

        if (item.status_id == 1 ||
            (item.hr_status_id == 12) ||
            item.status_id == 4 ||
            (item.status_id == 0 && item.hr_status_id == 20)) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return JobDetailsForCandidate(
                hint: 0,
                userrole: userrole.toString(),
                userid: userid!,
                userType: userType,
                Applies: false,
                referal: true,
                is_freelancer: 3,
                id: item.jobId,
              );
            },
          ));
        } else {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return JobDetails(
                id: item.jobId,
                Applies: false,
                referal: true,
                is_freelancer: 3,
              );
            },
          ));
        }

        /* Navigator.pushNamed(
          context,
          ERoute.jobsdetail.name,
          arguments: {
            'id': item.jobId,
          },
        ); */
      },
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
        /*  shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
          //set border radius more than 50% of height and width to make circle
        ),
        // shadowColor: Constants.themeBgColor,
        elevation: 4, */

        margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.r),
                    topRight: Radius.circular(8.r)),
              ),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
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
                    ],
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${item.applicantName.toString()} ${item.last_name.toString()}",
                        // maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp),
                      ),
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
                  const Spacer(),
                  Column(
                    children: [
                      if (item.resume != null)
                        IconButton(
                          onPressed: () {
                            item.resume!.contains(".docx")
                                ? Stack(
                                    children: [
                                      const SizedBox(),
                                      /*  FutureBuilder<void>(    //TODO: Docs view for cv.
                                        future:
                                            pdftron.PdftronFlutter.openDocument(
                                          "https://s3.ap-south-1.amazonaws.com/job-circle-2/${item.resume}",
                                          config: pdftron.Config.fromJson({
                                            'readOnly': true,
                                            // Add other configuration options as needed
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
                                      ), */
                                      Positioned(
                                        top:
                                            20, // Adjust the top position as needed
                                        right:
                                            20, // Adjust the right position as needed
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty
                                                .all<Color>(Colors
                                                    .blue), // Change the color here
                                          ),
                                          onPressed: () {
                                            // Handle button press
                                          },
                                          child: const Text('Button'),
                                        ),
                                      ),
                                    ],
                                  )

                                /* FutureBuilder<void>(
                                    future: pdftron.PdftronFlutter.openDocument(
                                      "https://s3.ap-south-1.amazonaws.com/job-circle-2/${item.resume}",
                                      config: pdftron.Config.fromJson({
                                        'readOnly':
                                            true, // Set to read-only mode
                                        // Add other configuration options as needed to remove watermark or customize viewer
                                      }),
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
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
                                      builder: (context) => PDFViewerScreen(
                                        isCvDownloaded:
                                            item.isCvDownload != null
                                                ? item.isCvDownload!.toInt()
                                                : 0,
                                        pdfAssetPath: item.resume.toString(),
                                        isref: true,
                                        phoneNumber1:
                                            item.spocContactNo!.toInt(),
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
                            height: 20.h,
                          ),
                        )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start, // Ad
                children: [
                  /* Container(   //TODO: CRPF container ....
                      decoration: BoxDecoration(
                          color: Constants.borderColor,
                          borderRadius: BorderRadius.circular(8.r)),
                      padding:
                          EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
                      margin: EdgeInsets.only(bottom: 4.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.companyName != null)
                            Text(
                              item.short_name != null
                                  ? item.short_name.toString()
                                  : item.companyName.toString(),
                              style: GoogleFonts.varela(
                                  fontWeight: FontWeight.bold, fontSize: 14.sp),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.process != null)
                                Text(
                                  item.process.toString(),
                                  style: GoogleFonts.varela(
                                      // color: Colors.black54,
                                      color:
                                          const Color.fromARGB(255, 22, 36, 32),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13.sp),
                                ),
                              if (item.lead_level != null)
                                Text(
                                  " || ",
                                  style: GoogleFonts.varela(
                                      // color: Colors.black54,
                                      color:
                                          const Color.fromARGB(255, 22, 36, 32),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13.sp),
                                ),
                              if (item.lead_level != null)
                                Text(
                                  item.lead_level == ""
                                      ? "Role Name**"
                                      : item.lead_level.toString(),
                                  // overflow: TextOverflow.visible,
                                  style: GoogleFonts.varela(
                                      // color: Colors.black54,
                                      color:
                                          const Color.fromARGB(255, 22, 36, 32),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13.sp),
                                ),
                            ],
                          ),
                        ],
                      )), */
                  if (item.companyName != null)
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
                  if (item.process != null)
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
                            "${item.process.toString()} || ${item.lead_level.toString()}",
                            style: GoogleFonts.varela(
                                // color: Colors.black54,
                                color: Constants.subtitleclr,
                                fontWeight: FontWeight.normal,
                                fontSize: 13.sp),
                          )
                        ],
                      ),
                    ),
                  if (item.totalSalary != null)
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
                  if (item.workLocation != null)
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
                          /* Text(
                            item.workLocation.toString(),
                            style: GoogleFonts.varela(
                                // color: Colors.black54,
                                color: Constants.subtitleclr,
                                fontWeight: FontWeight.normal,
                                fontSize: 13.sp),
                          ), */
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
                  if (item.status_id != 1)
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if ((item.referral_icon != null &&
                                      item.referral_icon != "null") ||
                                  item.s2ReferralIcon != null)
                                CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: CustomImage(
                                        imageUrl:
                                            "https://s3.ap-south-1.amazonaws.com/job-circle-2/${item.referral_icon ?? item.s2ReferralIcon}",
                                        height: 24.h,
                                        defaultImageUrl:
                                            "assets/images/error.png") /* Image.network(
                                    "https://s3.ap-south-1.amazonaws.com/job-circle-2/${item.referral_icon ?? item.s2ReferralIcon}",
                                    fit: BoxFit.fill,
                                    height: 24.h,
                                  ), */
                                    )
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      if (item.referral_feedback1 != null ||
                                          item.s2ReferralFeedback2 != null ||
                                          item.referral_feedback1 != "")
                                        Flexible(
                                          child: Text(
                                            item.referral_feedback1 != null
                                                ? item.referral_feedback1
                                                    .toString()
                                                : item.s2ReferralFeedback1
                                                    .toString(),
                                            style: GoogleFonts.varela(
                                                color: Constants.darkBlue,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.sp),
                                            softWrap: true,
                                            // maxLines: 3,
                                          ),
                                        ),
                                    ],
                                  ),
                                  if (item.referral_feedback2 != null ||
                                      item.s2ReferralFeedback2 != null)
                                    Text(
                                      item.referral_feedback2 != null
                                          ? item.referral_feedback2.toString()
                                          : item.s2ReferralFeedback2 != null
                                              ? item.s2ReferralFeedback2
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
                          )
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (item.status_id == 1 ||
                            (item.hr_status_id == 12) ||
                            item.status_id == 4 ||
                            (item.status_id == 0 && item.hr_status_id == 20))
                          InkWell(
                            onTap: () async {
                              SharedPreferences pref =
                                  await Utils.getSharedPreferences();
                              var userType = await Utils.getPreferencesValue(
                                  pref, ESharedPreferences.user_type.name);
                              var userrole = await Utils.getPreferencesValue(
                                  pref, ESharedPreferences.role.name);
                              var userid = await Utils.getPreferencesValue(
                                  pref, ESharedPreferences.user_id.name);
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return JobDetailsForCandidate(
                                    userrole: userrole,
                                    hint: 1,
                                    userid: userid,
                                    userType: userType,
                                    Applies: false,
                                    referal: true,
                                    is_freelancer: 3,
                                    id: item.jobId,
                                  );
                                },
                              ));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                  // border: Border.all(color: Constants.themeBgColor),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/interview_tips.gif",
                                    height: 15.h,
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    "Interview Tips",
                                    style: GoogleFonts.varela(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (item.hr_status_id != 12 &&
                            item.status_id != 1 &&
                            item.hr_status_id != 20)
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                  // border: Border.all(color: Constants.themeBgColor),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/similar.png",
                                    height: 15.h,
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    "View more jobs",
                                    style: GoogleFonts.varela(
                                        color: Constants.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const Spacer(),
                        RestrictedButton(
                          isChat: true,
                          onTap: () async {
                            Uri url = Uri.parse(
                                "whatsapp://send?phone=91${item.report_to_official_no != 0 && item.report_to_official_no != null ? item.report_to_official_no : 7507810000}");
                            await canLaunchUrl(url)
                                ? await launchUrl(url)
                                : throw "could not launch $url";
                          },
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        RestrictedButton(
                          isChat: false,
                          onTap: () async {
                            FlutterPhoneDirectCaller.callNumber(
                                "+91${item.report_to_official_no != 0 && item.report_to_official_no != null ? item.report_to_official_no : 7507810000}");
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5.h),
                    color: Colors.grey.shade400,
                    width: double.maxFinite,
                    height: 0.5.h,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/verified.png",
                                  height: 16.h,
                                  color: Constants.themeBgColor,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  //𝘧𝘳𝘦𝘦 𝘢𝘯𝘥 𝘷𝘦𝘳𝘪𝘧𝘪𝘦𝘥 𝘑𝘰𝘣
                                  "100% free and verified Job",
                                  style: GoogleFonts.varela(
                                      fontWeight: FontWeight.w500,
                                      color: Constants.subtitleclr),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
            Text(
              title,
              style: GoogleFonts.varela(),
            ),
            SizedBox(
              width: 5.w,
            ),
            Text(
              "($count)",
              style: GoogleFonts.varela(),
            ),
          ],
        ));
  }
}


/* import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/themes/colors.dart';

class ReferNow extends StatefulWidget {
  const ReferNow({super.key});

  @override
  State<ReferNow> createState() => _ReferNowState();
}

class _ReferNowState extends State<ReferNow>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 5, vsync: this);

  int? cutTab;
  Offset position = const Offset(.0, 200.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Constants.themeBgColor,
          foregroundColor: Colors.transparent,
          splashColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            Navigator.pushNamed(context, ERoute.application.name, arguments: {
              "isnew": true,
              // "prevModel": jobDetailsModel,
              "refer": false
            });
          },
          child: Image.asset(
            "assets/images/add.png",
            height: 30.h,
            color: Constants.borderColor,
          )),
/*       appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          "Who you refere",
          style: TextStyle(color: Colors.black),
        ),
        bottom: PreferredSize(
          preferredSize: const Size(0, 35.1),
          child: TabBar(
            labelPadding: const EdgeInsets.only(left: 5, right: 5),
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            splashBorderRadius: BorderRadius.circular(50),
            //indicatorSize: TabBarIndicatorSize.label,
            // indicatorWeight: 0,
            indicator: BoxDecoration(
                color: Constants.borderColor,
                borderRadius: BorderRadius.circular(50),
                border:
                    Border.all(color: Constants.borderColor) // Creates border
                ),
            onTap: (value) {
              setState(() {
                cutTab = value;
              });
            },
            isScrollable: true,
            tabs: [
              Tab(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet<void>(
                        // context and builder are
                        // required properties in this widget
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              children: [
                                Text(
                                  "Apply Filter",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            height: MediaQuery.of(context).size.height / 2.h,
                            width: double.maxFinite,
                          );
                        });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        border: Border.all(color: Constants.borderColor)),
                    height: 33.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Filter"),
                        SizedBox(
                          width: 5.w,
                        ),
                        const Icon(
                          Icons.filter_list,
                          color: Colors.black,
                        ),
                        // const Text("Sort by"),
                        /* DropdownButton<String>(
                            icon: const Icon(
                              Icons.filter_list,
                              color: Colors.black,
                            ),
                            underline: const SizedBox(),
                            style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                            value: sortByd,
                            alignment: Alignment.bottomRight,
                            items: <String>[
                              'Recomended',
                              // 'Salary - high to low',
                              // 'Distance - newr to far',
                              'Newer Jobs'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              );
                            }).toList(),
                            onChanged: (_) {
                              setState(() {
                                sortByd = _.toString();
                                searchAgain();
                              });
                            },
                          ), */
                      ],
                    ),
                  ),
                ),
              ),
             /*  Tab(child: customTab("New Jobs", "assets/images/check.png", 2)),
              Tab(
                  child: customTab(
                      "Work from home", "assets/images/check.png", 3)),
              Tab(
                  child: customTab(
                      "Work from office", "assets/images/check.png", 4)),
              Tab(child: customTab("Hybrid", "assets/images/check.png", 5)),
              Tab(child: customTab("Recomended", "assets/images/check.png", 6)), */
            ],
          ),
        ),
      ), */
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                customContainer(context, "Candidate Name", "ICICI Lombard",
                    "Vashi", "18,000 - 28,000 per month"),
                customContainer(context, "Candidate Name", "ICICI Lombard",
                    "Vashi", "18,000 - 28,000 per month"),
                customContainer(context, "Candidate Name", "ICICI Lombard",
                    "Vashi", "18,000 - 28,000 per month"),
                customContainer(context, "Candidate Name", "ICICI Lombard",
                    "Vashi", "18,000 - 28,000 per month"),
                customContainer(context, "Candidate Name", "ICICI Lombard",
                    "Vashi", "18,000 - 28,000 per month"),
                customContainer(context, "Candidate Name", "ICICI Lombard",
                    "Vashi", "18,000 - 28,000 per month"),
              ],
            ),
          ),
          /* Positioned(
            left: position.dx,
            top: position.dy,
            child: Draggable(
                feedback: FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.pushNamed(context, ERoute.application.name,
                          arguments: {
                            "isnew": true,
                            // "prevModel": jobDetailsModel,
                            "refer": false
                          });
                    }),
                child: FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.pushNamed(context, ERoute.application.name,
                          arguments: {
                            "isnew": true,
                            // "prevModel": jobDetailsModel,
                            "refer": false
                          });
                    }),
                childWhenDragging: Container(),
                onDragEnd: (details) {
                  setState(() {
                    position = details.offset;
                  });
                  print(position);
                  print(position.dx);
                  print(position.dy);
                }),
          ) */
        ],
      ),
    );
  }

  Widget customTab(String title, String img, int select) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 9.5.h, horizontal: 10.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.r),
            border: Border.all(color: Constants.borderColor, width: 1)),
        child: cutTab == select
            ? Row(
                children: [
                  Text(title),
                  SizedBox(
                    width: 5.w,
                  ),
                  Image.asset(
                    img,
                    height: 12.h,
                    //width: 15.w,
                  )
                ],
              )
            : Row(
                children: [
                  Text(title),
                  Icon(
                    Icons.add,
                    size: 15.h,
                  )
                ],
              ));
  }

  Container customContainer(BuildContext context, String title,
      String cmpnyName, String loctn, String slry) {
    return Container(
      padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 5.h, top: 5.h),
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      width: double.infinity,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(0, 0),
            blurRadius: 5)
      ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_2_outlined,
                        size: 17.h,
                        color: Colors.greenAccent[400],
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text("Qualification"),
                      SizedBox(
                        width: 2,
                      ),
                      Text("|"),
                      SizedBox(
                        width: 2,
                      ),
                      Text("Experience"),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    "assets/images/cv.png",
                    height: 20.h,
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              Column(
                children: [
                  const Icon(
                    Icons.business_outlined,
                    size: 17,
                    color: Color.fromARGB(255, 118, 118, 118),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Image.asset(
                    "assets/images/proces.png",
                    height: 15.h,
                    color: Colors.black,
                  ),
                ],
              ),
              SizedBox(
                width: 5.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Company name",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        // color: Colors.black54,
                        fontWeight: FontWeight.normal,
                        fontSize: 13.sp),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text("Designation"),
                      SizedBox(
                        width: 2,
                      ),
                      Text("|"),
                      SizedBox(
                        width: 2,
                      ),
                      Text("Healthcare"),
                      SizedBox(
                        width: 2,
                      ),
                      Text("|"),
                      SizedBox(
                        width: 2,
                      ),
                      Text("Blended")
                    ],
                  ),
                ],
              )
            ],
          ),
          /* Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          Text(
            cmpnyName,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Icon(Icons.pin_drop_outlined),
              const SizedBox(
                width: 5,
              ),
              Text(loctn)
            ],
          ),
          Row(
            children: [
              const Icon(Icons.currency_rupee_outlined),
              const SizedBox(
                width: 5,
              ),
              Text(slry)
            ],
          ),
          const SizedBox(
            height: 20,
          ), */
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey.shade200),
            width: double.infinity,
            child: Row(
              children: [
                Image.asset(
                  "assets/images/alert.png",
                  height: 20,
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Application sent succesfully",
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "To improve chances, try similar jobs",
                      style: TextStyle(fontSize: 12.sp),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black)),
                child: Row(
                  children: const [
                    Icon(
                      Icons.phone_android,
                      size: 14,
                      color: Constants.themeBgColor,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      "Call HR",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black)),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/whatsapp.png",
                      height: 14.h,
                      color: Colors.greenAccent[400],
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    const Text(
                      "Chat with HR",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              /* Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Constants.themeBgColor),
                    borderRadius: BorderRadius.circular(15)),
                child: const Text(
                  "Similar Jobs",
                  style: TextStyle(
                      color: Constants.themeBgColor,
                      fontWeight: FontWeight.bold),
                ),
              ), */
            ],
          )
        ],
      ),
    );
  }

  Container customRefer() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            offset: const Offset(0, 0),
            blurRadius: 2,
            color: Colors.grey.shade200)
      ]),
      child: Theme(
        data: ThemeData(
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: Colors.black)),
        child: ExpansionTile(
          leading: CircleAvatar(
              radius: 25.r,
              backgroundImage: const NetworkImage(
                "https://cdn.stocksnap.io/img-thumbs/280h/oldman-portrait_TTOM5R7SFF.jpg",
              )),
          title: const Text("User Name"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.h,
              ),
              const Text("8546558845"),
              const Text("Graduate")
            ],
          ),
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: 15.w, right: 15.w, bottom: 5.h, top: 5.h),
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              width: double.infinity,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    offset: const Offset(0, 0),
                    blurRadius: 5)
              ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Executive",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp),
                      ),
                      const Text("Team Leader")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/proces.png",
                        height: 15.h,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text("Healthcare"),
                      const SizedBox(
                        width: 2,
                      ),
                      const Text("|"),
                      const SizedBox(
                        width: 2,
                      ),
                      const Text("Blended")
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          const Icon(
                            Icons.business_outlined,
                            size: 17,
                            color: Color.fromARGB(255, 118, 118, 118),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Icon(
                            Icons.currency_rupee,
                            size: 15.h,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          const Icon(
                            Icons.location_pin,
                            size: 17,
                            color: Color.fromARGB(255, 118, 118, 118),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Company name",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                // color: Colors.black54,
                                fontWeight: FontWeight.normal,
                                fontSize: 13.sp),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            "18000",
                            style: TextStyle(
                                // color: Colors.black54,
                                fontWeight: FontWeight.normal,
                                fontSize: 13.sp),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            "Location",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
 */