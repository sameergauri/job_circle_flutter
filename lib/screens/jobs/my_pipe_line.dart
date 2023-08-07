import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/screens/jobs/pdf.dart';
import 'package:job_circle/service/data_get_api_service.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/customdialogue_for_call_whatsapp.dart';
import '../../constants/drop_down_class.dart';
import '../../models/application_status_model.dart';
import '../../themes/colors.dart';

//enum Issue { no, incorrect, recruiter, other }

class MyPipeLine extends StatefulWidget {
  const MyPipeLine({
    super.key,
  });

  @override
  State<MyPipeLine> createState() => _MyPipeLineState();
}

class _MyPipeLineState extends State<MyPipeLine>
    with SingleTickerProviderStateMixin {
  @override
  Future<List<Applicant>>? _applicantsFuture;
  List<Application>? applicationList = [];
  void fetchData() async {
    try {
      ApplicationAPI api = ApplicationAPI();
      applicationList = await api.getApplicationStatusList();
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // bindProfileSummary();
    fetchData();

    //  _applicantsFuture = fetchApplicantsByUserId(552);
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

  String? selectedStatusValue;

  List<String> getStatuses(List<Applicant> applicants) {
    return applicants
        .where((e) => e.status_code!.contains('MP'))
        .map((e) => e.status.toString())
        .toSet()
        .toList()
      ..sort();
  }

  bool isSelect = false;

  Map<int, SelectedOption> selectedValueMap = {};
  final GlobalKey<_MyPipeLineState> _talentPollKey =
      GlobalKey<_MyPipeLineState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // Build your widget's UI with the 'profilemodel' data
    // For example:
    return FutureBuilder<List<Applicant>>(
      future: fetchAllApplicants(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data!;
          final statuses = getStatuses(data); // Get the statuses here

          return DefaultTabController(
            length: statuses.length,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize:
                    Size(double.maxFinite, kTextTabBarHeight / 1.2.h),
                child: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  bottom: TabBar(
                    labelPadding: const EdgeInsets.only(left: 5, right: 5),
                    labelColor: Colors.black,
                    isScrollable: true,
                    unselectedLabelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.tab,
                    splashBorderRadius: BorderRadius.circular(8),
                    indicatorWeight: 7.h,
                    indicatorPadding:
                        EdgeInsets.only(bottom: 8.h, left: 3.w, right: 3.w),
                    indicator: BoxDecoration(
                      color: Constants.borderColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Constants.borderColor),
                    ),
                    tabs: statuses
                        .map(
                          (status) => customTab(
                            status, // Show status in the top-level tab bar
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  setState(
                      () {}); // This will trigger the rebuild of the widget tree
                },
                child: TabBarView(
                  children: statuses.map((status) {
                    // Filter applicants based on the current status
                    final applicants = data
                        .where((applicant) =>
                            applicant.status.toString() == status)
                        .toList();

                    if (status == 'New') {
                      // Display applicants directly without sub_status tabs
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: applicants.length,
                        itemBuilder: (context, index) {
                          final applicant = applicants[index];
                          return listViewItem_new(
                            context,
                            applicant,
                            true,
                            statuses,
                            index,
                          );
                        },
                      );
                    } else {
                      // Proceed with sub_status tabs for other statuses
                      final subStatuses = applicants
                          .map((applicant) => applicant.sub_status?.toString())
                          .where((subStatus) => subStatus != null)
                          .toSet()
                          .toList()
                        ..sort();
                      // Second tab bar needed for subStatuses
                      return DefaultTabController(
                        length: subStatuses.length,
                        child: Scaffold(
                          appBar: PreferredSize(
                            preferredSize:
                                const Size(double.maxFinite, kTextTabBarHeight),
                            child: AppBar(
                              //elevation: 0,
                              backgroundColor: Colors.white,
                              bottom: TabBar(
                                isScrollable: true,
                                indicatorSize: TabBarIndicatorSize.tab,
                                //indicatorWeight: 2.0,
                                unselectedLabelStyle: GoogleFonts.varela(),
                                labelStyle: GoogleFonts.varela(
                                    fontWeight: FontWeight.w600),
                                unselectedLabelColor: Colors.black,
                                labelColor: Constants.subtitleclr,
                                indicatorPadding: EdgeInsets.only(
                                    bottom: 8.h, left: 3.w, right: 3.w),
                                indicator: isSelect
                                    ? BoxDecoration(
                                        color: Constants.borderColor,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Constants
                                                .borderColor) // Creates border
                                        )
                                    : null,
                                indicatorColor: Constants.borderColor,
                                /*  onTap: (value) {
                                  setState(() {
                                    isSelect = !isSelect;
                                  });
                                }, */
                                tabs: subStatuses
                                    .map((subStatus) => Tab(text: subStatus!))
                                    .toList(),
                              ),
                            ),
                          ),
                          body: TabBarView(
                            children: subStatuses.map((subStatus) {
                              // Filter applicants based on the current status and sub_status
                              final filteredApplicants = applicants
                                  .where((applicant) =>
                                      applicant.sub_status.toString() ==
                                      subStatus)
                                  .toList();

                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: filteredApplicants.length,
                                itemBuilder: (context, index) {
                                  final applicant = filteredApplicants[index];

                                  return listViewItem_new(
                                    context,
                                    applicant,
                                    true,
                                    statuses,
                                    index,
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }
                  }).toList(),
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget listViewItem_new(BuildContext context, Applicant item, bool isTrue,
      List<String> status, int index) {
    return Stack(
      children: [
        InkWell(
          onTap: () {},
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
                          phoneNumber1: item.contactNo!.toInt(),
                          phoneNumber2: item.alternateNo!.toInt(),
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
                          phoneNumber1: item.contactNo!.toInt(),
                          phoneNumber2: item.alternateNo!.toInt(),
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
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://media.istockphoto.com/id/503040171/photo/middle-eastern-businessman-portrait.jpg?s=612x612&w=0&k=20&c=7t6c_HQHfUZNgrVtR-G1rQpJAMaCbFsuxppDRKBnXDw="),
                          // child: Text(item.applicantName[0].toUpperCase()),
                          radius: 22,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  item.applicantName.toString(),
                                  style: GoogleFonts.varela(
                                    // color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  " (${calculateAge(item.dateOfBirth.toString())} yr's)",
                                  style: GoogleFonts.varela(
                                      color: Colors.black54, fontSize: 12.sp),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                item.qualification == null
                                    ? Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/bag.png",
                                            height: 12.h,
                                            //  color: Constants.subtitleclr,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            item.isExperienced.toString(),
                                            style: GoogleFonts.varela(
                                              color: Colors.black54,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/graduate.png",
                                            height: 15.h,
                                            //  color: Constants.subtitleclr,
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            "${item.qualification.toString()}  |  ",
                                            style: GoogleFonts.varela(
                                              color: Colors.black54,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Image.asset(
                                            "assets/images/bag.png",
                                            height: 12.h,
                                            //  color: Constants.subtitleclr,
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            " ${item.isExperienced}",
                                            style: GoogleFonts.varela(
                                              color: Colors.black54,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Constants.borderColor,
                          /* border: Border.all(color: Constants.borderColor
                  ), */
                          // color: Constants.borderColor,
                          borderRadius: BorderRadius.circular(8)),
                      margin: EdgeInsets.only(bottom: 2, top: 6.h),
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      // padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 2),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: Constants.borderColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  item.companyName.toString(),
                                  style: GoogleFonts.varela(
                                    color: Colors.black54,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: Constants.borderColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "${item.process} - ${item.leadLevel}",
                                      style: GoogleFonts.varela(
                                        color: Colors.black54,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              // Declare selectedStatus as a class-level variable

// ...
                              item.status != "Selected"
                                  ? item.status == "Reject"
                                      ? Image.asset(
                                          "assets/images/selected.jpg",
                                          height: 40.h,
                                        )
                                      : Image.asset(
                                          "assets/images/reject.jpg",
                                          height: 25.h,
                                        )
                                  : Container(
                                      margin: EdgeInsets.only(right: 10.w),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          border: Border.all(
                                              color: Constants.borderColor)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 6),
                                      child: Text(
                                        item.sub_status.toString(),
                                        style: GoogleFonts.varela(
                                            fontWeight: FontWeight.w600),
                                      ))
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        if (item.resume != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PDFViewerScreen(
                              pdfAssetPath: 'assets/images/cv.pdf',
                              phoneNumber1: item.contactNo!.toInt(),
                              phoneNumber2: item.alternateNo!.toInt(),
                              // Replace with the actual asset path of your PDF file
                            ),
                          ),
                        );
                      },
                      icon: Image.asset(
                        "assets/images/cv.png",
                        height: 15.h,
                      )),
                ],
              ),
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
