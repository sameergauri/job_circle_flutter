import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/models/job_details_model.dart';
import 'package:job_circle/screens/home.dart';
import 'package:job_circle/screens/jobs/curve_painter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/utils.dart';
import '../../models/profileSummary.dart';
import '../../service/UserDataService.dart';
import '../../themes/colors.dart';

final fetchAllApplyProvider =
    FutureProvider.family<List<Applicant>, int>((ref, id) {
  Future.delayed(const Duration(seconds: 2));
  return _AppliedJobState.fetchApplicantsByUserId(id);
});
//enum Issue { no, incorrect, recruiter, other }

class AppliedJob extends ConsumerStatefulWidget {
  const AppliedJob({
    super.key,
  });

  @override
  ConsumerState<AppliedJob> createState() => _AppliedJobState();
}

List<String> getStatuses(List<Applicant> applicants) {
  return applicants.map((e) => e.status.toString()).toSet().toList()..sort();
}

class _AppliedJobState extends ConsumerState<AppliedJob>
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

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> _onRefresh() async {
    // Perform a global refresh (e.g., fetch new data for all tabs)
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      ref.refresh(fetchAllApplyProvider(profilemodel.id!.toInt()));
      // Update the UI with new data
    });
    _refreshController
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

  static Future<List<Applicant>> fetchApplicantsByUserId(int userId) async {
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/leads/v1/getAllAppliedJobByUserId?userId=$userId');
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (profilemodel == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      var fetchApplicants = profilemodel.id != null
          ? ref.watch(fetchAllApplyProvider(profilemodel.id!.toInt()))
          : null;
      // Build your widget's UI with the 'profilemodel' data
      // For example:
      return PageStorage(
          bucket: PageStorageBucket(),
          key: const PageStorageKey<String>("futureKey"),
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
                                      color: Constants
                                          .borderColor) // Creates border
                                  ),
                              tabs: statuses
                                  .map(
                                    (e) => Tab(
                                      child: customTab(
                                        e,
                                      ),
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
                          child: ListView.builder(
                            itemCount: statuses.length,
                            itemBuilder: (BuildContext context, int index) {
                              final filteredData = data
                                  .where((applicant) =>
                                      applicant.status.toString() ==
                                      statuses[index])
                                  .toList();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Add a header or any other UI element if needed
                                  // Text(statuses[index]),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: filteredData.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return listViewItem_new(
                                          context, filteredData[index], true);
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
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
                    return const Center(
                      child: Text("No data to display"),
                    );
                  }
                }, error: (error, stackTrace) {
                  return const Center(
                    child: Text("Error while fetching the data"),
                  );
                }, loading: () {
                  return const Center(child: CircularProgressIndicator());
                })
              : const Center(child: SizedBox()));
    }
  }

  Widget listViewItem_new(BuildContext context, Applicant item, bool isTrue) {
    // List<String>? myStrings;
    //  bool stopIteration = false;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          ERoute.jobsdetail.name,
          arguments: {
            'id': item.jobId,
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
        child: Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start, // Ad
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.process != null)
                    Text(
                      item.process.toString(),
                      style: GoogleFonts.varela(
                          fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ),
                  if (item.leadLevel != null)
                    Text(
                      " - ",
                      style: GoogleFonts.varela(
                          fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ),
                  if (item.leadLevel != null)
                    Text(
                      item.leadLevel == ""
                          ? "Role Name**"
                          : item.leadLevel.toString(),
                      // overflow: TextOverflow.visible,
                      style: GoogleFonts.varela(
                          fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ),
                  const Spacer(),
                  Icon(
                    Icons.more_horiz,
                    size: 17.h,
                  ),
                ],
              ),
              if (item.companyName != null)
                Text(
                  item.companyName.toString(),
                  style: GoogleFonts.varela(
                      // color: Colors.black54,
                      color: Constants.subtitleclr,
                      fontWeight: FontWeight.normal,
                      fontSize: 13.sp),
                ),
              if (item.totalSalary != null)
                Padding(
                  padding: EdgeInsets.only(top: 4.h, left: 4.w),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/wallet.png",
                        height: 14.h,
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
                  padding: EdgeInsets.only(left: 4.w),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/loc.png",
                        height: 14.sp,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        item.workLocation.toString(),
                        style: GoogleFonts.varela(
                            // color: Colors.black54,
                            color: Constants.subtitleclr,
                            fontWeight: FontWeight.normal,
                            fontSize: 13.sp),
                      ),
                    ],
                  ),
                ),
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
                      children: const [
                        Icon(
                          Icons.add_alert,
                          color: Colors.amber,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  item.status == "Application"
                                      ? "Application sent"
                                      : item.status == "Select"
                                          ? "You are selected for thi job"
                                          : item.status == "Reject"
                                              ? "Rejected"
                                              : item.status ==
                                                      "Interview Schedule"
                                                  ? "Interview Schedule"
                                                  : item.status == "Assign"
                                                      ? "Assign"
                                                      : "",
                                  style: GoogleFonts.varela(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          if (item.remark != null)
                            Text(
                              item.remark.toString(),
                              style: GoogleFonts.varela(
                                  fontWeight: FontWeight.w500, fontSize: 14.sp),
                            )
                        ],
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
            Text(title),
            SizedBox(
              width: 5.w,
            ),
          ],
        ));
  }
}
