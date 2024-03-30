// ignore_for_file: must_be_immutable, unused_local_variable, unnecessary_null_comparison, non_constant_identifier_names, avoid_print, avoid_unnecessary_containers, deprecated_member_use
// ignore_for_file: todo
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/job_details_model.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/screens/jobs/add_resume.dart';
import 'package:job_circle/service/JobSearchService.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_tooltip/super_tooltip.dart';

class DescriptionForCC extends StatefulWidget {
  int? id;
  bool Applies;
  bool referal;
  final int user_type;
  DescriptionForCC(
      {super.key,
      required this.id,
      required this.Applies,
      required this.user_type,
      required this.referal});

  @override
  State<DescriptionForCC> createState() => _DescriptionForCCState();
}

class _DescriptionForCCState extends State<DescriptionForCC> {
  //
  //
  //
  //
  //

  bool descTextShowFlag = false;
  final ScrollController _scrollController = ScrollController();
  final Color appBgColor = Constants.themeBgColor;
  final Color appBgScrolledColor = Constants.bgPanelColor;
  late Color currentAppBarColor = appBgColor;
  late double appBarElevate = 0;
  late Color appBarIconColor = Colors.white;

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

  Future<void> fetchJobs() async {
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
      /* profile_final_pic = Utils.resolveImage(profilemodel.profile_pic);
      profile_cv_link = Utils.resolveImage(profilemodel.cv_link);
      profile_cv_file = Utils.getFileName(profile_cv_link); */
      // user_selected_lcoation = user_selected_lcoation;
    }

