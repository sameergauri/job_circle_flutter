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

  JobDetailsModel jobDetailsModel = JobDetailsModel();

  @override
  void initState() {
    super.initState();

    // Calling For Job Details
    getJobDetails();

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
      if (_scrollController.position.extentBefore > 230 &&
          currentAppBarColor == appBgColor) {
        currentAppBarColor = appBgScrolledColor;

        appBarIconColor = Colors.black;
        setState(() {});
      } else if (_scrollController.position.extentBefore <= 230 &&
          currentAppBarColor == appBgScrolledColor) {
        currentAppBarColor = appBgColor;
        appBarIconColor = Colors.white;
        setState(() {});
      }
    });
  }

  getJobDetails() async {
    var result =
        await JobSearchService().getJobDetails({'id': widget.id.toString()});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      jobDetailsModel =
          JobDetailsModel.fromMap(Utils.parseResponse(result).resultData);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(""),
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
          SizedBox(
            width: 100,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Icon(
                Icons.share_outlined,
                color: appBarIconColor,
              ),
              const SizedBox(
                width: 15,
              ),
              Icon(
                Icons.favorite_border_outlined,
                color: appBarIconColor,
              ),
              const SizedBox(
                width: 20,
              ),
            ]),
          ),
        ],
      ),
      backgroundColor: Constants.bgPanelColor,
      bottomNavigationBar: Container(
        color: Constants.bgPanelColor,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ThemeButton(
            // icon: const Icon(
            //   Icons.arrow_forward,
            //   color: Color(0xffffffff),
            //   size: 25,
            // ),
            radious: 0,
            onPressed: () {
              // print(jobDetailsModel);
              // Navigator.pushNamed(context, ERoute.application.name);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ApplicationForm(
                            prevModel: jobDetailsModel,
                          )));
            },
            text: "APPLY",
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        controller: _scrollController,
        child: jobDetailsModel.id == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Stack(children: [
                    Container(
                      height: 190,
                      margin: const EdgeInsets.only(top: 0),
                      padding: const EdgeInsets.only(top: 0),
                      decoration: const BoxDecoration(
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Color.fromARGB(255, 245, 245, 245),
                          //     blurRadius: 10.0,
                          //     offset: Offset(2, 2),
                          //   ),
                          // ],
                          //color: Theme.of(context).primaryColor,
                          color: Constants.themeBgColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: const Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Constants.bgPanelColor,
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(255, 213, 213, 213),
                                    spreadRadius: 1),
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.network(
                                  jobDetailsModel.icon.toString(),
                                  errorBuilder: ((context, error, stackTrace) =>
                                      Image.asset("assets/images/male.png",
                                          height: 100,
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
                                // Row(
                                //   crossAxisAlignment: CrossAxisAlignment.center,
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     const Icon(
                                //       Icons.location_city,
                                //       size: 17,
                                //     ),
                                //     const SizedBox(
                                //       width: 5,
                                //     ),
                                //     Text(
                                //       jobDetailsModel.location.toString(),
                                //       style: const TextStyle(
                                //           color: Colors.black54, fontSize: 14),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                          width: MediaQuery.of(context).size.width - 50,
                        ),
                      ],
                    ),
                  ]),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: keyPair(
                                            "male.png",
                                            "Role",
                                            jobDetailsModel.rolename
                                                .toString())),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: keyPair(
                                            "location.png",
                                            "Work Location",
                                            jobDetailsModel.location
                                                .toString())),
                                  ],
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                keyPair(
                                    "keyresponsibility.png",
                                    "Key Responsiblility",
                                    jobDetailsModel.key_responsible.toString()),
                                const SizedBox(
                                  height: 25,
                                ),
                                keyPair("elligibility.png", "Eligibility",
                                    jobDetailsModel.eligibility.toString()),
                                const SizedBox(
                                  height: 25,
                                ),
                                keyPair("shifttime.png", "Shift Timing",
                                    jobDetailsModel.shifttime.toString()),
                                const SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: keyPair(
                                            "male.png",
                                            "Process",
                                            jobDetailsModel.process
                                                .toString())),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: keyPair(
                                            "interview_round.png",
                                            "Interview Rounds",
                                            jobDetailsModel.inteviewrounds!
                                                .join(' > ')
                                                .toString())),
                                  ],
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: keyPair(
                                            "rupee.png",
                                            "CTC/Inhand",
                                            jobDetailsModel.ctcdesc
                                                .toString())),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: keyPair(
                                            "paymentclause.png",
                                            "Payment Clause",
                                            jobDetailsModel.paymentclause ??
                                                '')),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                    ),
                  )
                ],
              ),
      )),
    );
  }

  Column keyPair(String imageName, String key, String value) {
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
        const Divider(
          height: 1,
        )
      ],
    );
  }
}
