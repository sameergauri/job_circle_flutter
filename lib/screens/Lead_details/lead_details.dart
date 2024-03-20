// ignore_for_file: must_be_immutable, unused_local_variable, unused_result, unnecessary_null_comparison, non_constant_identifier_names, avoid_print, use_build_context_synchronously, avoid_unnecessary_containers, deprecated_member_use, unused_element
// ignore_for_file: todo
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/constants/custom_network_image.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/models/job_details_model.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/screens/JobDetails/description.dart';
import 'package:job_circle/screens/Lead_details/history.dart';
import 'package:job_circle/screens/Lead_details/pdf_view_for_lead_detail.dart';
import 'package:job_circle/screens/faq/interview_bay_faq.dart';
import 'package:job_circle/screens/jobs/matching_jobs.dart';
import 'package:job_circle/service/JobSearchService.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/utils.dart';

/* final favJobProvider = FutureProvider.family<FavJobModel?, int>(
    (ref, id) => JobSearchService().getFavoriteJob(id)); */

class LeadDetailPage extends ConsumerStatefulWidget {
  int? id;
  Applicant item;
  int? userType;
  String? userrole;
  int userid;

  LeadDetailPage(
      {super.key,
      this.id,
      required this.userid,
      this.userType,
      this.userrole,
      required this.item});

  @override
  ConsumerState<LeadDetailPage> createState() => _LeadDetailPageState();
}

