// ignore_for_file: must_be_immutable, unused_local_variable, unused_result, unnecessary_null_comparison, non_constant_identifier_names, avoid_print, use_build_context_synchronously, avoid_unnecessary_containers, deprecated_member_use, unused_element
// ignore_for_file: todo
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_circle/constants/customButton_for_jobPosting.dart';
import 'package:job_circle/constants/custom_network_image.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/job_details_model.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/jobs/Applied_jobs.dart';
import 'package:job_circle/screens/jobs/curve_painter.dart';
import 'package:job_circle/screens/new_jobs/add_cv_to_apply.dart';
import 'package:job_circle/service/JobSearchService.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/utils.dart';
import 'add_resume.dart';
import 'matching_jobs.dart';

/* final favJobProvider = FutureProvider.family<FavJobModel?, int>(
    (ref, id) => JobSearchService().getFavoriteJob(id)); */

class JobDetails extends ConsumerStatefulWidget {
  int? id;
  bool Applies;
  bool referal;
  int is_freelancer;
  int? userType;
  // String? userrole;

  JobDetails({
    super.key,
    this.id,
    required this.Applies,
    required this.referal,
    required this.is_freelancer,
    this.userType,
    // this.userrole
  });

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
  int usertype = 0;

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

  /* String formatSalaryRange(double minSalary, double maxSalary) {
    String formattedMinSalary = '';
    String formattedMaxSalary = '';

    if (minSalary >= 100000) {
      formattedMinSalary = (minSalary / 100000).toStringAsFixed(2);
    } else if (minSalary >= 1000) {
      formattedMinSalary = '${(minSalary / 1000).toStringAsFixed(1)}k';
    } else {
      formattedMinSalary = minSalary.toStringAsFixed(1);
    }

    if (maxSalary >= 100000) {
      formattedMaxSalary = (maxSalary / 100000).toStringAsFixed(2);
    } else if (maxSalary >= 1000) {
      formattedMaxSalary = '${(maxSalary / 1000).toStringAsFixed(1)}k';
    } else {
      formattedMaxSalary = maxSalary.toStringAsFixed(1);
    }

    return maxSalary == 0.0
        ? formattedMinSalary
        : '$formattedMinSalary - $formattedMaxSalary';
  } */
  /*  String formatSalaryRange(double minSalary, double maxSalary) {
    String formattedMinSalary = '';
    String formattedMaxSalary = '';

    if (minSalary >= 100000) {
      formattedMinSalary = (minSalary / 100000).toStringAsFixed(2);
    } else if (minSalary >= 1000) {
      formattedMinSalary = '${(minSalary / 1000).toStringAsFixed(2)}k';
    } else {
      formattedMinSalary = minSalary.toStringAsFixed(2);
    }

    if (maxSalary >= 100000) {
      formattedMaxSalary = (maxSalary / 100000).toStringAsFixed(2);
    } else if (maxSalary >= 1000) {
      formattedMaxSalary = '${(maxSalary / 1000).toStringAsFixed(2)}k';
    } else {
      formattedMaxSalary = maxSalary.toStringAsFixed(2);
    }

    // Remove ".00" if present
    formattedMinSalary = formattedMinSalary.replaceAll(RegExp(r'\.00$'), '');
    formattedMaxSalary = formattedMaxSalary.replaceAll(RegExp(r'\.00$'), '');

    return maxSalary == 0.0
        ? formattedMinSalary
        : '$formattedMinSalary - $formattedMaxSalary';
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
    int? userid = int.tryParse(id.toString());
    var result = await UserDataService().getUserProfileSummary(userid!);

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
    // fillCacheData();
    // benefit();
    //   const RestrictedButton();
    fetchJobs();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var type = await Utils.getPreferencesValue(
          null, ESharedPreferences.user_type.name);
      usertype = int.tryParse(type.toString())!;
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

  /*  fillCacheData() async {
    partner_request = await Utils.getCacheData('partner_request');
    setState(() {});
  } */

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

