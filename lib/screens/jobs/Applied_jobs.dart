// ignore_for_file: unused_field, unused_result, unused_local_variable, file_names, avoid_print, avoid_unnecessary_containers, non_constant_identifier_names
// ignore_for_file: todo
import 'dart:convert';

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
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelines/timelines.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/utils.dart';
import '../../models/profileSummary.dart';
import '../../service/UserDataService.dart';
import '../../themes/colors.dart';

final fetchAllApplyProvider = FutureProvider<List<Applicant>>((ref) {
  Future.delayed(const Duration(milliseconds: 10));
  return _AppliedJobState.fetchApplicantsByUserId();
});
//enum Issue { no, incorrect, recruiter, other }

class AppliedJob extends ConsumerStatefulWidget {
  const AppliedJob({
    super.key,
  });

  @override
  ConsumerState<AppliedJob> createState() => _AppliedJobState();
}

List<String?> getStatuses(List<Applicant> applicants) {
  return applicants
      .map((e) =>
          e.apply_status != null ? e.apply_status.toString() : e.s2ApplyStatus)
      .toSet()
      .toList()
    ..sort();
}

class _AppliedJobState extends ConsumerState<AppliedJob>
    with SingleTickerProviderStateMixin {
  JobDetailsModel jobDetailsModel = JobDetailsModel();
  ProfileSummaryModel profilemodel = ProfileSummaryModel();
  Future<List<Applicant>>? _applicantsFuture;
  @override
  void initState() {
    super.initState();
    bindProfileSummary();
    //  _applicantsFuture = fetchApplicantsByUserId(552);
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final List<RefreshController> _refreshControllers = List.generate(
    10,
    (index) => RefreshController(initialRefresh: false),
  );

  Future<void> _onRefresh(int index) async {
    // Perform a global refresh (e.g., fetch new data for all tabs)
    await Future.delayed(const Duration(seconds: 2));

    ref.refresh(fetchAllApplyProvider);
    // Update the UI with new data

    _refreshControllers[index]
        .refreshCompleted(); // Call this to end the refresh animation
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

  static Future<List<Applicant>> fetchApplicantsByUserId() async {
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    var number = await Utils.getPreferencesValue(
        null, ESharedPreferences.user_mobile.name);
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/leads/v1/getAllAppliedJobByUserId?userId=$userid&mobile=$number&page=1&size=1000'

        // 'http://${GlobalConstants.API_Host_one}/leads/v1/getAllAppliedJobByUserId?userId=$userid&page=1&size=100'
        );
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

  /* String convertSalaryFormat(String input) {
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

  /* String  convertSalaryFormat(String input) {
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var fetchApplicants =
        profilemodel.id != null ? ref.watch(fetchAllApplyProvider) : null;
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
                      appBar: PreferredSize(
                        preferredSize:
                            const Size(double.maxFinite, kTextTabBarHeight),
                        child: AppBar(
                          backgroundColor: Colors.white,
                          bottom: TabBar(
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
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      body: TabBarView(
                        children: statuses.asMap().entries.map((entry) {
                          final index = entry.key;
                          final status = entry.value;
                          final applicants = data
                              .where((applicant) => applicant.apply_status !=
                                      null
                                  ? applicant.apply_status.toString() == status
                                  : applicant.s2ApplyStatus.toString() ==
                                      status)
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
                              physics: const BouncingScrollPhysics(),
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

                      /* body: SmartRefresher( //TODO: old code without scrolling.
                        enablePullDown: true,
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        child: NestedScrollView(
                            headerSliverBuilder: (BuildContext context,
                                bool innerBoxIsScrolled) {
                              return <Widget>[];
                            },
                            body: TabBarView(
                              children: statuses.map((e) {
                                final filteredData = data
                                    .where((applicant) =>
                                        applicant.status.toString() == e)
                                    .toList();

                                return CustomScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  slivers: [
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                          return listViewItem_new(context,
                                              filteredData[index], true);
                                        },
                                        childCount: filteredData.length,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            )),
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
                          Image.asset("assets/images/nojobs.gif"),
                          Text(
                            "You haven't applied yet!",
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
                                  "Search for jobs and start applying. You can track your applications here!",
                                  style: GoogleFonts.varela(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
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
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  );
                }
              }, error: (error, stackTrace) {
                return const Center(
                  child: Text(
                      "Oops! Something went wrong on our end. Our team is working to fix the issue. Please be patient and bear with us as we resolve this. Thank you for your understanding."),
                );
              }, loading: () {
                return const Center(child: CircularProgressIndicator());
              })
            : const Center(child: SizedBox()));
  }

  Widget listViewItem_new(BuildContext context, Applicant item, bool isTrue) {
    // List<String>? myStrings;
    //  bool stopIteration = false;

    //  List<String> finalinterviewRounds = json.decode(jsonString).cast<String>();

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
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return JobDetails(
              id: item.jobId,
              Applies: true,
              referal: false,
              is_freelancer: 3,
            );
          },
        ));
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
        /*   shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
          //set border radius more than 50% of height and width to make circle
        ),
        // shadowColor: Constants.themeBgColor,
        elevation: 4, */

        margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start, // Ad
                children: [
                  Row(
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (item.lead_level != null)
                              Text(
                                item.lead_level.toString(),
                                style: GoogleFonts.varela(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp),
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
                                        color: Constants.subtitleclr,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13.sp),
                                  ),
                                if (item.natureOfWork != null)
                                  Text(
                                    " || ",
                                    style: GoogleFonts.varela(
                                        // color: Colors.black54,
                                        color: Constants.subtitleclr,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13.sp),
                                  ),
                                if (item.natureOfWork != null)
                                  Text(
                                    item.natureOfWork == ""
                                        ? "Role Name**"
                                        : item.natureOfWork.toString(),
                                    // overflow: TextOverflow.visible,
                                    style: GoogleFonts.varela(
                                        // color: Colors.black54,
                                        color: Constants.subtitleclr,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13.sp),
                                  ),
                              ],
                            ),
                          ]),
                      const Spacer(),
                      const Column(
                        children: [],
                      ),
                    ],
                  ),
                  if (item.totalSalary != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h, left: 4.w),
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
                              style: GoogleFonts.varela(
                                  // color: Colors.black54,
                                  color: Constants.subtitleclr,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13.sp),
                            ),
                          ),
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
                        //scrollDirection: Axis.horizontal,
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
                          top: 6, bottom: 6, right: 6, left: 6),
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
                              (item.apply_icon != null &&
                                          item.apply_icon != "null") ||
                                      item.s2ApplyIcon != null
                                  ? CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: CustomImage(
                                          imageUrl:
                                              "https://s3.ap-south-1.amazonaws.com/job-circle-2/${item.apply_icon ?? item.s2ApplyIcon}",
                                          height: 24.h,
                                          defaultImageUrl:
                                              "assets/images/error.png")
                                      /*  Image.network(
                                        "https://s3.ap-south-1.amazonaws.com/job-circle-2/${item.apply_icon ?? item.s2ApplyIcon}",
                                        fit: BoxFit.fill,
                                        height: 24.h,
                                      ), */
                                      )
                                  : const SizedBox()
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  item.is_ref == 1
                                      ? Row(
                                          children: [
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "Application referred for interview.",
                                                style: GoogleFonts.varela(
                                                    color: Constants.blue,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14.sp),
                                                softWrap: true,
                                              ),
                                            )
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            item.apply_feedback1 != null ||
                                                    item.s2ApplyFeedback2 !=
                                                        null ||
                                                    item.apply_feedback1 != ""
                                                ? FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      item.apply_feedback1 !=
                                                              null
                                                          ? item.apply_feedback1
                                                              .toString()
                                                          : item
                                                              .s2ApplyFeedback1
                                                              .toString(),
                                                      style: GoogleFonts.varela(
                                                          color: Constants.blue,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14.sp),
                                                      softWrap: true,
                                                    ),
                                                  )
                                                : Text(
                                                    "Status Not Found",
                                                    style: GoogleFonts.varela(
                                                        color: Constants.blue,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14.sp),
                                                    softWrap: true,
                                                  ),
                                          ],
                                        ),
                                  if (item.apply_feedback2 != null ||
                                      item.s2ApplyFeedback2 != null)
                                    Text(
                                      item.apply_feedback2 != null
                                          ? item.apply_feedback2.toString()
                                          : item.s2ApplyFeedback2 != null
                                              ? item.s2ApplyFeedback2.toString()
                                              : "",
                                      softWrap: true,
                                      // maxLines: 2,
                                      style: GoogleFonts.varela(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp),
                                    ),
                                  /* if (item.apply_feedback2 == null ||
                                    item.s2ApplyFeedback2 == null)
                                  Text(
                                    "We apologize for any inconvenience caused; please be advised that your status could not be retrieved due to a technical fault. Kindly wait as we work to resolve the issue. We appreciate your understanding and patience in this matter.",
                                    softWrap: true,
                                    maxLines: 2,
                                    style: GoogleFonts.varela(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp),
                                  ), */
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
                                  "View More Jobs",
                                  style: GoogleFonts.varela(
                                      color: Constants.themeBgColor,
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
                                "whatsapp://send?phone=91${item.spocContactNo}");
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
                                "+91${item.spocContactNo}");
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
              item.company_icon != null
                  ? Positioned(
                      top: 0,
                      right: 0,
                      child: SizedBox(
                          height: 30.h,
                          width: 60.w,
                          child: CustomImage(
                            imageUrl:
                                "https://s3.ap-south-1.amazonaws.com/job-circle-2/${item.company_icon}",
                            defaultImageUrl: "assets/images/logo.png",
                          )),
                    )
                  : SizedBox(
                      height: 60.h,
                      width: 60.w,
                      child: Image.asset(
                        "assets/Images/logo.png",
                        fit: BoxFit.contain,
                      ))
            ],
          ),
        ),
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
            Text(
              title,
              style: GoogleFonts.varela(),
            ),
            SizedBox(
              width: 5.w,
            ),
          ],
        ));
  }
}