class _LeadDetailPageState extends ConsumerState<LeadDetailPage>
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
  List jobs = [];

  String extractText(String input) {
    RegExp regex = RegExp(r'[a-zA-Z\s]+');
    Iterable<Match> matches = regex.allMatches(input);
    List<String?> textList = matches.map((match) => match.group(0)).toList();
    String text = textList.join('');
    return text.trim();
  }

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
    var result = await UserDataService().getUserProfileSummary(
        await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_id.name));
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
    _tabController = TabController(length: 5, vsync: this);
    // benefit();
    //   const RestrictedButton();

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

  @override
  void dispose() {
    isLoading = false;

    super.dispose();
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

  bool isLoading = false;
  final PageController pageController = PageController();
  int selectedIndex = 0;

  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          /*     Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                  showDialog(
                    context: context,
                    builder: (context) {
                      return DialogueToGenerateLeadFromLeadDetails(
                          title: "Add New Lead",
                          cancel: () {
                            setState(() {
                              isLoading = false;
                            });
                          },
                          isLineUp: false,
                          refreshCallback: () {
                            ref.refresh(fetchAllTalentPoolProvider);
                            ref.refresh(fetchAllApplicantProvider);
                            ref.refresh(fetchAllExecutiveProvide);
                            ref.refresh(fetchAllReferalProvider);
                            ref.refresh(fetchAllApplyProvider);
                            ref.refresh(
                                getLeadHistory(widget.item.contactNo!.toInt()));
                            Navigator.pop(context);
                            Future.delayed(const Duration(seconds: 3), () {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          },
                          item: widget.item,
                          statusDdId: 1);
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 10, left: 20, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                      color: Constants.blue,
                      borderRadius: BorderRadius.circular(8.r)),
                  //width: double.maxFinite,
                  padding: const EdgeInsets.only(
                      bottom: 8, top: 8, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Add Lead",
                        style: GoogleFonts.varela(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              /* GestureDetector(
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                  showDialog(
                    context: context,
                    builder: (context) {
                      return DialogueToGenerateLeadFromLeadDetails(
                          title: "Add New Line-up",
                          cancel: () {
                            setState(() {
                              isLoading = false;
                            });
                          },
                          isLineUp: true,
                          refreshCallback: () {
                            ref.refresh(fetchAllTalentPoolProvider);
                            ref.refresh(fetchAllApplicantProvider);
                            ref.refresh(fetchAllExecutiveProvide);
                            ref.refresh(fetchAllReferalProvider);
                            ref.refresh(fetchAllApplyProvider);
                            ref.refresh(
                                getLeadHistory(widget.item.contactNo!.toInt()));
                            Navigator.pop(context);
                            Future.delayed(const Duration(seconds: 3), () {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          },
                          item: widget.item,
                          statusDdId: 1);
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10, right: 20, bottom: 10),
                  decoration: BoxDecoration(
                      color: Constants.blue,
                      borderRadius: BorderRadius.circular(8.r)),
                  //width: double.maxFinite,
                  padding: const EdgeInsets.only(
                      bottom: 8, top: 8, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Add Line-up",
                        style: GoogleFonts.varela(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ), */
            ],
          ), */
          key: const Key("first"),
          appBar: AppBar(
            titleTextStyle: GoogleFonts.varela(color: Constants.themeBgColor),
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Column(children: [
                  //
                  //
                  //
                  //
                  if (widget.item.gender != null)
                    widget.item.profilePic != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://s3.ap-south-1.amazonaws.com/job-circle-2/${widget.item.profilePic}"),
                            radius: 22,
                          )
                        : CircleAvatar(
                            backgroundColor: Constants.bgColorWhite,
                            backgroundImage: AssetImage(
                                widget.item.gender == "Male"
                                    ? "assets/images/leadmale.png"
                                    : "assets/images/leadfemal.png"),
                            radius: 22,
                          ),
                  if (widget.item.gender == null)
                    widget.item.profilePic != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://s3.ap-south-1.amazonaws.com/job-circle-2/${widget.item.profilePic}"),
                            radius: 22,
                          )
                        : CircleAvatar(
                            backgroundColor: Constants.borderColor,
                            radius: 22,
                            child: Text(
                              widget.item.applicantName!.isNotEmpty
                                  ? widget.item.applicantName![0].toUpperCase()
                                  : 'N',
                              style: const TextStyle(
                                color: Constants.themeBgColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                ]
                    //
                    //
                    //
                    //
                    ),
                SizedBox(
                  width: 4.sp,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // jobDetailsModel.name
                      "${widget.item.applicantName != null ? widget.item.applicantName.toString() : ""} ${widget.item.last_name != null ? widget.item.last_name.toString() : ""}",
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
                          jobDetailsModel.process != null
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
                          " ||",
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
                          widget.item.role_code != null &&
                                  widget.item.role_code != ""
                              ? widget.item.role_code.toString()
                              : jobDetailsModel.rolename.toString(),
                          style: GoogleFonts.varela(
                            color: Colors.black,
                            //  fontWeight: FontWeight.bold,
                            fontSize: 12.h,
                          ),
                        )
                      ],
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
          backgroundColor: Constants.bgPanelColor,
          body: jobDetailsModel.id == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15.w, right: 15.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (jobDetailsModel.name.toString().isNotEmpty)
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
                              ),
                            jobDetailsModel.isfresher == "Fresher"
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/bag.png",
                                            height: 12.5.h,
                                            //  color: Constants.subtitleclr,
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          jobDetailsModel.maxexperience ==
                                                  "& above"
                                              ? jobDetailsModel.minexperience ==
                                                      0.6
                                                  ? Text(
                                                      // "${item["minexperience"].replaceAll(".0", "")} Years & above.",
                                                      "6 Month & Above.",
                                                      style: GoogleFonts.varela(
                                                          // color: Colors.black54,
                                                          color: Colors
                                                              .grey.shade700,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 13.sp),
                                                    )
                                                  : Text(
                                                      "${jobDetailsModel.minexperience.toString().replaceAll(".0", "")} Years & above.",
                                                      style: GoogleFonts.varela(
                                                          // color: Colors.black54,
                                                          color: Colors
                                                              .grey.shade700,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 13.sp),
                                                    )
                                              : Text(
                                                  "${jobDetailsModel.minexperience.toString().replaceAll(".0", "")} - ${jobDetailsModel.maxexperience.toString().replaceAll(".0", "")} Years",
                                                  style: GoogleFonts.varela(
                                                      // color: Colors.black54,
                                                      color:
                                                          Colors.grey.shade700,
                                                      fontWeight:
                                                          FontWeight.normal,
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
                                  margin:
                                      const EdgeInsets.only(top: 2, right: 5),
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
                                        style: GoogleFonts.varela(
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 2, right: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Constants.borderColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "${jobDetailsModel.no_of_vacancy.toString()} Vacancies",
                                    style: GoogleFonts.varela(
                                        color: Colors.black54),
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
                                        style: GoogleFonts.varela(
                                            color: Colors.black54),
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
                            labelPadding:
                                const EdgeInsets.only(left: 8, right: 8),
                            labelColor: Colors.black,
                            isScrollable: true,
                            labelStyle:
                                GoogleFonts.varela(fontWeight: FontWeight.bold),
                            unselectedLabelColor: Colors.black,
                            unselectedLabelStyle: GoogleFonts.varela(
                                fontWeight: FontWeight.normal),
                            indicatorSize: TabBarIndicatorSize.tab,
                            splashBorderRadius: BorderRadius.circular(8),
                            indicatorWeight: 5.h,
                            indicatorPadding: EdgeInsets.only(
                                bottom: 8.h, left: 3.w, right: 3.w),
                            /*  indicator: BoxDecoration(
                                    color: Constants.borderColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Constants.borderColor),
                                  ), */
                            controller: _tabController,
                            tabs: const [
                              Row(
                                children: [Text("Job Description")],
                              ),
                              Tab(text: 'Interview FAQ'),
                              Tab(
                                text: "Recomended Job",
                              ),
                              Tab(
                                text: "History",
                              ),
                              Tab(
                                text: "Resume",
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        //  padding: const EdgeInsets.only(left: 20),
                        height: MediaQuery.of(context).size.height / 1.3.h,
                        width: double.maxFinite,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            DescriptionForCC(
                              id: widget.id,
                              Applies: false,
                              referal: false,
                            ),
                            InterviewFaqPage(
                              crpfid: jobDetailsModel.crpf_id!.toInt(),
                              userid: widget.userid,
                              userRole: widget.userrole.toString(),
                            ),
                            const MatchingJobs(),
                            History(
                              no: widget.item.contactNo!.toInt(),
                              item: widget.item,
                            ),
                            PDFViewForLeadDetail(
                              id: widget.item.id,
                              pdfAssetPath: widget.item.resume.toString(),
                              phoneNumber1: widget.item.contactNo!.toInt(),

                              phoneNumber2: widget.item.alternateNo != null
                                  ? widget.item.alternateNo!.toInt()
                                  : 0,

                              // Replace with the actual asset path of your PDF file
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
        ),
        isLoading
            ? BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 5, sigmaY: 5), // Adjust blur intensity as needed
                child: const Center(
                  child: AbsorbPointer(
                    absorbing: true, // Prevent interaction with elements behind
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