    setState(() {});
  }

  /* void benefit() async {
    setState(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      usertype = await Utils.getPreferencesValue(
          prefs, ESharedPreferences.user_type.name);
      userrole =
          await Utils.getPreferencesValue(prefs, ESharedPreferences.role.name);
    });
  } */

  @override
  void initState() {
    super.initState();
    bindProfileSummary();
    fillCacheData();
    // benefit();
    //   const RestrictedButton();
    fetchJobs();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
     
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

  //
  //
  //
  //
  //
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 15.h),
          child: Column(
            children: [
              if (jobDetailsModel.education != null &&
                  jobDetailsModel.education!.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                      color: Colors.lightBlue.shade300,
                      gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Constants.dullBlue,
                            Constants.bgColorWhite,

                            /* Constants.borderColor,
                                  Constants.maintheme_light_color, */
                          ]),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            offset: const Offset(0, 0),
                            blurRadius: 2)
                      ],
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.only(
                      left: 10, right: 8, top: 6, bottom: 6),
                  margin: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Job Highlights",
                        style: GoogleFonts.varela(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.h,
                          //decoration: TextDecoration.underline
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      if (jobDetailsModel.languageknown != null &&
                          jobDetailsModel.languageknown!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: 3.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/images/languages.png",
                                height: 17.h,
                                //  color: Colors.blac,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Expanded(
                                child: Column(
                                  //TODO: Temp....
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      spacing:
                                          4.0, // Adjust the spacing between items as needed
                                      children: [
                                        for (int index = 0;
                                            index <
                                                jobDetailsModel
                                                    .languageknown!.length;
                                            index++)
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                jobDetailsModel
                                                    .languageknown![index],
                                                style: GoogleFonts.varela(
                                                  // fontSize: 15,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                              Text(
                                                index ==
                                                        jobDetailsModel
                                                                .languageknown!
                                                                .length -
                                                            1
                                                    ? '.'
                                                    : ",",
                                                style: GoogleFonts.varela(
                                                    color:
                                                        Colors.grey.shade700),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                    /*  if (jobDetailsModel //TODO: Pending work due to overflow.
                                                  .languageknown!.length >=
                                              2)
                                            Text(
                                              " (Any one)",
                                              style: GoogleFonts.varela(
                                                  color: Colors.grey.shade700),
                                            ), */
                                  ],
                                ),
                              )

                              /*  SizedBox(  //TODO: old code before 2/11/2023.
                                      height: 18.h,
                                      child: Row(
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: jobDetailsModel
                                                .languageknown!.length,
                                            itemBuilder: (context, index) {
                                              String language = jobDetailsModel
                                                  .languageknown![index];
                                              bool isLastItem = index ==
                                                  jobDetailsModel
                                                          .languageknown!.length -
                                                      1;
                                              String separator =
                                                  isLastItem ? '.' : ', ';
                        
                                              return Row(
                                                children: [
                                                  Text(
                                                    language,
                                                    style: GoogleFonts.varela(
                                                        fontSize: 15,
                                                        color:
                                                            Colors.grey.shade700),
                                                    softWrap: true,
                                                  ),
                                                  Text(separator,
                                                      style: GoogleFonts.varela(
                                                          color: Colors
                                                              .grey.shade700)),
                                                ],
                                              );
                                            },
                                          ),
                                          jobDetailsModel.languageknown!.length >=
                                                  2
                                              ? Text(" (Any one)",
                                                  style: GoogleFonts.varela(
                                                      color:
                                                          Colors.grey.shade700))
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ), */
                            ],
                          ),
                        ),

                      //  if (jobDetailsModel.gender != null)
                      if (jobDetailsModel.gender != null &&
                          jobDetailsModel.gender != " ")
                        Padding(
                          padding: EdgeInsets.only(bottom: 3.h),
                          child: Row(
                            children: [
                              Image.asset(
                                jobDetailsModel.gender.toString() == "Male"
                                    ? "assets/images/male1.png"
                                    : jobDetailsModel.gender.toString() ==
                                            "Female"
                                        ? "assets/images/female1.png"
                                        : jobDetailsModel.gender.toString() ==
                                                "Female prefered"
                                            ? "assets/images/female1.png"
                                            : "",
                                height: 17.h,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                jobDetailsModel.gender == "Female prefered"
                                    ? "Female preferred"
                                    : jobDetailsModel.gender.toString(),
                                style: GoogleFonts.varela(
                                  color: Colors.grey.shade700,
                                ),
                              )
                            ],
                          ),
                        ),
                      if (jobDetailsModel.education != null &&
                          jobDetailsModel.education!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: 3.h),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/campus.png",
                                height: 17.h,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                jobDetailsModel.education.toString(),
                                style: GoogleFonts.varela(
                                  color: Colors.grey.shade700,
                                ),
                              )
                            ],
                          ),
                        ),
                      if (jobDetailsModel.shifttime != null &&
                          jobDetailsModel.shifttime!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: 3.h),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/watch_gif.gif",
                                height: 17,
                              ),
                              /* CachedNetworkImage(
                                imageUrl: "assets/images/watch_gif.gif",
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ), */
                              const SizedBox(
                                width: 5,
                              ),
                              jobDetailsModel.shifttime ==
                                      "👨Rotational (24/7) | 👩Rotational Day"
                                  ? Text(
                                      "Male: Rotational | Female: Day Rotational",
                                      style: GoogleFonts.varela(
                                        color: Colors.grey.shade700,
                                      ))
                                  : jobDetailsModel.shifttime == "🌄Day"
                                      ? Text("Day Shift",
                                          style: GoogleFonts.varela(
                                            color: Colors.grey.shade700,
                                          ))
                                      : jobDetailsModel.shifttime == "🌙 Night"
                                          ? Text("Night Shift",
                                              style: GoogleFonts.varela(
                                                color: Colors.grey.shade700,
                                              ))
                                          : Text(
                                              extractText(jobDetailsModel
                                                  .shifttime
                                                  .toString()),
                                              style: GoogleFonts.varela(
                                                color: Colors.grey.shade700,
                                              ),
                                            )
                            ],
                          ),
                        ),
                      if (jobDetailsModel.shiftdesc != null &&
                          jobDetailsModel.shiftdesc!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: 3.h),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/holiday.png",
                                height: 17.h,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                jobDetailsModel.shiftdesc.toString(),
                                style: GoogleFonts.varela(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      // if (jobDetailsModel.gender!.isEmpty)

                      /*  Row(
                        children: [
                          const Icon(
                            Icons.panorama_fish_eye,
                            // color: Colors.green,
                          ),
                          Text(jobDetailsModel.eligibility.toString())
                        ],
                                          ), */
                    ],
                  ),
                ),
              if (jobDetailsModel.key_responsible != null)
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            offset: const Offset(0, 0),
                            blurRadius: 2)
                      ],
                      color: Colors.white,
                      // border: Border.all(color: Colors.blue.shade200),
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.only(
                      left: 10, right: 5, top: 10, bottom: 10),
                  margin:
                      EdgeInsets.only(top: 10, left: 1, right: 1, bottom: 5.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (jobDetailsModel.job_benifits != null &&
                          jobDetailsModel.job_benifits!.isNotEmpty)
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Job Benefits",
                                style: GoogleFonts.varela(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.h),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Wrap(
                                spacing: 0.1,
                                children: [
                                  ...jobDetailsModel.job_benifits!
                                      .take(5)
                                      .map((item) => customSkill(item, false)),
                                ],
                              )
                              /* SizedBox(
                                  height: 30.h,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: jobDetailsModel
                                        .job_benifits?.length,
                                    itemBuilder: (context, index) {
                                      return Wrap(
                                        children: [
                                          customSkill(
                                              jobDetailsModel
                                                  .job_benifits![index],
                                              false),
                                        ],
                                      );
                                    },
                                  ),
                                ), */
                            ],
                          ),
                        ),
                      if (jobDetailsModel.skills != null &&
                          jobDetailsModel.skills!.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(top: 5.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Skills Required",
                                style: GoogleFonts.varela(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.h),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Wrap(
                                children: [
                                  ...jobDetailsModel.skills!
                                      .map((item) => customSkill(item, true)),
                                ],
                              )
                              /* SizedBox(
                                  height: 30.h,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount:
                                        jobDetailsModel.skills?.length,
                                    itemBuilder: (context, index) {
                                      return Wrap(
                                        children: [
                                          customSkill(
                                              jobDetailsModel
                                                  .skills![index],
                                              true),
                                        ],
                                      );
                                    },
                                  ),
                                ), */
                            ],
                          ),
                        ),
                      if (jobDetailsModel.key_responsible != null)
                        Container(
                          margin: EdgeInsets.only(top: 5.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Key Responsibilities",
                                style: GoogleFonts.varela(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.h),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: jobDetailsModel.key_responsible
                                          ?.map((item) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                width: 6,
                                                child: Text("•"),
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  item,
                                                  style: GoogleFonts.varela(
                                                    color: Colors.grey.shade700,
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList() ??
                                      [],
                                ),
                              ),

                              /*  LayoutBuilder(  // timeLiner Code 
                                builder: (p0, p1) {
                                  double desiredHeight = jobDetailsModel
                                          .key_responsible!.length *
                                      30.0;
                                  return CustomTimeline(
                                    keyResponsible: jobDetailsModel
                                        .key_responsible!,
                                    size: desiredHeight,
                                  );
                                },
                              ) */
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 5.h,
                      ),
                      if (jobDetailsModel.eligible != null)
                        Text(
                          "Eligibility ",
                          style: GoogleFonts.varela(
                              fontWeight: FontWeight.w600, fontSize: 15.h),
                        ),
                      SizedBox(
                        height: 2.h,
                      ),
                      //for(String item in jobDetailsModel.eligible.toString())
                      Padding(
                        padding: EdgeInsets.only(left: 5.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Add the static value based on the condition
                            if (jobDetailsModel.age_group != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 6,
                                      child: Text("•"),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        "Candidate Age should be in between ${jobDetailsModel.age_group}.",
                                        style: GoogleFonts.varela(
                                          color: Colors.grey.shade700,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // Display the items from the jobDetailsModel.eligible list
                            ...jobDetailsModel.eligible?.map((item) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          width: 6,
                                          child: Text("•"),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            item,
                                            style: GoogleFonts.varela(
                                              color: Colors.grey.shade700,
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList() ??
                                [],
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      jobDetailsModel.boundarylimits != null &&
                              jobDetailsModel.boundarylimits!.isNotEmpty
                          ? Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Transport boundaries",
                                    style: GoogleFonts.varela(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.h),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: jobDetailsModel.boundarylimits
                                              ?.map((item) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 6,
                                                    child: Text("•"),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      item,
                                                      style: GoogleFonts.varela(
                                                        color: Colors
                                                            .grey.shade700,
                                                        fontSize: 13.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList() ??
                                          [],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      jobDetailsModel.moredetails != null &&
                              jobDetailsModel.moredetails!.isNotEmpty
                          ? Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Other Details",
                                    style: GoogleFonts.varela(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.h),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: jobDetailsModel.moredetails
                                              ?.map((item) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 6,
                                                    child: Text("•"),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      item,
                                                      style: GoogleFonts.varela(
                                                        color: Colors
                                                            .grey.shade700,
                                                        fontSize: 13.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList() ??
                                          [],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              if (jobDetailsModel.is_graduate == 1)
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            offset: const Offset(0, 0),
                            blurRadius: 2)
                      ],
                      color: Colors.white,
                      // border: Border.all(color: Colors.blue.shade200),
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.only(
                      left: 10, right: 5, top: 10, bottom: 10),
                  margin: const EdgeInsets.only(top: 10, left: 1, right: 1),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Note's : ",
                          style: GoogleFonts.varela(
                            fontWeight:
                                FontWeight.bold, // Set bold for this part
                            fontSize: 15,
                            color: Colors.black, // Adjust color as needed
                          ),
                        ),
                        TextSpan(
                          text:
                              "Undergraduates with Relevant Experience can Apply.",
                          style: GoogleFonts.varela(
                            fontWeight:
                                FontWeight.normal, // Set normal for this part
                            fontSize: 14,
                            color: Colors.black, // Adjust color as needed
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (jobDetailsModel.spoc_fname != null)
                Stack(
                  children: [
                    Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.white,
                                Colors.grey.shade300,
                              ]),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                offset: const Offset(0, 0),
                                blurRadius: 2)
                          ],
                          color: Colors.grey.shade200,
                          // border: Border.all(color: Colors.blue.shade200),
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.only(
                          left: 10, right: 5, top: 10, bottom: 10),
                      margin: const EdgeInsets.only(
                          top: 10, left: 1, right: 1, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Recruiter Details",
                            style: GoogleFonts.varela(
                                fontWeight: FontWeight.w600, fontSize: 15.h),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${jobDetailsModel.spoc_fname.toString()}  ${jobDetailsModel.spoc_lname.toString()}",
                                      style: GoogleFonts.varela(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "${jobDetailsModel.spoc_designation.toString()} - ${jobDetailsModel.spoc_location.toString()}",
                                      style: GoogleFonts.varela(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (jobDetailsModel.interviewrounds != null)
                            Row(
                              children: [
                                Text(
                                  "Interview Rounds",
                                  style: GoogleFonts.varela(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.h),
                                ),
                              ],
                            ),
                          if (jobDetailsModel.interviewrounds != null)
                            SizedBox(
                              height: 3.sp,
                            ),
                          if (jobDetailsModel.interviewrounds != null)
                            Wrap(
                              children: [
                                ...jobDetailsModel.interviewrounds!
                                    .toSet() // Convert to set to remove duplicates
                                    .map((item) => customSkill(item, true)),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 20.h, right: 20.w),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: jobDetailsModel.spoc_profile_pic != null
                                ? CircleAvatar(
                                    radius: 30,
                                    backgroundImage: CachedNetworkImageProvider(
                                      "https://s3.ap-south-1.amazonaws.com/job-circle-2/${jobDetailsModel.spoc_profile_pic}",
                                    ),
                                  )
                                : const SizedBox())),
                  ],
                ),
              if (widget.user_type == EUserType.businessPartner.value &&
                  partner_request == EPartnerApproval.approved.value)
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            offset: const Offset(0, 0),
                            blurRadius: 2)
                      ],
                      color: Colors.white,
                      // border: Border.all(color: Colors.blue.shade200),
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(top: 10, left: 1, right: 1),
                  child: Column(
                    children: [
                      if (widget.user_type == EUserType.businessPartner.value &&
                          partner_request == EPartnerApproval.approved.value)
                        Row(children: [
                          const SizedBox(
                            height: 50,
                          ),
                          const Expanded(
                              child: Divider(
                            thickness: 1,
                          )),
                          Text(
                            "Commercial",
                            style:
                                GoogleFonts.varela(fontWeight: FontWeight.bold),
                          ),
                          const Expanded(
                              child: Divider(
                            thickness: 2,
                          )),
                        ]),
                      if (widget.user_type == EUserType.businessPartner.value &&
                          partner_request == EPartnerApproval.approved.value)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: keyPair("rupee.png", "Payout",
                                    jobDetailsModel.payout.toString(), false)),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: keyPair(
                                    "paymentclause.png",
                                    "Payment Clause",
                                    jobDetailsModel.paymentclause ?? '',
                                    false)),
                          ],
                        ),
                    ],
                  ),
                ),
              if (jobDetailsModel.partnerPayout == null ||
                  jobDetailsModel.partnerPayout == "" &&
                      (!widget.referal || widget.Applies) &&
                      (jobDetailsModel.partnerPayout != 'Flat' ||
                          jobDetailsModel.partnerPayout != 'Slab' ||
                          jobDetailsModel.partnerPayout != 'CTC Based' ||
                          jobDetailsModel.partnerPayout != "Work Pay" ||
                          jobDetailsModel.specialClause == null ||
                          jobDetailsModel.specialClause == ""))
                Visibility(
                    visible: widget.user_type != 3,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(
                        top: 2,
                        left: 20,
                        right: 5,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(color: Constants.borderColor),
                          color: Constants.borderColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                offset: const Offset(0, 0),
                                blurRadius: 2)
                          ]),
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Join our ",
                                  style: GoogleFonts.varela(
                                      fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  "Talent Referral Program",
                                  style: GoogleFonts.varela(
                                      color: Colors.indigo,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Refer a Friend Get\nRewarded",
                                                style: GoogleFonts.varela(
                                                    // color: Colors.white,
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width: 50.w,
                                                  child: const Divider(
                                                    thickness: 1.5,
                                                  )),
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .currency_rupee_outlined,
                                                            color: Colors.amber,
                                                          ),
                                                          Text(
                                                            "Payout will update soon!",
                                                            style: GoogleFonts.varela(
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .indigo),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  /*   Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              const Text(""),
                                                              Text(
                                                                " Per Referral",
                                                                style: GoogleFonts
                                                                    .varela(
                                                                  fontSize: 8.sp,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ],
                                                          ) */
                                                ],
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddResume(
                                                            report_to:
                                                                profilemodel
                                                                    .report_to!
                                                                    .toInt(),
                                                            company_name:
                                                                jobDetailsModel
                                                                    .name
                                                                    .toString(),
                                                            role:
                                                                jobDetailsModel
                                                                    .rolename
                                                                    .toString(),
                                                            process:
                                                                jobDetailsModel
                                                                    .process
                                                                    .toString(),
                                                            nature_of_work:
                                                                jobDetailsModel
                                                                    .naturofwork
                                                                    .toString(),
                                                            company_id:
                                                                jobDetailsModel
                                                                    .compnayid!
                                                                    .toInt(),
                                                            jobId:
                                                                jobDetailsModel
                                                                    .id!
                                                                    .toInt(),
                                                            sourceId:
                                                                profilemodel.id!
                                                                    .toInt(),
                                                            sourceName:
                                                                "${profilemodel.first_name.toString()} ${profilemodel.last_name.toString()}",
                                                            isRefer: true,
                                                            spocId:
                                                                jobDetailsModel
                                                                    .spoc!
                                                                    .toInt(),
                                                            is90: jobDetailsModel
                                                                        .payment_clause ==
                                                                    "90 Days"
                                                                ? true
                                                                : false,
                                                            is30: jobDetailsModel
                                                                        .payment_clause ==
                                                                    "30 Days"
                                                                ? true
                                                                : false,
                                                            userNumber:
                                                                profilemodel
                                                                    .mobile!
                                                                    .toInt(),
                                                            useAlternateNumber:
                                                                profilemodel
                                                                        .alternate_no
                                                                        ?.toInt() ??
                                                                    0,
                                                            interviewRounds:
                                                                jobDetailsModel
                                                                    .interviewrounds!
                                                                    .first
                                                                    .replaceAll(
                                                                        '[', '')
                                                                    .replaceAll(
                                                                        ']', '')
                                                                    .replaceAll(
                                                                        '"',
                                                                        ''),
                                                          )));
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6,
                                                      horizontal: 15),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors
                                                            .grey.shade400,
                                                        //  blurRadius: 10,
                                                        blurRadius: 15.0,
                                                        offset:
                                                            const Offset(1, 1))
                                                  ],
                                                  color: Constants.borderColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r)),
                                              child: Text(
                                                "Refer Now",
                                                style: GoogleFonts.varela(
                                                    fontSize: 14.sp,
                                                    letterSpacing: 1,
                                                    color: Colors.indigo,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "assets/images/refer.png",
                                            height: 80.h,
                                          ),
                                          // const Text("T & C apply")
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
              if (jobDetailsModel.partnerPayout != null &&
                  jobDetailsModel.partnerPayout != "" &&
                  (widget.referal || !widget.Applies) &&
                  (jobDetailsModel.partnerPayout == 'Flat' ||
                      jobDetailsModel.partnerPayout == 'Slab' ||
                      jobDetailsModel.partnerPayout == 'CTC Based' ||
                      jobDetailsModel.partnerPayout == "Work Pay" ||
                      jobDetailsModel.specialClause != null ||
                      jobDetailsModel.specialClause != ""))
                Visibility(
                  visible: widget.user_type != 3,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.only(
                      top: 2,
                      left: 20,
                      right: 5,
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(color: Constants.borderColor),
                        color: Constants.borderColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade300,
                              offset: const Offset(0, 0),
                              blurRadius: 2)
                        ]),
                    child: Stack(
                      children: [
                        // for (int i = 0;
                        //     i < jobDetailsModel.slabAmount!.length;
                        //     i++)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        "Join our ",
                                        style: GoogleFonts.varela(
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Text(
                                        "Talent Referral Program",
                                        style: GoogleFonts.varela(
                                            color: Colors.indigo,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "Refer a Friend Get\nRewarded",
                                    style: GoogleFonts.varela(
                                        // color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            if (jobDetailsModel.partnerPayout == 'Flat')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: 50.w,
                                      child: const Divider(
                                        thickness: 1.5,
                                      )),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.currency_rupee_outlined,
                                                color: Colors.amber,
                                              ),
                                              Text(
                                                "${(jobDetailsModel.flatAmount)?.toStringAsFixed(0)}/-",
                                                style: GoogleFonts.varela(
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.indigo),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          const Text(""),
                                          Text(
                                            " Per Referral",
                                            style: GoogleFonts.varela(
                                              fontSize: 8.sp,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            if (jobDetailsModel.partnerPayout == 'Slab')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: 50.w,
                                      child: const Divider(
                                        thickness: 1.5,
                                      )),
                                  const Row(
                                    children: [
                                      Text("Between"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.currency_rupee_outlined,
                                        color: Colors.amber,
                                      ),
                                      if (jobDetailsModel.slabAmount != null)
                                        Text(
                                          "${(double.tryParse(jobDetailsModel.slabAmount![0])!).toStringAsFixed(0)} to ${(double.tryParse(jobDetailsModel.slabAmount![jobDetailsModel.slabAmount!.length - 1])!).toStringAsFixed(0)} ",
                                          style: GoogleFonts.varela(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                      SuperTooltip(
                                        popupDirection: TooltipDirection.up,
                                        content: DataTable(
                                          columnSpacing: 10.0,
                                          dataRowHeight: 25.0,
                                          headingRowHeight: 25.0,
                                          horizontalMargin:
                                              5, // Adjust as needed
                                          columns: [
                                            DataColumn(
                                              label: Container(
                                                //width: 52,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Min",
                                                  style: GoogleFonts.varela(
                                                    color:
                                                        Constants.subtitleclr,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            //DataColumn(
                                            // label: Text(
                                            //   "-", // Separator
                                            //   style: GoogleFonts.varela(
                                            //     color: Constants.subtitleclr,
                                            //     fontWeight: FontWeight.bold,
                                            //     fontSize: 13.sp,
                                            //   ),
                                            // ),
                                            //   ),
                                            DataColumn(
                                              label: Container(
                                                // width: 55,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Max",
                                                  style: GoogleFonts.varela(
                                                    color:
                                                        Constants.subtitleclr,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // DataColumn(
                                            //   // label: Text(
                                            //   //   "=", // Separator
                                            //   //   style: GoogleFonts.varela(
                                            //   //     color: Constants.subtitleclr,
                                            //   //     fontWeight: FontWeight.bold,
                                            //   //     fontSize: 13.sp,
                                            //   //   ),
                                            //   // ),
                                            // ),
                                            DataColumn(
                                              label: Container(
                                                // width: 40,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Amt",
                                                  style: GoogleFonts.varela(
                                                    color:
                                                        Constants.subtitleclr,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                          rows: List<DataRow>.generate(
                                            jobDetailsModel.minCount!.length,
                                            (index) => DataRow(
                                              cells: [
                                                DataCell(
                                                  Container(
                                                    // width: 52,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      _formatSlab(
                                                          jobDetailsModel
                                                                  .minCount![
                                                              index]),
                                                      style: GoogleFonts.varela(
                                                        color: Constants
                                                            .subtitleclr,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 13.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // DataCell(
                                                //   Text(
                                                //     "-", // Separator
                                                //     style: GoogleFonts.varela(
                                                //       color: Constants.subtitleclr,
                                                //       fontWeight: FontWeight.normal,
                                                //       fontSize: 13.sp,
                                                //     ),
                                                //   ),
                                                // ),
                                                /* DataCell(
                                                          Container(
                                                            // width: 55,
                                                            alignment:
                                                                Alignment.center,
                                                            child: Text(
                                                              jobDetailsModel
                                                                      .maxCount![
                                                                  index],
                                                              /* _formatSlab(   //TODO: chnages done to display &above.
                                                                  jobDetailsModel
                                                                          .maxCount![
                                                                      index]), */
                                                              style: GoogleFonts
                                                                  .varela(
                                                                color: Constants
                                                                    .subtitleclr,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 13.sp,
                                                              ),
                                                            ),
                                                          ),
                                                        ), */
                                                DataCell(
                                                  jobDetailsModel.maxCount![
                                                              index] !=
                                                          null
                                                      ? Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            jobDetailsModel
                                                                    .maxCount![
                                                                index],
                                                            style: GoogleFonts
                                                                .varela(
                                                              color: Constants
                                                                  .subtitleclr,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 13.sp,
                                                            ),
                                                          ),
                                                        )
                                                      : Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "& above",
                                                            style: GoogleFonts
                                                                .varela(
                                                              color: Constants
                                                                  .subtitleclr,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 13.sp,
                                                            ),
                                                          ),
                                                        ), // Empty container if maxCount[index] is null or empty
                                                ),
                                                // DataCell(
                                                //   Text(
                                                //     "=", // Separator
                                                //     style: GoogleFonts.varela(
                                                //       color: Constants.subtitleclr,
                                                //       fontWeight: FontWeight.normal,
                                                //       fontSize: 13.sp,
                                                //     ),
                                                //   ),
                                                // ),
                                                DataCell(
                                                  Container(
                                                    // width: 40,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "${_formatSlabAmount(double.tryParse(jobDetailsModel.slabAmount?[index] ?? '0.0'))}/-",
                                                      style: GoogleFonts.varela(
                                                        color: Constants
                                                            .subtitleclr,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 13.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.info,
                                          color: Colors.grey.shade400,
                                          size: 18.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Per Referral",
                                        style: GoogleFonts.varela(
                                          fontSize: 8.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            if (jobDetailsModel.partnerPayout == 'CTC Based')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                      width: 50.w,
                                      child: const Divider(
                                        thickness: 1.5,
                                      )),
                                  RichText(
                                    text: TextSpan(
                                        text:
                                            "${jobDetailsModel.ctcPrecent!.toStringAsFixed(0)}%",
                                        style: GoogleFonts.varela(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.indigo),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: " of Annual CTC",
                                            style: GoogleFonts.varela(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.indigo),
                                          )
                                        ]),
                                  ),
                                  /*   Text(
                                            "${jobDetailsModel.ctcPrecent!.toStringAsFixed(0)} % of Annual CTC",
                                            style: GoogleFonts.varela(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.indigo),
                                          ), */
                                  Text(
                                    "(excluding gratuity & variables)",
                                    style: GoogleFonts.varela(
                                        fontSize: 8.sp,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.indigo),
                                  ),
                                ],
                              ),
                            if (jobDetailsModel.partnerPayout == "Work Pay")
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: 50.w,
                                      child: const Divider(
                                        thickness: 1.5,
                                      )),
                                  Text(
                                    "Fresher :",
                                    style: GoogleFonts.varela(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  jobDetailsModel.is_fresh_ctc == 0
                                      ? Row(
                                          children: [
                                            const Icon(
                                              Icons.currency_rupee_outlined,
                                              color: Colors.amber,
                                              //size: 15.sp,
                                            ),
                                            Text(
                                              "${(jobDetailsModel.partner_fresher_pay)?.toStringAsFixed(0)}/-",
                                              style: GoogleFonts.varela(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.indigo),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                const Text(""),
                                                Text(
                                                  " Per Referral",
                                                  style: GoogleFonts.varela(
                                                    fontSize: 8.sp,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Column(
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                      text:
                                                          "${jobDetailsModel.partner_fresher_pay!.toStringAsFixed(0)}%",
                                                      style: GoogleFonts.varela(
                                                          fontSize: 18.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.indigo),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text:
                                                              " of Annual CTC",
                                                          style: GoogleFonts
                                                              .varela(
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .indigo),
                                                        )
                                                      ]),
                                                ),
                                                Text(
                                                  "(excluding gratuity & variables)",
                                                  style: GoogleFonts.varela(
                                                      fontSize: 8.sp,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.indigo),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                  const Divider(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Experience :",
                                        style: GoogleFonts.varela(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      jobDetailsModel.is_exp_ctc == 0
                                          ? Row(
                                              children: [
                                                const Icon(
                                                  Icons.currency_rupee_outlined,
                                                  color: Colors.amber,
                                                  //size: 15.sp,
                                                ),
                                                Text(
                                                  "${(jobDetailsModel.partner_exp_pay)?.toStringAsFixed(0)}/-",
                                                  style: GoogleFonts.varela(
                                                      fontSize: 20.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.indigo),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    const Text(""),
                                                    Text(
                                                      " Per Referral",
                                                      style: GoogleFonts.varela(
                                                        fontSize: 8.sp,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                          text:
                                                              "${jobDetailsModel.partner_exp_pay!.toStringAsFixed(0)}%",
                                                          style: GoogleFonts
                                                              .varela(
                                                                  fontSize:
                                                                      18.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .indigo),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text:
                                                                  " of Annual CTC",
                                                              style: GoogleFonts.varela(
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .indigo),
                                                            )
                                                          ]),
                                                    ),
                                                    Text(
                                                      "(excluding gratuity & variables)",
                                                      style: GoogleFonts.varela(
                                                          fontSize: 8.sp,
                                                          letterSpacing: 1,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.indigo),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddResume(
                                              report_to: profilemodel.report_to!
                                                  .toInt(),
                                              company_name: jobDetailsModel.name
                                                  .toString(),
                                              role: jobDetailsModel.rolename
                                                  .toString(),
                                              process: jobDetailsModel.process
                                                  .toString(),
                                              nature_of_work: jobDetailsModel
                                                  .naturofwork
                                                  .toString(),
                                              company_id: jobDetailsModel
                                                  .compnayid!
                                                  .toInt(),
                                              jobId:
                                                  jobDetailsModel.id!.toInt(),
                                              sourceId:
                                                  profilemodel.id!.toInt(),
                                              sourceName:
                                                  "${profilemodel.first_name.toString()} ${profilemodel.last_name.toString()}",
                                              isRefer: true,
                                              spocId:
                                                  jobDetailsModel.spoc!.toInt(),
                                              is90: jobDetailsModel
                                                          .payment_clause ==
                                                      "90 Days"
                                                  ? true
                                                  : false,
                                              is30: jobDetailsModel
                                                          .payment_clause ==
                                                      "30 Days"
                                                  ? true
                                                  : false,
                                              userNumber:
                                                  profilemodel.mobile!.toInt(),
                                              useAlternateNumber: profilemodel
                                                      .alternate_no
                                                      ?.toInt() ??
                                                  0,
                                              interviewRounds: jobDetailsModel
                                                  .interviewrounds!.first
                                                  .replaceAll('[', '')
                                                  .replaceAll(']', '')
                                                  .replaceAll('"', ''),
                                            )));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 15),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade400,
                                          //  blurRadius: 10,
                                          blurRadius: 15.0,
                                          offset: const Offset(1, 1))
                                    ],
                                    color: Constants.borderColor,
                                    borderRadius: BorderRadius.circular(8.r)),
                                child: Text(
                                  "Refer Now",
                                  style: GoogleFonts.varela(
                                      fontSize: 14.sp,
                                      letterSpacing: 1,
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                        Positioned(
                          bottom:
                              jobDetailsModel.payoutType == 'Slab' ? 10.h : 0.h,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/refer.png",
                                  height: 80.h,
                                ),
                                // const Text("T & C apply")
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5, top: 5),
                            child: Text(
                              "Terms & condition Apply",
                              style: GoogleFonts.varela(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 9.sp,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget customSkill(String title, bool isHash) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Constants.subtitleclr, width: 0.5)),
      child: isHash
          ? Text(
              "#$title",
              style: GoogleFonts.varela(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            )
          : Text(
              title,
              style: GoogleFonts.varela(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
    );
  }

  Column keyPair(String imageName, String key, String value, bool devider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            // Icon(
            //   icon,
            //   size: 17,
            // ),
            const SizedBox(
              width: 3,
            ),
            Text(
              key,
              style:
                  GoogleFonts.varela(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            value,
            style: GoogleFonts.varela(
              color: Colors.black54,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        if (devider)
          const Divider(
            height: 1,
          )
      ],
    );
  }

  String _formatSlab(String? stringValue) {
    if (stringValue == null) {
      return '& above'; // Handle null values gracefully
    }

    try {
      final double parsedValue = double.parse(stringValue);
      if (parsedValue >= 100000) {
        final double lAmount = parsedValue / 100000;
        return '${lAmount.toStringAsFixed(1)}L';
      } else if (parsedValue >= 1000) {
        final double kAmount = parsedValue / 1000;
        return '${kAmount.toStringAsFixed(1)}k';
      } else {
        return parsedValue
            .toStringAsFixed(0); // Keep two decimal places for other values
      }
    } catch (e) {
      return 'Invalid'; // Handle parsing errors gracefully
    }
  }

  String _formatSlabAmount(double? amount) {
    try {
      if (amount == null) {
        return 'N/A'; // Handle null values gracefully
      } else {
        // Ensure the value is not null before parsing
        double parsedAmount = double.parse(amount.toString());
        return parsedAmount.toStringAsFixed(0);
      }
    } catch (e) {
      // Handle the case where parsing fails
      return 'Invalid Amount';
    }
  }
}
