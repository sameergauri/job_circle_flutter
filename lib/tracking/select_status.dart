// ignore_for_file: unused_result, unused_local_variable, avoid_print, avoid_unnecessary_containers, use_full_hex_values_for_flutter_colors, use_build_context_synchronously
// ignore_for_file: todo
import 'dart:ui';

import 'package:awesome_calendar/awesome_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/customSnackBar.dart';
import 'package:job_circle/constants/custom_dialogue_join.dart';
import 'package:job_circle/constants/custom_dialogue_select.dart';
import 'package:job_circle/models/changeStatusModel.dart';
import 'package:job_circle/models/drop_down_model.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/screens/jobs/Applied_jobs.dart';
import 'package:job_circle/screens/jobs/Interview_bay_cc.dart';
import 'package:job_circle/screens/jobs/interview_bay_executive.dart';
import 'package:job_circle/screens/jobs/talent_pool_detail.dart';
import 'package:job_circle/screens/refer_now.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';

class SelectStatus extends ConsumerStatefulWidget {
  final Applicant item;
  final List<DropDownItem> finalDropDownItemforJoinNot;
  final List<DropDownItem> finalDropDownItemforReadyOffer;
  final List<DropDownItem> finalDropDownItemForTrainingDrop;
  const SelectStatus(
      {super.key,
      required this.item,
      required this.finalDropDownItemforJoinNot,
      required this.finalDropDownItemforReadyOffer,
      required this.finalDropDownItemForTrainingDrop});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectStatusState();
}

class _SelectStatusState extends ConsumerState<SelectStatus> {
  @override
  void initState() {
    /*  if (widget.item.salary != null) {
      salaryController.text = widget.item.salary.toString();
    }
    if (widget.item.emp_id != null) {
      empIdController.text = widget.item.emp_id.toString();
    }
    if (widget.item.is_exp != null) {
      widget.item.is_exp == 1 ? experience = true : fresher = true;
    } */

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    salaryController.clear();
    empIdController.clear();

    // Perform cleanup tasks here
    // Release resources, cancel subscriptions, etc.
    super.dispose(); // Call the superclass dispose method if needed
  }

  DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
  DateTime today = DateTime.now();
  DateTime? doj;
  DateTime initialDate = DateTime.now();
  DateTime lastAllowedDate = DateTime.now().add(const Duration(days: 4 * 31));
  DateTime? singleSelect;

