// ignore_for_file: must_be_immutable, unused_local_variable, unused_result, unnecessary_null_comparison, non_constant_identifier_names, avoid_print, use_build_context_synchronously, avoid_unnecessary_containers, deprecated_member_use, unused_element
// ignore_for_file: todo
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/constants/custom_network_image.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/job_details_model.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/screens/JobDetails/description.dart';
import 'package:job_circle/screens/faq/interview_bay_faq.dart';
import 'package:job_circle/service/JobSearchService.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/utils.dart';

/* final favJobProvider = FutureProvider.family<FavJobModel?, int>(
    (ref, id) => JobSearchService().getFavoriteJob(id)); */

class JobDetailsForCandidate extends ConsumerStatefulWidget {
  int? id;
  bool Applies;
  bool referal;
  int is_freelancer;
  int? userType;
  String? userrole;
  int userid;
  int hint;

  JobDetailsForCandidate(
      {super.key,
      this.id,
      required this.Applies,
      required this.referal,
      required this.is_freelancer,
      required this.userid,
      required this.hint,
      this.userType,
      this.userrole});

  @override
  ConsumerState<JobDetailsForCandidate> createState() =>
      _JobDetailsForCandidateState();
}

class _JobDetailsForCandidateState extends ConsumerState<JobDetailsForCandidate>
    with SingleTickerProviderStateMixin {
  bool descTextShowFlag = false;
  final ScrollController _scrollController = ScrollController();
  final Color appBgColor = Constants.themeBgColor;
  final Color appBgScrolledColor = Constants.bgPanelColor;
  late Color currentAppBarColor = appBgColor;
  late double appBarElevate = 0;
  late Color appBarIconColor = Colors.white;
  var usertype = 0;

  JobDetailsModel jobDetailsModel = JobDetailsModel();
  var titleText = "";
  var subtitleText = "";
  var partner_request = 1;
  NumberFormat format = NumberFormat.compact();
  // List jobs = [];

  String extractText(String input) {
    RegExp regex = RegExp(r'[a-zA-Z\s]+');
    Iterable<Match> matches = regex.allMatches(input);
    List<String?> textList = matches.map((match) => match.group(0)).toList();
    String text = textList.join('');
    return text.trim();
  }

/*   Future<void> fetchJobs() async {
    Uri url = Uri.parse('http://${GlobalConstants.API_Host_one}/favjob/v1');
    final response = await http.get(url, headers: {
      "Content-Type": "application/json"
    }); // replace with your API endpoint
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      var list = data as List;
      setState(() {
        jobs.addAll(list);
        // print(jobs);
      });
    } else {
      print("No fav job found!");
      // handle error
    }
  } */

  String formatSalaryRange(int minSalary, int maxSalary) {
    String formattedMinSalary = '';
    String formattedMaxSalary = '';

    if (minSalary >= 100000) {
      formattedMinSalary = (minSalary / 100000).toStringAsFixed(2);
    } else if (minSalary >= 1000) {
      formattedMinSalary =
          '${(minSalary / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0*$'), '')}k';
    } else {
      formattedMinSalary = minSalary
          .toStringAsFixed(2)
          .replaceAll(RegExp(r'(?<=\.\d*?)0*$'), '');
    }

    if (maxSalary >= 100000) {
      formattedMaxSalary = (maxSalary / 100000).toStringAsFixed(2);
    } else if (maxSalary >= 1000) {
      formattedMaxSalary =
          '${(maxSalary / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0*$'), '')}k';
    } else {
      formattedMaxSalary = maxSalary
          .toStringAsFixed(2)
          .replaceAll(RegExp(r'(?<=\.\d*?)0*$'), '');
    }

    // Remove ".00" if present
    formattedMinSalary = formattedMinSalary.replaceAll(RegExp(r'\.00$'), '');
    formattedMaxSalary = formattedMaxSalary.replaceAll(RegExp(r'\.00$'), '');

    return maxSalary == 0
        ? formattedMinSalary
        : '$formattedMinSalary - $formattedMaxSalary';
  }

  late ProfileSummaryModel profilemodel = ProfileSummaryModel();

  bindProfileSummary() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var id =
        await Utils.getPreferencesValue(prefs, ESharedPreferences.user_id.name);
    int? userid = int.tryParse(id);
    var result = await UserDataService().getUserProfileSummary(userid!);

    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      var dataResult = Utils.parseResponse(result).resultData;
      profilemodel = ProfileSummaryModel.fromJson(dataResult);
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    bindProfileSummary();
    fillCacheData();
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.hint == 1 ? 1 : 0);
    // benefit();
    //   const RestrictedButton();
    // fetchJobs();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      usertype = await Utils.getPreferencesValue(
          null, ESharedPreferences.user_type.name);
      dynamic args = ModalRoute.of(context)!.settings.arguments;
      if (widget.id != null) {
        getJobDetails(widget.id);
      }
    });
    // Future.delayed(const Duration(milliseconds: 10), () {
    //   // dynamic args = ModalRoute.of(context)!.settings.arguments;

    // });
    // Calling For Job Details
    // getJobDetails(arguments["id"]);

    _scrollController.addListener(() {
      if (_scrollController.position.extentBefore > 0 && appBarElevate == 0) {
        appBarElevate = 3;
        setState(() {});
      } else if (_scrollController.position.extentBefore == 0 &&
          appBarElevate > 0) {
        appBarElevate = 0;
        setState(() {});
      }

      ///
      if (_scrollController.position.extentBefore > 180 &&
          currentAppBarColor == appBgColor) {
        currentAppBarColor = appBgScrolledColor;
        appBarIconColor = Colors.black;
        titleText = jobDetailsModel.name.toString();
        subtitleText =
            "${jobDetailsModel.rolename} | ${jobDetailsModel.process}";

        setState(() {});
      } else if (_scrollController.position.extentBefore <= 180 &&
          currentAppBarColor == appBgScrolledColor) {
        setState(() {
          currentAppBarColor = appBgColor;
          appBarIconColor = Colors.white;
          titleText = "";
          subtitleText = "";
        });
      }
    });
  }

  fillCacheData() async {
    partner_request = await Utils.getCacheData('partner_request');
    setState(() {});
  }

  getJobDetails(id) async {
    try {
      var result =
          await JobSearchService().getJobDetails({'id': id.toString()});
      if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
        setState(() {
          jobDetailsModel =
              JobDetailsModel.fromMap(Utils.parseResponse(result).resultData);
        });
      }
    } catch (error) {
      // Handle the error appropriately
      print('Error occurred during job details retrieval: $error');
      // Perform any necessary error handling logic, such as showing an error message to the user
    }
  }

  bool isLoading = true;
  final PageController pageController = PageController();
  int selectedIndex = 0;

  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key("first"),
      appBar: AppBar(
        titleTextStyle: GoogleFonts.varela(color: Constants.themeBgColor),
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // jobDetailsModel.name
              jobDetailsModel.rolename != null
                  ? jobDetailsModel.rolename.toString()
                  : "",
              textAlign: TextAlign.center,
              style: GoogleFonts.varela(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16.h,
              ),
            ),
            Row(
              children: [
                Text(
                  jobDetailsModel.process != null &&
                          jobDetailsModel.process != ""
                      ? jobDetailsModel.process.toString()
                      : "",
                  style: GoogleFonts.varela(
                    color: Colors.black,
                    //fontWeight: FontWeight.bold,
                    fontSize: 12.h,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  jobDetailsModel.naturofwork != "" &&
                          jobDetailsModel.naturofwork != null
                      ? " ||"
                      : "",
                  style: GoogleFonts.varela(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                    fontSize: 12.h,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  jobDetailsModel.naturofwork != null &&
                          jobDetailsModel.naturofwork != ""
                      ? jobDetailsModel.naturofwork.toString()
                      : "",
                  style: GoogleFonts.varela(
                    color: Colors.black,
                    //  fontWeight: FontWeight.bold,
                    fontSize: 12.h,
                  ),
                )
              ],
            )
          ],
        ),
        actions: [
          jobDetailsModel.icon != ""
              ? Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: CustomImage(
                    imageUrl:
                        "https://s3.ap-south-1.amazonaws.com/job-circle-2/${jobDetailsModel.icon}",
                    defaultImageUrl: "assets/images/logo.png",
                    height: 80,
                  ))
              : const SizedBox()
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Constants.bgColorWhite,
      body: jobDetailsModel.id == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.w, right: 15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /* if (jobDetailsModel.name.toString().isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // item['process'] != null)
                            Image.asset(
                              "assets/images/cmpny.png",
                              height: 12.5.h,
                            ),

                            SizedBox(
                              width: 6.w,
                            ),
                            Text(
                              jobDetailsModel.name.toString(),
                              // maxLines: 2,
                              // overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.varela(
                                  color: Colors.grey.shade700,
                                  //color: Colors.black54,
                                  fontSize: 13.sp),
                            )
                          ],
                        ), */
                      jobDetailsModel.isfresher == "Fresher"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/bag.png",
                                  height: 12.5.h,
                                ),
                                SizedBox(
                                  width: 7.w,
                                ),
                                SizedBox(
                                  child: Text(
                                    "Fresher can apply",
                                    style: GoogleFonts.varela(
                                        color: Colors.grey.shade700,
                                        // color: Colors.black54,
                                        //fontWeight: FontWeight.normal,
                                        fontSize: 13.sp),
                                  ),
                                ),
                              ],
                            )
                          : jobDetailsModel.minexperience == null
                              ? jobDetailsModel.maxexperience == null
                                  ? const SizedBox()
                                  : const SizedBox()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/bag.png",
                                      height: 12.5.h,
                                      //  color: Constants.subtitleclr,
                                    ),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    jobDetailsModel.maxexperience == "& above"
                                        ? jobDetailsModel.minexperience == 0.6
                                            ? Text(
                                                // "${item["minexperience"].replaceAll(".0", "")} Years & above.",
                                                "6 Month & Above.",
                                                style: GoogleFonts.varela(
                                                    // color: Colors.black54,
                                                    color: Colors.grey.shade700,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 13.sp),
                                              )
                                            : Text(
                                                "${jobDetailsModel.minexperience.toString().replaceAll(".0", "")} Years & above.",
                                                style: GoogleFonts.varela(
                                                    // color: Colors.black54,
                                                    color: Colors.grey.shade700,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 13.sp),
                                              )
                                        : Text(
                                            "${jobDetailsModel.minexperience.toString().replaceAll(".0", "")} - ${jobDetailsModel.maxexperience.toString().replaceAll(".0", "")} Years",
                                            style: GoogleFonts.varela(
                                                // color: Colors.black54,
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 13.sp),
                                          )
                                  ],
                                ),

                      if (jobDetailsModel.minctc != null &&
                          jobDetailsModel.maxctc != null)
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/wallet.png",
                              height: 12.5.h,
                            ),
                            SizedBox(
                              width: 5.5.w,
                            ),
                            Text(
                              "${formatSalaryRange(jobDetailsModel.minctc!.toInt(), jobDetailsModel.maxctc!.toInt())} ${jobDetailsModel.ismonthly ?? ""}",
                              style: GoogleFonts.varela(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13.sp),
                            )
                          ],
                        ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/loc.png",
                            height: 12.5.h,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          jobDetailsModel.location == "WFH"
                              ? Text(
                                  "Work from home",
                                  // maxLines: 2,
                                  // overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.varela(
                                      color: Colors.grey.shade700,
                                      //color: Colors.black54,
                                      fontSize: 13.sp),
                                )
                              : Expanded(
                                  child: Text(
                                    jobDetailsModel.location.toString(),
                                    // maxLines: 2,
                                    // overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.varela(
                                        color: Colors.grey.shade700,
                                        //color: Colors.black54,
                                        fontSize: 13.sp),
                                  ),
                                )
                        ],
                      ),

                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2, right: 5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Constants.borderColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/verified.png",
                                  height: 15.h,
                                  color: Colors.black45,
                                ),
                                Text(
                                  "Verified",
                                  style:
                                      GoogleFonts.varela(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 2, right: 5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Constants.borderColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${jobDetailsModel.no_of_vacancy.toString()} Vacancies",
                              style: GoogleFonts.varela(color: Colors.black54),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Constants.borderColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/shifttimes.png",
                                  height: 15.h,
                                  color: Colors.black45,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  jobDetailsModel.emptype.toString(),
                                  style:
                                      GoogleFonts.varela(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      //TODO:: TabBar for cc
                    ],
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      indicatorColor: Constants.blue,
                      physics: const AlwaysScrollableScrollPhysics(),
                      labelPadding: const EdgeInsets.only(left: 5, right: 5),
                      labelColor: Colors.black,
                      // isScrollable: true,
                      labelStyle:
                          GoogleFonts.varela(fontWeight: FontWeight.bold),
                      unselectedLabelColor: Colors.black,
                      unselectedLabelStyle:
                          GoogleFonts.varela(fontWeight: FontWeight.normal),
                      indicatorSize: TabBarIndicatorSize.tab,
                      splashBorderRadius: BorderRadius.circular(8),
                      indicatorWeight: 5.h,
                      indicatorPadding:
                          EdgeInsets.only(bottom: 8.h, left: 3.w, right: 3.w),
                      /*  indicator: BoxDecoration(
                            color: Constants.borderColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Constants.borderColor),
                          ), */
                      controller: _tabController,
                      tabs: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/job_desc.png",
                              height: 15.sp,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            const Tab(text: 'Job Description'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/qa.png",
                              height: 15.sp,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            const Tab(text: 'Interview FAQ'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  //  padding: const EdgeInsets.only(left: 20),

                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      DescriptionForCC(
                        user_type: usertype,
                        id: widget.id,
                        Applies: widget.Applies,
                        referal: widget.referal,
                        jobDetailsModel: jobDetailsModel,
                      ),
                      InterviewFaqPage(
                        crpfid: jobDetailsModel.crpf_id!.toInt(),
                        userid: widget.userid,
                        userType: widget.userType!.toInt(),
                        userRole: widget.userrole.toString(),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
