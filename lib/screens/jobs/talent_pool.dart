import 'dart:convert';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/models/job_details_model.dart';
import 'package:job_circle/screens/jobs/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/utils.dart';
import '../../constants/customdialogue_for_call_whatsapp.dart';
import '../../models/profileSummary.dart';
import '../../service/UserDataService.dart';
import '../../themes/colors.dart';

//enum Issue { no, incorrect, recruiter, other }

class TalentPool extends StatefulWidget {
  const TalentPool({
    super.key,
  });

  @override
  State<TalentPool> createState() => _TalentPoolState();
}

class _TalentPoolState extends State<TalentPool>
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
        profilemodel = ProfileSummaryModel.fromMap(dataResult);
      });
    } else {
      // Handle the case when the API call fails
      setState(() {
        profilemodel =
            ProfileSummaryModel(); // or set it to an appropriate default value
      });
    }
  }

  Future<List<Applicant>> fetchAllApplicants() async {
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/leads/v1/getAllAppliedJobs?page=1&size=10');
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

  int calculateAge(String dateOfBirth) {
    DateTime now = DateTime.now();
    DateTime dob = DateTime.parse(dateOfBirth);

    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }

    return age;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (profilemodel == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      // Build your widget's UI with the 'profilemodel' data
      // For example:
      return FutureBuilder<List<Applicant>>(
        future: fetchAllApplicants(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final data = snapshot.data!;
            final statuses =
                data.map((e) => e.status.toString()).toSet().toList().toList();
            statuses.sort();
            return DefaultTabController(
              length: statuses.length,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize:
                      const Size(double.maxFinite, kTextTabBarHeight),
                  child: AppBar(
                    backgroundColor: Colors.white,
                    bottom: TabBar(
                      labelPadding: const EdgeInsets.only(left: 5, right: 5),
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
                              color: Constants.borderColor) // Creates border
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
                body: TabBarView(
                  children: statuses
                      .map(
                        (e) => ListView(
                          shrinkWrap: true,
                          children: data
                              .where(
                                (applicant) => applicant.status.toString() == e,
                              )
                              .map(
                                (e) => listViewItem_new(context, e, true),
                              )
                              .toList(),
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          }
          return const SizedBox();
        },
      );
    }
  }

  Widget listViewItem_new(BuildContext context, Applicant item, bool isTrue) {
    // List<String>? myStrings;
    //  bool stopIteration = false;

    return Stack(
      children: [
        InkWell(
          onTap: () {
            item.status == "Application"
                ? null
                : Navigator.pushNamed(
                    context,
                    ERoute.jobsdetail.name,
                    arguments: {
                      'id': item.jobId,
                    },
                  );
          },
          child: SwipeTo(
            iconOnRightSwipe: Icons.call,
            iconOnLeftSwipe: Icons.sms_outlined,
            onRightSwipe: item.alternateNo == 0
                ? () async {
                    FlutterPhoneDirectCaller.callNumber("+91${item.contactNo}");
                  }
                : () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                          phoneNumber1: item.contactNo,
                          phoneNumber2: item.alternateNo,
                          isCall: true,
                        );
                      },
                    );
                  },
            onLeftSwipe: item.alternateNo == 0
                ? () async {
                    Uri url =
                        Uri.parse("whatsapp://send?phone=91${item.contactNo}");
                    await canLaunchUrl(url)
                        ? await launchUrl(url)
                        : throw "could not launch $url";
                  }
                : () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                          phoneNumber1: item.contactNo,
                          phoneNumber2: item.alternateNo,
                          isCall: false,
                        );
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
              child: ExpansionTileCard(
                  //key: cardB,
                  trailing: const Icon(null),
                  leading: const CircleAvatar(child: Text('A')),
                  title: Row(
                    children: [
                      Text(item.applicantName.toString()),
                      Text(" (${calculateAge(item.dateofbirth)})")
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      item.qualification == ""
                          ? Text(item.isExperienced)
                          : Text(
                              "${item.qualification.toString()}  |  ${item.isExperienced}")
                    ],
                  ),
                  children: <Widget>[
                    const Divider(
                      thickness: 1.0,
                      height: 1.0,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 10),
                      // padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [Text("${item.process} - ${item.level}")],
                          ),
                          Text(item.companyName)
                        ],
                      ),
                    )
                    
                  ]),
            ),
          ),
        ),
        if (item.resume != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PDFViewerScreen(
                          pdfAssetPath: 'assets/images/cv.pdf',
                          phoneNumber1: item.contactNo,
                          phoneNumber2: item.alternateNo,
                          // Replace with the actual asset path of your PDF file
                        ),
                      ),
                    );
                  },
                  icon: Image.asset(
                    "assets/images/cv.png",
                    height: 15.h,
                  )),
            ),
          )
      ],
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
