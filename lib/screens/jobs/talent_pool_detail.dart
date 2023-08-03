import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/customDialogue_Edit_CRPF.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';

import '../../themes/colors.dart';

class TalentPoolDetail extends StatefulWidget {
  final Applicant applicant;
  final List<String> Status;
  const TalentPoolDetail(
      {super.key, required this.applicant, required this.Status});

  @override
  State<TalentPoolDetail> createState() => _TalentPoolDetailState();
}

String calculateTotalExperience(
    String? lastWorkingDateStr, String? joiningDateStr) {
  // Check if either of the dates is null
  if (lastWorkingDateStr == null || joiningDateStr == null) {
    return 'N/A'; // Return 'N/A' if any date is null
  }

  // Parse the date strings into DateTime objects
  DateTime lastWorkingDate =
      DateTime.tryParse(lastWorkingDateStr) ?? DateTime.now();
  DateTime joiningDate = DateTime.tryParse(joiningDateStr) ?? DateTime.now();

  // Calculate the difference in years, months, and days
  int years = joiningDate.year - lastWorkingDate.year;
  int months = joiningDate.month - lastWorkingDate.month;
  int days = joiningDate.day - lastWorkingDate.day;

  // Adjust the months and years if the days difference is negative
  if (days < 0) {
    months--;
    // Calculate the number of days in the last month
    int lastMonthDays = DateTime(
      joiningDate.year,
      joiningDate.month,
      0,
    ).day;
    days += lastMonthDays;
  }

  if (months < 0) {
    years--;
    months += 12; // There are 12 months in a year
  }

  // Format the total experience as a string
  String totalExperience = '${years}y, ${months}m';
  return totalExperience;
}

int calculateAge(String dateOfBirth) {
  DateTime now = DateTime.now();
  DateTime dob = DateTime.parse(dateOfBirth);

  int age = now.year - dob.year;
  if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
    age--;
  }

  return age;
}

String? selectedStatus;