  @override
  Widget build(BuildContext context) {
    //final favProvider = ref.watch(favJobProvider(widget.id ?? 0));
    // bool isFav = favProvider.value?.isFav ?? false;
    return Scaffold(
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
                /* Image.asset(
                  "assets/images/proces.png",
                  height: 12.h,
                  //color: Colors.black45,
                ),
                const SizedBox(
                  width: 5,
                ), */
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
                  jobDetailsModel.naturofwork != null ? " ||" : "",
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
                  jobDetailsModel.naturofwork != null
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
        /* Text(
          "Job Details",
          style: GoogleFonts.varela(fontSize: 16.h),
        ), */
        actions: [
          jobDetailsModel.icon != ""
              ? Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: CustomImage(
                    imageUrl:
                        "https://s3.ap-south-1.amazonaws.com/job-circle-2/${jobDetailsModel.icon}",
                    defaultImageUrl: "assets/images/logo.png",
                    height: 80,
                  )
                  /* Image.network(
                    "https://s3.ap-south-1.amazonaws.com/job-circle-2/${jobDetailsModel.icon}",
                    fit: BoxFit.contain,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        isLoading = false;
                      }
                      return isLoading
                          ? const Center(
                              child:
                                  CircularProgressIndicator(), // Customize the loading indicator here.
                            )
                          : child;
                    },
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      // Display the default icon when there's an error loading the image.
                      return const SizedBox();
                    },
                  ) */
                  /* Image.network(
                    "https://s3.ap-south-1.amazonaws.com/job-circle-2/${jobDetailsModel.icon}",
                    fit: BoxFit.contain,
                  ), */
                  )
              : const SizedBox()
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
      bottomNavigationBar: jobDetailsModel.id != null
          ? Container(
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
                    if (profilemodel.id == jobDetailsModel.spoc)
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MatchingJobs()));
                          /* JobPostApiService.postJobApply(
                            jobId: item['id'],
                            userId: int.parse(profilemodel.id.toString()),
                            context: context);
                        /*  Navigator.pushNamed(context, ERoute.application.name,
                            arguments: {
                              "isnew": false,
                              "prevModel": jobDetailsModel,
                              "refer": true,
                              "cmpnyname": item['companyname'].toString()
                            }); */ */
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10, left: 20.w),
                          padding: EdgeInsets.symmetric(
                              vertical: 4.h, horizontal: 8.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: Constants.subtitleclr),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Matching CV",
                                style: TextStyle(
                                  color: Constants.subtitleclr,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    usertype == EUserType.jobSeeker.value ||
                            usertype == EUserType.businessPartner.value
                        ? const SizedBox(
                            width: 10,
                          )
                        : const SizedBox(),
                    /*   Visibility(   //TODO: coming soon
                visible: (usertype == EUserType.jobSeeker.value),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
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
              ), */
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
                                usertype == EUserType.businessPartner.value) &&
                            (!widget.Applies && !widget.referal),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddResume(
                                          // report_to: profilemodel.report_to!.toInt(),
                                          company_name:
                                              jobDetailsModel.name.toString(),
                                          role: jobDetailsModel.rolename
                                              .toString(),
                                          process: jobDetailsModel.process
                                              .toString(),
                                          nature_of_work: jobDetailsModel
                                              .naturofwork
                                              .toString(),
                                          company_id: jobDetailsModel.compnayid!
                                              .toInt(),
                                          jobId: jobDetailsModel.id!.toInt(),
                                          // sourceId: profilemodel.id!.toInt(),
                                          // sourceName:
                                          //     "${profilemodel.first_name.toString()} ${profilemodel.last_name.toString()}",
                                          isRefer: true,
                                          spocId: jobDetailsModel.spoc!.toInt(),
                                          is90:
                                              jobDetailsModel.payment_clause ==
                                                      "90 Days"
                                                  ? true
                                                  : false,
                                          is30:
                                              jobDetailsModel.payment_clause ==
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
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade400,
                                      //  blurRadius: 10,
                                      blurRadius: 15.0,
                                      offset: const Offset(1, 1))
                                ],
                                color: Constants.darkBlue,
                                borderRadius: BorderRadius.circular(8.r)),
                            child: const customTextForWeather(
                                title: "Refer Now",
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ) /* InkWell(  //TODO:: Apply button for job apply
                    onTap: () async {
                      CoolingForApply apiresult =
                          await ApplicationAPI.getStatusAndDolOfUser(
                              companyId: jobDetailsModel.compnayid!.toInt(),
                              process: jobDetailsModel.process.toString(),
                              role: jobDetailsModel.rolename.toString(),
                              now: jobDetailsModel.naturofwork.toString());
                      DateTime dolDate = apiresult.dol != ""
                          ? DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ")
                              .parse(apiresult.dol)
                          : DateTime.now();
                      DateTime currentDate = DateTime.now();
                      int differenceInDays =
                          currentDate.difference(dolDate).inDays;
                      final diff = differenceInDays > 30;
                      if (jobDetailsModel.id == apiresult.jobid) {
                        if (apiresult.status != "Interview bay" &&
                            apiresult.status != "Assign" &&
                            apiresult.status != "Application" &&
                            diff) {
                          if (profilemodel.cv_link != null) {
                            await JobPostApiService.postJobApply(
                              context: context,
                              jobId: int.parse(jobDetailsModel.id.toString()),
                              // userId: int.parse(profilemodel.id.toString()
                              userId: await Utils.getPreferencesValue(
                                  null, ESharedPreferences.user_id.name),
                              number: await Utils.getPreferencesValue(
                                  null, ESharedPreferences.user_mobile.name),
                            );
                            ref.refresh(fetchAllApplyProvider);
                            ref.refresh(fetchAllTalentPoolProvider);
                          } else {
                            if (jobDetailsModel.id != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddCvtoApply(
                                            jobId: jobDetailsModel.id!.toInt(),
                                          )));
                            }
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialog(
                                  fetchDataFromApi: () {},
                                  onClose: () {
                                    Navigator.pop(context);
                                  },
                                  isFisrt: false,
                                  title: "Error",
                                  subtitle:
                                      "Your CV is already in process in the PipeLine");
                            },
                          );
                        }
                      } else {
                        if (profilemodel.cv_link != null) {
                          await JobPostApiService.postJobApply(
                              jobId: jobDetailsModel.id!.toInt(),
                              userId: await Utils.getPreferencesValue(
                                  null, ESharedPreferences.user_id.name),
                              number: await Utils.getPreferencesValue(
                                  null, ESharedPreferences.user_mobile.name),
                              context: context);
                          ref.refresh(fetchAllApplyProvider);
                          ref.refresh(fetchAllTalentPoolProvider);
                        } else {
                          if (jobDetailsModel.id != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddCvtoApply(
                                          jobId: jobDetailsModel.id!.toInt(),
                                        )));
                          }
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Constants.navyblue),
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        "Apply",
                        style: GoogleFonts.varela(
                            color: Constants.navyblue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ) */
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
                      visible: usertype == 3,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddResume(
                                        // report_to: profilemodel.report_to!.toInt(),
                                        company_name:
                                            jobDetailsModel.name.toString(),
                                        role:
                                            jobDetailsModel.rolename.toString(),
                                        process:
                                            jobDetailsModel.process.toString(),
                                        nature_of_work: jobDetailsModel
                                            .naturofwork
                                            .toString(),
                                        company_id:
                                            jobDetailsModel.compnayid!.toInt(),
                                        jobId: jobDetailsModel.id!.toInt(),
                                        // sourceId: profilemodel.id!.toInt(),
                                        // sourceName:
                                        //     "${profilemodel.first_name.toString()} ${profilemodel.last_name.toString()}",
                                        isRefer: false,
                                        spocId: jobDetailsModel.spoc!.toInt(),
                                        is90: jobDetailsModel.payment_clause ==
                                                "90 Days"
                                            ? true
                                            : false,
                                        is30: jobDetailsModel.payment_clause ==
                                                "30 Days"
                                            ? true
                                            : false,
                                        userNumber:
                                            profilemodel.mobile!.toInt(),
                                        useAlternateNumber:
                                            profilemodel.alternate_no!.toInt(),
                                        interviewRounds: jobDetailsModel
                                            .interviewrounds!.first
                                            .replaceAll('[', '')
                                            .replaceAll(']', '')
                                            .replaceAll('"', ''),
                                      )));
                          /* JobPostApiService.postJobApply(
                              jobId: item['id'],
                              userId: int.parse(profilemodel.id.toString()),
                              context: context);
                          /*  Navigator.pushNamed(context, ERoute.application.name,
                              arguments: {
                                "isnew": false,
                                "prevModel": jobDetailsModel,
                                "refer": true,
                                "cmpnyname": item['companyname'].toString()
                              }); */ */
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: EdgeInsets.symmetric(
                              vertical: 4.h, horizontal: 8.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: Constants.blue),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add,
                                color: Constants.blue,
                                size: 15.h,
                              ),
                              Text(
                                "Resume",
                                style: TextStyle(
                                  color: Constants.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    /*  Visibility(
                child: Row(
                  children: [
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
              ), */
                    usertype == EUserType.businessPartner.value
                        ? const SizedBox(
                            width: 10,
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            )
          : const SizedBox(),
      body: jobDetailsModel.id == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*  Column(
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
                    const SizedBox(
                      height: 10,
                    ), */
                    /*  if (jobDetailsModel.name.toString().isNotEmpty)
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
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 13.sp),
                                            )
                                          : Text(
                                              "${jobDetailsModel.minexperience.toString().replaceAll(".0", "")} Years & above.",
                                              style: GoogleFonts.varela(
                                                  // color: Colors.black54,
                                                  color: Colors.grey.shade700,
                                                  fontWeight: FontWeight.normal,
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

                    /* Row(
                                children: [
                                  Image.asset(
                                    "assets/images/bag.png",
                                    height: 12.5.h,
                                    color: Colors.grey.shade700,
                                  ),
                                  SizedBox(
                                    width: 7.w,
                                  ),
                                  jobDetailsModel.maxexperience == "& above"
                                      ? SizedBox(
                                          child: Text(
                                            "${jobDetailsModel.minexperience.toString().replaceAll(".0", "")} Month & above.",
                                            style: GoogleFonts.varela(
                                                color: Colors.grey.shade700,
                                                // color: Colors.black54,
                                                //fontWeight: FontWeight.normal,
                                                fontSize: 13.sp),
                                          ),
                                        )
                                      : SizedBox(
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
                              ), */
                    if (jobDetailsModel.minctc != null &&
                        jobDetailsModel.maxctc != null)
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/wallet.png",
                            height: 12.5.h,
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
                            "${formatSalaryRange(jobDetailsModel.minctc!.toInt(), jobDetailsModel.maxctc!.toInt())} ${jobDetailsModel.ismonthly ?? ""}",
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
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/loc.png",
                          height: 12.5.h,
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

                    // ]),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                      color:
                                                          Colors.grey.shade700,
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
                                                        color: Colors
                                                            .grey.shade700),
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
                                            : jobDetailsModel.gender
                                                        .toString() ==
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
                                          : jobDetailsModel.shifttime ==
                                                  "🌙 Night"
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
                      margin: EdgeInsets.only(
                          top: 10, left: 1, right: 1, bottom: 5.h),
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
                                          .map((item) =>
                                              customSkill(item, false)),
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
                                      ...jobDetailsModel.skills!.map(
                                          (item) => customSkill(item, true)),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                      color:
                                                          Colors.grey.shade700,
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
                                          children: jobDetailsModel
                                                  .boundarylimits
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
                                        padding: EdgeInsets.only(left: 5.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: jobDetailsModel.moredetails
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
                        margin:
                            const EdgeInsets.only(top: 10, left: 1, right: 1),
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
                                  fontWeight: FontWeight
                                      .normal, // Set normal for this part
                                  fontSize: 14,
                                  color: Colors.black, // Adjust color as needed
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    //  if (widget.userrole != "1")
                    Visibility(
                      visible: (usertype == EUserType.jobSeeker.value ||
                              usertype == EUserType.businessPartner.value) &&
                          (!widget.Applies && !widget.referal),
                      child: CustomButtonForJobPosting(
                          buttonText: "Apply Now",
                          onTap: () async {
                            String id = await Utils.getPreferencesValue(
                                null, ESharedPreferences.user_id.name);
                            /*  CoolingForApply apiresult =
                              await ApplicationAPI.getStatusAndDolOfUser(
                                  companyId: jobDetailsModel.compnayid!.toInt(),
                                  process: jobDetailsModel.process.toString(),
                                  role: jobDetailsModel.rolename.toString(),
                                  now: jobDetailsModel.naturofwork.toString());
                          DateTime dolDate; */

                            /*  if (apiresult.dol != null &&
                              apiresult.dol.isNotEmpty &&
                              apiresult.dol != "N/A") {
                            try {
                              dolDate =
                                  DateFormat("yyyy-MM-dd").parse(apiresult.dol);
                            } catch (e) {
                              print("Invalid date format: ${apiresult.dol}");
                              dolDate = DateTime.now(); // Default fallback date
                            }
                          } else {
                            dolDate = DateTime.now(); // Default fallback date
                          } */
                            /*  DateTime currentDate = DateTime.now();
                          int differenceInDays =
                              currentDate.difference(dolDate).inDays;
                          final diff = differenceInDays > 30; */
                            /* if (jobDetailsModel.id == apiresult.jobid) {
                            if (apiresult.status != "Interview bay" &&
                                apiresult.status != "Assign" &&
                                apiresult.status != "Application" &&
                                diff) { */
                            if (profilemodel.cv_link != null &&
                                profilemodel.cv_link != " ") {
                              await JobPostApiService.postJobApply(
                                addcv: false,
                                context: context,
                                jobId: jobDetailsModel.id!,
                                // userId: int.parse(profilemodel.id.toString()
                                userId: int.tryParse(id)!,
                              );
                              ref.refresh(fetchAllApplyProvider);
                              
                            } else {
                              if (jobDetailsModel.id != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddCvtoApply(
                                              jobId:
                                                  jobDetailsModel.id!.toInt(),
                                              userid: int.tryParse(id)!,
                                            )));
                              }
                            }
                          } /* else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomDialog(
                                      fetchDataFromApi: () {},
                                      onClose: () {
                                        Navigator.pop(context);
                                      },
                                      isFisrt: false,
                                      title: "Error",
                                      subtitle:
                                          "Your CV is already in process in the PipeLine");
                                },
                              );
                            } */
                          /*  else {
                            if (profilemodel.cv_link != null) {
                              await JobPostApiService.postJobApply(
                                  jobId: jobDetailsModel.id!,
                                  userId: int.tryParse(id.toString())!,
                                  context: context);
                              ref.refresh(fetchAllApplyProvider);
                              ref.refresh(fetchAllTalentPoolProvider);
                            } else {
                              if (jobDetailsModel.id != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddCvtoApply(
                                              jobId:
                                                  jobDetailsModel.id!.toInt(),
                                            )));
                              }
                            }
                          } */

                          ),
                    ),
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
                          margin:
                              const EdgeInsets.only(top: 10, left: 1, right: 1),
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
                              if (jobDetailsModel.interviewrounds != null)
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
                                    ? Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                              "https://s3.ap-south-1.amazonaws.com/job-circle-2/${jobDetailsModel.spoc_profile_pic}",
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            child: Image.asset(
                                              "assets/images/verify.png",
                                              height: 15,
                                              //color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox())),
                      ],
                    ),
                    if (usertype == EUserType.businessPartner.value &&
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
                        margin:
                            const EdgeInsets.only(top: 10, left: 1, right: 1),
                        child: Column(
                          children: [
                            if (usertype == EUserType.businessPartner.value &&
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
                            if (usertype == EUserType.businessPartner.value &&
                                partner_request ==
                                    EPartnerApproval.approved.value)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: keyPair(
                                          "rupee.png",
                                          "Payout",
                                          jobDetailsModel.payout.toString(),
                                          false)),
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
                          visible: usertype != 3,
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.only(
                              top: 2,
                              left: 20,
                              right: 5,
                            ),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Constants.borderColor),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 5),
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
                                                                  color: Colors
                                                                      .amber,
                                                                ),
                                                                Text(
                                                                  "Payout will update soon!",
                                                                  style: GoogleFonts.varela(
                                                                      fontSize:
                                                                          16.sp,
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
                                                /* InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    AddResume(
                                                                      report_to: profilemodel
                                                                          .report_to!
                                                                          .toInt(),
                                                                      company_name: jobDetailsModel
                                                                          .name
                                                                          .toString(),
                                                                      role: jobDetailsModel
                                                                          .rolename
                                                                          .toString(),
                                                                      process: jobDetailsModel
                                                                          .process
                                                                          .toString(),
                                                                      nature_of_work: jobDetailsModel
                                                                          .naturofwork
                                                                          .toString(),
                                                                      company_id: jobDetailsModel
                                                                          .compnayid!
                                                                          .toInt(),
                                                                      jobId: jobDetailsModel
                                                                          .id!
                                                                          .toInt(),
                                                                      sourceId: profilemodel
                                                                          .id!
                                                                          .toInt(),
                                                                      sourceName:
                                                                          "${profilemodel.first_name.toString()} ${profilemodel.last_name.toString()}",
                                                                      isRefer:
                                                                          true,
                                                                      spocId: jobDetailsModel
                                                                          .spoc!
                                                                          .toInt(),
                                                                      is90: jobDetailsModel.payment_clause ==
                                                                              "90 Days"
                                                                          ? true
                                                                          : false,
                                                                      is30: jobDetailsModel.payment_clause ==
                                                                              "30 Days"
                                                                          ? true
                                                                          : false,
                                                                      userNumber: profilemodel
                                                                          .mobile!
                                                                          .toInt(),
                                                                      useAlternateNumber:
                                                                          profilemodel.alternate_no?.toInt() ??
                                                                              0,
                                                                      interviewRounds: jobDetailsModel
                                                                          .interviewrounds!
                                                                          .first
                                                                          .replaceAll(
                                                                              '[',
                                                                              '')
                                                                          .replaceAll(
                                                                              ']',
                                                                              '')
                                                                          .replaceAll(
                                                                              '"',
                                                                              ''),
                                                                    )));
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 6,
                                                        horizontal: 15),
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.white),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors.grey
                                                                  .shade400,
                                                              //  blurRadius: 10,
                                                              blurRadius: 15.0,
                                                              offset:
                                                                  const Offset(
                                                                      1, 1))
                                                        ],
                                                        color: Constants
                                                            .borderColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.r)),
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
                                                ) */
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
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
                        visible: usertype != 3,
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
                                                  fontWeight:
                                                      FontWeight.normal),
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
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .currency_rupee_outlined,
                                                      color: Colors.amber,
                                                    ),
                                                    Text(
                                                      "${(jobDetailsModel.flatAmount)?.toStringAsFixed(0)}/-",
                                                      style: GoogleFonts.varela(
                                                          fontSize: 20.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            if (jobDetailsModel.slabAmount !=
                                                null)
                                              Text(
                                                "${(double.tryParse(jobDetailsModel.slabAmount![0])!).toStringAsFixed(0)} to ${(double.tryParse(jobDetailsModel.slabAmount![jobDetailsModel.slabAmount!.length - 1])!).toStringAsFixed(0)} ",
                                                style: GoogleFonts.varela(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.indigo,
                                                ),
                                              ),
                                            SuperTooltip(
                                              popupDirection:
                                                  TooltipDirection.up,
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "Min",
                                                        style:
                                                            GoogleFonts.varela(
                                                          color: Constants
                                                              .subtitleclr,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "Max",
                                                        style:
                                                            GoogleFonts.varela(
                                                          color: Constants
                                                              .subtitleclr,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "Amt",
                                                        style:
                                                            GoogleFonts.varela(
                                                          color: Constants
                                                              .subtitleclr,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                rows: List<DataRow>.generate(
                                                  jobDetailsModel
                                                      .minCount!.length,
                                                  (index) => DataRow(
                                                    cells: [
                                                      DataCell(
                                                        Container(
                                                          // width: 52,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            _formatSlab(
                                                                jobDetailsModel
                                                                        .minCount![
                                                                    index]),
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
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  jobDetailsModel
                                                                          .maxCount![
                                                                      index],
                                                                  style:
                                                                      GoogleFonts
                                                                          .varela(
                                                                    color: Constants
                                                                        .subtitleclr,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        13.sp,
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  "& above",
                                                                  style:
                                                                      GoogleFonts
                                                                          .varela(
                                                                    color: Constants
                                                                        .subtitleclr,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        13.sp,
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
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "${_formatSlabAmount(double.tryParse(jobDetailsModel.slabAmount?[index] ?? '0.0'))}/-",
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                  if (jobDetailsModel.partnerPayout ==
                                      'CTC Based')
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                  if (jobDetailsModel.partnerPayout ==
                                      "Work Pay")
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                    Icons
                                                        .currency_rupee_outlined,
                                                    color: Colors.amber,
                                                    //size: 15.sp,
                                                  ),
                                                  Text(
                                                    "${(jobDetailsModel.partner_fresher_pay)?.toStringAsFixed(0)}/-",
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
                                                        style:
                                                            GoogleFonts.varela(
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
                                                                "${jobDetailsModel.partner_fresher_pay!.toStringAsFixed(0)}%",
                                                            style: GoogleFonts.varela(
                                                                fontSize: 18.sp,
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
                                                        style:
                                                            GoogleFonts.varela(
                                                                fontSize: 8.sp,
                                                                letterSpacing:
                                                                    1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .indigo),
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
                                                        Icons
                                                            .currency_rupee_outlined,
                                                        color: Colors.amber,
                                                        //size: 15.sp,
                                                      ),
                                                      Text(
                                                        "${(jobDetailsModel.partner_exp_pay)?.toStringAsFixed(0)}/-",
                                                        style:
                                                            GoogleFonts.varela(
                                                                fontSize: 20.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .indigo),
                                                      ),
                                                      Column(
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
                                                                style: GoogleFonts.varela(
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
                                                                        fontSize: 14
                                                                            .sp,
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
                                                                letterSpacing:
                                                                    1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .indigo),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  /* InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddResume(
                                                    report_to: profilemodel
                                                        .report_to!
                                                        .toInt(),
                                                    company_name:
                                                        jobDetailsModel.name
                                                            .toString(),
                                                    role: jobDetailsModel
                                                        .rolename
                                                        .toString(),
                                                    process: jobDetailsModel
                                                        .process
                                                        .toString(),
                                                    nature_of_work:
                                                        jobDetailsModel
                                                            .naturofwork
                                                            .toString(),
                                                    company_id: jobDetailsModel
                                                        .compnayid!
                                                        .toInt(),
                                                    jobId: jobDetailsModel.id!
                                                        .toInt(),
                                                    sourceId: profilemodel.id!
                                                        .toInt(),
                                                    sourceName:
                                                        "${profilemodel.first_name.toString()} ${profilemodel.last_name.toString()}",
                                                    isRefer: true,
                                                    spocId: jobDetailsModel
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
                                                    userNumber: profilemodel
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
                                                            .replaceAll('[', '')
                                                            .replaceAll(']', '')
                                                            .replaceAll(
                                                                '"', ''),
                                                  )));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 15),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.shade400,
                                                //  blurRadius: 10,
                                                blurRadius: 15.0,
                                                offset: const Offset(1, 1))
                                          ],
                                          color: Constants.borderColor,
                                          borderRadius:
                                              BorderRadius.circular(8.r)),
                                      child: Text(
                                        "Refer Now",
                                        style: GoogleFonts.varela(
                                            fontSize: 14.sp,
                                            letterSpacing: 1,
                                            color: Colors.indigo,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ) */
                                ],
                              ),
                              Positioned(
                                bottom: jobDetailsModel.payoutType == 'Slab'
                                    ? 10.h
                                    : 0.h,
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
                                  padding:
                                      const EdgeInsets.only(bottom: 5, top: 5),
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

                    /* Visibility(  //TODO: Refer card before 28/10/2023
                      visible: usertype != 3,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 20,
                          right: 20,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(color: Constants.borderColor),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AddResume(
                                                      company_name:
                                                          jobDetailsModel.name
                                                              .toString(),
                                                      role: jobDetailsModel
                                                          .rolename
                                                          .toString(),
                                                      process: jobDetailsModel
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
                                                      jobId: jobDetailsModel.id!
                                                          .toInt(),
                                                      sourceId: profilemodel.id!
                                                          .toInt(),
                                                      sourceName:
                                                          "${profilemodel.first_name.toString()} ${profilemodel.last_name.toString()}",
                                                      isRefer: true,
                                                      spocId: jobDetailsModel
                                                          .spoc!
                                                          .toInt(),
                                                    )));
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
                      ),
                    ) */
                  ],
                ),
              ),
            ),
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

  String _formatAmount(double? amount) {
    if (amount == null) {
      return 'N/A'; // Handle null values gracefully
    } else {
      return amount
          .toStringAsFixed(0); // Keep two decimal places for other values
    }
  }

  String _formatSlabFix(double? amount) {
    if (amount == null) {
      return 'N/A'; // Handle null values gracefully
    } else {
      return amount
          .toStringAsFixed(2); // Keep two decimal places for other values
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
}
