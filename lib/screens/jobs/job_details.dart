import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/job_details_model.dart';
import 'package:job_circle/screens/jobs/curve_painter.dart';
import 'package:job_circle/service/JobSearchService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/utils.dart';
import '../../models/fav_job_model.dart';

final favJobProvider = FutureProvider.family<FavJobModel?, int>(
    (ref, id) => JobSearchService().getFavoriteJob(id));

class JobDetails extends ConsumerStatefulWidget {
  int? id;
  JobDetails({Key? key, this.id}) : super(key: key);

  @override
  ConsumerState<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends ConsumerState<JobDetails> {
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
      print("Somthing Wrong");
      // handle error
    }
  }

  String formatSalaryRange(double minSalary, double maxSalary) {
    String formattedMinSalary = '';
    String formattedMaxSalary = '';

    if (minSalary >= 100000) {
      formattedMinSalary = (minSalary / 100000).toStringAsFixed(2);
    } else if (minSalary >= 1000) {
      formattedMinSalary = '${(minSalary / 1000).toStringAsFixed(0)}k';
    } else {
      formattedMinSalary = minSalary.toStringAsFixed(2);
    }

    if (maxSalary >= 100000) {
      formattedMaxSalary = (maxSalary / 100000).toStringAsFixed(2);
    } else if (maxSalary >= 1000) {
      formattedMaxSalary = '${(maxSalary / 1000).toStringAsFixed(0)}k';
    } else {
      formattedMaxSalary = maxSalary.toStringAsFixed(2);
    }

    return '$formattedMinSalary - $formattedMaxSalary';
  }

  @override
  void initState() {
    super.initState();
    fillCacheData();
    //   const RestrictedButton();
    fetchJobs();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      usertype = await Utils.getPreferencesValue(
          null, ESharedPreferences.user_type.name);
      dynamic args = ModalRoute.of(context)!.settings.arguments;
      if (args != null && args["id"] != null) {
        getJobDetails(args["id"]);
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
        subtitleText = jobDetailsModel.rolename.toString() +
            " | " +
            jobDetailsModel.process.toString();

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

  @override
  Widget build(BuildContext context) {
    final favProvider = ref.watch(favJobProvider(widget.id ?? 0));
    bool isFav = favProvider.value?.isFav ?? false;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Job Details",
          style: GoogleFonts.varela(fontSize: 16.h),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.share,
                size: 18.h,
                color: Constants.themeBgColor,
              )),
        ],
        // bottom: PreferredSize(
        //   child: Text(subtitleText),
        //   preferredSize: const Size.fromHeight(0),
        //   // change height for changing app bar height as per content
        // ),

        // bottom: const PreferredSize(
        //     child: Text(
        //       "Search New Jobs",
        //       style:
        //           GoogleFonts.varela(color: Colors.white, fontWeight: FontWeight.bold),
        //     ),
        //     preferredSize: Size.zero),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,

        //backgroundColor: Theme.of(context).primaryColor,
        /* actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Attendence()));
              },
              icon: const Icon(Icons.add)),
          // SizedBox(
          //   width: 100,
          //   child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          //     Icon(
          //       Icons.share_outlined,
          //       color: appBarIconColor,
          //     ),
          //     const SizedBox(
          //       width: 15,
          //     ),
          //     Icon(
          //       Icons.favorite_border_outlined,
          //       color: appBarIconColor,
          //     ),
          //     const SizedBox(
          //       width: 20,
          //     ),
          //   ]),
          // ),
        ], */
      ),
      backgroundColor: Constants.bgPanelColor,

      //  Container(
      //   height: 50,
      //   color: Constants.bgPanelColor,
      //   child: ThemeButton(
      //     // icon: const Icon(
      //     //   Icons.arrow_forward,
      //     //   color: Color(0xffffffff),
      //     //   size: 25,
      //     // ),
      //     radious: 0,
      //     onPressed: () {
      //       // print(jobDetailsModel);
      //       // Navigator.pushNamed(context, ERoute.application.name);
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) => ApplicationForm(
      //                     prevModel: jobDetailsModel,
      //                   )));
      //     },
      //     text: "APPLY",
      //   ),
      // ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 15, top: 15),
        //  padding: const EdgeInsets.only(bottom: 15),
        // height: usertype == EUserType.jobSeeker.value ? 70 : 60,
        //width: double.maxFinite,
        /* decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(0.0)),
        ), */
        child: Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: Row(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              usertype == EUserType.jobSeeker.value ||
                      usertype == EUserType.businessPartner.value
                  ? const SizedBox(
                      width: 10,
                    )
                  : const SizedBox(),
              Visibility(
                visible: (usertype == EUserType.jobSeeker.value),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                        "Similar Jobs",
                        style: GoogleFonts.varela(
                            color: Constants.themeBgColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Visibility(
                  visible: (usertype == EUserType.jobSeeker.value ||
                      usertype == EUserType.businessPartner.value),
                  child: RestrictedButton(
                    isChat: true,
                    onTap: () async {
                      Uri url = Uri.parse(
                          "whatsapp://send?phone=91${jobDetailsModel.spoc_contact}");
                      await canLaunchUrl(url)
                          ? await launchUrl(url)
                          : throw "could not launch $url";
                    },
                  ) /* InkWell(
                    onTap: () async {
                      Uri url = Uri.parse(
                          "whatsapp://send?phone=91${jobDetailsModel.spoc_contact}");
                      await canLaunchUrl(url)
                          ? await launchUrl(url)
                          : throw "could not launch $url";
                    },
                    child: Container(
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
                          Text(
                            "Chat",
                            style:
                                GoogleFonts.varela(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ) */
                  ),
              SizedBox(
                width: 5.w,
              ),
              Visibility(
                  visible: (usertype == EUserType.jobSeeker.value ||
                      usertype == EUserType.businessPartner.value),
                  child: RestrictedButton(
                    isChat: false,
                    onTap: () async {
                      FlutterPhoneDirectCaller.callNumber(
                          "+91${jobDetailsModel.spoc_contact}");
                    },
                  )
                  /* InkWell(
                    onTap: () {
                      FlutterPhoneDirectCaller.callNumber(
                          "+91${jobDetailsModel.spoc_contact}");
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black)),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.phone_android,
                            size: 14,
                            color: Constants.themeBgColor,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            "Call ",
                            style:
                                GoogleFonts.varela(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ) */
                  ),
              SizedBox(
                width: 5.w,
              ),
              Visibility(
                  visible: (usertype == EUserType.jobSeeker.value ||
                      usertype == EUserType.businessPartner.value),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, ERoute.application.name,
                          arguments: {
                            "isnew": false,
                            "prevModel": jobDetailsModel,
                            "refer": true
                          });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Constants.themeBgColor),
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        "Apply",
                        style: GoogleFonts.varela(
                            color: Constants.themeBgColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                  /* /* */ ThemeButton(
                    width: 100,
                    radious: 20,
                    themeButtonSize: ThemeButtonSize.small,
                    onPressed: () {
                      Navigator.pushNamed(context, ERoute.application.name,
                          arguments: {
                            "isnew": false,
                            "prevModel": jobDetailsModel,
                          });
                    },
                    text: "Apply Now",
                  ) */
                  ),
              SizedBox(
                width: 10.w,
              ),
              Visibility(
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    ThemeButton(
                      width: 100,
                      radious: 20,
                      themeButtonSize: ThemeButtonSize.small,
                      onPressed: () {
                        Navigator.pushNamed(context, ERoute.application.name,
                            arguments: {
                              "isnew": true,
                              "prevModel": jobDetailsModel,
                              "refer": false
                            });
                      },
                      text: "New Line-up",
                    ),
                  ],
                ),
                visible: (usertype == EUserType.employee.value ||
                    (usertype == EUserType.businessPartner.value &&
                        partner_request == EPartnerApproval.approved.value)),
              ),
              usertype == EUserType.businessPartner.value
                  ? const SizedBox(
                      width: 10,
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: jobDetailsModel.id == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // jobDetailsModel.name
                                    jobDetailsModel.rolename.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.varela(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.h,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.h,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/proces.png",
                                        height: 12.h,
                                        //color: Colors.black45,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        jobDetailsModel.process.toString(),
                                        style: GoogleFonts.varela(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        "|",
                                        style: GoogleFonts.varela(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        jobDetailsModel.naturofwork.toString(),
                                        style: GoogleFonts.varela(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (jobDetailsModel.name.toString().isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // item['process'] != null)
                                Image.asset(
                                  "assets/images/cmpny.png",
                                  height: 13.h,
                                ),
                                /* Icon(
                                  Icons.business_outlined,
                                  size: 15.h,
                                  color: Colors.grey.shade700,
                                  // color: Color.fromARGB(255, 118, 118, 118),
                                ), */
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/bag.png",
                                      height: 12.5.h,
                                      color: Colors.grey.shade700,
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
                                      children: [
                                        Image.asset(
                                          "assets/images/bag.png",
                                          height: 12.5.h,
                                          color: Colors.grey.shade700,
                                        ),
                                        SizedBox(
                                          width: 7.w,
                                        ),
                                        SizedBox(
                                          child: Text(
                                            "${jobDetailsModel.minexperience.toString().replaceAll(".0", "")} - ${jobDetailsModel.maxexperience.toString().replaceAll(".0", "")} Years",
                                            style: GoogleFonts.varela(
                                                color: Colors.grey.shade700,
                                                // color: Colors.black54,
                                                //fontWeight: FontWeight.normal,
                                                fontSize: 13.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                          if (jobDetailsModel.minctc != null &&
                              jobDetailsModel.maxctc != null)
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/wallet.png",
                                  height: 14.3.h,
                                ),
                                /* Icon(
                                  Icons.currency_rupee,
                                  size: 15.h,
                                  color: Colors.grey.shade700,
                                ), */
                                SizedBox(
                                  width: 5.5.w,
                                ),
                                Text(
                                  "${formatSalaryRange(jobDetailsModel.minctc!.toDouble(), jobDetailsModel.maxctc!.toDouble())} ${jobDetailsModel.ismonthly ?? ""}",
                                  style: GoogleFonts.varela(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13.sp),
                                )
                                /* jobDetailsModel.ismonthly == true
                                    ? Text(
                                        "Yearly",
                                        style: GoogleFonts.varela(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13.sp),
                                      )
                                    : Text(
                                        "Monthly",
                                        style: GoogleFonts.varela(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13.sp),
                                      ) */
                              ],
                            ),
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/loc.png",
                                height: 14.h,
                              ),
                              /* const Icon(
                                Icons.pin_drop_outlined,
                                size: 15,
                              ), */
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
                                  : Text(
                                      jobDetailsModel.location.toString(),
                                      // maxLines: 2,
                                      // overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.varela(
                                          color: Colors.grey.shade700,
                                          //color: Colors.black54,
                                          fontSize: 13.sp),
                                    )
                            ],
                          ),
                          /* Text(
                            jobDetailsModel.name.toString(),
                            style: const GoogleFonts.varela(
                                color: Colors.black54, fontSize: 16),
                          ),
                          /* if (jobDetailsModel.naturofwork != null)
                          Text(
                            jobDetailsModel.naturofwork.toString(),
                            style: const GoogleFonts.varela(
                                color: Colors.black54,
                                fontSize: 14),
                          ), */
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.pin_drop_outlined,
                                  size: 20, color: Colors.black54),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                jobDetailsModel.location.toString(),
                                style: const GoogleFonts.varela(
                                    color: Colors.black54, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.currency_rupee_outlined,
                                  size: 20, color: Colors.black54),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                jobDetailsModel.salary.toString(),
                                style: const GoogleFonts.varela(
                                    color: Colors.black54, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: const [
                              Icon(Icons.badge_outlined,
                                  size: 20, color: Colors.black54),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "0 - 6 months Experience",
                                style: GoogleFonts.varela(
                                    color: Colors.black54, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ), */
                          Row(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 10, right: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Constants.themeBgColorLight,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Constants.borderColor)),
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
                                    const EdgeInsets.only(top: 10, right: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Constants.themeBgColorLight,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Constants.borderColor)),
                                child: Text(
                                  "${jobDetailsModel.no_of_vacancy.toString()} Vacancies",
                                  style:
                                      GoogleFonts.varela(color: Colors.black54),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Constants.themeBgColorLight,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Constants.borderColor)),
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

                          // ]),
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      offset: const Offset(0, 0),
                                      blurRadius: 2)
                                ],
                                color: Constants.themeBgColorLight,
                                border: Border.all(
                                    color: Constants.borderColor, width: 2),
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.only(
                                left: 10, right: 20, top: 6, bottom: 6),
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
                                      children: [
                                        Image.asset(
                                          "assets/images/languages.JPG",
                                          height: 17.h,
                                          //  color: Colors.blac,
                                        ),
                                        const SizedBox(
                                          width: 7,
                                        ),
                                        SizedBox(
                                          height: 18.h,
                                          child: Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: jobDetailsModel
                                                  .languageknown!.length,
                                              itemBuilder: (context, index) {
                                                String language =
                                                    jobDetailsModel
                                                        .languageknown![index];
                                                bool isLastItem = index ==
                                                    jobDetailsModel
                                                            .languageknown!
                                                            .length -
                                                        1;
                                                String separator =
                                                    isLastItem ? '.' : ', ';

                                                return Row(
                                                  children: [
                                                    Text(
                                                      language,
                                                      style: GoogleFonts.varela(
                                                          color: Colors
                                                              .grey.shade700),
                                                    ),
                                                    Text(separator,
                                                        style:
                                                            GoogleFonts.varela(
                                                                color: Colors
                                                                    .grey)),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                //  if (jobDetailsModel.gender != null)
                                if (jobDetailsModel.gender != null &&
                                    jobDetailsModel.gender!.isEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 3.h),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          jobDetailsModel.gender.toString() ==
                                                  "Male"
                                              ? "assets/images/male1.png"
                                              : jobDetailsModel.gender
                                                          .toString() ==
                                                      "Female"
                                                  ? "assets/images/female1.png"
                                                  : "assets/images/female1.png",
                                          height: 17.h,
                                        ),
                                        const SizedBox(
                                          width: 7,
                                        ),
                                        Text(
                                          jobDetailsModel.gender.toString(),
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
                                          "assets/images/education.png",
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
                                          width: 7,
                                        ),
                                        Text(
                                          extractText(jobDetailsModel.shifttime
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
                            margin: const EdgeInsets.only(
                                top: 10, left: 1, right: 1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (jobDetailsModel.job_benifits != null &&
                                    jobDetailsModel.job_benifits!.isNotEmpty)
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          children: [
                                            ...jobDetailsModel.job_benifits!
                                                .take(5)
                                                .map((item) =>
                                                    customSkill(item, false))
                                                .toList(),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Skill's Required",
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
                                                .take(5)
                                                .map((item) =>
                                                    customSkill(item, true))
                                                .toList(),
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
                                Container(
                                  margin: EdgeInsets.only(top: 5.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Key Resposibilities ",
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
                                          children: jobDetailsModel
                                                  .key_responsible
                                                  ?.map((item) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 2),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                        width: 6,
                                                        child: Text("•"),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Expanded(
                                                        child: Text(
                                                          item,
                                                          style: GoogleFonts
                                                              .varela(
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

                                Text(
                                  "Eligibility ",
                                  style: GoogleFonts.varela(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.h),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                //for(String item in jobDetailsModel.eligible.toString())
                                Padding(
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Add the static value based on the condition
                                      if (jobDetailsModel.age_group!.isNotEmpty)
                                        Padding(
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
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                jobDetailsModel.boundarylimits!.isEmpty
                                    ? const SizedBox()
                                    : Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Transport boundries ",
                                              style: GoogleFonts.varela(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15.h),
                                            ),
                                            SizedBox(
                                              height: 2.h,
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 5.w),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: jobDetailsModel
                                                        .boundarylimits
                                                        ?.map((item) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 2),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const SizedBox(
                                                              width: 6,
                                                              child: Text("•"),
                                                            ),
                                                            const SizedBox(
                                                                width: 4),
                                                            Expanded(
                                                              child: Text(
                                                                item,
                                                                style:
                                                                    GoogleFonts
                                                                        .varela(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade700,
                                                                  fontSize:
                                                                      13.sp,
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
                                      ),
                                jobDetailsModel.moredetails!.isEmpty
                                    ? const SizedBox()
                                    : Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              padding:
                                                  EdgeInsets.only(left: 5.w),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: jobDetailsModel
                                                        .moredetails
                                                        ?.map((item) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 2),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const SizedBox(
                                                              width: 6,
                                                              child: Text("•"),
                                                            ),
                                                            const SizedBox(
                                                                width: 4),
                                                            Expanded(
                                                              child: Text(
                                                                item,
                                                                style:
                                                                    GoogleFonts
                                                                        .varela(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade700,
                                                                  fontSize:
                                                                      13.sp,
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
                                      ),
                                /* InkWell(
                                  onTap: () {
                                    setState(() {
                                      descTextShowFlag = !descTextShowFlag;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      descTextShowFlag
                                          ? const Text(
                                              "Show Less",
                                              style: GoogleFonts.varela(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xfff95d3d2)),
                                            )
                                          : const Text("Read More",
                                              style: GoogleFonts.varela(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xfff95d3d2)))
                                    ],
                                  ),
                                ), */
                              ],
                            ),
                          ),

                          /* Container(                             need to be implemented further......
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      offset: const Offset(0, 0),
                                      blurRadius: 2)
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.only(
                                left: 10, right: 20, top: 6, bottom: 6),
                            margin: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Other Details :",
                                  style: GoogleFonts.varela(
                                      fontSize: 15.h,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text("data"),
                                )
                              ],
                            ),
                          ), */

                          Stack(
                            children: [
                              Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade300,
                                          offset: const Offset(0, 0),
                                          blurRadius: 2)
                                    ],
                                    color: Constants.themeBgColorLight,
                                    // border: Border.all(color: Colors.blue.shade200),
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.only(
                                    left: 10, right: 5, top: 10, bottom: 10),
                                margin: const EdgeInsets.only(
                                    top: 10, left: 1, right: 1),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Recruiter Details",
                                      style: GoogleFonts.varela(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15.h),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5.sp),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                    /* Text(
                                      jobDetailsModel.shifttime.toString(),
                                      style: const GoogleFonts.varela(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    jobDetailsModel.boundrylmit != null &&
                                            jobDetailsModel.boundrylmit != ""
                                        ? const Text(
                                            "Boundary limits",
                                            style: GoogleFonts.varela(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          )
                                        : const SizedBox(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      jobDetailsModel.boundrylmit.toString(),
                                      style: const GoogleFonts.varela(
                                        color: Colors.black54,
                                      ),
                                    ), */
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    if (jobDetailsModel.inteviewrounds != null)
                                      Row(
                                        children: [
                                          /*  Image.asset(
                                            "assets/images/interview_round.png",
                                            height: 17.h,
                                          ), */

                                          Text(
                                            "Interview Rounds",
                                            style: GoogleFonts.varela(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15.h),
                                          ),
                                        ],
                                      ),
                                    if (jobDetailsModel.inteviewrounds != null)
                                      SizedBox(
                                        height: 3.sp,
                                      ),
                                    if (jobDetailsModel.inteviewrounds != null)
                                      Wrap(
                                        children: [
                                          ...jobDetailsModel.inteviewrounds!
                                              .take(5)
                                              .map((item) =>
                                                  customSkill(item, true))
                                              .toList(),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 20.h, right: 20.w),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: CircleAvatar(
                                      radius: 30,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${jobDetailsModel.spoc_profile_pic}",
                                        errorWidget: (context, url, error) {
                                          return const CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                  "https://media.istockphoto.com/id/503040171/photo/middle-eastern-businessman-portrait.jpg?s=612x612&w=0&k=20&c=7t6c_HQHfUZNgrVtR-G1rQpJAMaCbFsuxppDRKBnXDw="));
                                        },
                                      )),
                                ),
                              )
                            ],
                          ),
                          if (usertype == EUserType.businessPartner.value &&
                              partner_request ==
                                  EPartnerApproval.approved.value)
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
                              margin: const EdgeInsets.only(
                                  top: 10, left: 1, right: 1),
                              child: Column(
                                children: [
                                  if (usertype ==
                                          EUserType.businessPartner.value &&
                                      partner_request ==
                                          EPartnerApproval.approved.value)
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
                                        style: GoogleFonts.varela(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Expanded(
                                          child: Divider(
                                        thickness: 2,
                                      )),
                                    ]),
                                  if (usertype ==
                                          EUserType.businessPartner.value &&
                                      partner_request ==
                                          EPartnerApproval.approved.value)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: keyPair(
                                                "rupee.png",
                                                "Payout",
                                                jobDetailsModel.payout
                                                    .toString(),
                                                false)),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: keyPair(
                                                "paymentclause.png",
                                                "Payment Clause",
                                                jobDetailsModel.paymentclause ??
                                                    '',
                                                false)),
                                      ],
                                    ),
                                ],
                              ),
                            ),

                          /* Visibility(
                          visible: usertype == EUserType.jobSeeker.value,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                                size: 17,
                              ),
                              Text(
                                "100% Free & Verified job.",
                                style: GoogleFonts.varela(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ), */
                          /* Visibility(
                            visible: usertype == EUserType.jobSeeker.value,
                            child: const Padding(
                              padding: EdgeInsets.only(bottom: 4, left: 20),
                              child: Text(
                                "Report jobs that ask for money",
                                style: GoogleFonts.varela(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 101, 7, 0)),
                              ),
                            ),
                          ), */

                          /* SizedBox(
                          child: SizedBox(
                            width: double.infinity,
                            child: Card(
                              color: Constants.bgPanelColor,
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (jobDetailsModel.key_responsible !=
                                              null &&
                                          jobDetailsModel.key_responsible != "")
                                        keyPair(
                                            "keyresponsibility.png",
                                            "Job Description",
                                            jobDetailsModel.key_responsible
                                                .toString(),
                                            true),
                                      if (jobDetailsModel.eligibility != null &&
                                          jobDetailsModel.eligibility != "")
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      if (jobDetailsModel.eligibility != null &&
                                          jobDetailsModel.eligibility != "")
                                        keyPair(
                                            "elligibility.png",
                                            "Eligibility",
                                            jobDetailsModel.eligibility
                                                .toString(),
                                            true),
                                      if (jobDetailsModel.education != null &&
                                              jobDetailsModel.education != "" ||
                                          jobDetailsModel.languageKnow !=
                                                  null &&
                                              jobDetailsModel
                                                  .languageKnow!.isNotEmpty)
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (jobDetailsModel.languageKnow !=
                                                  null &&
                                              jobDetailsModel
                                                  .languageKnow!.isNotEmpty)
                                            Expanded(
                                                child: keyPair(
                                                    "languages.png",
                                                    "Language Required",
                                                    jobDetailsModel
                                                        .languageKnow!
                                                        .join(', ')
                                                        .toString(),
                                                    false)),
                                          if (jobDetailsModel.languageKnow !=
                                                  null &&
                                              jobDetailsModel
                                                  .languageKnow!.isNotEmpty)
                                            const SizedBox(
                                              width: 25,
                                            ),
                                          if (jobDetailsModel.education !=
                                                  null &&
                                              jobDetailsModel.education != "")
                                            Expanded(
                                                child: keyPair(
                                                    "education_d.png",
                                                    "Qualification",
                                                    jobDetailsModel.education
                                                        .toString(),
                                                    false)),
                                        ],
                                      ),
                                      const Divider(
                                        height: 1,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Visibility(
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                      child: keyPair(
                                                          "shifttimes.png",
                                                          "Shift Timing",
                                                          jobDetailsModel
                                                              .shifttime
                                                              .toString(),
                                                          false)),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  if (jobDetailsModel
                                                              .shiftdesc !=
                                                          null &&
                                                      jobDetailsModel
                                                              .shiftdesc !=
                                                          "")
                                                    Expanded(
                                                        child: keyPair(
                                                            "weeklyoff.png",
                                                            "Weekly Off",
                                                            jobDetailsModel
                                                                .shiftdesc
                                                                .toString(),
                                                            false)),
                                                ],
                                              ),
                                              const Divider(
                                                height: 1,
                                              ),
                                            ],
                                          ),
                                          visible: ((jobDetailsModel
                                                          .shifttime !=
                                                      null &&
                                                  jobDetailsModel.shifttime !=
                                                      "") ||
                                              jobDetailsModel.shiftdesc !=
                                                      null &&
                                                  jobDetailsModel.shiftdesc !=
                                                      "")),
                    
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      if (jobDetailsModel.salary != null &&
                                          jobDetailsModel.salary != "")
                                        keyPair(
                                            "salary.png",
                                            "Salary",
                                            jobDetailsModel.salary.toString(),
                                            true),
                                      if (jobDetailsModel.salary != null &&
                                          jobDetailsModel.salary != "")
                                        const SizedBox(
                                          height: 25,
                                        ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: keyPair(
                                                  "location.png",
                                                  "Work Location",
                                                  jobDetailsModel.location ??
                                                      'N/A',
                                                  false)),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          if (jobDetailsModel.boundrylmit !=
                                                  null &&
                                              jobDetailsModel.boundrylmit != "")
                                            Expanded(
                                                child: keyPair(
                                                    "area.png",
                                                    "Boundary limits",
                                                    jobDetailsModel.boundrylmit
                                                        .toString(),
                                                    false)),
                                        ],
                                      ),
                                      const Divider(
                                        height: 1,
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                    
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: keyPair(
                                                  "interview_round.png",
                                                  "Interview Rounds",
                                                  jobDetailsModel
                                                      .inteviewrounds!
                                                      .join(', ')
                                                      .toString(),
                                                  false)),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: keyPair(
                                                  "emptype.png",
                                                  "Employment Type",
                                                  jobDetailsModel.emptype
                                                      .toString(),
                                                  false)),
                                        ],
                                      ),
                                      // const Divider(
                                      //   height: 1,
                                      // ),
                                      if (usertype ==
                                              EUserType.businessPartner.value &&
                                          partner_request ==
                                              EPartnerApproval.approved.value)
                                        Row(children: const [
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Expanded(
                                              child: Divider(
                                            thickness: 1,
                                          )),
                                          Text(
                                            "Commercial",
                                            style: GoogleFonts.varela(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(
                                              child: Divider(
                                            thickness: 2,
                                          )),
                                        ]),
                    
                                      if (usertype ==
                                              EUserType.businessPartner.value &&
                                          partner_request ==
                                              EPartnerApproval.approved.value)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: keyPair(
                                                    "rupee.png",
                                                    "Payout",
                                                    jobDetailsModel.payout
                                                        .toString(),
                                                    false)),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: keyPair(
                                                    "paymentclause.png",
                                                    "Payment Clause",
                                                    jobDetailsModel
                                                            .paymentclause ??
                                                        '',
                                                    false)),
                                          ],
                                        ),
                    
                                      Visibility(
                                        visible: ((usertype ==
                                                    EUserType.businessPartner
                                                        .value &&
                                                partner_request ==
                                                    EPartnerApproval
                                                        .approved.value) ||
                                            usertype ==
                                                EUserType.employee.value),
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                              color: const Color.fromARGB(
                                                  255, 240, 240, 240),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: const [
                                                    Icon(
                                                      Icons
                                                          .warning_amber_outlined,
                                                      color: Colors.red,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "Asking job seekers for any kind of payment is strictly prohibited",
                                                        style: GoogleFonts.varela(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ), */

                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.only(
                              top: 10,
                              left: 20,
                              right: 20,
                            ),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Constants.borderColor),
                                color: Constants.themeBgColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      offset: const Offset(0, 0),
                                      blurRadius: 2)
                                ]),
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Refer your friend for above Job and get \npaid upto Rs. 1000/-",
                                          style: GoogleFonts.varela(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                ERoute.application.name,
                                                arguments: {
                                                  "isnew": false,
                                                  "prevModel": jobDetailsModel,
                                                  "refer": false
                                                });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 20),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Text(
                                              "Refer Now",
                                              style: GoogleFonts.varela(
                                                  fontSize: 14.sp,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 35,
                                        backgroundColor: Colors.white,
                                        child: Image.asset(
                                          "assets/images/moneybag.png",
                                          height: 40,
                                        ),
                                      ),
                                      // const Text("T & C apply")
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget customSkill(String title, bool isHash) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
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
}
