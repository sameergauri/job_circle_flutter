import 'package:flutter/material.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/job_details_model.dart';
import 'package:job_circle/service/DataService.dart';
import 'package:job_circle/service/JobSearchService.dart';
import 'package:job_circle/themes/colors.dart';

import '../../common/utils.dart';
import '../profile/application.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({Key? key, this.id}) : super(key: key);
  final int? id;

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  ScrollController _scrollController = ScrollController();
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
  @override
  void initState() {
    super.initState();
    fillCacheData();
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
    var result = await JobSearchService().getJobDetails({'id': id.toString()});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      setState(() {
        jobDetailsModel =
            JobDetailsModel.fromMap(Utils.parseResponse(result).resultData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(titleText),
        // bottom: PreferredSize(
        //   child: Text(subtitleText),
        //   preferredSize: const Size.fromHeight(0),
        //   // change height for changing app bar height as per content
        // ),

        // bottom: const PreferredSize(
        //     child: Text(
        //       "Search New Jobs",
        //       style:
        //           TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        //     ),
        //     preferredSize: Size.zero),
        elevation: appBarElevate,
        backgroundColor: currentAppBarColor,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: appBarIconColor, //change your color here
        ),
        //backgroundColor: Theme.of(context).primaryColor,
        actions: [
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
        ],
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
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: jobDetailsModel.id == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 239, 250, 255),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color.fromARGB(255, 213, 213, 213),
                                        spreadRadius: 0),
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.network(
                                      jobDetailsModel.icon.toString(),
                                      errorBuilder: ((context, error,
                                              stackTrace) =>
                                          Image.asset(
                                              "assets/images/company.png",
                                              height: 120,
                                              width: 120,
                                              fit: BoxFit.contain)),
                                      height: 100,
                                      width: 120,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      // jobDetailsModel.name
                                      jobDetailsModel.name.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          fontFamily: "Roboto"),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          jobDetailsModel.process.toString(),
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          "|",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          jobDetailsModel.rolename.toString(),
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    if (jobDetailsModel.naturofwork != null)
                                      Text(
                                        jobDetailsModel.naturofwork.toString(),
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14),
                                      ),
                                  ],
                                ),
                              ),
                              width: MediaQuery.of(context).size.width,
                            ),
                          ],
                        ),
                        // ]),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
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
                                                      .languageKnow!.length >
                                                  0)
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
                                                      .languageKnow!.length >
                                                  0)
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
                                                      .languageKnow!.length >
                                                  0)
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
                                            style: TextStyle(
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
                                    ]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          Container(
            height: 60,
            width: double.maxFinite,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(0.0)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                    visible: (usertype == EUserType.jobSeeker.value ||
                        usertype == EUserType.businessPartner.value),
                    child: ThemeButton(
                      width: 150,
                      radious: 0,
                      themeButtonSize: ThemeButtonSize.small,
                      onPressed: () {
                        Navigator.pushNamed(context, ERoute.application.name,
                            arguments: {
                              "isnew": false,
                              "prevModel": jobDetailsModel,
                            });
                      },
                      text: "APPLY",
                    )),
                Visibility(
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      ThemeButton(
                        width: 150,
                        radious: 0,
                        themeButtonSize: ThemeButtonSize.small,
                        onPressed: () {
                          Navigator.pushNamed(context, ERoute.application.name,
                              arguments: {
                                "isnew": true,
                                "prevModel": jobDetailsModel,
                              });
                        },
                        text: "New Line-up",
                      ),
                    ],
                  ),
                  visible: (usertype == EUserType.employee.value ||
                      (usertype == EUserType.businessPartner.value &&
                          partner_request == EPartnerApproval.approved.value)),
                )
              ],
            ),
          )
        ],
      )),
    );
  }

  Column keyPair(String imageName, String key, String value, bool devider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset("assets/images/" + imageName,
                height: 20, width: 20, fit: BoxFit.contain),
            // Icon(
            //   icon,
            //   size: 17,
            // ),
            const SizedBox(
              width: 3,
            ),
            Text(
              key,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Text(
            value,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black87),
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
