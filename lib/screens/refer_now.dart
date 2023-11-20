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
import 'package:job_circle/screens/jobs/pdf.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

List<String> getStatuses(List<Applicant> applicants) {
  return applicants.map((e) => e.status.toString()).toSet().toList()..sort();
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
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/leads/v1/getReferralJobsByUser?userId=$userid&pageNumber=1&pageSize=1000000');
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

  final RefreshController _refreshController =
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
      var fetchApplicants =
          profilemodel.id != null ? ref.watch(fetchAllReferalProvider) : null;
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
                          child: NestedScrollView(
                            headerSliverBuilder: (BuildContext context,
                                bool innerBoxIsScrolled) {
                              return <Widget>[];
                            },
                            body: TabBarView(
                              children: statuses.asMap().entries.map((entry) {
                                final index = entry.key;
                                final status = entry.value;
                                final applicants = data
                                    .where((applicant) =>
                                        applicant.status.toString() == status)
                                    .toList();

                                // Create widgets based on the applicants list

                                // Return the list of widgets for this status
                                return ListView.builder(
                                  shrinkWrap: true,
                                  // physics: const BouncingScrollPhysics(),
                                  itemCount: applicants.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return listViewItem_new(
                                        context, applicants[index], true);
                                  },
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
              : const SizedBox());
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
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
              decoration: BoxDecoration(
                  color: Constants.borderColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.r),
                      topRight: Radius.circular(8.r)),
                  border: Border.all(color: Constants.maintheme_light_color)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person_2_outlined,
                              size: 17.h, color: Constants.themeBgColor),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            item.applicantName.toString(),
                            // maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.sp),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(item.qualification.toString()),
                          const SizedBox(
                            width: 2,
                          ),
                          const Text("|"),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(item.isExperienced.toString()),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFViewerScreen(
                                pdfAssetPath: item.resume.toString(),
                                isref: true,
                                phoneNumber1: item.spocContactNo!.toInt(),
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
                          height: 20.h,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
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
                              fontWeight: FontWeight.bold, fontSize: 14.sp),
                        ),
                      if (item.lead_level != null)
                        Text(
                          " || ",
                          style: GoogleFonts.varela(
                              fontWeight: FontWeight.bold, fontSize: 14.sp),
                        ),
                      if (item.lead_level != null)
                        Text(
                          item.lead_level == ""
                              ? "Role Name**"
                              : item.lead_level.toString(),
                          // overflow: TextOverflow.visible,
                          style: GoogleFonts.varela(
                              fontWeight: FontWeight.bold, fontSize: 14.sp),
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
                                      item.status_code == "TP1"
                                          ? "Application sent"
                                          : item.status_code == "IB7"
                                              ? "You are selected for this job"
                                              : item.status_code == "IB6"
                                                  ? "Rejected"
                                                  : item.status_code == "IB5"
                                                      ? "CV is in process"
                                                      : item.status_code ==
                                                              "TP2"
                                                          ? "Assign"
                                                          : item.status_code ==
                                                                  "IB4"
                                                              ? "CV is shortlisted"
                                                              : item.status_code ==
                                                                      "TP3"
                                                                  ? "Screening Rejected"
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
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp),
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
          ],
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