  Future<void> singleSelectPicker() async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AwesomeCalendarDialog(
          initialDate: initialDate,
          startDate: initialDate,
          endDate: lastAllowedDate,
          selectionMode: SelectionMode.single,
          cancelBtnText: "",
          confirmBtnText: "Submit",
        );
      },
    );
    if (picked != null) {
      setState(() {
        singleSelect = picked;
      });
      print(picked);
      NewChangeStatusModel changeStatusModel =
          NewChangeStatusModel(doj: picked);
      Map<String, dynamic> jsonData = changeStatusModel.toJson();
      try {
        await JobPostApiService.NewchangeStatus(
            jsonData, widget.item.id!.toInt());
        ref.refresh(fetchAllApplicantProvider);
        ref.refresh(fetchAllExecutiveProvide);
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isLoading = false;
          });
        });
        // First pop to close the dialog
      } catch (e) {
        print('Error: $e');
        // Handle error...
      }
    }
  }

  TextEditingController salaryController = TextEditingController();
  TextEditingController empIdController = TextEditingController();

  bool fresher = false, experience = false;
  bool isSalaryEdit = false;
  bool isEmpIdEdit = false;
  bool under = false, submited = false, notSubmited = false;
  FocusNode salaryFocuNode = FocusNode();
  FocusNode empIdFocusNode = FocusNode();

  TextEditingController remark = TextEditingController();
  TextEditingController remark2 = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    if (widget.item.salary != null) {
      salaryController.text = widget.item.salary.toString();
    }
    if (widget.item.emp_id != null) {
      empIdController.text = widget.item.emp_id.toString();
    }
    if (widget.item.is_exp != null) {
      widget.item.is_exp == 1 ? experience = true : fresher = true;
    }
    DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
    DateTime today = DateTime.now();
    DateTime? doj;
    if (widget.item.doj != null) {
      doj = DateTime(
          widget.item.doj!.year, widget.item.doj!.month, widget.item.doj!.day);
    }
    DateTime today1 = DateTime(today.year, today.month, today.day);

    bool isToday = doj != null && doj.isAtSameMomentAs(today1);

    DateTime yesterday = today1.subtract(const Duration(days: 1));
    bool isYesterday = doj != null && doj.isAtSameMomentAs(yesterday);

    DateTime initialDate = DateTime.now();
    DateTime lastAllowedDate = DateTime.now().add(const Duration(days: 4 * 31));
    DateTime? singleSelect;

    return Stack(
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (widget.item.gender != null)
                    widget.item.profilePic != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://s3.ap-south-1.amazonaws.com/job-circle-2/${widget.item.profilePic}"),
                            // child: Text(item.applicantName[0].toUpperCase()),
                            radius: 22,
                          )
                        : CircleAvatar(
                            backgroundColor: Constants.bgColorWhite,
                            backgroundImage: AssetImage(
                                widget.item.gender == "Male"
                                    ? "assets/images/leadmale.png"
                                    : "assets/images/leadfemal.png"),
                            // child: Text(item.applicantName[0].toUpperCase()),
                            radius: 22,
                          ),
                  if (widget.item.gender == null)
                    widget.item.profilePic != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://s3.ap-south-1.amazonaws.com/job-circle-2/${widget.item.profilePic}"),
                            // child: Text(item.applicantName[0].toUpperCase()),
                            radius: 22,
                          )
                        : CircleAvatar(
                            backgroundColor: Constants.borderColor,
                            // child: Text(item.applicantName[0].toUpperCase()),
                            radius: 22,
                            child: Text(
                              widget.item.applicantName!.isNotEmpty
                                  ? widget.item.applicantName![0].toUpperCase()
                                  : 'N', // Default to 'N' if the name is empty
                              style: const TextStyle(
                                color: Constants.themeBgColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                  const SizedBox(
                    width: 6,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${widget.item.applicantName.toString().toTitleCase()} ${widget.item.last_name.toString().toTitleCase()}",
                            style: GoogleFonts.varela(
                              fontStyle: FontStyle.normal,
                              // color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.item.dateOfBirth != null)
                            Text(
                              " (${calculateAge(widget.item.dateOfBirth.toString())} yr's)",
                              style: GoogleFonts.varela(
                                  color: Colors.black54, fontSize: 12.sp),
                            )
                        ],
                      ),
                      Row(
                        children: [
                          /*  widget.item.qualification == null
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
                                      widget.item.isExperienced.toString(),
                                      style: GoogleFonts.varela(
                                        color: Colors.black54,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              : */
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/process.png",
                                height: 12.h,
                                //  color: Constants.subtitleclr,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                "${widget.item.process.toString()}  |  ",
                                style: GoogleFonts.varela(
                                  color: Colors.black54,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              Image.asset(
                                "assets/images/designation.png",
                                height: 12.h,
                                //  color: Constants.subtitleclr,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                " ${widget.item.role_code != null && widget.item.role_code != "" ? widget.item.role_code : widget.item.lead_level}",
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
              // //TODO:: ui for not join, offer decline and training dropout....
              //
              //
              //
              //
              //
              //
              if (widget.item.status_id == 16 ||
                  widget.item.status_id == 17 ||
                  widget.item.status_id == 19)
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/images/cmpny.png",
                                    height: 12.5.h,
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  Text(
                                    widget.item.short_name != null
                                        ? widget.item.short_name.toString()
                                        : widget.item.companyName.toString(),
                                    style: GoogleFonts.varela(
                                        // color: Colors.black54,
                                        color: Constants.subtitleclr,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13.sp),
                                  ),
                                ],
                              ),
                              if (widget.item.hr_status_id != 14)
                                SizedBox(
                                  height: 4.h,
                                ),
                              if (widget.item.hr_status_id != 14)
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/documentStatus.png",
                                          height: 15.sp,
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Text(
                                          widget.item.document_status ==
                                                  "Schedule F2F"
                                              ? "Pending"
                                              : widget.item.document_status
                                                  .toString(),
                                          style: GoogleFonts.varela(
                                              // color: Colors.black54,
                                              color: Constants.subtitleclr,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 13.sp),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              if (widget.item.hr_status_id != 14)
                                SizedBox(
                                  height: 4.h,
                                ),
                              if (widget.item.hr_status_id != 14)
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month_outlined,
                                          size: 15.sp,
                                          color: Constants.blue,
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Text(
                                          widget.item.doj != null
                                              ? DateFormat('dd MMM yyyy')
                                                  .format(widget.item.doj!)
                                              : "Pending",
                                          style: GoogleFonts.varela(
                                              // color: Colors.black54,
                                              color: Constants.subtitleclr,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 13.sp),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "assets/images/loc.png",
                                      height: 12.5.sp,
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Expanded(
                                      child: Text(
                                        widget.item.workLocation.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        style: GoogleFonts.varela(
                                          fontSize: 13.sp,
                                          color: Constants.subtitleclr,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                if (widget.item.hr_status_id != 14)
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                if (widget.item.hr_status_id != 14 &&
                                    widget.item.emp_id != null &&
                                    widget.item.emp_id != "")
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        "assets/images/id-card.png",
                                        height: 12.5.sp,
                                        color: Constants.blue,
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Expanded(
                                        child: Text(
                                          widget.item.emp_id.toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: GoogleFonts.varela(
                                            fontSize: 13.sp,
                                            color: Constants.subtitleclr,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                if (widget.item.hr_status_id != 14)
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                if (widget.item.hr_status_id != 14)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.currency_rupee_outlined,
                                        size: 15.sp,
                                        color: Constants.blue,
                                      ),
                                      Text(
                                        widget.item.salary != null
                                            ? "${widget.item.salary}"
                                            : "Pending",
                                        style: GoogleFonts.varela(
                                          fontSize: 13.sp,
                                          color: Constants.subtitleclr,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8.r),
                          // border: Border.all(color: Colors.grey.shade400)
                        ),
                        margin: EdgeInsets.only(top: 4.h),
                        padding: EdgeInsets.only(
                            left: 4.w, right: 4.w, top: 6.h, bottom: 6.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.item.remark ?? "",
                              style: GoogleFonts.varela(
                                fontStyle: FontStyle.italic,
                                // color: Constants.subtitleclr,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              //
              //
              //
              //
              //
              //

              // //TODO:: ui for select and ready to join.....
              //
              //
              //
              //
              //
              if (widget.item.status_id != 16 &&
                  widget.item.status_id != 17 &&
                  widget.item.status_id != 19)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 4.h),
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        // horizontal: 8,
                      ),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/cmpny.png",
                            height: 15.sp,
                          ),
                          SizedBox(width: 4.sp),
                          Text(
                            widget.item.short_name != null
                                ? widget.item.short_name.toString()
                                : widget.item.companyName.toString(),
                            style: GoogleFonts.varela(
                              color: Constants.navyblue,

                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          /*  if (widget.item.status_id == 18)
                      Container(
                        margin: EdgeInsets.only(bottom: 10.h, right: 10.w),
                        child: Image.asset(
                          "assets/images/Join.png",
                          height: 15.h,
                        ),
                      ),
                    if (widget.item.status_id == 15) //TODO:: Ready to join.
                      Container(
                        margin: EdgeInsets.only(bottom: 10.h, right: 10.w),
                        child: Image.asset(
                          "assets/images/readytojoin.png",
                          height: 30.h,
                        ),
                      ), */
                        ],
                      ),
                    ),

                    //TODO:: Document Status{
                    //
                    //
                    //
                    //
                    //
                    //
                    //
                    //
                    //}
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 2,
                        ),
                        Text("Documentation Status",
                            style: GoogleFonts.varela(
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 4.h,
                        ),
                        Wrap(
                          children: [
                            InkWell(
                              onTap: () async {
                                if (widget.item.document_status !=
                                        "Under Review" &&
                                    widget.item.document_status !=
                                        "Submitted" &&
                                    widget.item.document_status !=
                                        "Not Submitted") {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  NewChangeStatusModel changeStatusModel =
                                      NewChangeStatusModel(
                                    /* status: "IB7",
                                            subStatus: item.sub_code == "IB7-4"
                                                ? "Ready to Join"
                                                : "Confirmation Pending", */

                                    doj: widget.item.doj,
                                    document_status: "Not Submitted",
                                  );
                                  Map<String, dynamic> jsonData =
                                      changeStatusModel.toJson();
                                  try {
                                    await JobPostApiService.NewchangeStatus(
                                        jsonData, widget.item.id!.toInt());
                                    ref.refresh(fetchAllApplicantProvider);
                                    ref.refresh(fetchAllExecutiveProvide);

                                    setState(() {
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      });
                                    });

                                    // First pop to close the dialog
                                  } catch (e) {
                                    print('Error: $e');
                                    // Handle error...
                                  }
                                }
                              },
                              child: widget.item.document_status !=
                                          "Under Review" &&
                                      widget.item.document_status != "Submitted"
                                  ? Container(
                                      margin: EdgeInsets.only(right: 6.w),
                                      decoration: BoxDecoration(
                                          color: widget.item.document_status ==
                                                  "Not Submitted"
                                              ? Colors.red
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          border: Border.all(
                                              color: Constants.borderColor)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 10),
                                      child: Text("Pending",
                                          style: GoogleFonts.varela(
                                              color:
                                                  widget.item.document_status ==
                                                          "Not Submitted"
                                                      ? Colors.white
                                                      : Colors.black)),
                                    )
                                  : disableContainer("Pending"),
                            ),
                            InkWell(
                                onTap: () async {
                                  if (widget.item.document_status !=
                                          "Submitted" &&
                                      widget.item.document_status !=
                                          "Under Review") {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    NewChangeStatusModel changeStatusModel =
                                        NewChangeStatusModel(
                                            /* status: "IB7",
                                                    subStatus: item.sub_code ==
                                                            "IB7-4"
                                                        ? "Ready to Join"
                                                        : "Confirmation Pending", */

                                            doj: widget.item.doj,
                                            document_status: "Under Review");
                                    Map<String, dynamic> jsonData =
                                        changeStatusModel.toJson();
                                    try {
                                      await JobPostApiService.NewchangeStatus(
                                          jsonData, widget.item.id!.toInt());

                                      ref.refresh(fetchAllApplicantProvider);
                                      ref.refresh(fetchAllExecutiveProvide);

                                      setState(() {
                                        Future.delayed(
                                            const Duration(seconds: 2), () {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        });
                                      });
                                      // First pop to close the dialog
                                    } catch (e) {
                                      print('Error: $e');
                                      // Handle error...
                                    }
                                  }
                                },
                                child: widget.item.document_status !=
                                        "Submitted"
                                    ? Container(
                                        margin: EdgeInsets.only(right: 6.w),
                                        decoration: BoxDecoration(
                                            color:
                                                widget.item.document_status ==
                                                        "Under Review"
                                                    ? Colors.orangeAccent
                                                    : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            border: Border.all(
                                                color: Constants.borderColor)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 10),
                                        child: Text("Under Review",
                                            style: GoogleFonts.varela(
                                                color: widget.item
                                                            .document_status ==
                                                        "Under Review"
                                                    ? Colors.white
                                                    : Colors.black)),
                                      )
                                    : disableContainer("Under Review")),
                            InkWell(
                                onTap: () async {
                                  if (widget.item.document_status ==
                                          "Under Review" ||
                                      widget.item.document_status ==
                                              "Not Submitted" &&
                                          widget.item.mode_document == 1) {
                                    setState(() {
                                      isLoading = true;
                                      notSubmited = false;
                                      submited = true;
                                      under = false;
                                    });
                                    NewChangeStatusModel changeStatusModel =
                                        NewChangeStatusModel(
                                            /* status: "IB7",
                                                  subStatus:
                                                      item.sub_code == "IB7-4"
                                                          ? "Ready to Join"
                                                          : "Confirmation Pending", */

                                            doj: widget.item.doj,
                                            document_status: "Submitted");
                                    Map<String, dynamic> jsonData =
                                        changeStatusModel.toJson();
                                    try {
                                      await JobPostApiService.NewchangeStatus(
                                          jsonData, widget.item.id!.toInt());

                                      ref.refresh(fetchAllApplicantProvider);
                                      ref.refresh(fetchAllExecutiveProvide);
                                      setState(() {
                                        Future.delayed(
                                            const Duration(seconds: 2), () {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        });
                                      });
                                      // First pop to close the dialog
                                    } catch (e) {
                                      print('Error: $e');
                                      // Handle error...
                                    }
                                  }
                                },
                                child: widget.item.document_status !=
                                        "Submitted"
                                    ? Container(
                                        margin: EdgeInsets.only(right: 6.w),
                                        decoration: BoxDecoration(
                                            color:
                                                widget.item.document_status ==
                                                        "Submitted"
                                                    ? Colors.green
                                                    : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            border: Border.all(
                                                color: Constants.borderColor)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 10),
                                        child: Text("Submitted",
                                            style: GoogleFonts.varela(
                                                color: widget.item
                                                                .document_status ==
                                                            "Submitted" &&
                                                        widget.item
                                                                .mode_document ==
                                                            1
                                                    ? Colors.white
                                                    : Colors.black)),
                                      )
                                    : disableContainer("Submitted")),
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        )
                      ],
                    ),
                    //
                    //
                    //
                    //
                    //
                    //
                    //
                    //
                    //TODO:: Documenrt Status}

                    if (widget.item.company_workstatus == 1
                        // &&widget.item.is_exp == null  //TODO: use to hide the worktype data when that have data on it...
                        )
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Work Status",
                              style: GoogleFonts.varela(
                                  fontSize: 14.sp, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                customContainerMale(
                                    onPressed: () async {
                                      setState(() {
                                        fresher = !fresher;
                                        experience = false;
                                      });
                                      NewChangeStatusModel changeStatusModel =
                                          NewChangeStatusModel(
                                              doj: widget.item.doj, isExp: 0);
                                      Map<String, dynamic> jsonData =
                                          changeStatusModel.toJson();
                                      try {
                                        await JobPostApiService.NewchangeStatus(
                                            jsonData, widget.item.id!.toInt());
                                        ref.refresh(fetchAllApplicantProvider);
                                        ref.refresh(fetchAllExecutiveProvide);
                                      } catch (e) {
                                        print('Error: $e');
                                        // Handle error...
                                      }
                                    },
                                    isSelect: fresher,
                                    title: "Fresher",
                                    img: "",
                                    isimage: false),
                                customContainerMale(
                                    onPressed: () async {
                                      setState(() {
                                        fresher = false;

                                        experience = !experience;
                                      });
                                      NewChangeStatusModel changeStatusModel =
                                          NewChangeStatusModel(
                                              doj: widget.item.doj, isExp: 1);
                                      Map<String, dynamic> jsonData =
                                          changeStatusModel.toJson();
                                      try {
                                        await JobPostApiService.NewchangeStatus(
                                            jsonData, widget.item.id!.toInt());
                                        ref.refresh(fetchAllApplicantProvider);
                                        ref.refresh(fetchAllExecutiveProvide);
                                      } catch (e) {
                                        print('Error: $e');
                                        // Handle error...
                                      }
                                    },
                                    isSelect: experience,
                                    title: "Experience",
                                    img: "",
                                    isimage: false)
                              ],
                            ),
                          ],
                        ),
                      ),
                    // if ((widget.item.is_ctc_pay == 1 || widget.item.is_work_pay == 1))  //TODO:: Salary is allow for every lead
                    //&&widget.item.salary == null  //TODO: use to hide the salary field when that have data on it...

                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          margin: EdgeInsets.only(top: 8.h, bottom: 4.h),
                          height: MediaQuery.of(context).size.height / 35,
                          child: TextField(
                            autofocus: true,
                            focusNode: salaryFocuNode,
                            enabled: isSalaryEdit,
                            maxLength: 7,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],

                            keyboardType: TextInputType.number,
                            //textInputAction: TextInputAction.s, // Set TextInputAction to sentences
                            textCapitalization: TextCapitalization.sentences,
                            controller: salaryController,

                            style: GoogleFonts.varela(
                                color: Constants.subtitleclr, fontSize: 14.sp),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(
                                  Icons.currency_rupee_outlined,
                                  color: Constants.subtitleclr,
                                  size: 15.h,
                                ),
                                contentPadding: const EdgeInsets.only(
                                    top: 8, left: 10, right: 10),
                                counterText: '',
                                labelText: "CTC",
                                labelStyle: const TextStyle(
                                  color: Constants.subtitleclr,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide:
                                      BorderSide(color: Constants.lightdull),
                                ),
                                focusColor: const Color(0xffff0eceb),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: Constants.subtitleclr,
                                  ),
                                ),
                                hintText: "20,000",
                                hintStyle: GoogleFonts.sourceSansPro(
                                    color: Constants.hintColor,
                                    fontSize: 15.sp)),
                          ),
                        ),
                        isSalaryEdit == true
                            ? InkWell(
                                onTap: () async {
                                  setState(() {
                                    isSalaryEdit = false;
                                  });
                                  NewChangeStatusModel changeStatusModel =
                                      NewChangeStatusModel(
                                    doj: widget.item.doj,
                                    salary: salaryController.text.isNotEmpty
                                        ? double.tryParse(salaryController.text)
                                        : null,
                                  );
                                  Map<String, dynamic> jsonData =
                                      changeStatusModel.toJson();
                                  try {
                                    await JobPostApiService.NewchangeStatus(
                                        jsonData, widget.item.id!.toInt());
                                    ref.refresh(fetchAllApplicantProvider);
                                    ref.refresh(fetchAllExecutiveProvide);
                                  } catch (e) {
                                    print('Error: $e');
                                    // Handle error...
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2.h, horizontal: 4.w),
                                  child: Text("Submit",
                                      style: GoogleFonts.varela(
                                          color: isSalaryEdit
                                              ? Colors.red
                                              : Constants.blue)),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    isSalaryEdit = true;
                                    salaryFocuNode.requestFocus();
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2.h, horizontal: 4.w),
                                  child: Image.asset(
                                    "assets/images/pencil.png",
                                    height: 15.sp,
                                  ),
                                ),
                              )
                      ],
                    ),
                    // if (widget.item.status_id == 18 && widget.item.empCID == 1)  //TODO when all condition apply ater join not after select.
                    if (widget.item.empCID == 1)
                      // &&widget.item.emp_id == null //TODO: use to hide the empid field when that have data on it...

                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            margin: EdgeInsets.only(top: 8.h, bottom: 4.h),
                            height: MediaQuery.of(context).size.height / 35,
                            child: TextField(
                              autofocus: true,
                              focusNode: empIdFocusNode,
                              enabled: isEmpIdEdit,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z0-9\s]')),
                              ],

                              keyboardType: TextInputType.name,
                              //textInputAction: TextInputAction.s, // Set TextInputAction to sentences
                              textCapitalization: TextCapitalization.words,
                              controller: empIdController,

                              style: GoogleFonts.varela(
                                  color: Constants.subtitleclr,
                                  fontSize: 14.sp),
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIcon: const Icon(
                                    Icons.badge_outlined,
                                    color: Constants.subtitleclr,
                                  ),
                                  prefixIconColor: Constants.themeBgColor,
                                  contentPadding: const EdgeInsets.only(
                                      top: 8, bottom: 8, left: 10, right: 10),
                                  counterText: '',
                                  labelText: "Emp ID",
                                  labelStyle: const TextStyle(
                                    color: Constants.subtitleclr,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide(
                                        color: isEmpIdEdit
                                            ? Colors.red
                                            : Constants.lightdull),
                                  ),
                                  focusColor: const Color(0xffff0eceb),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: const BorderSide(
                                      color: Constants.subtitleclr,
                                    ),
                                  ),
                                  hintText: "E1515115....",
                                  hintStyle: GoogleFonts.sourceSansPro(
                                      color: Constants.hintColor,
                                      fontSize: 15.sp)),
                            ),
                          ),
                          isEmpIdEdit == true
                              ? InkWell(
                                  onTap: () async {
                                    setState(() {
                                      isEmpIdEdit = false;
                                    });
                                    NewChangeStatusModel changeStatusModel =
                                        NewChangeStatusModel(
                                      empId: empIdController.text.isNotEmpty
                                          ? empIdController.text.toUpperCase()
                                          : null,
                                      doj: widget.item.doj,
                                    );
                                    Map<String, dynamic> jsonData =
                                        changeStatusModel.toJson();
                                    try {
                                      await JobPostApiService.NewchangeStatus(
                                          jsonData, widget.item.id!.toInt());
                                      ref.refresh(fetchAllApplicantProvider);
                                      ref.refresh(fetchAllExecutiveProvide);
                                    } catch (e) {
                                      print('Error: $e');
                                      // Handle error...
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.h, horizontal: 4.w),
                                    child: Text("Submit",
                                        style: GoogleFonts.varela(
                                            color: isEmpIdEdit
                                                ? Colors.red
                                                : Constants.blue)),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      isEmpIdEdit = true;
                                      empIdFocusNode.requestFocus();
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.h, horizontal: 4.w),
                                    child: Image.asset(
                                      "assets/images/pencil.png",
                                      height: 15.sp,
                                    ),
                                  ),
                                )
                        ],
                      ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              isLoading = true;
                            });
                            isToday ||
                                    isYesterday ||
                                    widget.item.status_id ==
                                        1 //TODO :: Ready to join
                                ? null
                                : singleSelectPicker();
                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          },
                          child: Container(
                              margin: EdgeInsets.only(top: 4.h, right: 8.w),
                              decoration: BoxDecoration(
                                  color: doj == yesterday
                                      ? Constants.themeBgColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                      color: widget.item.doj != null
                                          ? widget.item.doj?.day ==
                                                      tomorrow.day &&
                                                  widget.item.doj!.month ==
                                                      tomorrow.month &&
                                                  widget.item.doj!.year ==
                                                      tomorrow.year
                                              ? Colors.blue
                                              : widget.item.doj!.day ==
                                                          DateTime.now().day &&
                                                      widget.item.doj!.month ==
                                                          DateTime.now()
                                                              .month &&
                                                      widget.item.doj!.year ==
                                                          DateTime.now().year
                                                  ? Colors.green
                                                  : doj == yesterday
                                                      ? Colors.white
                                                      : Colors.brown
                                          : Constants.themeBgColor)),
                              padding: const EdgeInsets.only(
                                  left: 5, top: 4, bottom: 4, right: 5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.calendar_month_outlined,
                                      size: 15.h,
                                      color: widget.item.doj != null
                                          ? widget.item.doj?.day ==
                                                      tomorrow.day &&
                                                  widget.item.doj!.month ==
                                                      tomorrow.month &&
                                                  widget.item.doj!.year ==
                                                      tomorrow.year
                                              ? Colors.blue
                                              : widget.item.doj!.day ==
                                                          DateTime.now().day &&
                                                      widget.item.doj!.month ==
                                                          DateTime.now()
                                                              .month &&
                                                      widget.item.doj!.year ==
                                                          DateTime.now().year
                                                  ? Colors.green
                                                  : doj == yesterday
                                                      ? Colors.white
                                                      : Colors.brown
                                          : Constants.themeBgColor),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  widget.item.doj != null
                                      ? widget.item.doj!.day ==
                                                  DateTime.now().day &&
                                              widget.item.doj!.month ==
                                                  DateTime.now().month &&
                                              widget.item.doj!.year ==
                                                  DateTime.now().year
                                          ? Text("Today",
                                              style: GoogleFonts.varela(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w600))
                                          : widget.item.doj!.day ==
                                                      tomorrow.day &&
                                                  widget.item.doj!.month ==
                                                      tomorrow.month &&
                                                  widget.item.doj!.year ==
                                                      tomorrow.year
                                              ? Text("Tomorrow",
                                                  style: GoogleFonts.varela(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w600))
                                              : doj == yesterday
                                                  ? Text("Yesterday",
                                                      style: GoogleFonts.varela(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600))
                                                  : Text(DateFormat('dd MMM yyyy').format(widget.item.doj!),
                                                      style: GoogleFonts.varela(
                                                          color: Colors.brown,
                                                          fontWeight:
                                                              FontWeight.w600))
                                      : Text("Select DOJ",
                                          style: GoogleFonts.varela(
                                              color: Constants.themeBgColor,
                                              fontWeight: FontWeight.w600)),
                                ],
                              )),
                        ),
                        //TODO:: Button tariningDropOut........

                        if (widget.item.doj != null &&
                            !isToday &&
                            widget.item.status_id != 18)
                          SizedBox(
                            width: 5.w,
                          ),
                        if (widget.item.doj != null &&
                            !isToday &&
                            widget.item.status_id != 18 &&
                            !widget.item.doj!.isBefore(DateTime.now()) &&
                            !isYesterday) //TODO:: Ready to join.
                          InkWell(
                            onTap: () async {
                              NewChangeStatusModel changeStatusModel =
                                  NewChangeStatusModel(
                                      // statusId: item.status_id,
                                      doj: null);
                              Map<String, dynamic> jsonData =
                                  changeStatusModel.toJson();
                              try {
                                await JobPostApiService.NewchangeStatus(
                                    jsonData, widget.item.id!.toInt());
                                setState(() {});
                                // First pop to close the dialog
                              } catch (e) {
                                print('Error: $e');
                                // Handle error...
                              }
                              setState(() {
                                widget.item.doj == null;
                              });
                              ref.refresh(fetchAllApplicantProvider);
                              ref.refresh(fetchAllExecutiveProvide);
                            },
                            child: Image.asset(
                              "assets/images/close.png",
                              height: 13.h,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        const Spacer(),

                        //TODO:: Primary butoon which join, notjoin, offerdecline and ready to join....{
                        //
                        //
                        //
                        //
                        //
                        //
                        //
                        widget.item.doj != null &&
                                (widget.item.doj!.day == today.day ||
                                    widget.item.doj!
                                        .isBefore(DateTime.now())) &&
                                widget.item.status_id != 18
                            ? Wrap(
                                children: List.generate(
                                  widget.finalDropDownItemforJoinNot
                                      .length, //TODO: Join and Not Join button
                                  (index) => GestureDetector(
                                      onTap:
                                          widget
                                                      .finalDropDownItemforJoinNot[
                                                          index]
                                                      .priStatusId ==
                                                  18
                                              ? () {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return CustomDialogueForJoin(
                                                        onTab: () {
                                                          Future.delayed(
                                                              const Duration(
                                                                  seconds: 2),
                                                              () {
                                                            setState(() {
                                                              isLoading = false;
                                                            });
                                                          });
                                                        },
                                                        onCancel: () {
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                        },
                                                        item: widget.item,
                                                        secStatusId: widget
                                                            .finalDropDownItemforJoinNot[
                                                                index]
                                                            .priStatusId!
                                                            .toInt(),
                                                        statusId: widget
                                                            .finalDropDownItemforJoinNot[
                                                                index]
                                                            .priStatusId!
                                                            .toInt(),
                                                      );
                                                    },
                                                  );
                                                }
                                              : widget.item.status_id == 18
                                                  ? () {}
                                                  : widget
                                                              .finalDropDownItemforJoinNot[
                                                                  index]
                                                              .pri_status_remark !=
                                                          1 //TODO:: check for remark
                                                      ? () async {
                                                          setState(() {
                                                            isLoading = true;
                                                          });
                                                          NewChangeStatusModel
                                                              changeStatusModel =
                                                              NewChangeStatusModel(
                                                                  doj: widget
                                                                      .item.doj,
                                                                  hrStatusId: widget
                                                                              .finalDropDownItemforJoinNot[
                                                                                  index]
                                                                              .priStatusId ==
                                                                          16 //TODO:: ID of "not join"..
                                                                      ? widget
                                                                          .finalDropDownItemforJoinNot[
                                                                              index]
                                                                          .statusId
                                                                      : widget
                                                                          .finalDropDownItemforJoinNot[
                                                                              index]
                                                                          .statusId,
                                                                  statusId: widget
                                                                      .finalDropDownItemforJoinNot[
                                                                          index]
                                                                      .priStatusId);
                                                          Map<String, dynamic>
                                                              jsonData =
                                                              changeStatusModel
                                                                  .toJson();
                                                          try {
                                                            await JobPostApiService
                                                                .NewchangeStatus(
                                                                    jsonData,
                                                                    widget.item
                                                                        .id!
                                                                        .toInt());
                                                            ref.refresh(
                                                                fetchAllApplicantProvider);
                                                            ref.refresh(
                                                                fetchAllReferalProvider);
                                                            ref.refresh(
                                                                fetchAllApplyProvider);
                                                            ref.refresh(
                                                                fetchAllExecutiveProvide);
                                                            Future.delayed(
                                                                const Duration(
                                                                    seconds: 2),
                                                                () {
                                                              setState(() {
                                                                isLoading =
                                                                    false;
                                                              });
                                                            });
                                                          } catch (e) {
                                                            print('Error: $e');
                                                            // Handle error...
                                                          }
                                                        }
                                                      : () {
                                                          setState(() {
                                                            isLoading = true;
                                                          });
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return CustomDialogueForRemark(
                                                                onCancel: () {
                                                                  setState(() {
                                                                    isLoading =
                                                                        false;
                                                                  });
                                                                },
                                                                hint: widget
                                                                    .finalDropDownItemforJoinNot[
                                                                        index]
                                                                    .primaryStatus
                                                                    .toString(),
                                                                item:
                                                                    widget.item,
                                                                onTab:
                                                                    () async {
                                                                  NewChangeStatusModel
                                                                      changeStatusModel =
                                                                      NewChangeStatusModel(
                                                                          remark: remark
                                                                              .text,
                                                                          doj: widget
                                                                              .item
                                                                              .doj,
                                                                          hrStatusId: widget.finalDropDownItemforJoinNot[index].priStatusId == 16 //TODO:: ID of "not join"..
                                                                              ? widget.finalDropDownItemforJoinNot[index].statusId
                                                                              : widget.finalDropDownItemforJoinNot[index].statusId,
                                                                          statusId: widget.finalDropDownItemforJoinNot[index].priStatusId);
                                                                  Map<String,
                                                                          dynamic>
                                                                      jsonData =
                                                                      changeStatusModel
                                                                          .toJson();
                                                                  try {
                                                                    await JobPostApiService.NewchangeStatus(
                                                                        jsonData,
                                                                        widget
                                                                            .item
                                                                            .id!
                                                                            .toInt());
                                                                    ref.refresh(
                                                                        fetchAllApplicantProvider);
                                                                    ref.refresh(
                                                                        fetchAllReferalProvider);
                                                                    ref.refresh(
                                                                        fetchAllApplyProvider);
                                                                    ref.refresh(
                                                                        fetchAllExecutiveProvide);
                                                                    Future.delayed(
                                                                        const Duration(
                                                                            seconds:
                                                                                2),
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        isLoading =
                                                                            false;
                                                                      });
                                                                    });
                                                                    Navigator.pop(
                                                                        context);
                                                                  } catch (e) {
                                                                    print(
                                                                        'Error: $e');
                                                                    // Handle error...
                                                                  }
                                                                },
                                                                controller:
                                                                    remark,
                                                                callBack: (p0) {
                                                                  remark.text =
                                                                      p0;
                                                                },
                                                              );
                                                            },
                                                          );
                                                        },
                                      child: widget.item.status_id == 18
                                          ? const SizedBox()
                                          : Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6,
                                                      horizontal: 4),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.h,
                                                  horizontal: 8.w),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: widget
                                                                  .finalDropDownItemforJoinNot[
                                                                      index]
                                                                  .priStatusId ==
                                                              16
                                                          ? Colors.red
                                                          : Constants.blue),
                                                  //color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(8.r)),
                                              child: Text(
                                                widget
                                                    .finalDropDownItemforJoinNot[
                                                        index]
                                                    .primaryStatus
                                                    .toString(),
                                                style: GoogleFonts.varela(
                                                    color: widget
                                                                .finalDropDownItemforJoinNot[
                                                                    index]
                                                                .priStatusId ==
                                                            16
                                                        ? Colors.red
                                                        : Constants.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))),
                                ),
                              )
                            : widget.item.status_id != 18
                                ? Wrap(
                                    children: List.generate(
                                      widget.finalDropDownItemforReadyOffer
                                          .length, //TODO: Ready to join and Offer decline button
                                      (index) => GestureDetector(
                                          onTap:
                                              widget.item.status_id ==
                                                      15 //TODO::
                                                  ? () {}
                                                  : widget
                                                              .finalDropDownItemforReadyOffer[
                                                                  index]
                                                              .pri_status_remark !=
                                                          1
                                                      ? () async {
                                                          setState(() {
                                                            isLoading = true;
                                                          });
                                                          //TODO: To hide ready to join
                                                          NewChangeStatusModel changeStatusModel = NewChangeStatusModel(
                                                              doj: widget
                                                                  .item.doj,
                                                              hrStatusId: widget
                                                                          .finalDropDownItemforReadyOffer[
                                                                              index]
                                                                          .priStatusId ==
                                                                      17
                                                                  ? widget
                                                                      .finalDropDownItemforReadyOffer[
                                                                          index]
                                                                      .statusId
                                                                  : widget
                                                                      .finalDropDownItemforReadyOffer[
                                                                          index]
                                                                      .statusId,
                                                              statusId: widget
                                                                  .finalDropDownItemforReadyOffer[
                                                                      index]
                                                                  .priStatusId);
                                                          Map<String, dynamic>
                                                              jsonData =
                                                              changeStatusModel
                                                                  .toJson();
                                                          try {
                                                            await JobPostApiService
                                                                .NewchangeStatus(
                                                                    jsonData,
                                                                    widget.item
                                                                        .id!
                                                                        .toInt());
                                                            ref.refresh(
                                                                fetchAllApplicantProvider);
                                                            ref.refresh(
                                                                fetchAllReferalProvider);
                                                            ref.refresh(
                                                                fetchAllApplyProvider);
                                                            ref.refresh(
                                                                fetchAllExecutiveProvide);
                                                            Future.delayed(
                                                                const Duration(
                                                                    seconds: 2),
                                                                () {
                                                              setState(() {
                                                                isLoading =
                                                                    false;
                                                              });
                                                            });
                                                          } catch (e) {
                                                            print('Error: $e');
                                                            // Handle error...
                                                          }
                                                        }
                                                      : () {
                                                          setState(() {
                                                            isLoading = true;
                                                          });
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return CustomDialogueForRemark(
                                                                onCancel: () {
                                                                  setState(() {
                                                                    isLoading =
                                                                        false;
                                                                  });
                                                                },
                                                                hint: widget
                                                                    .finalDropDownItemforReadyOffer[
                                                                        index]
                                                                    .primaryStatus
                                                                    .toString(),
                                                                item:
                                                                    widget.item,
                                                                onTab:
                                                                    () async {
                                                                  NewChangeStatusModel
                                                                      changeStatusModel =
                                                                      NewChangeStatusModel(
                                                                          remark: remark2
                                                                              .text,
                                                                          doj: widget
                                                                              .item
                                                                              .doj,
                                                                          hrStatusId: widget.finalDropDownItemforReadyOffer[index].priStatusId == 17 //TODO:: Offer decline.
                                                                              ? widget.finalDropDownItemforReadyOffer[index].statusId
                                                                              : widget.finalDropDownItemforReadyOffer[index].statusId,
                                                                          statusId: widget.finalDropDownItemforReadyOffer[index].priStatusId);
                                                                  Map<String,
                                                                          dynamic>
                                                                      jsonData =
                                                                      changeStatusModel
                                                                          .toJson();
                                                                  try {
                                                                    await JobPostApiService.NewchangeStatus(
                                                                        jsonData,
                                                                        widget
                                                                            .item
                                                                            .id!
                                                                            .toInt());
                                                                    ref.refresh(
                                                                        fetchAllApplicantProvider);
                                                                    ref.refresh(
                                                                        fetchAllReferalProvider);
                                                                    ref.refresh(
                                                                        fetchAllApplyProvider);
                                                                    ref.refresh(
                                                                        fetchAllExecutiveProvide);
                                                                    Future.delayed(
                                                                        const Duration(
                                                                            seconds:
                                                                                2),
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        isLoading =
                                                                            false;
                                                                      });
                                                                    });
                                                                    Navigator.pop(
                                                                        context);
                                                                  } catch (e) {
                                                                    print(
                                                                        'Error: $e');
                                                                    // Handle error...
                                                                  }
                                                                },
                                                                controller:
                                                                    remark2,
                                                                callBack: (p0) {
                                                                  remark2.text =
                                                                      p0;
                                                                },
                                                              );
                                                            },
                                                          );
                                                        },
                                          child: widget.item.status_id == 15
                                              ? const SizedBox()
                                              : Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 6,
                                                      horizontal: 4),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 4.h,
                                                      horizontal: 8.w),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: widget
                                                                      .finalDropDownItemforReadyOffer[
                                                                          index]
                                                                      .priStatusId ==
                                                                  17
                                                              ? Colors.red
                                                              : Constants.blue),
                                                      // color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r)),
                                                  child: Text(
                                                    widget
                                                        .finalDropDownItemforReadyOffer[
                                                            index]
                                                        .primaryStatus
                                                        .toString(),
                                                    style: GoogleFonts.varela(
                                                        color: widget
                                                                    .finalDropDownItemforReadyOffer[
                                                                        index]
                                                                    .priStatusId ==
                                                                17
                                                            ? Colors.red
                                                            : Constants.blue,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ))),
                                    ),
                                  )
                                : const SizedBox(),

                        //
                        //
                        //
                        //
                        //
                        //
                        //
                        //
                        // TODO:: Primary butoon which join, notjoin, offerdecline and ready to join....}

                        // TODO ::Primary Button which is training DropOut.. {

                        if (widget.item.hr_sub_status == "Join")
                          Wrap(
                            children: List.generate(
                              widget.finalDropDownItemForTrainingDrop
                                  .length, //TODO: Ready to join and Offer decline button
                              (index) => GestureDetector(
                                  onTap: widget.item.status_id == 15
                                      ? () {}
                                      : widget
                                                  .finalDropDownItemForTrainingDrop[
                                                      index]
                                                  .pri_status_remark !=
                                              1
                                          ? () async {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              //TODO: To hide ready to join
                                              NewChangeStatusModel
                                                  changeStatusModel =
                                                  NewChangeStatusModel(
                                                      doj: widget.item.doj,
                                                      hrStatusId: widget
                                                          .finalDropDownItemForTrainingDrop[
                                                              index]
                                                          .statusId,
                                                      statusId: widget
                                                          .finalDropDownItemForTrainingDrop[
                                                              index]
                                                          .priStatusId);
                                              Map<String, dynamic> jsonData =
                                                  changeStatusModel.toJson();
                                              try {
                                                await JobPostApiService
                                                    .NewchangeStatus(
                                                        jsonData,
                                                        widget.item.id!
                                                            .toInt());
                                                ref.refresh(
                                                    fetchAllApplicantProvider);
                                                ref.refresh(
                                                    fetchAllReferalProvider);
                                                ref.refresh(
                                                    fetchAllApplyProvider);
                                                ref.refresh(
                                                    fetchAllExecutiveProvide);
                                                Future.delayed(
                                                    const Duration(seconds: 2),
                                                    () {
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                });
                                              } catch (e) {
                                                print('Error: $e');
                                                // Handle error...
                                              }
                                            }
                                          : () {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CustomDialogueForRemark(
                                                    onCancel: () {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                    },
                                                    hint: widget
                                                        .finalDropDownItemForTrainingDrop[
                                                            index]
                                                        .primaryStatus
                                                        .toString(),
                                                    item: widget.item,
                                                    onTab: () async {
                                                      NewChangeStatusModel
                                                          changeStatusModel =
                                                          NewChangeStatusModel(
                                                              remark:
                                                                  remark2.text,
                                                              doj: widget
                                                                  .item.doj,
                                                              hrStatusId: widget
                                                                  .finalDropDownItemForTrainingDrop[
                                                                      index]
                                                                  .statusId,
                                                              /*   statusId: widget
                                                            .finalDropDownItemforReadyOffer[
                                                                index]
                                                            .priStatusId */ //TODO :: for testing i m not sure about this ......
                                                              statusId: widget
                                                                  .finalDropDownItemForTrainingDrop[
                                                                      index]
                                                                  .priStatusId);
                                                      Map<String, dynamic>
                                                          jsonData =
                                                          changeStatusModel
                                                              .toJson();
                                                      try {
                                                        await JobPostApiService
                                                            .NewchangeStatus(
                                                                jsonData,
                                                                widget.item.id!
                                                                    .toInt());
                                                        ref.refresh(
                                                            fetchAllApplicantProvider);
                                                        ref.refresh(
                                                            fetchAllReferalProvider);
                                                        ref.refresh(
                                                            fetchAllApplyProvider);
                                                        ref.refresh(
                                                            fetchAllExecutiveProvide);
                                                        Future.delayed(
                                                            const Duration(
                                                                seconds: 2),
                                                            () {
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                        });
                                                        Navigator.pop(context);
                                                      } catch (e) {
                                                        print('Error: $e');
                                                        // Handle error...
                                                      }
                                                    },
                                                    controller: remark2,
                                                    callBack: (p0) {
                                                      remark2.text = p0;
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                  child: widget.item.status_id == 15
                                      ? const SizedBox()
                                      : Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 6, horizontal: 4),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4.h, horizontal: 8.w),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              // color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(8.r)),
                                          child: Text(
                                            widget
                                                .finalDropDownItemForTrainingDrop[
                                                    index]
                                                .primaryStatus
                                                .toString(),
                                            style: GoogleFonts.varela(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ))),
                            ),
                          ),

                        // TODO:: ..}
                        /*  if (widget.item.hr_sub_status == "Join" &&
                      ((fresher || experience) &&
                          salaryController.text.isNotEmpty &&
                          empIdController.text.isNotEmpty)) */
                        if ((widget.item.hr_sub_status == "Join" &&
                            widget.item.document_status == "Submitted"))
                          InkWell(
                            onTap: () async {
                              int digitCount = salaryController.text.length;
                              if (empIdController.text.isEmpty &&
                                  widget.item.empCID == 1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackbarfinal(
                                        title: "Specify Emp ID ", error: true));
                              } else if (salaryController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackbarfinal(
                                        title: "Specify Anual CTC",
                                        error: true));
                              } else if (!fresher &&
                                  !experience &&
                                  widget.item.company_workstatus == 1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackbarfinal(
                                        title: "Select Work Status",
                                        error: true));
                              }
                              if ((widget.item.is_ctc_pay == 1 ||
                                      widget.item.is_work_pay == 1) &&
                                  digitCount < 6 &&
                                  salaryController.text.isNotEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackbarfinal(
                                        title: "Salary Should be CTC based",
                                        error: true));
                              } else if ((widget.item.is_ctc_pay == 0 ||
                                      widget.item.is_work_pay == 0) &&
                                  digitCount < 4 &&
                                  salaryController.text.isNotEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackbarfinal(
                                        title: "Salary Should be Monthly bases",
                                        error: true));
                              } else {
                                setState(() {
                                  isLoading = true;
                                });
                                NewChangeStatusModel changeStatusModel =
                                    NewChangeStatusModel(
                                  doj: widget.item.doj,
                                  isJoinSubmitted: 1,
                                );
                                Map<String, dynamic> jsonData =
                                    changeStatusModel.toJson();
                                try {
                                  await JobPostApiService.NewchangeStatus(
                                      jsonData, widget.item.id!.toInt());
                                  ref.refresh(fetchAllApplicantProvider);
                                  ref.refresh(fetchAllReferalProvider);
                                  ref.refresh(fetchAllExecutiveProvide);
                                  ref.refresh(fetchAllApplyProvider);
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
                                } catch (e) {
                                  print('Error: $e');
                                  // Handle error...
                                }
                              }
                            },
                            child: Container(
                              decoration: const BoxDecoration(),
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 8.w),
                              child: Text("Submit",
                                  style: GoogleFonts.varela(
                                      color: Constants.blue)),
                            ),
                          ),
                      ],
                    ),
                    if (widget.item.notes != null && widget.item.notes != "")
                      const Divider(),
                    Container(
                        child: note
                            ? Container(
                                margin: EdgeInsets.only(top: 8.h),
                                height: MediaQuery.of(context).size.height / 28,
                                child: TextField(
                                  focusNode: noteFocusNote,
                                  maxLines: 2,
                                  controller: notes,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  style: GoogleFonts.varela(
                                      color: Constants.subtitleclr,
                                      fontSize: 14.sp),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey.shade200,
                                      contentPadding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 8,
                                          left: 10,
                                          right: 10),
                                      counterText: '',
                                      labelText: "Note",
                                      labelStyle: const TextStyle(
                                        color: Constants.subtitleclr,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        borderSide: BorderSide(
                                            color: Constants.lightdull),
                                      ),
                                      focusColor: const Color(0xffff0eceb),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        borderSide: BorderSide(
                                          color: Constants.lightdull,
                                        ),
                                      ),
                                      hintText: "Add Notes .... ",
                                      hintStyle: GoogleFonts.sourceSansPro(
                                          color: Constants.hintColor,
                                          fontSize: 12.sp)),
                                ))
                            : widget.item.notes != null &&
                                    widget.item.notes != ""
                                ? SizedBox(
                                    // width: MediaQuery.of(context).size.width / 1.5,
                                    child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                              "Note : ${widget.item.notes.toString()}")),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            note = true;
                                            notes.text =
                                                widget.item.notes.toString();
                                          });
                                          noteFocusNote.requestFocus();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "assets/images/pencil.png",
                                                height: 18.h,
                                              )
                                              /*  Icon(
                                          Icons.edit_outlined,
                                          size: 18.h,
                                        ), */
                                              /*  Text("Edit Note",
                                            style: GoogleFonts.varela(
                                              color: Colors.black,
                                              fontSize: 12.sp,
                                            )), */
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ))
                                : const SizedBox()),
                    note
                        ? SizedBox(
                            height: 8.h,
                          )
                        : const SizedBox(),
                    Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        note
                            ? Row(
                                children: [
                                  if (note)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          note = false;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text("Cancel",
                                            style: GoogleFonts.varela(
                                              color: Colors.red,
                                              fontSize: 12.sp,
                                            )),
                                      ),
                                    ),
                                  GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        note = false;
                                      });

                                      {
                                        NewChangeStatusModel changeStatusModel =
                                            NewChangeStatusModel(
                                                doj: widget.item.doj,
                                                notes: notes.text);
                                        Map<String, dynamic> jsonData =
                                            changeStatusModel.toJson();
                                        try {
                                          await JobPostApiService
                                              .NewchangeStatus(jsonData,
                                                  widget.item.id!.toInt());

                                          ref.refresh(
                                              fetchAllApplicantProvider);
                                          ref.refresh(fetchAllExecutiveProvide);
                                          // ref.refresh(fetchAllReferalProvider);
                                          // ref.refresh(fetchAllApplyProvider);
                                          notes.clear();
                                          //  Navigator.pop(context);
                                        } catch (e) {
                                          print('Error: $e');
                                          //
                                        }
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Text("Submit",
                                          style: GoogleFonts.varela(
                                              color: Constants.blue)),
                                    ),
                                  ),
                                ],
                              )
                            : widget.item.notes != null &&
                                    widget.item.notes != ""
                                ? const SizedBox()
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        note = true;
                                      });
                                      noteFocusNote.requestFocus();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.post_add_outlined,
                                            color: Colors.grey,
                                            size: 20.h,
                                          ),
                                          /* Text("Add Note",
                                        style: GoogleFonts.varela(
                                            fontSize: 12.sp, color: Colors.black)), */
                                        ],
                                      ),
                                    ),
                                  ),
                      ],
                    ))
                  ],
                )
            ],
          ),
        ),
        isLoading == true
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

  FocusNode noteFocusNote = FocusNode();

  TextEditingController notes = TextEditingController();

  bool note = false;

  InkWell customContainerMale(
      {required final VoidCallback onPressed,
      required bool isSelect,
      required String title,
      required String img,
      required bool isimage,
      bool? isSalary = false}) {
    return InkWell(
        onTap: onPressed,
        child: Container(
            //  width: MediaQuery.of(context).size.width / 2.5.w,

            // height: MediaQuery.of(context).size.height / 26.h,
            margin: const EdgeInsets.only(top: 5, bottom: 5, right: 4),
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
            decoration: BoxDecoration(
                color:
                    // isSelect ? const Color(0xfff310d44) :
                    isSelect ? Constants.lightdull : null,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Constants.subtitleclr)),
            // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isimage)
                  Image.asset(
                    img,
                    height: 20,
                  ),
                if (isimage)
                  const SizedBox(
                    width: 10,
                  ),
                Text(title,
                    style: GoogleFonts.sourceSansPro(
                        color: Constants.subtitleclr,
                        fontSize: 15.sp,
                        fontWeight:
                            isSelect ? FontWeight.bold : FontWeight.normal)),
              ],
            )));
  }

  Container disableContainer(String title) {
    return Container(
      margin: EdgeInsets.only(right: 6.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child:
          Text(title, style: GoogleFonts.varela(color: Colors.grey.shade500)),
    );
  }
}
