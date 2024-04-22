// ignore_for_file: unused_result, unused_local_variable, avoid_print, avoid_unnecessary_containers, use_full_hex_values_for_flutter_colors, use_build_context_synchronously
// ignore_for_file: todo
import 'package:awesome_calendar/awesome_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/models/changeStatusModel.dart';
import 'package:job_circle/models/drop_down_model.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/screens/jobs/Interview_bay_cc.dart';
import 'package:job_circle/screens/jobs/interview_bay_executive.dart';
import 'package:job_circle/screens/jobs/talent_pool_detail.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';

class ManagerSelect extends ConsumerStatefulWidget {
  final Applicant item;
  final List<DropDownItem> finalDropDownItemforJoinNot;
  final List<DropDownItem> finalDropDownItemforReadyOffer;
  final List<DropDownItem> finalDropDownItemForTrainingDrop;
  const ManagerSelect(
      {super.key,
      required this.item,
      required this.finalDropDownItemforJoinNot,
      required this.finalDropDownItemforReadyOffer,
      required this.finalDropDownItemForTrainingDrop});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ManagerSelectState();
}

class _ManagerSelectState extends ConsumerState<ManagerSelect> {
  @override
  void initState() {
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
                              SizedBox(
                                height: 4.h,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/source.png",
                                    height: 15.sp,
                                  ),
                                  Text(
                                    widget.item.spoc_name != null
                                        ? "${widget.item.spoc_name}"
                                        : "No Source",
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
                    if (widget.item.remark != null && widget.item.remark != "")
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
                            Expanded(
                              child: Text(
                                widget.item.remark ?? "",
                                style: GoogleFonts.varela(
                                  fontStyle: FontStyle.italic,
                                  // color: Constants.subtitleclr,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              /*    if (widget.item.notes != null && widget.item.notes != "")
                const Divider(),
              if (widget.item.notes != null && widget.item.notes != "")
                Row(
                  children: [
                    Expanded(
                      child: Text("Note : ${widget.item.notes.toString()}",
                          style: GoogleFonts.varela(fontSize: 12.sp)),
                    ),
                  ],
                ), */
            ],
          ),
        ),
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