class _TalentPoolDetailState extends State<TalentPoolDetail>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  List<String> items = [];

  String convertSalaryFormat(String input) {
    // Extract numeric values from the input string
    List<int> salaryValues = [
      for (var value in input.split(' '))
        if (int.tryParse(value.trim().replaceAll(RegExp(r'[^\d]'), '')) != null)
          int.parse(value.trim().replaceAll(RegExp(r'[^\d]'), ''))
    ];

    if (salaryValues.isNotEmpty) {
      int salary = salaryValues[0];
      if (input.contains('Per Month')) {
        if (salary >= 1000) {
          double shortSalary = salary / 1000;
          return '${shortSalary.toStringAsFixed(shortSalary.truncateToDouble() == shortSalary ? 0 : 1)}k P.M';
        } else {
          return '$salary P.M';
        }
      } else if (input.contains("Lac's P.A")) {
        if (salary >= 100000) {
          double shortSalary = salary / 100000;
          return "${shortSalary.toStringAsFixed(shortSalary.truncateToDouble() == shortSalary ? 0 : 1)}L P.A";
        } else {
          return '$salary P.A';
        }
      }
    }

    // Handle other cases or return the input as it is if it doesn't match any pattern
    return input;
  }

  PopupMenuItem<String> customMenuItem(String option, bool isOdd) {
    return PopupMenuItem<String>(
      value: option,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Text(
          option,
          style: TextStyle(
            color: isOdd ? Colors.grey.shade400 : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  bool isSelect = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Lead Detail",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.applicant.applicantName
                              .toString()
                              .toTitleCase(),
                          style: GoogleFonts.varela(
                              fontSize: 22.sp, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Text(
                          "(${calculateAge(widget.applicant.dateOfBirth.toString())} yrs)",
                          style: GoogleFonts.varela(
                              fontSize: 15.sp, color: Colors.grey[600]),
                        )
                      ],
                    ),
                    Text(
                      "Last active 27 July 2023 *",
                      style: GoogleFonts.varela(
                          fontSize: 12.sp, color: Colors.grey[400]),
                    ),
                  ],
                ),
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://media.istockphoto.com/id/503040171/photo/middle-eastern-businessman-portrait.jpg?s=612x612&w=0&k=20&c=7t6c_HQHfUZNgrVtR-G1rQpJAMaCbFsuxppDRKBnXDw="),
                  // child: Text(item.applicantName[0].toUpperCase()),
                  radius: 25,
                ),
              ],
            ),
            Row(
              children: [
                if (widget.applicant.educationLevel != null)
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/graduate.png",
                        height: 13.h,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        widget.applicant.educationLevel.toString(),
                        style: GoogleFonts.varela(
                            fontSize: 13.sp, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                SizedBox(
                  width: 4.w,
                ),
                Image.asset(
                  "assets/images/bag.png",
                  height: 13.h,
                ),
                SizedBox(
                  width: 4.w,
                ),
                widget.applicant.isExperienced == "Experience" &&
                        widget.applicant.joiningDateRecent != null
                    ? Text(
                        calculateTotalExperience(
                          widget.applicant.joiningDateRecent,
                          widget.applicant.lastWorkingDateRecent,
                        ),
                        style: GoogleFonts.varela(
                            fontSize: 13.sp, color: Colors.grey[600]),
                      )
                    : Text(
                        "Fresher",
                        style: GoogleFonts.varela(
                            fontSize: 13.sp, color: Colors.grey[600]),
                      ),
                SizedBox(
                  width: 4.w,
                ),
                if (widget.applicant.userLocation != null)
                  Image.asset(
                    "assets/images/loc.png",
                    height: 13.h,
                  ),
                SizedBox(
                  width: 4.w,
                ),
                if (widget.applicant.userLocality != null)
                  Text(
                    "${widget.applicant.userLocality.toString().toTitleCase()}, ",
                    style: GoogleFonts.varela(
                        fontSize: 13.sp, color: Colors.grey[600]),
                  ),
                if (widget.applicant.userLocation != null)
                  Text(
                    widget.applicant.userLocation.toString().toTitleCase(),
                    style: GoogleFonts.varela(
                        fontSize: 13.sp, color: Colors.grey[600]),
                  )
              ],
            ),
            SizedBox(
              height: 6.h,
            ),
            if (widget.applicant.jobTitleRecent != null &&
                widget.applicant.companyNameRecent != null)
              Row(
                children: [
                  Text(
                    widget.applicant.jobTitleRecent.toString(),
                    style: GoogleFonts.varela(
                        fontSize: 13.sp, color: Colors.grey[600]),
                  ),
                  Text(
                    " at ",
                    style: GoogleFonts.varela(
                        fontSize: 13.sp, color: Colors.grey[600]),
                  ),
                  Text(
                    "${widget.applicant.companyNameRecent.toString()}.",
                    style: GoogleFonts.varela(
                        fontSize: 13.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600),
                  ),
                  const Text(""),
                  SizedBox(
                    width: 4.w,
                  ),
                  Icon(
                    Icons.currency_rupee_rounded,
                    size: 14.h,
                    color: Colors.grey[600],
                  ),
                  Expanded(
                    child: Text(
                      convertSalaryFormat(
                        widget.applicant.salaryRecent.toString(),
                      ),
                      style: GoogleFonts.varela(
                          fontSize: 13.sp, color: Colors.grey[600]),
                      softWrap: true,
                    ),
                  )
                ],
              ),
            Container(
              margin: EdgeInsets.only(bottom: 2, top: 4.h),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                  color: Constants.borderColor,
                  /* border: Border.all(color: Constants.borderColor
                  ), */
                  // color: Constants.borderColor,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return CustomDialogueForCRPF(
                            status: widget.Status,
                            selectedStatus: selectedStatus.toString(),
                            getStatus: (value) {
                              setState(() {
                                selectedStatus = value;
                              });
                            },
                            companyName:
                                widget.applicant.companyName.toString(),
                            process: widget.applicant.process.toString(),
                            role: widget.applicant.leadLevel.toString(),
                            isEdit: true,
                          );
                        },
                      );
                    },
                    child: Column(
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
                            widget.applicant.companyName.toString(),
                            style: GoogleFonts.varela(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500
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
                                "${widget.applicant.process} - ${widget.applicant.leadLevel}",
                                style: GoogleFonts.varela(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500
                                    // fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          setState(() {
                            selectedStatus = value;
                          });
                        },
                        itemBuilder: (BuildContext context) {
                          return widget.Status.asMap().entries.map((entry) {
                            int index = entry.key;
                            String option = entry.value;
                            bool isOdd = index % 2 == 1;
                            return customMenuItem(option, isOdd);
                          }).toList();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Constants.subtitleclr,
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Text(
                                selectedStatus ?? 'Please Select',
                                style: GoogleFonts.varela(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_drop_down,
                                size: 13,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                        offset: const Offset(0, 32),
                        elevation: 16,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),

                      /* DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        hint: const Text('Status'),
                        value: selectedStatus,
                        onChanged: (newValue) {
                          setState(() {
                            selectedStatus = newValue.toString();
                          });
                        },
                        items: widget.Status.map((location) {
                          return DropdownMenuItem<String>(
                            value: location,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(location),
                            ),
                          );
                        }).toList(),
                      ), */

                      /* Container(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: DropdownButton(
                          itemHeight: kMinInteractiveDimension,
                          borderRadius: BorderRadius.circular(8),
                          underline: Container(),
                          hint: const Text(
                              'Status'), // Not necessary for Option 1
                          value: selectedStatus,
                          onChanged: (newValue) {
                            setState(() {
                              selectedStatus = newValue.toString();
                            });
                          },
                          items: widget.Status.map((location) {
                            return DropdownMenuItem(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                child: Text(location),
                              ),
                              value: location,
                            );
                          }).toList(),
                        ),
                      ), */
                    ],
                  )
                ],
              ),
            ),
            TabBar(
              // indicatorPadding: EdgeInsets.zero,
              indicatorWeight: 2.0,
              unselectedLabelStyle: GoogleFonts.varela(),
              labelStyle: GoogleFonts.varela(fontWeight: FontWeight.w600),
              unselectedLabelColor: Colors.black,
              labelColor: Colors.red,
              indicatorPadding: EdgeInsets.only(
                  top: 4.5.h, bottom: 8.h, left: 3.w, right: 3.w),
              indicator: isSelect
                  ? BoxDecoration(
                      color: Constants.borderColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Constants.borderColor) // Creates border
                      )
                  : null,
              indicatorColor: Colors.red,
              onTap: (value) {
                setState(() {
                  isSelect = !isSelect;
                });
              },
              tabs: const [
                Tab(
                  text: "Recomended Jobs",
                ),
                Tab(text: "History")
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize
                  .tab, // Indicator height will be same as the tab height
              labelPadding: const EdgeInsets.symmetric(
                  vertical:
                      2), // Adjust the vertical padding for the tab labels
            ),
            Expanded(
              child: TabBarView(
                children: const [Text('people'), Text('Person')],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
